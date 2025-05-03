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
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "default",
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
            tools = {
              ["mcp"] = {
                callback = function() return require("mcphub.extensions.codecompanion") end,
                description = "Call tools and resources from the MCP Servers",
              }
            }
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.7-sonnet",
                },
              },
            })
          end,
        },
      })
    end,
    keys = {
      { "<Leader>ac", "<CMD>CodeCompanionChat<CR>",    desc = "Code Companion Chat",    mode = { "n", "v" } },
      { "<Leader>aa", "<CMD>CodeCompanionActions<CR>", desc = "Code Companion Actions", mode = { "n", "v" } },
    },
  },
  {
    "sourcegraph/sg.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },
}

return M
