{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  homebrew = {
    brews = [
      "gh"
      "uv"
    ];

    taps = [
      "BarutSRB/tap"
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
      "BarutSRB/tap/hyprspace"
    ];
  };
}
