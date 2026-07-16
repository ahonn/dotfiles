local javascript_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

local function has_linting_lsp(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == "biome" or client.name == "eslint" then
      return true
    end
  end

  return false
end

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        css = { "biome", "prettier", stop_after_first = true },
        graphql = { "prettier" },
        html = { "biome", "prettier", stop_after_first = true },
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
        markdown = { "prettier" },
        scss = { "prettier" },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        yaml = { "prettier" },
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
      },
    },
    keys = {
      {
        "<Leader>f",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local eslint_namespace = lint.get_namespace("eslint")
      local javascript_lookup = {}
      local eslint = lint.linters.eslint

      eslint.cmd = function()
        local local_eslint = vim.fn.fnamemodify("./node_modules/.bin/eslint", ":p")
        if (vim.uv or vim.loop).fs_stat(local_eslint) then
          return local_eslint
        end

        return vim.fn.stdpath("data")
          .. "/mason/packages/eslint_d/node_modules/eslint_d/node_modules/.bin/eslint"
      end

      for _, filetype in ipairs(javascript_filetypes) do
        javascript_lookup[filetype] = true
      end

      local function clear_eslint(bufnr, retries)
        retries = retries or 20

        if retries > 0 and vim.tbl_contains(lint.get_running(bufnr), "eslint") then
          vim.defer_fn(function()
            clear_eslint(bufnr, retries - 1)
          end, 50)
          return
        end

        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.diagnostic.reset(eslint_namespace, bufnr)
        end
      end

      local function lint_buffer(bufnr)
        if not javascript_lookup[vim.bo[bufnr].filetype] then
          return
        end

        if has_linting_lsp(bufnr) then
          clear_eslint(bufnr)
          return
        end

        vim.api.nvim_buf_call(bufnr, function()
          lint.try_lint("eslint")
        end)
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function(args)
          lint_buffer(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and (client.name == "biome" or client.name == "eslint") then
            clear_eslint(args.buf)
          end
        end,
      })
    end,
  },
}
