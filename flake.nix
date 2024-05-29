{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    alacritty-theme,
    ...
  }:
  let
    configuration = { pkgs, ... }: {
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [];
      programs.zsh.enable = true;

      users.users.yuexunjiang = {
        name = "yuexunjiang";
        home = "/Users/yuexunjiang";
        shell = pkgs.zsh;
      };
    };
  in
  {
    darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        configuration
        ({ config, pkgs, ...}: {
          nixpkgs.overlays = [
            alacritty-theme.overlays.default
          ];
        })
        home-manager.darwinModules.home-manager  {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.yuexunjiang = import ./modules/home-manager;
        }
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/homebrew
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.macbook.pkgs;
  };
}
