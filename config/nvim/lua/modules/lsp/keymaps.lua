local M = {}

function M.buf_set_keymaps(bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  -- Code Actions
  buf_set_keymap("n", "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("v", "<Leader>f", "<cmd><C-U>lua vim.lsp.buf.range_code_action()<CR>", opts)

  -- Movements
  buf_set_keymap("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts);
  buf_set_keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts);
  buf_set_keymap("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts);

  -- Docs
  buf_set_keymap("n", "gh", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gt", "<CMD>lua vim.lsp.buf.signature_help()<CR>", opts)

  -- Diagnostics
  for _, mode in pairs { "n", "v" } do
    buf_set_keymap(mode, "[e", "<CMD>lua vim.diagnostic.goto_prev({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap(mode, "]e", "<CMD>lua vim.diagnostic.goto_next({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap(mode, "[E", "<CMD>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap(mode, "]E", "<CMD>lua vim.diagnostic.goto_next()<CR>", opts)
  end
  buf_set_keymap("n", "].", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

return M