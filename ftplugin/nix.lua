local root_files = {
  "flake.nix",
  "default.nix",
  "shell.nix",
  ".git",
}

vim.lsp.start {
  name = "nil_ls",
  cmd = { "nil" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require("iknacx.lsp").make_client_capabilities(),
}
