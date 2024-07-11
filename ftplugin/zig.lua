local root_files = {
  "build.zig",
  ".git",
}

vim.g.zig_fmt_autosave = 0
vim.g.zig_fmt_parse_errors = 0

vim.lsp.start {
  name = "zls",
  cmd = { "zls" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require("iknacx.lsp").make_client_capabilities(),
}
