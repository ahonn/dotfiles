local M = {
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    init = function()
      vim.g.gruvbox_bold = true
      vim.g.gruvbox_italic = true
      vim.g.gruvbox_invert_selection = false
    end,
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd([[colorscheme carbonfox]])
    end
  }
}

return M
