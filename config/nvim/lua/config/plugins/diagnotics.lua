local M = {
  {
    "folke/trouble.nvim",
    event = "BufWinEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<Leader>d", "<CMD>Trouble diagnostics<CR>", desc = "Diagnostics" },
    }
  },
  {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = {}
  }
}

return M
