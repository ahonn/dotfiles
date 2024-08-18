local M = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  cond = function()
    return vim.loop.fs_stat(".git")
  end,
}

function M.config()
  require("gitsigns").setup({
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '▸' },
      topdelete    = { text = '▾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '▸' },
      topdelete    = { text = '▾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
  })
end

return M
