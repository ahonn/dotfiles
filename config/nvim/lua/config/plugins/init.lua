return {
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "jose-elias-alvarez/typescript.nvim",
  "editorconfig/editorconfig-vim",
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      }
    }
  },
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "BufReadPost",
    config = {},
  },
  {
    "tpope/vim-commentary",
    event = "BufReadPost",
  },
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
    event = "VeryLazy",
    config = {}
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
    config = {}
  },
}
