# Program Module Template

Copy this to `modules/home-manager/programs/PROGRAM_NAME.nix`, replace all `PROGRAM_NAME` and `PROGRAM_DESCRIPTION` placeholders.

```nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.PROGRAM_NAME;
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";
in {
  options.my.PROGRAM_NAME = {
    enable = mkEnableOption "PROGRAM_DESCRIPTION";
  };

  config = mkIf cfg.enable {
    # Option A: Install package
    home.packages = with pkgs; [
      # package-name
    ];

    # Option B: Use programs.X for native home-manager support
    # programs.PROGRAM_NAME = {
    #   enable = true;
    # };

    # Option C: Symlink external config (editable without rebuild)
    # home.file.".config/PROGRAM_NAME".source =
    #   config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/PROGRAM_NAME";
  };
}
```

Then:
1. Import in `hosts/HOST/home.nix`
2. Set `my.PROGRAM_NAME.enable = true`
3. If it needs a GUI cask, add to `hosts/HOST/homebrew.nix`
