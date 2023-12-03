local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "lvimuser/lsp-inlayhints.nvim",
        config = function()
          local inlayhints = require("lsp-inlayhints")
          inlayhints.setup({})

          vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
          vim.api.nvim_create_autocmd("LspAttach", {
            group = "LspAttach_inlayhints",
            callback = function(args)
              if not (args.data and args.data.client_id) then
                return
              end
              local bufnr = args.buf
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              inlayhints.on_attach(client, bufnr)
            end,
          })
        end,
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      vim.api.nvim_create_augroup("LspAttach_keymap", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_keymap",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local bufnr = args.buf
          require("config.plugins.lsp.keymaps").buf_set_keymaps(bufnr)
          require("config.plugins.lsp.diagnostic").setup()
        end,
      })

      -- Typescript language server
      -- lspconfig.tsserver.setup({
      --   on_attach = function(client)
      --     client.resolved_capabilities.document_formatting = false
      --   end,
      --   settings = {
      --   }
      -- })

      lspconfig.tailwindcss.setup({})
      lspconfig.cssls.setup({
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
        },
        capabilities = capabilities,
      })
      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({})
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "tsserver", "lua_ls", "jsonls", "tailwindcss" },
      automatic_installation = true,
    }
  },
  {
    "tami5/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({})
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require 'lsp_signature'.setup(opts)
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          expose_as_code_action = "all",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'none',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      })
    end,
  },
  {
    "folke/neodev.nvim",
    event = "BufReadPre",
    ft = { "lua" },
    opts = {}
  },
}

return M
