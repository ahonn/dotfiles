{ inputs, ... }:
let
  inherit (inputs) nixpkgs homebrew-core homebrew-cask homebrew-bundle homebrew-services;
  homebrew-services-patched = nixpkgs.legacyPackages."aarch64-darwin".applyPatches {
    name = "homebrew-services-patched";
    src = homebrew-services;
    patches = [./homebrew-services.patch];
  };
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
      "homebrew/homebrew-services" = homebrew-services-patched;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
    };

    taps = [
      "nikitabobko/tap"
    ];

    brews = [
      "nodejs"
    ];

    casks = [
      "setapp"
      "1password"
      "google-chrome"
      "raycast"
      "telegram"
      "netnewswire"
      "fork"
      "orbstack"
      "alacritty"
      "tailscale"
      "visual-studio-code"
      "aerospace"
    ];
  };
}
