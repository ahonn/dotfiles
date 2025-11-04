{ pkgs, ... }:
{
  imports = [];

  system.primaryUser = "yuexunjiang";

  # Dock configuration
  system.defaults.dock = {
    autohide = true;
    orientation = "left";
    persistent-apps = [];
    show-recents = false;
    minimize-to-application = true;
    tilesize = 48;
  };

  # Finder configuration
  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv";
    FXEnableExtensionChangeWarning = false;
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true;
  };

  # Keyboard and input
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Mouse configuration
  system.defaults.magicmouse.MouseButtonMode = "TwoButton";

  # Global domain settings
  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 14;
    KeyRepeat = 1;
    NSDocumentSaveNewDocumentsToCloud = false;
    AppleShowAllExtensions = true;
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;
  };

  # Security settings
  system.defaults.screencapture.location = "~/Desktop";

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadThreeFingerDrag = true;
  };

  # Mission Control
  system.defaults.spaces.spans-displays = false;
}
