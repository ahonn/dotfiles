{ pkgs, lib, ... }:
{
  system.primaryUser = "yuexunjiang";

  security.pam.services = lib.mkForce {};

  environment.etc."pam.d/sudo_local".enable = lib.mkForce false;

  system.defaults.dock = {
    autohide = true;
    orientation = "left";
    persistent-apps = [];
    show-recents = false;
    minimize-to-application = true;
    tilesize = 48;
  };

  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv";
    FXEnableExtensionChangeWarning = false;
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 14;
    KeyRepeat = 1;
    NSDocumentSaveNewDocumentsToCloud = false;
    AppleShowAllExtensions = true;
  };

  system.defaults.screencapture.location = "~/Desktop";
}
