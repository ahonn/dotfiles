return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ["o"] = "open",
          ["s"] = "open_split",
          ["i"] = "open_vsplit",
          ["ma"] = "add",
          ["md"] = "delete",
          ["mm"] = "move",
          ["mc"] = "copy",
          ["mp"] = "paste_from_clipboard",
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      hijack_netrw_behavior = "open_current",
    },
    event_handlers = {
      {
        event = "vim_buffer_enter",
        handler = function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd("setlocal statuscolumn=")
          end
        end,
      },
    }
  },
  keys = {
    { "<C-b>", "<CMD>Neotree toggle<CR>", desc = "NeoTree" },
  },
}
