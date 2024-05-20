{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.wezterm;
in {
  options.services.wezterm = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      colorSchemes = {
        Carbonfox = {
          foreground = "#f2f4f8";
          background = "#161616";
          cursor_bg = "#f2f4f8";
          cursor_border = "#f2f4f8";
          cursor_fg = "#161616";
          compose_cursor = "#3ddbd9";
          selection_bg = "#2a2a2a";
          selection_fg = "#f2f4f8";
          scrollbar_thumb = "#7b7c7e";
          split = "#0c0c0c";
          visual_bell = "#f2f4f8";
          ansi = [ "#161616" "#ee5396" "#25be6a" "#08bdba" "#78a9ff" "#be95ff" "#33b1ff" "#dfdfe0" ];
          brights = [ "#484848" "#f16da6" "#46c880" "#2dc7c4" "#8cb6ff" "#c8a5ff" "#52bdff" "#e4e4e5" ];
        };
      };
      extraConfig =
        ''
          return {
            enable_tab_bar = false,
            font_size = 15,
            color_scheme = "Carbonfox",
          }
        '';
    };
  };
}
