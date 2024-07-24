local root_files = {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac',
  '.git',
  'build.zig'
}

vim.lsp.start {
  name = "clangd",
  cmd = { "clangd" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
}
