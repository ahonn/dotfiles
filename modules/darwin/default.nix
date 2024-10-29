{ pkgs, vars, ... }:
{
  imports = [];

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.persistent-apps = [];

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.magicmouse.MouseButtonMode = "TwoButton";
}
