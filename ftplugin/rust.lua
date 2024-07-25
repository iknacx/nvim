local root_files = {
  '.git',
  "Cargo.toml",
  "rust-project.json",
}

vim.lsp.start {
  name = "rust-analyzer",
  cmd = { "rust-analyzer" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require("iknacx.lsp").make_client_capabilities(),
}
