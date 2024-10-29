{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.aerospace;
in {
  options.services.aerospace = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".config/aerospace" = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/config/aerospace";
        recursive = true;
      };
    };
  };
}
