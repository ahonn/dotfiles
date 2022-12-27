return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    { "nvim-treesitter/playground", cmd ="TSPlaygroundToggle" },
  },
  config = {
    sync_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
		},
  },
}
