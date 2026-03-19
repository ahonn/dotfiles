# Commands Reference

## Build & Apply

```bash
# Apply to workstation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation

# Apply to homelab
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#homelab

# Dry run (show what would change, don't apply)
sudo nix run nix-darwin/master#darwin-rebuild -- build --flake .#workstation

# Rollback to previous generation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --rollback
```

## Flake Management

```bash
# Validate flake
nix flake check

# Update all inputs
nix flake update

# Update single input
nix flake update nixpkgs
nix flake update nix-darwin

# Show flake metadata
nix flake metadata

# Show flake outputs
nix flake show
```

## Debugging

```bash
# Evaluate without building (fast syntax check)
nix eval .#darwinConfigurations.workstation.system

# Build with verbose output
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation --show-trace

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Check what a package provides
nix-store -qR $(which some-binary)

# Search nixpkgs for a package
nix search nixpkgs some-package
```

## Garbage Collection

```bash
# Remove old generations (keep last 7 days)
sudo nix-collect-garbage --delete-older-than 7d

# Remove all old generations
sudo nix-collect-garbage -d

# Optimize nix store (deduplicate)
nix store optimise
```

## Homebrew (managed by nix-homebrew)

```bash
# List installed brews/casks (should match homebrew.nix)
brew list
brew list --cask

# Check for outdated packages
brew outdated

# Note: Don't use `brew install/uninstall` for managed packages.
# Edit homebrew.nix instead, then darwin-rebuild switch.
```
