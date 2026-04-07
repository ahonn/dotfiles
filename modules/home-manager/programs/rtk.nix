{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.rtk;
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";
in
{
  options.my.rtk = {
    enable = mkEnableOption "rtk (Rust Token Killer) configuration";
  };

  config = mkIf cfg.enable {
    home.file."Library/Application Support/rtk/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/rtk/config.toml";
  };
}
