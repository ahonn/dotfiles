local M = {
  {
    "nvim-neorg/neorg",
    version = "*",
    lazy = false,
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.qol.toc"] = {},
          ["core.journal"] = {
            config = {
              strategy = "flat"
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            }
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = os.getenv("NEORG_WORKSPACE")
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function()
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(0, "n", "<", "<Plug>(neorg.promo.demote.nested)", opts)
          vim.api.nvim_buf_set_keymap(0, "n", ">", "<Plug>(neorg.promo.promote.nested)", opts)
          vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", opts)
        end
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    keys = {
      { "<Leader>nn", "<Plug>(neorg.dirman.new-note)",            desc = "Create new note" },
      { "<Leader>no", "<CMD>Neorg journal today<CR>",             desc = "Open today's journal" },
      { "<Leader>nt", "<CMD>Neorg journal tomorrow<CR>",          desc = "Open tomorrow's journal" },
      { "<Leader>nw", "<Plug>(neorg.telescope.switch_workspace)", desc = "Switch workspace" },
      { "<Leader>np", "<Plug>(neorg.telescope.find_norg_files)",  desc = "Find Neorg files" },
    },
  }
}

return M
