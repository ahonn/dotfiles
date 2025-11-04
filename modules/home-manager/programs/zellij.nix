{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zellij;
in {
  options.services.zellij = {
    enable = mkEnableOption "Zellij terminal workspace manager";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
  };
}
