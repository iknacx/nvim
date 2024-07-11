{
  pkgs,
  lib,
  stdenv,
  plugins ? [],
  extraPackages ? [],
  extraLuaPackages ? p: [],
  extraPython3Packages ? p: [], 
  withPython3 ? true, 
  withRuby ? false, 
  withNodeJs ? false, 
  withSqlite ? true, 
  viAlias ? true, 
  vimAlias ? true, 
}: with lib; let

  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
    runtime = {};
  };

  externalPackages = extraPackages ++ (optionals withSqlite [pkgs.sqlite]);

  normalizedPlugins = map (x:
    defaultPlugin // ( if x ? plugin then x else { plugin = x; })
  ) plugins;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    plugins = normalizedPlugins;
  };

  nvimRtp = stdenv.mkDerivation {
    name = "nvim-rtp";
    src = ./.;

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua
      rm init.lua
    '';

    installPhase = ''
      cp -r after $out/after
      rm -r after
      cp -r lua $out/lua
      rm -r lua
      cp -r * $out/nvim
    '';
  };

  initLua = ''
    vim.loader.enable()
    -- prepend lua directory
    vim.opt.rtp:prepend('${nvimRtp}/lua')
  '' + (builtins.readFile ./init.lua) + ''
    vim.opt.rtp:prepend('${nvimRtp}/nvim')
    vim.opt.rtp:prepend('${nvimRtp}/after')
  '';

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    (optional (externalPackages != [])
      ''--prefix PATH : "${makeBinPath externalPackages}"'')
    ++ (optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    ++ (optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
  );

  luaPackages = pkgs.neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  extraMakeWrapperLuaCArgs =
    optionalString (resolvedExtraLuaPackages != [])
    ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

  extraMakeWrapperLuaArgs =
    optionalString (resolvedExtraLuaPackages != [])
    ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

in pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {
  luaRcContent = initLua;
  wrapperArgs =
  escapeShellArgs neovimConfig.wrapperArgs
    + " "
    + extraMakeWrapperArgs
    + " "
    + extraMakeWrapperLuaCArgs
    + " "
    + extraMakeWrapperLuaArgs;
  wrapRc = true;
})
