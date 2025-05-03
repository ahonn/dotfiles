local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "AndreM222/copilot-lualine",
    "dokwork/lualine-ex"
  },
  config = function()
    local diff = {
      "diff",
      diff_color = {
        added = "LualineGitAdd",
        modified = "LualineGitChange",
        removed = "LualineGitDelete",
      },
    }
    local FilenamePath = {
      filename_only = 0,
      relative_path = 1,
      absolute_path = 2,
    }

    local function filename(path)
      return {
        "filename",
        path = path,
      }
    end

    require("lualine").setup({
      options = {
        disabled_filetypes = { 'neo-tree' },
      },
      sections = {
        lualine_b = { "branch", diff },
        lualine_c = { filename(FilenamePath.relative_path) },
        lualine_x = {
          'ex.lsp.single',
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
          },
          "filetype",
          {
            'copilot',
            symbols = {
              spinners = "dots",
              spinner_color = "#6272A4"
            },
            show_colors = true,
            show_loading = true
          },
        },
      },
      inactive_sections = {
        lualine_c = { filename(FilenamePath.absolute_path) },
      },
      extensions = { "nvim-tree", "quickfix", "toggleterm", "fugitive" },
    })
  end,
}

return M
