return {
  "jose-elias-alvarez/typescript.nvim",
  {
    "tpope/vim-repeat",
    event = "BufReadPost",
  },
  {
    "tpope/vim-surround",
    event = "BufReadPost",
  },
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      }
    },
    event = "BufReadPost",
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
    event = "BufReadPre",
    config = {}
  },
  {
    "mattn/emmet-vim",
    cmd = "EmmetExpandAbbreviation",
    init = function()
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
  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    init = function()
      vim.api.nvim_set_keymap("n", "gm", "<CMD>:GitMessenger<CR>", { noremap = true })
    end,
  },
  {
    "RRethy/vim-illuminate",
    cmd = "IlluminateToggle",
    init = function()
      vim.api.nvim_set_keymap("n", "&", "<CMD>:IlluminateToggle<CR>", { noremap = true })
      vim.cmd([[highlight link IlluminatedWordText LspReferenceText]])
      vim.cmd([[highlight link IlluminatedWordRead LspReferenceRead]])
      vim.cmd([[highlight link IlluminatedWordWrite LspReferenceWrite]])
    end
  },
}
