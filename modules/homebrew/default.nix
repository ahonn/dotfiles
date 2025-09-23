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
      # Keep macOS-specific tools
      "gh"
      # Development tools moved to Nix where possible
      # "nodejs" - available in nixpkgs
      # "python" - available in nixpkgs
      # "pipx" - available in nixpkgs
      "make"  # Keep for compatibility
      "gcc"   # Keep for system compilation
      "uv"    # Python package manager
    ];

    taps = [
    ];

    casks = [
      "setapp"
      # "1password"
      "google-chrome"
      "badgeify"
      "raycast"
      "discord"
      "fork"
      "orbstack"
      # "tailscale"
    ];
  };
}
