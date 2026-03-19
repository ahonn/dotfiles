# Architecture Reference

## Dependency Flow

```
flake.nix
│
├── inputs
│   ├── nixpkgs (unstable)           # Primary packages
│   ├── nixpkgs-stable (24.11)       # For macOS 13 compat (homelab)
│   ├── nix-darwin                   # macOS system management
│   ├── home-manager                 # User environment
│   ├── nix-homebrew                 # Declarative Homebrew
│   └── homebrew-core/-cask/-bundle  # Pinned taps (flake = false)
│
├── workstation (darwinConfigurations)
│   ├── modules/darwin/default.nix   # Dock, Finder, keyboard, trackpad
│   ├── home-manager
│   │   ├── modules/home-manager/base.nix
│   │   │   ├── programs/zsh.nix        (shared)
│   │   │   ├── programs/git.nix        (shared)
│   │   │   ├── programs/tmux.nix       (shared)
│   │   │   ├── programs/starship.nix   (shared)
│   │   │   ├── programs/direnv.nix     (shared)
│   │   │   └── programs/claude-code.nix (shared)
│   │   ├── programs/neovim.nix         (unstable, workstation only)
│   │   ├── programs/hyprspace.nix      (workstation only)
│   │   ├── programs/zed-editor.nix     (workstation only)
│   │   └── programs/ghostty.nix        (workstation only)
│   └── homebrew: gh, repomix, rtk + GUI casks
│
└── homelab (darwinConfigurations)
    ├── modules/darwin/default.nix
    ├── hosts/homelab/darwin.nix      # Overrides (mkForce PAM, etc.)
    ├── home-manager
    │   ├── modules/home-manager/base.nix (shared)
    │   └── programs/neovim-stable.nix   (stable from pkgs-stable)
    └── homebrew: gh, uv + minimal casks
```

## Module Layers

| Layer | Location | Scope | Rebuild? |
|-------|----------|-------|----------|
| System (darwin) | `modules/darwin/` | macOS defaults, dock, finder, keyboard | Yes |
| User (home-manager) | `modules/home-manager/` | Programs, dotfiles, shell | Yes |
| Homebrew | `modules/homebrew/` | GUI apps, CLI not in nixpkgs | Yes |
| App configs | `config/` | nvim, hyprspace, zed | No (symlinked) |
| Dotfiles | `symlink/` | editorconfig, gitignore, prettier | No (symlinked) |
| Claude configs | `.claude/` | Skills, agents, hooks, settings | No (symlinked) |

## Key Design Decisions

**Why two nixpkgs channels?**
homelab runs macOS 13 which can't use some unstable packages. `pkgs-stable` passed via `extraSpecialArgs` only to homelab.

**Why `mkOutOfStoreSymlink`?**
Allows editing configs (nvim, hyprspace) without `darwin-rebuild switch`. Changes take effect immediately.

**Why nix-homebrew with pinned taps?**
`flake = false` inputs pin exact homebrew tap versions. `mutableTaps = true` still allows manual `brew install` for quick experiments.

**Why separate `hosts/{host}/darwin.nix`?**
homelab needs darwin-level overrides that don't apply to workstation (e.g., disabling PAM, different dock layout). Using `mkForce` in a separate file keeps it explicit.
