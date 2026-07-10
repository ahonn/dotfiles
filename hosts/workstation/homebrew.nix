{ inputs, ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  # Core formulas can adopt newer DSL features before nix-homebrew updates its pin.
  nix-homebrew.package = inputs.homebrew-brew // {
    name = "brew-6.0.9";
    version = "6.0.9";
  };

  homebrew = {
    brews = [
      "cocoapods"
      "gh"
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
      "discord"
      "fork"
      "orbstack"
      "tailscale"
      "ghostty"
      "codex"
      "zed"
      "nikitabobko/tap/aerospace"
    ];
  };
}
