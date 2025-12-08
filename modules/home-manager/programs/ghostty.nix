{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.ghostty;
in {
  options.my.ghostty = {
    enable = mkEnableOption "Ghostty GPU-accelerated terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = null;
      enableZshIntegration = true;
      installBatSyntax = false;
      settings = {
        font-family = [
          "JetBrainsMono Nerd Font"
          "PingFang SC"
        ];
        font-size = 15;
        font-feature = "calt";
        font-style = "Light";
        font-style-bold = "Regular";
        font-style-italic = "Italic";
        font-thicken = true;
        window-decoration = true;
        macos-titlebar-style = "hidden";
        theme = "carbonfox";
        shell-integration = "zsh";
        macos-option-as-alt = true;
        cursor-style = "block";
        cursor-style-blink = false;
        copy-on-select = true;
        confirm-close-surface = false;
      };
      themes = {
        carbonfox = {
          background = "161616";
          foreground = "f2f4f8";
          cursor-color = "b6b8bb";
          selection-background = "2a2a2a";
          selection-foreground = "f2f4f8";
          palette = [
            "0=#282828"
            "1=#ee5396"
            "2=#25be6a"
            "3=#08bdba"
            "4=#78a9ff"
            "5=#be95ff"
            "6=#33b1ff"
            "7=#dfdfe0"
            "8=#484848"
            "9=#f16da6"
            "10=#46c880"
            "11=#2dc7c4"
            "12=#8cb6ff"
            "13=#c8a5ff"
            "14=#52bdff"
            "15=#e4e4e5"
          ];
        };
      };
    };
  };
}
