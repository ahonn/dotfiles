local M = {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("i", "<C-y>", "copilot#Accept('<CR>')", { noremap = true, silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
    vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)
  end,
}

return M
