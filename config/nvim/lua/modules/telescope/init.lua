local actions = require("telescope.actions")

local M = {}

function M.setup()
	require("telescope").load_extension("fzf")
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<Esc>"] = actions.close,
				},
			},
		},
	})

	local function telescope(func)
		return "<CMD>lua require('telescope.builtin')." .. func .. "<CR>"
	end

	local opts = { noremap = true }
	vim.api.nvim_set_keymap("n", "<C-p>", telescope("find_files()"), opts)
	vim.api.nvim_set_keymap("n", "<C-f>", telescope("live_grep()"), opts)
	vim.api.nvim_set_keymap("n", "<Leader><Space>", telescope("buffers()"), opts)
	vim.api.nvim_set_keymap("n", "<Leader>d", telescope("diagnostics()"), opts)
	vim.api.nvim_set_keymap("n", "<Leader>s", telescope("lsp_document_symbols()"), opts)
end

return M
