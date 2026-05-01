{ lib, config, ... }:
with lib;
let
  cfg = config.my.aerospace;
in
{
  options.my.aerospace = {
    enable = mkEnableOption "AeroSpace tiling window manager for macOS";
  };

  config = mkIf cfg.enable {
    home.file.".aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/config/aerospace/aerospace.toml";
  };
}
