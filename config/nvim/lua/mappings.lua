vim.g.mapleader = " "

local function set_keymap(...)
	vim.api.nvim_set_keymap(...)
end

local opts = { noremap = true, silent = true }

set_keymap("n", "<", "<<", opts)
set_keymap("n", ">", ">>", opts)
set_keymap("v", "<", "<gv", opts)
set_keymap("v", ">", ">gv", opts)

set_keymap("n", "k", "gk", opts)
set_keymap("n", "gk", "k", opts)
set_keymap("n", "j", "gj", opts)
set_keymap("n", "gj", "j", opts)

set_keymap("n", "\\", ":nohlsearch<CR>", opts)
