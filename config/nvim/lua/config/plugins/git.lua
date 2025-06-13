-- Auto-populate commit message with AI if buffer is empty
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*/COMMIT_EDITMSG",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    -- Check if buffer is empty (ignoring comment lines)
    local is_empty = true
    for _, line in ipairs(lines) do
      if line ~= "" and not line:match("^#") then
        is_empty = false
        break
      end
    end
    
    if is_empty then
      local ai_message = vim.fn.system("claude -p 'Look at the staged git changes and create a summarizing git commit title. Only respond with the title and no affirmation.' 2>/dev/null"):gsub("%s+$", "")
      if vim.v.shell_error == 0 and ai_message ~= "" then
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, {ai_message, ""})
        vim.notify("AI-generated commit message inserted", vim.log.levels.INFO)
      end
    end
  end
})

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
      { "<Leader>gg", "<CMD>Neogit<CR>", desc = "Neogit" },
      { "<Leader>gc", "<CMD>!git cai<CR>", desc = "Git commit with AI" },
      { "<Leader>gai", function()
        -- Generate AI commit message and open Neogit for review
        local ai_message = vim.fn.system("claude -p 'Look at the staged git changes and create a summarizing git commit title. Only respond with the title and no affirmation.' 2>/dev/null"):gsub("%s+$", "")
        if vim.v.shell_error == 0 and ai_message ~= "" then
          -- Store AI message in register for easy access
          vim.fn.setreg('"', ai_message)
          -- Open Neogit commit interface
          require('neogit').open({ "commit" })
          -- Notify user that AI message is in clipboard
          vim.notify("AI commit message ready in clipboard: " .. ai_message, vim.log.levels.INFO)
        else
          vim.notify("Failed to generate AI commit message", vim.log.levels.ERROR)
        end
      end, desc = "AI commit via Neogit" },
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
