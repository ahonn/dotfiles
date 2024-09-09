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
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  }
}

return M
