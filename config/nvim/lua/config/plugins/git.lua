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
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "<author> • <date> • <summary>",
      date_format = "%r",
      virtual_text_column = 1,
    },
  }
}

return M
