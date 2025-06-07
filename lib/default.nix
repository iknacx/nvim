{ self, nixpkgs, ... } @ inputs: let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  inherit (pkgs) lib;

  make-nvix = {
    aliases ? [],
    plugins ? {},
    binaries ? [],
    libraries ? [],
    debugging ? false,
    neovim-unwrapped ? pkgs.neovim-unwrapped,
  }: let
    lua = neovim-unwrapped.lua;

    pack-dir = import ./vim-pack-dir.nix {
      inherit pkgs;
      plugins = builtins.attrValues plugins;
    };

    inherit (pack-dir) vim-pack-dir grammar-path;

    plugin-json = lib.pipe plugins [
      (lib.mapAttrs (_: v: toString v))
      builtins.toJSON
    ];

    early-init = pkgs.replaceVars ./early-init.lua {
      inherit plugin-json vim-pack-dir grammar-path;
      nvix-path = self;
    };

    wrapperArgs = lib.escapeShellArgs ([
      "--suffix" "PATH" ":" (lib.makeBinPath binaries)
      "--suffix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath libraries)
      "--add-flags" ''--cmd "source ${early-init}"''
    ] ++ lib.optionals (! debugging)
      [ "--set-default" "VIMINIT" "lua nvix.__early_init()" ]);


    version = lib.getVersion neovim-unwrapped;
  in pkgs.stdenv.mkDerivation {
    name = "nvix-${version}";
    pname = "nvim";
    inherit version;

    nativeBuildInputs = with pkgs; [
      xorg.lndir
      makeWrapper
    ];

    dontUnpack = true;
    preferLocalBuild = true;
    __structuredAttrs = true;
    
    postBuild = ''
      rm $out/bin/nvim

      echo "Looking for lua dependencies..."
      echo "file at ${lua}/nix-support"
      source ${lua}/nix-support/utils.sh

      _addToLuaPath "${vim-pack-dir}"

      echo "LUA_PATH towards the end of packdir: $LUA_PATH"

      makeWrapper ${neovim-unwrapped}/bin/nvim $out/bin/nvim ${wrapperArgs} \
          --prefix LUA_PATH ';' "$LUA_PATH" \
          --prefix LUA_CPATH ';' "$LUA_CPATH" 

      ${lib.concatMapStringsSep "\n" (alias: "ln -s $out/bin/nvim $out/bin/${alias}") aliases}
    '';

    buildPhase = ''
      runHook preBuild
      mkdir -p $out
      for i in ${neovim-unwrapped}; do
        lndir -silent $i $out
      done
      runHook postBuild
    '';


    checkPhase = ''
      runHook preCheck
      $out/bin/nvim -i NONE -e +quitall!
      runHook postCheck
    '';

  };
in {
  inherit make-nvix;
}
