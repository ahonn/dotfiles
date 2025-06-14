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

    brews = [
      "nodejs"
      "python"
      "pipx"
      "make"
      "gcc"
      "uv"
      "gh"
    ];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "orion"
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
