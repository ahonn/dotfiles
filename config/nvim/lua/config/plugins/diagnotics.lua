local M = {
  {
    "folke/trouble.nvim",
    event = "BufWinEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<Leader>d", "<CMD>Trouble diagnostics<CR>", desc = "Diagnostics" },
    }
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()

      local function toggle_virtual_lines_on_hover()
        local current_cursor = vim.api.nvim_win_get_cursor(0)
        local current_line = current_cursor[1] - 1

        if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = current_line })) then
          vim.diagnostic.config({
            virtual_lines = false,
            virtual_text = true,
          })
        else
          vim.diagnostic.config({
            virtual_lines = { only_current_line = true },
            virtual_text = false,
          })
        end
      end

      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
      })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
        },
      })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = toggle_virtual_lines_on_hover,
      })
    end,
  }
}

return M
