{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.alacritty;
in {
  options.services.alacritty = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        import = [ pkgs.alacritty-theme.carbonfox ];
        shell = {
          program = "/run/current-system/sw/bin/bash";
          args = [
            "-l"
            "-c"
            "tmux attach || tmux"
          ];
        };
        window = {
          startup_mode = "Fullscreen";
          opacity = 0.8;
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
