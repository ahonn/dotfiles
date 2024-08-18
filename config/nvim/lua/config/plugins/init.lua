return {
  {
    'wakatime/vim-wakatime',
    lazy = false
  },
  {
    "nathangrigg/vim-beancount",
    event = "BufReadPre",
    ft = { "beancount" },
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    event = "BufReadPre",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "jparise/vim-graphql",
    event = "BufReadPre",
    ft = { "graphql" },
  },
  {
    "prisma/vim-prisma",
    event = "BufReadPre",
    ft = { "prisma" },
  },
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
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
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").opts)
      vim.cmd("autocmd FileType alpha setlocal statuscolumn=")
    end,
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
    event = "BufReadPost",
    init = function()
      vim.api.nvim_set_keymap("n", "gm", "<CMD>:GitMessenger<CR>", { noremap = true })
    end,
  },
}
