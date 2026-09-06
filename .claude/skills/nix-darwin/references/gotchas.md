# Gotchas

## Build & System

### Nix builds cause UI jank on macOS

**Symptom:** Audio stuttering, cursor lag, general system slowness during `darwin-rebuild switch`.

**Fix:** Add to darwin config:
```nix
nix.daemonProcessType = "Background";
nix.daemonIOLowPriority = true;
```

### Determinate Nix conflicts with nix-darwin nix management

**Symptom:** Error about conflicting nix.conf or nix.package definitions.

**Cause:** Both Determinate Nix and nix-darwin try to manage the Nix daemon.

**Fix:** Disable nix-darwin's management:
```nix
nix.useDaemon = false;  # Let Determinate Nix handle the daemon
```

### `follows` not set causes closure bloat

**Symptom:** Slow evaluations, large `/nix/store` usage.

**Cause:** home-manager and nix-darwin each bring their own nixpkgs if `follows` is missing.

**Fix:** Always set `follows` for shared inputs:
```nix
home-manager.inputs.nixpkgs.follows = "nixpkgs";
nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
```

### darwin-rebuild switch fails after macOS update

**Symptom:** Various errors after upgrading macOS.

**Fix:**
```bash
# 1. Update nix-darwin to get macOS compatibility fixes
nix flake update nix-darwin

# 2. If nix itself is broken
curl -L https://nixos.org/nix/install | sh

# 3. Rebuild
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#hostname
```

## macOS Compatibility

### Unstable packages fail on homelab (macOS 13)

**Symptom:** Build error mentioning macOS version requirement.

**Cause:** homelab runs macOS 13 (Ventura), some unstable packages require 14+.

**Fix:** Use `pkgs-stable` for homelab-specific packages:
```nix
# In flake.nix, pass pkgs-stable via extraSpecialArgs
# In module, use pkgs-stable.neovim instead of pkgs.neovim
```

### PAM services not available on all hosts

**Symptom:** Error about PAM or fingerprint auth on homelab.

**Fix:** Override in host-specific darwin.nix:
```nix
security.pam.services.sudo_local.touchIdAuth = lib.mkForce false;
```

## Packages

### Neovim tree-sitter CLI missing

**Symptom:** `:TSInstall` fails with "tree-sitter CLI not found".

**Cause:** tree-sitter is a plugin dependency, not automatically in PATH.

**Fix:** Add to neovim extraPackages:
```nix
programs.neovim.extraPackages = with pkgs; [ tree-sitter nodejs ];
```

### Homebrew brew lags a tap (DSL errors)

**Symptom:** `undefined method 'if_path_exists'`, `openssl@3: unknown keyword: :overwrite`, `Cask 'aerospace' is unreadable: unknown keyword: :must_succeed`; `brew bundle` fails during activation.

**Cause:** brew and every tap are separate flake inputs. A tap updated past the locked brew uses keywords brew does not know yet. brew tracks `master` so a plain `nix flake update` keeps them aligned; drift only happens when a tap is updated alone (`nix flake update homebrew-cask`).

**Fix:** Update brew and the taps together:
```bash
./scripts/update-homebrew-inputs.sh   # or a full `nix flake update`
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation
./scripts/update-homebrew-inputs.sh --check
```
If brew `master` itself is broken, pin it temporarily in `flake.nix` (`github:Homebrew/brew/<tag>`) and drop the pin once fixed. `modules/homebrew/base.nix` names the build after the locked rev, so both forms work.

### brew bundle cleanup: "No available formula ... requires the tap"

**Symptom:** `Error: No available formula with the name "rjyo/moshi/moshi-hook". This command requires the tap rjyo/moshi.`

**Cause:** `mutableTaps = false`: nix-homebrew lays down only the declared taps, so a manually `brew tap`-ped tap vanishes on rebuild while its installed keg stays. `brew bundle --force-cleanup` then cannot load the orphaned keg's formula.

**Fix:** Declare the tap: add a `flake = false` input in `flake.nix`, register it in `nix-homebrew.taps` (`modules/homebrew/base.nix`), and list the package fully qualified (`tap/name`) in the host's `homebrew.brews`. If the tool is unwanted, delete `$(brew --cellar)/<name>` plus its `opt/` and `bin/` symlinks by hand instead.

### Homebrew cleanup removes nix-managed packages

**Symptom:** After `darwin-rebuild switch`, some brew packages disappear.

**Cause:** Homebrew's autoCleanup removes packages not in the Nix-declared list.

**Fix:** Either list all wanted packages in `homebrew.nix`, or disable cleanup.

### Homebrew cask vs nixpkgs conflict

**Symptom:** Same app installed twice, or version mismatch.

**Rule of thumb:**
- **nixpkgs**: CLI tools, libraries, development tools
- **homebrew casks**: GUI apps that need macOS integration (notarization, auto-update)
- **Never both** for the same package

## Nix Patterns

### mkForce vs mkDefault priority

```
mkDefault (1000) < normal (100) < mkForce (50)
```

- `mkDefault`: "use this unless something else is set" (base modules)
- Normal: standard assignment (host configs)
- `mkForce`: "override everything" (use sparingly, only for host-specific overrides)

### mkOutOfStoreSymlink requires absolute string

**Symptom:** Symlink points to `/nix/store/...` instead of the real path.

**Cause:** Using a nix path (`./config/nvim`) instead of a string.

**Fix:**
```nix
# Wrong
home.file.".config/nvim".source = ./config/nvim;

# Right
home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/.config/nix-darwin/config/nvim";
```

### Infinite recursion in module evaluation

**Symptom:** `error: infinite recursion encountered`.

**Common causes:**
1. Module `config` references its own `options` without `mkIf`
2. Two modules circularly depend on each other's config values
3. Using `config.X` in `options` definition

**Fix:** Always guard config with `mkIf`:
```nix
config = mkIf cfg.enable { ... };
```
