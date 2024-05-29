{ inputs, ... }:
let
  inherit (inputs) homebrew-core homebrew-cask homebrew-bundle;
in
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "yuexunjiang";
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/bundle" = homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [];
    brews = [];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "raycast"
      "telegram"
      "logseq"

      # Dev
      "fork"
      "orbstack"
      "alacritty"
      "tailscale"
    ];
  };
}
