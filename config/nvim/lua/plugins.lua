local install_path = ("%s/site/pack/packer-lib/opt/packer.nvim"):format(vim.fn.stdpath("data"))

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

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
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
			"neovim/nvim-lspconfig",
			"ray-x/lsp_signature.nvim",
			"folke/lua-dev.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("modules.lsp").setup()
		end,
	})

	-- Completion
	use({
		"github/copilot.vim",
		{
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"L3MON4D3/LuaSnip",
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
		{
			"simnalamburt/vim-mundo",
			cmd = "MundoInstall",
		},
		{
			"ntpeters/vim-better-whitespace",
			setup = function()
				vim.g.better_whitespace_enabled = true
				vim.g.strip_whitespace_on_save = true
				vim.g.strip_whitespace_confirm = false
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

	-- Misc
	use({
		"wakatime/vim-wakatime",
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
