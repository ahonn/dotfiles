local M = {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = {
      heading = {
        position = 'inline',
        icons = { '◈ ', '◇ ', '◆ ', '⋄ ', '❖ ', '⟡ ' },
      },
      bullet = {
        icons = { '○' },
      },
      checkbox = {
        unchecked = {
          icon = "(×)",
        },
        checked = {
          icon = "(󰄬)",
        },
      },
      link = {
        hyperlink = '󰈙 ',
      },
      indent = { enabled = true },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes",
        },
      },
      daily_notes = {
        folder = "journal",
        date_format = "%Y-%m-%d",
        default_tags = {},
        template = nil,
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<C-x>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["gd"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        ["<CR>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<Leader>nn",
          insert_link = "<Leader>ni",
        },
      },
    },
    keys = {
      { "<Leader>np", "<CMD>ObsidianQuickSwitch<CR>", desc = "Quickly switch to (or open) note" },
      { "<Leader>nn", ":ObsidianNew",                 desc = "Create a new note" },
      { "<Leader>no", "<CMD>ObsidianToday<CR>",       desc = "Open today's note" },
      { "<Leader>ny", "<CMD>ObsidianYesterday<CR>",   desc = "Open yesterday's note" },
      { "<Leader>nt", "<CMD>ObsidianTomorrow<CR>",    desc = "Open tomorrow's note" },
    }
  }
}

return M
