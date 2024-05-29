local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local opts = { noremap = true, silent = true }

set_keymap("n", "<", "<<", opts)
set_keymap("n", ">", ">>", opts)
set_keymap("v", "<", "<gv", opts)
set_keymap("v", ">", ">gv", opts)

for _, mode in pairs { "n", "v" } do
  set_keymap(mode, "J", "G", opts)
  set_keymap(mode, "K", "gg", opts)
  set_keymap(mode, "H", "^", opts)
  set_keymap(mode, "L", "$", opts)

  set_keymap(mode, "k", "gk", opts)
  set_keymap(mode, "gk", "k", opts)
  set_keymap(mode, "j", "gj", opts)
  set_keymap(mode, "gj", "j", opts)
end

set_keymap("n", "\\", ":nohlsearch<CR>", opts)
