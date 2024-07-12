local oil = require("oil")

oil.setup {
  default_file_browser = true,
  skip_confirm_for_simple_edits = true,

  keymaps = {
    ["<leader>f"] = "actions.cd",
  },

  view_options = {
    show_hidden = true,
  }
}

vim.keymap.set('n', "<leader>e", oil.toggle_float)
