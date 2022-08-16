local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_keymaps = require("modules.lsp.keymaps")
local lsp_capabilities = require("modules.lsp.capabilities")
local lsp_diagnostic = require("modules.lsp.diagnostic")
local lspconfig = require("lspconfig")

local M = {}

function M.setup()
	local on_attach = function(_, bufnr)
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
    ensure_installed = {"tsserver", "sumneko_lua", "jsonls"},
    automatic_installation = true,
  })

  local tsutils = require("nvim-lsp-ts-utils")
  lspconfig.tsserver.setup({
    init_options = {
      hostInfo = "neovim",
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      tsutils.setup({})
      tsutils.setup_client(client)
    end,
  })

  lspconfig.sumneko_lua.setup(require("lua-dev").setup({
    lspconfig = {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
  }))

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
