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

    brews = [
      "nodejs"
      "python"
      "pipx"
      "make"
      "gcc"
      "uv"
      "gh"
    ];

    taps = [
    ];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "badgeify"
      "raycast"
      "discord"
      "telegram"
      "fork"
      "orbstack"
      "tailscale"
    ];
  };
}
