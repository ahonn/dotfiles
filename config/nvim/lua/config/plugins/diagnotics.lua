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
    'sontungexpt/better-diagnostic-virtual-text',
    event = "LspAttach",
    config = function()
      require('better-diagnostic-virtual-text').setup({})
    end
  }
}

return M
