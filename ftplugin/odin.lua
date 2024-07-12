local root_files = {
  ".git"
}

vim.lsp.start {
  name = "ols",
  cmd = { "ols" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require("iknacx.lsp").make_client_capabilities(),
}
