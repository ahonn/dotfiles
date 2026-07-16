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
      disable_insert_on_commit = "auto",
      commit_editor = {
        kind = "split",
        show_staged_diff = true,
        spell_check = true,
      },
    },
    keys = {
      { "<Leader>gg", "<CMD>Neogit<CR>",   desc = "Neogit" },
      { "<Leader>gc", "<CMD>!git cai<CR>", desc = "Git commit with AI" },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {
      diff = {
        compute_moves = true,
        hide_merge_artifacts = true,
      },
      explorer = {
        view_mode = "tree",
      },
      history = {
        view_mode = "tree",
      },
      keymaps = {
        view = {
          toggle_explorer = "<C-b>",
        },
        explorer = {
          select = "o",
          toggle_view_mode = false,
          fold_toggle = "<space>",
          fold_close = "C",
          fold_close_all = "z",
        },
        history = {
          select = "o",
          toggle_view_mode = false,
          fold_toggle = "<space>",
          fold_close = "C",
          fold_close_all = "z",
        },
      },
    },
    keys = {
      { "<Leader>gd", "<CMD>CodeDiff<CR>",           desc = "CodeDiff" },
      { "<Leader>gh", "<CMD>CodeDiff history %<CR>", desc = "CodeDiff file history" },
    },
  }
}

return M
