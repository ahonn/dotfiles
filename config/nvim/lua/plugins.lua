nlocal install_path = ("%s/site/pack/packer-lib/opt/packer.nvim"):format(vim.fn.stdpath("data"))

local function install_packer()
	vim.fn.termopen(("git clone https://github.com/wbthomason/packer.nvim %q"):format(install_path))
end

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	install_packer()
end

vim.cmd([[packadd packer.nvim]])

function _G.packer_upgrade()
	vim.fn.delete(install_path, "rf")
	install_packer()
end

vim.cmd([[command! PackerUpgrade :call v:lua.packer_upgrade()]])

local function spec(use)
	use("lewis6991/impatient.nvim")

	-- Color scheme
	use({
		"gruvbox-community/gruvbox",
		setup = function()
			vim.g.gruvbox_bold = true
			vim.g.gruvbox_italic = true
			vim.g.gruvbox_invert_selection = false
		end,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
		end,
	})

	-- Doc
	use({
		"kkoomen/vim-doge",
		cmd = { "DogeGenerate" },
		run = function()
			vim.fn["doge#install"]()
		end,
		setup = function()
			vim.g.doge_enable_mappings = 0
			vim.g.doge_comment_jump_modes = { "n" }
		end,
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/playground",
		},
		run = ":TSUpdate",
		config = function()
			require("modules.treesitter").setup()
		end,
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			require("modules.telescope").setup()
		end,
	})

	-- LSP
	use({
		"williamboman/nvim-lsp-installer",
		requires = {
      "tami5/lspsaga.nvim",
			"neovim/nvim-lspconfig",
			"ray-x/lsp_signature.nvim",
			"folke/lua-dev.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"jose-elias-alvarez/null-ls.nvim",
			"jose-elias-alvarez/nvim-lsp-ts-utils",
		},
		config = function()
			require("modules.lsp").setup()
		end,
	})

	-- Completion
	use({
		{
			"github/copilot.vim",
			setup = function()
				vim.cmd([[
          let g:copilot_no_tab_map = v:true
          imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        ]])
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip",
				"hrsh7th/cmp-copilot",
				"rafamadriz/friendly-snippets",
			},
			config = function()
				require("modules.completion").setup()
			end,
		},
	})

	-- Git
	use({
		{
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("gitsigns").setup()
			end,
		},
		{
			"rhysd/git-messenger.vim",
			config = function()
				vim.api.nvim_set_keymap("n", "gm", "<CMD>GitMessenger<CR>", { noremap = true })
			end,
		},
	})

	-- Extensions
	use({
		"tomlion/vim-solidity",
		"tpope/vim-repeat",
		"tpope/vim-surround",
		"tpope/vim-commentary",
		"ygm2/rooter.nvim",
    {
      "mattn/emmet-vim",
      setup = function()
        vim.g.emmet_enable_mappings = 0
        vim.api.nvim_set_keymap("n", "<C-e>", "<cmd>EmmetExpandAbbreviation<CR>", { noremap = true })
      end,
    },
		{
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				require("alpha").setup(require("alpha.themes.startify").opts)
			end,
		},
		{
			"simnalamburt/vim-mundo",
			cmd = "MundoInstall",
		},
		{
			"ntpeters/vim-better-whitespace",
			setup = function()
				vim.g.better_whitespace_enabled = true
			end,
		},
		{
			"alexghergh/nvim-tmux-navigation",
			config = function()
				require("modules.navigation").setup()
			end,
		},
		{
			"kyazdani42/nvim-tree.lua",
			config = function()
				require("modules.file-explorer").setup()
			end,
		},
		{
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup()
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			setup = function()
				vim.g.indent_blankline_use_treesitter = true
				vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
				vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
				vim.g.indent_blankline_char = "▏"
				vim.cmd([[set colorcolumn=99999]])
			end,
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
					show_current_context_start = false,
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			requires = {
				"arkav/lualine-lsp-progress",
				{
					"SmiteshP/nvim-gps",
					config = function()
						require("nvim-gps").setup()
					end,
				},
			},
			config = function()
				require("modules.lualine").setup()
			end,
		},
		{
			"akinsho/bufferline.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
				vim.api.nvim_set_keymap("n", "[b", "<CMD>BufferLineCyclePrev<CR>", { noremap = true })
				vim.api.nvim_set_keymap("n", "]b", "<CMD>BufferLineCycleNext<CR>", { noremap = true })
			end,
		},
		{
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({
					mappings = { "<C-u>", "<C-d>", "zz" },
				})
			end,
		},
		{
			"hrsh7th/vim-eft",
			config = function()
				vim.api.nvim_set_keymap("n", "f", "<Plug>(eft-f)", { noremap = false })
				vim.api.nvim_set_keymap("n", "F", "<Plug>(eft-F)", { noremap = false })
				vim.api.nvim_set_keymap("n", "t", "<Plug>(eft-t)", { noremap = false })
				vim.api.nvim_set_keymap("n", "T", "<Plug>(eft-T)", { noremap = false })
			end,
		},
		{
			"eraserhd/parinfer-rust",
			run = "cargo build --release",
		},
	})

  use({
    'David-Kunz/jester',
    config = function()
      vim.api.nvim_set_keymap("n", "<Leader>tn", "<CMD>lua require('jester').run()<CR>", { noremap = false })
      vim.api.nvim_set_keymap("n", "<Leader>td", "<CMD>lua require('jester').debug()<CR>", { noremap = false })
      vim.api.nvim_set_keymap("n", "<Leader>tf", "<CMD>lua require('jester').run_file()<CR>", { noremap = false })
    end,
  })
	-- Misc
	use({
		"wakatime/vim-wakatime",
		"dstein64/vim-startuptime",
	})
end

require("packer").startup({
	spec,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
