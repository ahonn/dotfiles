{
  config,
  pkgs,
  stdenv,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}:
{
  nix-homebrew = {
    inherit user;
    enable = true;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
  };
}
