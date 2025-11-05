{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.direnv;
in {
  options.my.direnv = {
    enable = mkEnableOption "direnv for automatic environment loading";
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
