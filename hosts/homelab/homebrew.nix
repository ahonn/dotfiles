{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  homebrew = {
    brews = [
      "gh"
      "uv"
    ];

    casks = [
      "1password"
      "raycast"
      "orbstack"
      "tailscale"
    ];
  };
}
