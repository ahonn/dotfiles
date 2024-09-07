local M = {
  {
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
  },
  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    event = "BufReadPost",
    keys = {
      { "gm", "<CMD>GitMessenger<CR>", desc = "Git Messenger" },
    },
  },
}

return M
