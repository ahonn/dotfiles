return {
  "sidebar-nvim/sidebar.nvim",
  config = {
    disable_default_keybindings = 0,
    open = true,
    side = "right",
    update_interval = 500,
    sections = { "git", "diagnostics", "todos", "symbols" },
    section_separator = { "", "-----", "" },
    section_title_separator = { "" },
    todos = {
      ignored_paths = { "~" },
      initially_closed = false,
    },
    bindings = { ["q"] = function() require("sidebar-nvim").close() end }
  },
}
