---
name: nix-darwin
description: Configure this macOS dotfiles repository's Nix modules, hosts, and packages, or diagnose darwin-rebuild failures.
user-invocable: false
---

# nix-darwin Configuration

Two hosts (`workstation`, `homelab`) are built by `mkDarwinConfig` in `flake.nix` from three layers: darwin modules (system) → home-manager (user) → nix-homebrew (GUI apps and taps). Both hosts share nixpkgs-unstable. Read the host's `home.nix` and `homebrew.nix` for what is currently enabled; do not rely on remembered program lists.

## Conventions

New programs follow [templates/program-module.md](templates/program-module.md): an `options.my.<program>.enable` module under `modules/home-manager/programs/`, imported by the host's `home.nix` and enabled there. Shared programs are imported by `modules/home-manager/base.nix` instead.

| Config delivery | When to use | Example |
|-----------------|-------------|---------|
| `mkOutOfStoreSymlink` | Config edited often, applied without rebuild | neovim, aerospace |
| `builtins.readFile` | Config copied into the Nix store | zed-editor |
| Inline Nix `settings` | Small, Nix-native config | ghostty, starship |

Naming: `kebab-case.nix` files and host names, `my.<program>.enable` options, `symlink/<name>.symlink` dotfiles, and conventional commit scopes such as `feat(neovim):` or `fix(darwin):`.

## Read by problem

| Problem or decision | Reference |
|---------------------|-----------|
| Where a module is wired in, or why the layout is shaped this way | [architecture.md](references/architecture.md) |
| Build, rollback, generations, input updates, garbage collection | [commands.md](references/commands.md) |
| `darwin-rebuild` or evaluation failure, Homebrew DSL or tap errors, macOS compatibility | [gotchas.md](references/gotchas.md) |
| The user asks how to restructure or improve the configuration | [community-patterns.md](references/community-patterns.md) — check each pattern's status in this repo first |

## Complete the change

Evaluate each affected host with `nix eval --raw .#darwinConfigurations.<host>.system.drvPath`. `nix flake check` only checks formatting and passes even when a host fails to evaluate; `nix fmt` fixes formatting. Changes under `modules/`, `hosts/`, or `flake.nix` take effect only after `darwin-rebuild switch`; follow the project CLAUDE.md for when that needs confirmation.
