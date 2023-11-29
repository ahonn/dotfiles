return {
  "jparise/vim-graphql",
  "jose-elias-alvarez/typescript.nvim",
  -- "wuelnerdotexe/vim-astro",
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
    'windwp/nvim-autopairs',
    event = "InsertEnter",
  },
  {
    "tpope/vim-commentary",
    event = "BufReadPost",
  },
  {
    "alexghergh/nvim-tmux-navigation",
    opts = {
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
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    init = function()
      vim.api.nvim_set_keymap("n", "gm", "<CMD>:GitMessenger<CR>", { noremap = true })
    end,
  },
}
