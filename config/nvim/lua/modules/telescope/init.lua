local M = {}

function M.setup()
  require("telescope").load_extension("fzf")
  require("telescope").setup {}
  
  local opts = { noremap = true }
  vim.api.nvim_set_keymap("n", "<C-p>", "<CMD>lua require('telescope.builtin').find_files()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<C-f>", "<CMD>lua require('telescope.builtin').live_grep()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require('telescope.builtin').buffers()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<Leader>d", "<CMD>lua require('telescope.builtin').diagnostics()<CR>", opts)
end

return M