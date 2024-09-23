local M = {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { "markdown" },
  opts = {
    heading = {
      position = 'inline',
      icons = { '◈ ', '◇ ', '◆ ', '⋄ ', '❖ ', '⟡ ' },
    },
    bullet = {
      icons = { '•' },
    },
    checkbox = {
      unchecked = {
        icon = "• (×)",
      },
      checked = {
        icon = "• (󰄬)",
      },
    },
    link = {
      hyperlink = '󰈙 ',
    },
    indent = { enabled = true },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}

return M
