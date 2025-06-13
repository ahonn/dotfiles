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
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = function()
      local hl_cursor_line = vim.api.nvim_get_hl(0, { name = "CursorLine" })
      local hl_comment = vim.api.nvim_get_hl(0, { name = "Comment" })
      local hl_combined = vim.tbl_extend("force", hl_comment, { bg = hl_cursor_line.bg })
      vim.api.nvim_set_hl(0, "CursorLineBlame", hl_combined)

      return {
        enabled = true,
        message_template = "<author> • <date> • <summary>",
        date_format = "%r",
        virtual_text_column = 1,
        highlight_group = "CursorLineBlame",
      }
    end
  }
}

return M
