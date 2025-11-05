# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **nix-darwin dotfiles repository** that manages a complete macOS development environment using Nix flakes. It provides declarative system configuration through modular Nix expressions.

## Essential Commands

### System Configuration
```bash
# Apply configuration changes (main command)
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#macos

# Update all flake inputs
nix flake update

# Check configuration without applying
nix flake check
```

### Git Workflow
This repository uses conventional commits via cz-cli:
```bash
# Create conventional commits
cz commit
# or
git cz
```

## Architecture

### Modular Structure
- **flake.nix**: Main entry point defining system configuration
- **modules/darwin/**: macOS system-level settings
- **modules/home-manager/**: User-level program configurations
- **modules/homebrew/**: Homebrew package management
- **config/**: Direct application configuration files (nvim, hyprspace, zed)
- **symlink/**: Dotfiles managed via out-of-store symlinks

### Program Configuration Pattern
Each program follows this pattern in `modules/home-manager/programs/`:
- Individual `.nix` file per program
- Enable/disable via `services.{program}.enable = true/false` in `default.nix`
- Configuration either inline in Nix or referencing files in `config/`

### Key Services
All services are toggled in `modules/home-manager/default.nix`:
- **neovim**: Primary editor with extensive Lua configuration
- **zsh**: Shell with starship prompt
- **git**: Version control with difftastic integration
- **tmux**: Terminal multiplexer
- **hyprspace**: Tiling window manager (enhanced AeroSpace fork)
- **alacritty**: Terminal emulator
- **claude-code**: Claude Code CLI integration

## Development Environment

### Core Tools
- **Editor**: Neovim (config in `config/nvim/`) with LSP, treesitter, and plugin ecosystem
- **Shell**: Zsh with starship prompt and custom aliases
- **Terminal**: Alacritty with tmux integration
- **Languages**: Node.js, Python (via homebrew), Rust (via rustup)
- **Git**: Enhanced with difftastic for diffs, conventional commits for messages

### Neovim Configuration
The Neovim setup (`config/nvim/`) is extensively configured with:
- Lazy.nvim for plugin management
- LSP integration with multiple language servers
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Git integration (gitsigns, git-blame)
- Copilot for AI assistance

## File Management

### Symlink Strategy
Dotfiles in `symlink/` are managed via `config.lib.file.mkOutOfStoreSymlink` allowing:
- Live editing without rebuilds
- Version control of configuration files
- Consistent management across different file types

### Configuration Updates
- **Nix modules**: Require system rebuild after changes
- **Direct configs** (nvim, hyprspace): Take effect immediately
- **Symlinked files**: Changes reflected immediately

## Platform Specifics

- **Target**: Apple Silicon macOS (aarch64-darwin)
- **Nix**: Flakes enabled with experimental features
- **Homebrew**: Integrated via nix-homebrew for macOS-specific applications
- **Fonts**: Nerd Fonts (Fira Code, JetBrains Mono) managed via Nix