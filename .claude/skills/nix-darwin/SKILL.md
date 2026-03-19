---
name: nix-darwin
description: "nix-darwin dotfiles configuration for macOS with Nix flakes and home-manager. Use when: adding/modifying programs, writing nix modules, editing host configs (workstation/homelab), debugging darwin-rebuild errors, managing homebrew packages via nix, or improving nix architecture."
user-invocable: false
---

# nix-darwin Configuration

## Architecture

Three-layer system: **darwin modules** (system) → **home-manager** (user) → **homebrew** (GUI apps).

```
flake.nix                          # Thin orchestration layer
├── hosts/workstation/             # Unstable packages, full toolchain
│   ├── default.nix → modules/darwin/
│   ├── home.nix    → modules/home-manager/base.nix + program modules
│   └── homebrew.nix → modules/homebrew/base.nix + host casks
└── hosts/homelab/                 # Stable packages (macOS 13), minimal
    ├── default.nix → modules/darwin/
    ├── darwin.nix                  # Host-specific overrides (mkForce)
    ├── home.nix    → modules/home-manager/base.nix + neovim-stable
    └── homebrew.nix
```

For full dependency flow and module layers, see `references/architecture.md`.

## Core Conventions

### Program Toggle Pattern

Every program module follows this structure (see `templates/program-module.nix`):

```nix
options.my.{program}.enable = mkEnableOption "description";
config = mkIf cfg.enable { /* config */ };
```

Enable in host's `home.nix`:
```nix
my.neovim.enable = true;
```

### Adding a New Program

1. Create `modules/home-manager/programs/{name}.nix` using template
2. Import it in the host's `home.nix`
3. Set `my.{name}.enable = true`
4. If it needs a GUI cask, add to `hosts/{host}/homebrew.nix`

### Configuration Management

| Method | When to Use | Example |
|--------|-------------|---------|
| `mkOutOfStoreSymlink` | Config that changes without rebuild | nvim, hyprspace |
| `builtins.readFile` | Config loaded into nix store | zed-editor |
| Inline nix | Simple, nix-native config | ghostty, starship |

### Naming Conventions

- Nix files: `kebab-case.nix`
- Module options: `my.{program}.enable`
- Dotfile symlinks: `{name}.symlink` in `symlink/`
- Hosts: `kebab-case`
- Commits: conventional (`feat(neovim):`, `fix(darwin):`)

## Essential Commands

See `references/commands.md` for full list.

```bash
# Apply configuration
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#homelab

# Validate without applying
nix flake check

# Update inputs
nix flake update
```

## Gotchas

See `references/gotchas.md` for detailed explanations and fixes.

**Build & System:**
- `nix.daemonProcessType = "Background"` prevents UI jank during builds
- Determinate Nix conflicts with nix-darwin's nix management — disable one
- `follows` not set correctly causes closure size bloat

**macOS Compatibility:**
- homelab (macOS 13) needs `pkgs-stable` — don't use unstable packages there
- PAM services may need `lib.mkForce {}` to override darwin defaults

**Packages:**
- Neovim tree-sitter CLI must be explicit in `extraPackages` (not auto-included)
- Homebrew cleanup can remove nix-managed packages — disable `autoCleanup`
- Homebrew cask vs nixpkgs: prefer nixpkgs for CLI tools, homebrew for GUI apps

**Nix Patterns:**
- `mkForce` vs `mkDefault` — mkForce wins over everything, use sparingly
- `mkOutOfStoreSymlink` paths must be absolute strings, not nix paths

## Community Patterns

When the user asks about improvements or alternative approaches, refer to `references/community-patterns.md`. Key patterns from high-star repos:

- **mkDarwinConfig helper** — reduces flake.nix boilerplate (malob, kclejeune)
- **Multi-channel overlay** — `pkgs.stable.X` anywhere vs specialArgs (malob)
- **Auto-import modules** — directory scanning eliminates manual import lists (wimpysworld)
- **Tag-based features** — declare what a host IS, not what it HAS (wimpysworld)
- **primaryUser alias** — write `hm.programs.X` instead of full path (kclejeune)
- **treefmt in flake** — deadnix + nixfmt + statix (kclejeune)
- **Automated flake lock updates** — CI auto-PR + auto-merge (wimpysworld)
