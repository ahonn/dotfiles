{
  inputs,
  user,
  config,
  ...
}:
let
  inherit (inputs)
    homebrew-core
    homebrew-cask
    homebrew-bundle
    ;
in
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user.username;
    autoMigrate = true;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    global.brewfile = true;
  };
}
