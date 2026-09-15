# Architecture Reference

## Dependency Flow

```
flake.nix                            # mkDarwinConfig { hostname, extraModules }
│
├── inputs
│   ├── nixpkgs (unstable)           # Single channel shared by both hosts
│   ├── nix-darwin                   # macOS system management
│   ├── home-manager                 # User environment
│   ├── nix-homebrew                 # Declarative Homebrew
│   ├── homebrew-brew                # brew itself, tracks master (flake = false)
│   ├── homebrew-*                   # Taps (flake = false), updated together with homebrew-brew
│   └── treefmt-nix                  # nixfmt + deadnix + statix (`nix fmt`, `nix flake check`)
│
├── workstation
│   ├── hosts/workstation/default.nix
│   ├── modules/darwin/              # Dock, Finder, keyboard, trackpad
│   ├── hosts/workstation/home.nix   # base.nix + workstation program modules
│   └── hosts/workstation/homebrew.nix → modules/homebrew/base.nix
│
└── homelab
    ├── hosts/homelab/default.nix
    ├── modules/darwin/
    ├── hosts/homelab/darwin.nix     # extraModules: host overrides (mkForce PAM, etc.)
    ├── hosts/homelab/home.nix       # base.nix + shared neovim module
    └── hosts/homelab/homebrew.nix → modules/homebrew/base.nix
```

The current program list lives in the `imports` of `modules/home-manager/base.nix` (shared) and each `hosts/<host>/home.nix` (host-specific, toggled with `my.<program>.enable`).

## Module Layers

| Layer | Location | Scope | Rebuild? |
|-------|----------|-------|----------|
| System (darwin) | `modules/darwin/` | macOS defaults, dock, finder, keyboard | Yes |
| User (home-manager) | `modules/home-manager/` | Programs, dotfiles, shell | Yes |
| Homebrew | `modules/homebrew/` | GUI apps, CLI not in nixpkgs | Yes |
| App configs | `config/` | nvim, aerospace, zed | No (symlinked) |
| Dotfiles | `symlink/` | editorconfig, gitignore, prettier | No (symlinked) |
| Claude configs | `.claude/` | Skills, agents, hooks, settings | No (symlinked); adding or removing a skill directory needs a rebuild to update `~/.agents/skills` |

## Key Design Decisions

**Why one nixpkgs channel?**
Both hosts use nixpkgs-unstable. homelab previously had a separate `nixpkgs-stable` input and `neovim-stable` module; both were removed once homelab could import the shared neovim module. If a package fails on homelab, see the macOS compatibility entry in `gotchas.md` before reintroducing a second channel.

**Why `mkOutOfStoreSymlink`?**
Allows editing configs (nvim, aerospace) without `darwin-rebuild switch`. Changes take effect immediately.

**Why nix-homebrew with brew and taps as flake inputs?**
`flake = false` inputs lock brew and every tap in `flake.lock`. brew tracks master so `nix flake update` moves it together with the taps; a brew that lags its taps fails on new DSL keywords. `mutableTaps = false` means only declared taps exist, so a manual `brew tap` disappears on the next rebuild.

**Why separate `hosts/{host}/darwin.nix`?**
homelab needs darwin-level overrides that don't apply to workstation (e.g., disabling PAM, different dock layout). Using `mkForce` in a separate file keeps it explicit.
