local M = {}

function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_lsp = require('cmp_nvim_lsp')
  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
  capabilities = vim.tbl_deep_extend('keep', capabilities, cmp_lsp_capabilities)
  return capabilities
end

return M
