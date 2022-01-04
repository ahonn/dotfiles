local M = {}

function M.create()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(capabilities)
end

return M