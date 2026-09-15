# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

nix-darwin dotfiles repository managing macOS development environments via Nix flakes. Two hosts, `workstation` (primary dev machine) and `homelab` (Mac Mini), share base modules and add host-specific overrides.

## Where to Look

- Nix modules, hosts, packages, Homebrew, or `darwin-rebuild` failures: use the `nix-darwin` skill.
- `.claude/`, `config/`, and `symlink/` are linked with `mkOutOfStoreSymlink`, so edits apply without a rebuild. Adding or removing a skill directory is the exception: `~/.agents/skills` links are generated at evaluation time.
- Changes under `flake.nix`, `hosts/`, or `modules/` apply only after `darwin-rebuild switch`.

## Permissions

Run these without asking, and fix failures caused by your change:

- `nix eval --raw .#darwinConfigurations.<host>.system.drvPath` for each affected host. This is the evaluation check; `nix flake check` only checks formatting.
- `nix flake check` and `nix fmt`.

Confirm before running:

- `darwin-rebuild switch`: requires sudo and changes the live system.
- `nix-collect-garbage`: deletes rollback generations.
- `brew install`, `brew uninstall`, or `brew cleanup` against managed packages: Homebrew state is declared in `hosts/<host>/homebrew.nix`.

Update flake inputs only when the task is about updating them; `./scripts/update-homebrew-inputs.sh` keeps brew and its taps in step.

Git uses conventional commits via `cz commit` or `git cz`.
