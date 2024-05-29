local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "folke/neodev.nvim",
        event = "BufReadPre",
        ft = { "lua" },
        opts = {}
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

      -- tailwindcss & css
      lspconfig.tailwindcss.setup({})
      local unknownAtRules = {
        validate = true,
        lint = {
          unknownAtRules = "ignore"
        }
      }
      lspconfig.cssls.setup({
        settings = {
          css = unknownAtRules,
          scss = unknownAtRules,
          less = unknownAtRules,
        },
        capabilities = capabilities,
      })

      lspconfig.rust_analyzer.setup({
        settings = {
          files = {
            excludeDirs = { ".devbox", "node_modules" }
          }
        }
      })
      lspconfig.svelte.setup({})

      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.beancount.setup({})
      lspconfig.astro.setup({})
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
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        code_action = {
          show_server_name = false
        },
        ui = {
          title = false,
          code_action = ''
        }
      })
    end,
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
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          expose_as_code_action = "all",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "literals",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = true,
          }
        }
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        ensure_installed = {
          "eslint",
          "prettier",
        },
      })
    end,
    lazy = true,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
      -- https://github.com/nvimtools/none-ls.nvim/discussions/81 for more information
      "nvimtools/none-ls-extras.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local eslint_actions = require("none-ls.code_actions.eslint");
      local eslint_diagnostics = require("none-ls.diagnostics.eslint");
      local eslint_formatting = require("none-ls.formatting.eslint");

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

          eslint_actions.with(eslint_config),
          eslint_diagnostics.with(eslint_config),
          eslint_formatting.with(eslint_config),
        },
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "piersolenski/wtf.nvim",
    config = function()
      local openai_key = os.getenv("OPENAI_KEY")
      require("wtf").setup({
        openai_api_key = openai_key,
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
    }
  },
}

return M
