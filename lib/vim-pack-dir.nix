{
  pkgs,
  plugins ? [],
}:
let
  lib = pkgs.lib;

  transitiveClosure = plugin:
    [plugin] ++ (lib.unique (builtins.concatLists (map transitiveClosure plugin.dependencies or [])));

  findDependenciesRecursively = plugins: lib.concatMap transitiveClosure plugins;

  vimFarm = prefix: name: drvs: let
    mkEntryFromDrv = drv: {
      name = "${prefix}/${lib.getName drv}";
      path = drv;
    };
  in pkgs.linkFarm name (map mkEntryFromDrv drvs);


  pluginsWithDeps = findDependenciesRecursively plugins;
  grammars = builtins.filter (plugin: let
    cond = (builtins.match "^vimplugin-treesitter-grammar-.*" "${lib.getName plugin}") != null;
  in cond) pluginsWithDeps;

  packages = lib.subtractLists grammars pluginsWithDeps; 

  grammarBundle = pkgs.symlinkJoin {
    name = "vimplugin-treesitter-grammar-bundle";
    paths = map (e: e.outPath) grammars;
  };

  packdirPackages = vimFarm "pack/nvix-plugins/start" "packdir-start" packages;
  packdirGrammars = vimFarm "pack/nvix-grammars/start" "packdir-grammar" [ grammarBundle ];

in {
  vim-pack-dir = pkgs.buildEnv {
    name = "vim-pack-dir";
    paths = [ packdirPackages packdirGrammars ];

    postBuild = ''
      mkdir $out/nix-support
      for i in $(find -L $out -name propagated-build-inputs); do
        cat "$i" >> $out/nix-support/propagated-build-inputs
      done
    '';
  };

  grammar-path = grammarBundle.outPath;
}
