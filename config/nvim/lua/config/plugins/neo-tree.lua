return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "NeoTreeFocusToggle",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = {
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
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
    },
  },
  keys = {
    { "<C-b>", "<CMD>NeoTreeFocusToggle<CR>", desc = "NeoTree"},
  },
}
