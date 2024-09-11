local M = {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = 'curved',
          width = 100,
          height = 30,
        }
      })
    end,
    keys = {
      { '<C-t>', '<CMD>:ToggleTerm<CR>', desc = 'Toggle terminal' },
    }
  }
}

return M
