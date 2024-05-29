local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "arkav/lualine-lsp-progress",
  },
}

function M.config()
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
        {
          'lsp_progress',
          display_components = { 'lsp_client_name' }
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic", "coc" },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
        "encoding",
        { "filetype", separator = { right = "" }, right_padding = 0 },
      },
    },
    inactive_sections = {
      lualine_c = { filename(FilenamePath.absolute_path) },
    },
    extensions = { "nvim-tree", "quickfix", "toggleterm", "fugitive" },
  })
end

return M
