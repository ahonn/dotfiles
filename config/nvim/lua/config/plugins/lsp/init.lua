
local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "tami5/lspsaga.nvim",
    "ray-x/lsp_signature.nvim",
    "folke/neodev.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "lvimuser/lsp-inlayhints.nvim",
  },
}

function M.config()
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")

  local lsp_keymaps = require("config.plugins.lsp.keymaps")
  local lsp_capabilities = require("config.plugins.lsp.capabilities")
  local lsp_diagnostic = require("config.plugins.lsp.diagnostic")

  local on_attach = function(client, bufnr)
    require('lsp-inlayhints').on_attach(client, bufnr);
    require("lsp_signature").on_attach()
    require("lspsaga").setup({
      code_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
      },
      rename_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
      },
    })

    lsp_diagnostic.setup()
    lsp_keymaps.buf_set_keymaps(bufnr)
  end

  local capabilities = lsp_capabilities.create()
  ---@diagnostic disable-next-line: assign-type-mismatch
  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = capabilities,
  })

  mason.setup({})
  mason_lspconfig.setup({
    ensure_installed = { "tsserver", "sumneko_lua", "jsonls" },
    automatic_installation = true,
  })

  local tsutils = require("nvim-lsp-ts-utils")
  lspconfig.tsserver.setup({
    init_options = {
      hostInfo = "neovim",
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      tsutils.setup({})
      tsutils.setup_client(client)
    end,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = true,
        }
      },
    }
  })

  require("neodev").setup({})
  lspconfig.sumneko_lua.setup({
    ettings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        }
      }
    }
  })

  lspconfig.jsonls.setup({
    on_attach = on_attach,
  })

  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.diagnostics.eslint.with({
        prefer_local = "node_modules/.bin",
      }),
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.completion.spell,
      null_ls.builtins.completion.tags,
    },
    on_attach = on_attach,
  })
end

return M