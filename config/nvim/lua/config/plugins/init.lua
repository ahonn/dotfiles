return {
  "jparise/vim-graphql",
  "jose-elias-alvarez/typescript.nvim",
  "wuelnerdotexe/vim-astro",
  "prisma/vim-prisma",
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    config = function()
      require("ibl").setup {
        indent = { char = "|" },
        whitespace = {
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }
    end
  },
  {
    "tpope/vim-repeat",
    event = "BufReadPost",
  },
  {
    "tpope/vim-surround",
    event = "BufReadPost",
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        tailwind = true,
      }
    },
    event = "BufReadPost",
  },
  {
    "ggandor/leap.nvim",
    event = "BufReadPost",
    config = function()
      require('leap').add_default_mappings();
    end
  },
  {
    "rcarriga/nvim-notify",
    init = function()
      vim.notify = require("notify");
    end,
    event = "VeryLazy"
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
    "mattn/emmet-vim",
    event = "BufReadPost"
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
