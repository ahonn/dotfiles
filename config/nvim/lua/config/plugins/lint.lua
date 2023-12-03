local M = {
  'mfussenegger/nvim-lint',
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      json = { 'jsonlint' },
      markdown = { 'markdownlint' },
    }

    vim.api.nvim_create_augroup("Lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = "Lint",
      callback = function()
        lint.try_lint()
      end,
    })
  end
}

return M
