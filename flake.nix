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
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nix-homebrew,
    ...
  }:
  let
    system = "aarch64-darwin";
    user = {
      username = "yuexunjiang";
      homeDirectory = "/Users/yuexunjiang";
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    darwinConfigurations.workstation = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self user; };
      modules = [
        ./hosts/workstation/default.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.${user.username} = import ./hosts/workstation/home.nix;
        }
        nix-homebrew.darwinModules.nix-homebrew
        ./hosts/workstation/homebrew.nix
        ./modules/darwin
      ];
    };

    darwinConfigurations.homelab = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self user pkgs-stable; };
      modules = [
        ./hosts/homelab/default.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.extraSpecialArgs = { inherit pkgs-stable; };
          home-manager.users.${user.username} = import ./hosts/homelab/home.nix;
        }
        nix-homebrew.darwinModules.nix-homebrew
        ./hosts/homelab/homebrew.nix
        ./hosts/homelab/darwin.nix
      ];
    };

    darwinPackages = self.darwinConfigurations.workstation.pkgs;
  };
}
