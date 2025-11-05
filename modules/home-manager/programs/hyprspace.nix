{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.hyprspace;
in {
  options.my.hyprspace = {
    enable = mkEnableOption "HyprSpace tiling window manager for macOS";
  };

  config = mkIf cfg.enable {
    # HyprSpace is installed via Homebrew, so we just need to manage the config file
    home.file.".hyprspace.toml".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nix-darwin/config/hyprspace/hyprspace.toml";
  };
}
