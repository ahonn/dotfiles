return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "NeoTreeFocusToggle",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  init = function()
    vim.api.nvim_set_keymap("n", "<C-b>", "<CMD>NeoTreeFocusToggle<CR>", { noremap = true })
  end,
  config = {
    window = {
      mappings = {
        ["o"] = "open",
        ["s"] = "open_split",
        ["i"] = "open_vsplit",
      },
    },
    filesystem = {
      follow_current_file = true,
      hijack_netrw_behavior = "open_current",
    },
  },
}
