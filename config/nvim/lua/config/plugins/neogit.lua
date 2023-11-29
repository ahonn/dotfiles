return {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    "sindrets/diffview.nvim",
  },
  opts = {
    kind = "split",
    integrations = {
      diffview = true,
    },
  },
  keys = {
    { "<Leader>gg", "<CMD>Neogit<CR>", desc = "Neogit" },
  },
}
