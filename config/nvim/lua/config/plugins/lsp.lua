local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "pest-parser/pest.vim"
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      mason.setup({})
      mason_lspconfig.setup({
        ensure_installed = { 'ts_ls', 'biome', 'eslint', 'rust_analyzer', 'lua_ls' },
        automatic_installation = true,
        automatic_enable = {
          exclude = {
            "rust_analyzer",
          }
        },
        handlers = {
          function(server_name)
            if server_name == 'rust_analyzer' then
              return
            end
            lspconfig[server_name].setup({})
          end,
        },
        tsserver = function()
          lspconfig.ts_ls.setup({
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
        lua_ls = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = {
                  enable = false,
                },
              },
            }
          })
        end,
        pest_ls = function()
          require('pest-vim').setup {}
        end,
      })
    end,
    keys = {
      { "gh",        "<CMD>lua vim.lsp.buf.hover()<CR>",                                desc = "Show hover information" },
      { "gr",        "<CMD>lua require('telescope.builtin').lsp_references()<CR>",      desc = "Find references" },
      { "gd",        "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>",     desc = "Find definitions" },
      { "gi",        "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", desc = "Go to implementation" },
      { "ga",        "<CMD>lua vim.lsp.buf.code_action()<CR>",                          mode = { "n", "v" },            desc = "Code action" },
      { "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>",                               desc = "Rename symbol" },
      { "<Leader>f", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>",               mode = { "n", "v" },            desc = "Format" },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                targetDir = true,
                -- extraEnv = {
                -- MACOSX_DEPLOYMENT_TARGET = "10.15"
                -- },
              },
              check = {
                command = "check",
              },
            }
          }
        }
      }
    end
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
    event = "LspAttach",
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
  {
    "j-hui/fidget.nvim",
    event = "BufRead",
    config = function()
      require("fidget").setup()
    end,
  },
}

return M
