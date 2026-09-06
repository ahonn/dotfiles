{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  # Third-party packages need their tap declared as a flake input and
  # registered in modules/homebrew/base.nix (mutableTaps = false).

  homebrew = {
    brews = [
      "cocoapods"
      "gh"
      "herdr"
      "node"
      "repomix"
      "rjyo/moshi/moshi-hook"
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
