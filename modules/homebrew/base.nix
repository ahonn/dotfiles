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
    ;

  # Single source of truth: flake.nix `homebrew-brew` URL tag (locked in flake.lock).
  # Do not hardcode the version here — bump via scripts/update-homebrew-inputs.sh.
  flakeLock = builtins.fromJSON (builtins.readFile ../../flake.lock);
  brewVersion = flakeLock.nodes.homebrew-brew.original.ref;
in
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user.username;
    autoMigrate = true;
    mutableTaps = false;
    # Pin brew to the flake input so core/cask DSL stays parseable.
    package = homebrew-brew // {
      name = "brew-${brewVersion}";
      version = brewVersion;
    };
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "nikitabobko/homebrew-tap" = homebrew-nikitabobko;
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
