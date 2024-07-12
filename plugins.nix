inputs: pkgs: let
  customPlugin = pname: src: pkgs.vimUtils.buildVimPlugin {
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
    otter-nvim

    # Telescope
    telescope-nvim

    # Tools
    comment-nvim
    gitsigns-nvim
    lazygit-nvim
    nvim-autopairs
    nvim-surround
    oil-nvim
    which-key-nvim

    # Dependencies
    plenary-nvim
    nvim-web-devicons
  ];

  # Language servers
  extraPackages = with pkgs; [
    lua-language-server
    nil
  ];
}
