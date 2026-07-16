local M = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  cond = function()
    return vim.loop.fs_stat(".git")
  end,
}

function M.config()
  local hl_cursor_line = vim.api.nvim_get_hl(0, { name = "CursorLine" })
  local hl_comment = vim.api.nvim_get_hl(0, { name = "Comment" })
  local hl_blame = vim.tbl_extend("force", hl_comment, { bg = hl_cursor_line.bg })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", hl_blame)

  require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_formatter = "<author> • <author_time:%R> • <summary>",
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
