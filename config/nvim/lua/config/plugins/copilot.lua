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
    "robitx/gp.nvim",
    config = function()
      local conf = {
        providers = {
          openai = {
            disable = true,
          },
          anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
          },
        },
        agents = {
          {
            name = "Claude 3.5 Sonnet",
            provider = "anthropic",
            chat = true,
            model = {
              model = "claude-3.5-sonnet",
            },
            system_prompt = require("gp.defaults").chat_system_prompt,
          }
        },
        hooks = {
          BufferChatNew = function(gp, _)
            vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew vsplit")
          end,
        },
        chat_confirm_delete = false,
        chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>p" },
        chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
        chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
        chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>a" },
      }
      require("gp").setup(conf)
    end,
    keys = {
      -- Visual mode mappings
      { "<C-g>c", ":<C-u>'<,'>GpChatPaste vsplit<cr>", mode = "v", desc = "Visual Chat New" },
      -- Normal mode mappings
      { "<C-g>c", "<cmd>GpChatNew vsplit<cr>",         mode = "n", desc = "New Chat" },
      { "<C-g>b", "<cmd>GpBufferChatNew vsplit<cr>",   mode = "n", desc = "New Buffer Chat" },
      { "<C-g>f", "<cmd>GpChatFinder<cr>",             mode = "n", desc = "Chat Finder" },
    },
  }
}

return M
