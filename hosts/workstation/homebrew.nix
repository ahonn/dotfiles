{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  # Brew pin lives in flake.nix + modules/homebrew/base.nix.
  # Co-update brew/core/cask: ./scripts/update-homebrew-inputs.sh

  homebrew = {
    brews = [
      "cocoapods"
      "gh"
      "herdr"
      "node"
      "repomix"
      "uv"
    ];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "badgeify"
      "raycast"
      "fork"
      "tailscale-app"
      "ghostty"
      "codex"
      "zed"
      "nikitabobko/tap/aerospace"
    ];
  };
}
