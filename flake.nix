{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pin to a stable brew *tag* (not master). Version is the single source of truth;
    # modules/homebrew/base.nix reads it from flake.lock. Never update homebrew-core
    # without also bumping this tag — use: ./scripts/update-homebrew-inputs.sh
    homebrew-brew = {
      url = "github:Homebrew/brew/6.0.15";
      flake = false;
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Always co-update with homebrew-brew (see scripts/update-homebrew-inputs.sh).
    # Floating core + stale brew pin → DSL errors (if_path_exists, overwrite:).
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
    homebrew-nikitabobko = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";
      user = {
        username = "yuexunjiang";
        homeDirectory = "/Users/yuexunjiang";
      };

      mkDarwinConfig =
        {
          hostname,
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs self user; };
          modules = [
            ./hosts/${hostname}/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user.username} = import ./hosts/${hostname}/home.nix;
            }
            nix-homebrew.darwinModules.nix-homebrew
            ./hosts/${hostname}/homebrew.nix
            ./modules/darwin
          ]
          ++ extraModules;
        };

      treefmtEval = treefmt-nix.lib.evalModule (import nixpkgs { inherit system; }) {
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        programs.statix.enable = true;
      };
    in
    {
      darwinConfigurations.workstation = mkDarwinConfig {
        hostname = "workstation";
      };

      darwinConfigurations.homelab = mkDarwinConfig {
        hostname = "homelab";
        extraModules = [ ./hosts/homelab/darwin.nix ];
      };

      darwinPackages = self.darwinConfigurations.workstation.pkgs;
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
