{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.rustup;
in {
  options.services.rustup = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.rustup = {
      enable = true;
      toolchains = {
          stable = {
              components = [ "clippy"];
          };
      };
      defaultToolchain = "stable";
    };
  };
}
