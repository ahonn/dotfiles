local M = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<C-j>",
            prev = "<C-k>",
            dismiss = "<C-h>",
          },
        },
        server_opts_overrides = {
          settings = {
            advanced = {
              listCount = 10,
              inlineSuggestCount = 5,
            }
          },
        }
      })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false,
    opts = {
      hints = { enabled = false }
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "hrsh7th/nvim-cmp",
  --     "nvim-telescope/telescope.nvim",
  --     {
  --       "stevearc/dressing.nvim",
  --       opts = {},
  --     },
  --   },
  --   config = function()
  --     require("codecompanion").setup({
  --       strategies = {
  --         chat = {
  --           adapter = "anthropic",
  --         },
  --         inline = {
  --           adapter = "copilot",
  --         },
  --         agent = {
  --           adapter = "anthropic",
  --         },
  --       },
  --     })
  --   end,
  --   keys = {
  --     { "<Leader>cc", "<CMD>CodeCompanionChat<CR>",    desc = "Code Companion Chat" },
  --     { "<Leader>ca", "<CMD>CodeCompanionActions<CR>", desc = "Code Companion Actions" },
  --   },
  -- }
}

return M
