local lsp_installer = require "nvim-lsp-installer"
local lsp_keymaps = require "modules.lsp.keymaps"
local lsp_capabilities = require "modules.lsp.capabilities"

local M = {}

function M.setup()
  lsp_installer.on_server_ready(function(server)

    local on_attach = function(client, bufnr)
      require "lsp_signature".on_attach()
      lsp_keymaps.buf_set_keymaps(bufnr)
    end

    local capabilities = lsp_capabilities.create()

    local options = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    server:setup(options)
  end)
end

return M