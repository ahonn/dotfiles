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
    };
  };
}
