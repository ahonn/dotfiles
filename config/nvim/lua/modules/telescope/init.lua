local actions = require "telescope.actions"

local M = {}

function M.setup()
  require("telescope").load_extension("fzf")
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Esc>"] = actions.close,
        }
      }
    }
  }

  local opts = { noremap = true }
  vim.api.nvim_set_keymap("n", "<C-p>", "<CMD>lua require('telescope.builtin').find_files()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<C-f>", "<CMD>lua require('telescope.builtin').live_grep()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require('telescope.builtin').buffers()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<Leader>d", "<CMD>lua require('telescope.builtin').diagnostics()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<Leader>s", "<CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)
end

return M
