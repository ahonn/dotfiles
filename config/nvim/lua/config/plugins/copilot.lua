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

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<Leader>aa", "<CMD>GpChatNew vsplit<CR>", opts)
      vim.keymap.set("n", "<Leader>af", "<CMD>GpChatFinder<CR>", opts)
      vim.keymap.set("v", "<Leader>aa", ":<C-u>'<,'>GpChatPaste vsplit<CR>", opts)
      vim.keymap.set({ "n", "v" }, "<Leader>ab", "<CMD>GpBufferChatNew<CR>", opts)
    end,
  }
}

return M
