local M = {}

function M.setup()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "maintained",
		sync_install = false,
		tree_docs = {
      enable = true
    },
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<Leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<Leader>A"] = "@parameter.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]a"] = "@parameter.inner",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
					["]A"] = "@parameter.inner",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@parameter.inner",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
					["[A"] = "@parameter.inner",
				},
			},
		},
	})
end

return M
