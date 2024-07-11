{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
  };

  outputs = { nixpkgs, gen-luarc, ... } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        gen-luarc.overlays.default
      ];
    };

    plugins = import ./plugins.nix inputs pkgs;

    nvim-luarc-json = pkgs.mk-luarc-json {
      inherit (plugins) plugins;
    };

  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "nvim-devShell";
      buildInputs = with pkgs; [
        lua-language-server
        nil
        stylua
        luajitPackages.luacheck
      ];

      shellHook = ''
        ln -fs ${nvim-luarc-json} .luarc.json
      '';
    };

    packages.x86_64-linux.default = pkgs.callPackage ./. {
      inherit (plugins) plugins extraPackages;
    };
  };
}
