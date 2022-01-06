local lsp_installer = require "nvim-lsp-installer"
local lsp_keymaps = require "modules.lsp.keymaps"
local lsp_capabilities = require "modules.lsp.capabilities"

local M = {}

function M.setup()
  local on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()

    lsp_keymaps.buf_set_keymaps(bufnr)
  end

  lsp_installer.on_server_ready(function(server)
    local capabilities = lsp_capabilities.create()

    local default_opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    local server_opts = {
      ["sumneko_lua"] = function ()
        return require("lua-dev").setup {
          lspconfig = vim.tbl_deep_extend("force", default_opts, {
              settings = {
                  Lua = {
                      diagnostics = {
                          globals = { "vim" },
                      },
                  },
              },
         }),
        }
      end
    }

    server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
  end)

  local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.completion.spell,
      },
      on_attach = on_attach,
    }
end

return M
