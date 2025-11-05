{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.zellij;
in {
  options.my.zellij = {
    enable = mkEnableOption "Zellij terminal workspace manager";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
  };
}
