{ config, lib, pkgs, ... }:
with lib;
let
  homeDir = config.users.users.yuexunjiang.home;
in {
  options.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Simple hotkey daemon for macOS
      '';
    };
  };

  config = mkIf config.skhd.enable {
    services = {
      skhd = {
        enable = true;
        package = pkgs.skhd;
        skhdConfig = ''
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

          cmd + alt - h : yabai -m window --swap west
          cmd + alt - j : yabai -m window --swap south
          cmd + alt - k : yabai -m window --swap north
          cmd + alt - l : yabai -m window --swap east

          shift + alt - h : yabai -m space --focus prev
          shift + alt - l : yabai -m space --focus next
        '';
      };
    };

    launchd.user.agents.skhd.serviceConfig.StandardErrorPath = "${homeDir}/Library/Logs/skhd.stderr.log";
    launchd.user.agents.skhd.serviceConfig.StandardOutPath = "${homeDir}/Library/Logs/skhd.stdout.log";
  };
}
