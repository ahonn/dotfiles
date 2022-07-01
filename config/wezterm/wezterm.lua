local wezterm = require 'wezterm';

return {
  enable_tab_bar = false,

  font = wezterm.font_with_fallback({
    "FiraCode Nerd Font",
    "Fira Code Retina",
  }),
  font_size = 15,

  color_scheme = "Gruvbox",
  color_schemes = {
    ["Gruvbox"] = {
      foreground = "#ebdbb2",
      background = "#282828",
      cursor_bg = "#928374",
      selection_bg = "#ebdbb2",
      selection_fg = "#657b83",
      ansi = {"#282828","#cc231c","#989719","#d79920","#448488","#b16185","#689d69","#a89983"},
      brights = {"#373b40","#fb4833","#b8ba25","#fabc2e","#83a597","#d3859a","#8ec07b","#ebdbb2"},
    }
  },
}
