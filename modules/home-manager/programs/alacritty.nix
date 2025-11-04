{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.alacritty;
in {
  options.services.alacritty = {
    enable = mkEnableOption "Alacritty GPU-accelerated terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          import = [ pkgs.alacritty-theme.carbonfox ];
        };
        # terminal = {
        #   shell = {
        #     program = "/run/current-system/sw/bin/bash";
        #     args = [
        #       "-l"
        #       "-c"
        #       "tmux attach || tmux"
        #     ];
        #   };
        # };
        window = {
          decorations = "Buttonless";
          startup_mode = "Maximized";
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Light";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          size = 15;
        };
      };
    };
  };
}
