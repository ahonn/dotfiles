{ pkgs, vars, ... }:
{
  imports = [
    ./modules/skhd.nix
    ./modules/yabai.nix
  ];

  skhd.enable = true;
  yabai.enable = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.persistent-apps = [];

  system.defaults.finder.AppleShowAllExtensions = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
