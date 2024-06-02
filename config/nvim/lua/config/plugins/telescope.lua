return {
  "nvim-telescope/telescope.nvim",
  event = "BufWinEnter",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        require("telescope").load_extension("ui-select")
      end
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
  },
  config = function()
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-L>"] = actions.cycle_history_next,
            ["<C-H>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
            ["<c-t>"] = open_with_trouble,
          },
          n = { ["<c-t>"] = open_with_trouble },
        },
      },
    })
  end,
  keys = {
    { "<C-p>",           "<CMD>Telescope find_files<CR>",  desc = "Find Files" },
    { "<C-f>",           "<CMD>Telescope live_grep<CR>",   desc = "Live Grep" },
    { "<Leader><Space>", "<CMD>Telescope buffers<CR>",     desc = "Buffers" },
    { "<Leader>d",       "<CMD>Telescope diagnostics<CR>", desc = "Diagnostics" },
  },
}
