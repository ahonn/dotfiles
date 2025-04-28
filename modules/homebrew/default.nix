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
    mutableTaps = true;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
    };

    taps = [
      "nikitabobko/tap"
    ];

    brews = [
      "nodejs"
      "make"
      "gcc"
    ];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "raycast"
      "telegram"
      "netnewswire"
      "fork"
      "orbstack"
      "alacritty"
      "tailscale"
      "visual-studio-code"
      "aerospace"
    ];
  };
}
