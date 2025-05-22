{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.aerospace;
in {
  options.services.aerospace = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.aerospace = {
      enable = true;
      userSettings = builtins.fromTOML (builtins.readFile ../../../config/aerospace/aerospace.toml);
    };
  };
}
