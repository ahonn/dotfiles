{ ... }:
{
  imports = [ ../../modules/homebrew/base.nix ];

  homebrew = {
    casks = [
      "1password"
      "raycast"
      "orbstack"
      "tailscale"
    ];
  };
}
