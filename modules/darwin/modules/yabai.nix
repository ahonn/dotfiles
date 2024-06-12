{ config, lib, pkgs, ... }:
with lib;
let
  homeDir = config.users.users.yuexunjiang.home;
in {
  options.yabai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Tiling Window Manager for MacOS
      '';
    };
  };

  config = mkIf config.yabai.enable {
    services = {
      yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;
        config = {
          layout = "bsp";
          window_placement = "second_child";
          top_padding = "5";
          bottom_padding = "5";
          left_padding = "5";
          right_padding = "5";
          window_gap = "5";
        };
        extraConfig = ''
          yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
          sudo yabai --load-sa

          yabai -m rule --add app="^System Settings$"    manage=off
          yabai -m rule --add app="^System Information$" manage=off
          yabai -m rule --add app="^System Preferences$" manage=off
          yabai -m rule --add app="^Screen Sharing$" manage=off
          yabai -m rule --add title="Preferences$"       manage=off
          yabai -m rule --add title="Settings$"          manage=off

          yabai -m rule --add app="^Setapp$"    manage=off
          yabai -m rule --add app="^Step Two$"    manage=off
        '';
      };
    };

    launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "${homeDir}/Library/Logs/yabai.stderr.log";
    launchd.user.agents.yabai.serviceConfig.StandardOutPath = "${homeDir}/Library/Logs/yabai.stdout.log";
  };
}
