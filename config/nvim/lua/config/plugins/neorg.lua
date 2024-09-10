local M = {
  {
    "nvim-neorg/neorg",
    version = "*",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.qol.toc"] = {},
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            }
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/Library/Mobile Documents/com~apple~CloudDocs/Notes",
              },
              default_workspace = "notes",
            },
          },
          ["core.integrations.telescope"] = {
            config = {
              insert_file_link = {
                show_title_preview = true,
              },
            }
          }
        },
      }
    end,
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
    keys = {
      { "<Leader>nw", "<Plug>(neorg.telescope.switch_workspace)" },
      { "<Leader>np", "<Plug>(neorg.telescope.find_norg_files)" }
    },
  }
}

return M
