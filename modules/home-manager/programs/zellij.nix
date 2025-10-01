{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zellij;
in {
  options.services.zellij = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "tokyo-night-dark";
        pane_frames = false;
        default_shell = "zsh";
        copy_on_select = true;
        mouse_mode = true;

        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };

        themes = {
          tokyo-night-dark = {
            fg = "#a9b1d6";
            bg = "#1a1b26";
            black = "#32344a";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#ad8ee6";
            cyan = "#449dab";
            white = "#787c99";
            orange = "#ff9e64";
          };
        };
      };
    };

    home.file = {
      ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-drawin/config/zellij";
    };
  };
}
