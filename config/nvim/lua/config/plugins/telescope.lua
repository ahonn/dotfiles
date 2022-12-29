return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  init = function()
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-p>", "<CMD>:Telescope find_files<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-f>", "<CMD>:Telescope live_grep<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>:Telescope buffers<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>d", "<CMD>:Telescope diagnostics<CR>", opts)
  end,
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-L>"] = actions.cycle_history_next,
            ["<C-H>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
        },
      },
    })
    require("telescope").load_extension("fzf")
  end,
  keys = {
    { "<C-p>", "<CMD>:Telescope find_files<CR>", desc = "Find Files" },
    { "<C-f>", "<CMD>:Telescope live_grep<CR>", desc = "Live Grep" },
    { "<Leader><Space>", "<CMD>:Telescope buffers<CR>", desc = "Buffers" },
    { "<Leader>d", "<CMD>:Telescope diagnostics<CR>", desc = "Diagnostics" },
  },
}
