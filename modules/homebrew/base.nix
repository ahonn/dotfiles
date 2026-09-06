{
  inputs,
  user,
  config,
  ...
}:
let
  inherit (inputs)
    homebrew-brew
    homebrew-core
    homebrew-cask
    homebrew-bundle
    homebrew-nikitabobko
    homebrew-moshi
    ;

  # homebrew-brew floats (see flake.nix); name the build after the locked rev
  # so `brew-<date>-<rev>-patched` in the store tells which brew is installed.
  brewVersion = "${builtins.substring 0 8 homebrew-brew.lastModifiedDate}-${homebrew-brew.shortRev}";
in
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user.username;
    autoMigrate = true;
    mutableTaps = false;
    # Build brew from the flake input so it is locked together with the taps.
    package = homebrew-brew // {
      name = "brew-${brewVersion}";
      version = brewVersion;
    };
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "nikitabobko/homebrew-tap" = homebrew-nikitabobko;
      "rjyo/homebrew-moshi" = homebrew-moshi;
    };
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    global.brewfile = true;
  };
}
