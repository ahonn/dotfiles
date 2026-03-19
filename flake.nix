{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";

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
      nixpkgs-stable,
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

      overlays = [
        (_final: prev: {
          stable = import nixpkgs-stable {
            inherit (prev) system;
            inherit (prev) config;
          };
        })
      ];

      mkDarwinConfig =
        {
          hostname,
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs self user; };
          modules = [
            { nixpkgs.overlays = overlays; }
            ./hosts/${hostname}/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
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
