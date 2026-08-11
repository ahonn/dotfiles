{ lib, config, ... }:
with lib;
let
  cfg = config.my.herdr;
  # Out-of-store symlink: tweak keybindings without a rebuild.
  herdrConfig = "${config.home.homeDirectory}/.config/nix-darwin/config/herdr/config.toml";
in
{
  options.my.herdr = {
    enable = mkEnableOption "Herdr agent terminal runtime (tmux-aligned keys)";
  };

  config = mkIf cfg.enable {
    # Package is installed via Homebrew (hosts/*/homebrew.nix) for a newer
    # release track than nixpkgs; this module only manages config.
    xdg.configFile."herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink herdrConfig;
  };
}
