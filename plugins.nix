inputs: pkgs: let
  customPlugin = src: pname: pkgs.vimUtils.buildVimPlugin {
    inherit pname src;
    version = src.lastModifiedDate;
  };
in {
  plugins = with pkgs.vimPlugins; [
    # Style
    fidget-nvim
    neovim-ayu
    lualine-nvim

    # Completion
    cmp_luasnip
    cmp-nvim-lsp
    cmp-path
    lspkind-nvim
    luasnip
    nvim-cmp

    # LSP / Syntax
    nvim-lspconfig
    nvim-navic
    nvim-treesitter.withAllGrammars

    # Telescope
    telescope-nvim

    # Tools
    nvim-autopairs
    nvim-surround
    which-key-nvim

    # Dependencies
    plenary-nvim
  ];

  # Language servers
  extraPackages = with pkgs; [
    lua-language-server
    nil
  ];
}
