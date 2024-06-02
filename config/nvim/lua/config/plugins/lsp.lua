local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
      }
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      local lspconfig = require('lspconfig')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      mason.setup({})
      mason_lspconfig.setup({
        ensure_installed = { 'tsserver', 'rust_analyzer', 'lua_ls' },
        automatic_installation = true,
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        },
        tsserver = function()
          lspconfig.tsserver.setup({
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "literals",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            }
          })
        end,
      })

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)

        vim.keymap.set("n", "gh", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
        vim.keymap.set("n", "gr", "<CMD>lua require('telescope.builtin').lsp_references()<CR>", opts);
        vim.keymap.set("n", "gd", "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>", opts);
        vim.keymap.set("n", "gi", "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", opts);

        vim.keymap.set("n", "ga", "<CMD>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.keymap.set("v", "ga", "<CMD>lua vim.lsp.buf.range_code_action()<CR>", opts)

        vim.keymap.set("n", "<Leader>f", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", opts)
        vim.keymap.set("v", "<Leader>f", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", opts)
      end)
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local mason_null_ls = require("mason-null-ls")
      local eslint_actions = require("none-ls.code_actions.eslint");
      local eslint_diagnostics = require("none-ls.diagnostics.eslint");
      local eslint_formatting = require("none-ls.formatting.eslint");

      mason_null_ls.setup({
        automatic_installation = true,
        ensure_installed = {
          "eslint",
          "prettier",
        },
      })

      local eslint_config = {
        condition = function(utils)
          return utils.root_has_file { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
        end,
        prefer_local = "node_modules/.bin",
      }

      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.completion.spell,

          eslint_actions.with(eslint_config),
          eslint_diagnostics.with(eslint_config),
          eslint_formatting.with(eslint_config),
        },
      })
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
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    config = function()
      require("inlay-hints").setup()
    end
  },
}

return M
