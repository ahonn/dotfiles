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

    taps = [
      "homebrew/cask-fonts"
    ];

    brews = [];

    casks = [
      "setapp"
      "1password"
      "discord"
      "google-chrome"
      "raycast"
      "cloudflare-warp"

      # Dev
      "fork"
      "orbstack"
      "ollama"
      "wezterm"

      # Fonts
      "font-fira-code"
      "font-jetbrains-mono"
    ];
  };
}
