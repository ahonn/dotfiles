local M = {}

function M.buf_set_keymaps(bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  buf_set_keymap("n", "<Leader>r", "<CMD>Lspsaga rename<CR>", opts)
  buf_set_keymap("n", "gr", "<CMD>lua require('telescope.builtin').lsp_references()<CR>", opts);
  buf_set_keymap("n", "gd", "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>", opts);
  buf_set_keymap("n", "gi", "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", opts);
  buf_set_keymap("n", "gh", "<CMD>Lspsaga hover_doc<CR>", opts)

  buf_set_keymap("n", "ga", "<CMD>Lspsaga code_action<CR>", opts)
  buf_set_keymap("v", "ga", "<CMD>Lspsaga range_code_action<CR>", opts)

  buf_set_keymap("n", "<Leader>f", "<CMD>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("v", "<Leader>f", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", opts)

  for _, mode in pairs { "n", "v" } do
    buf_set_keymap(mode, "[e", "<CMD>lua vim.diagnostic.goto_prev({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap(mode, "]e", "<CMD>lua vim.diagnostic.goto_next({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap(mode, "[E", "<CMD>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap(mode, "]E", "<CMD>lua vim.diagnostic.goto_next()<CR>", opts)
  end
  buf_set_keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
end

return M
