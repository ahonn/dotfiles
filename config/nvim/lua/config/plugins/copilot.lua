local M = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
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
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "claude_code",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          }
        },
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read op://Personal/claude-code/credential",
                },
              })
            end,
          },
        },
      })
    end,
    keys = {
      { "<Leader>ac", "<CMD>CodeCompanionChat<CR>",     desc = "Code Companion Chat",    mode = { "n", "v" } },
      { "<Leader>aa", "<CMD>CodeCompanionActions<CR>",  desc = "Code Companion Actions", mode = { "n", "v" } },
      { "<Leader>ag", "<CMD>CodeCompanion /commit<CR>", desc = "Code Companion Commit",  mode = { "n", "v" } },
    },
  },
  {
    "sourcegraph/sg.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  }
}

return M
