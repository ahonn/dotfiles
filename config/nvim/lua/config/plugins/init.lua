return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'wakatime/vim-wakatime',
    lazy = false
  },
  -- {
  --   "nathangrigg/vim-beancount",
  --   event = "BufReadPre",
  --   ft = { "beancount" },
  -- },
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
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = '120',
      disabled_filetypes = { "alpha" }
    }
  },
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   opts = {
  --     stiffness = 0.8,
  --     trailing_stiffness = 0.5,
  --     distance_stop_animating = 0.5,
  --     transparent_bg_fallback_color = "#303030",
  --   },
  -- }
}
