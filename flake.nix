{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    lib = import ./lib inputs;
    
    nvix = lib.make-nvix {
      debugging = true;
      
      aliases = [ "vi" "vim" "nv" ];
      binaries = with pkgs; [ btop ];

      plugins = with pkgs.vimPlugins; {
        "tokyonight-nvim" = tokyonight-nvim;
        "plenary-nvim" = plenary-nvim;
        "nvim-treesitter" = nvim-treesitter.withAllGrammars;
      };
    };

  in {
    packages.${system}.default = nvix;
    devShells.${system}.default = pkgs.mkShell {
      name = "nvix";
      packages = [ nvix ];
    };
  };
}
