{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  homebrew = {
    brews = [
      "gh"
      "node"
      "repomix"
      "rtk"
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
      "BarutSRB/tap/hyprspace"
    ];
  };
}
