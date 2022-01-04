local M = {}

function M.setup()
	local opts = { noremap = true }
	vim.api.nvim_set_keymap("n", "<C-h>", "<CMD>lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<C-j>", "<CMD>lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<C-k>", "<CMD>lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<C-l>", "<CMD>lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<CR>", opts)
end

return M
