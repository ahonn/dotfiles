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
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          expose_as_code_action = "all",
        }
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.eslint,
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.eslint,
          null_ls.builtins.formatting.stylelint,
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
  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" }
  }
}

return M
