return {
  {
    "ellisonleao/gruvbox.nvim",
    init = function()
      vim.g.gruvbox_bold = true
      vim.g.gruvbox_italic = true
      vim.g.gruvbox_invert_selection = false
    end,
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = {
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
        next = "<C-Space>",
      }
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = {
      show_current_context = true,
      show_current_context_start = true,
    }
  },
  {
    "mattn/emmet-vim",
    cmd = "EmmetExpandAbbreviation",
    config = function()
      vim.g.emmet_enable_mappings = 0
      vim.api.nvim_set_keymap("n", "<C-e>", "<CMD>EmmetExpandAbbreviation<CR>", { noremap = true })
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
  },
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "windwp/nvim-autopairs",
}
