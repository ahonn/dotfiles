{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.direnv;
in {
  options.services.direnv = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      config = {
        global = {
            log_format = "-";
            log_filter = "^$";
        };
      };
    };
  };
}
