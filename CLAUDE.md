# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

nix-darwin dotfiles repository managing macOS development environments via Nix flakes. Supports multiple hosts with shared base modules and host-specific overrides.

## Essential Commands

```bash
# Apply configuration (workstation - primary dev machine)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation

# Apply configuration (homelab - Mac Mini server)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#homelab

# Update flake inputs
nix flake update

# Validate without applying
nix flake check

# Fetch secrets from 1Password (run after rebuild or manually)
fetch-secrets
```

Git uses conventional commits via `cz commit` or `git cz`.

## Architecture

### Host Configuration Flow
```
flake.nix
├── hosts/workstation/     # Primary dev machine
│   ├── home.nix          # Imports base + workstation programs
│   └── homebrew.nix      # Workstation-specific casks/brews
└── hosts/homelab/         # Mac Mini (macOS 13, uses stable neovim)
    ├── home.nix
    └── homebrew.nix
```

### Module Layers
- **modules/darwin/**: System-level (nix settings, system defaults)
- **modules/home-manager/base.nix**: Shared user config (zsh, git, tmux, starship, direnv, claude-code)
- **modules/home-manager/programs/**: Individual program modules
- **modules/homebrew/base.nix**: Shared homebrew config

### Program Toggle Pattern
Programs use `my.{program}.enable` in host's `home.nix`:
```nix
my.neovim.enable = true;      # workstation: unstable neovim
my.neovim-stable.enable = true; # homelab: stable for macOS 13
my.hyprspace.enable = true;
```

### File Types
| Location | Rebuild Required | Use Case |
|----------|-----------------|----------|
| `modules/**/*.nix` | Yes | Nix expressions |
| `config/` | No | App configs (nvim, hyprspace, zed) |
| `symlink/` | No | Dotfiles via mkOutOfStoreSymlink |

## Secrets Management

Secrets fetched from 1Password via `fetch-secrets` script. Configure in `modules/home-manager/base.nix`:
```nix
opSecrets = {
  CONTEXT7_API_KEY = "op://Personal/Context7/credential";
  EXA_API_KEY = "op://Personal/Exa/credential";
};
```
Secrets stored in `~/.config/nix-secrets/env.zsh`, sourced by zsh.