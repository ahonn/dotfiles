# Community Patterns

Best practices from high-star nix-darwin repos on GitHub. Reference these when the user asks about improving their config architecture.

## mkDarwinConfig Helper (malob 455★, kclejeune 515★)

Wrap host creation in a helper function to reduce flake.nix boilerplate:

```nix
# lib/mkDarwinConfig.nix
{ inputs, ... }:
{ hostname, username, extraModules ? [] }:
inputs.nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs username; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    ./hosts/${hostname}
  ] ++ extraModules;
};

# flake.nix — thin orchestration
darwinConfigurations = {
  workstation = mkDarwinConfig { hostname = "workstation"; username = "yuexun"; };
  homelab = mkDarwinConfig { hostname = "homelab"; username = "yuexun"; };
};
```

**When to adopt:** 3+ hosts, or when flake.nix exceeds ~80 lines of host definitions.

## Multi-Channel Overlay (malob 455★)

Access multiple nixpkgs versions from any module via overlays:

```nix
# In flake.nix overlays
overlays = [
  (final: prev: {
    stable = import inputs.nixpkgs-stable { system = prev.system; config = prev.config; };
  })
];

# In any module — no specialArgs needed
environment.systemPackages = [ pkgs.stable.neovim ];
```

**vs specialArgs approach:** Overlay is available everywhere automatically. specialArgs requires explicit threading through module arguments.

**When to adopt:** When multiple modules need stable packages, not just one host.

## Auto-Import Modules (wimpysworld 654★, MatthiasBenaets 730★)

Eliminate manual import lists by scanning directories:

```nix
# Simple auto-import (scan all .nix files in a directory)
imports = let
  entries = builtins.readDir ./.;
  nixFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n && n != "default.nix") entries;
  dirs = lib.filterAttrs (n: v: v == "directory") entries;
in
  (lib.mapAttrsToList (n: _: ./${n}) nixFiles)
  ++ (lib.mapAttrsToList (n: _: ./${n}) dirs);
```

Or use `import-tree` with `flake-parts`:
```nix
imports = [ (inputs.import-tree ./modules) ];
```

**When to adopt:** 10+ modules, or tired of maintaining import lists.

## primaryUser Alias (kclejeune 515★, malob 455★)

Avoid writing `home-manager.users.username` everywhere:

```nix
# modules/primary-user.nix
{ config, lib, ... }:
let cfg = config.user; in {
  options = {
    user.name = lib.mkOption { type = lib.types.str; };
    hm = lib.mkOption { type = lib.types.attrs; default = {}; };
  };
  config.home-manager.users.${cfg.name} = lib.mkAliasDefinitions config.hm;
};

# Usage anywhere:
hm.programs.git.enable = true;    # instead of home-manager.users.yuexun.programs.git.enable
```

**When to adopt:** When you find yourself typing the full home-manager path repeatedly.

## Tag-Based Feature Selection (wimpysworld 654★)

Declare what a host IS, features follow automatically:

```nix
# Host definition
noughty.host = {
  kind = "workstation";
  tags = [ "studio" "development" ];
};

# In feature modules
config = lib.mkIf (builtins.elem "studio" config.noughty.host.tags) {
  homebrew.casks = [ "obs" "davinci-resolve" ];
};
```

**vs `my.{program}.enable`:** Toggle pattern is explicit and clear for <15 programs. Tags scale better for 30+ features and cross-cutting concerns.

**When to adopt:** When host configs become long lists of enables/disables.

## makeOverridable for CI (malob 455★)

Derive CI config from real config without duplication:

```nix
darwinConfigurations.MaloBookPro = lib.makeOverridable inputs.nix-darwin.lib.darwinSystem { ... };

darwinConfigurations.githubCI = self.darwinConfigurations.MaloBookPro.override {
  username = "runner";
  extraModules = [{
    homebrew.enable = lib.mkForce false;
  }];
};
```

**When to adopt:** When setting up CI for your nix config.

## treefmt in Flake (kclejeune 515★)

Integrated formatting and linting:

```nix
# flake.nix with treefmt-nix
treefmt.config = {
  programs.deadnix.enable = true;     # Remove unused bindings
  programs.nixfmt.enable = true;      # Format nix files
  programs.statix.enable = true;      # Lint nix anti-patterns
  programs.shellcheck.enable = true;  # Lint shell scripts
};
```

Run with `nix fmt` or as pre-commit hook.

**When to adopt:** Immediately — catches dead code and anti-patterns early.

## Automated Flake Lock Updates (wimpysworld 654★)

```yaml
# .github/workflows/update-flake-lock.yml
on:
  schedule:
    - cron: '0 6 * * 1,3,5'  # Mon/Wed/Fri
jobs:
  update:
    uses: DeterminateSystems/update-flake-lock@main
    with:
      pr-title: "chore(flake): update inputs"
```

**When to adopt:** When you forget to `nix flake update` and run on stale inputs.

## Secrets Management (dustinlyons 3.4k★, eh8 428★)

Two common approaches:

**agenix** (dustinlyons):
```nix
age.secrets.my-secret = {
  file = ./secrets/my-secret.age;
  owner = "yuexun";
};
```

**sops-nix** (eh8, wimpysworld):
```nix
sops.secrets."my-secret" = {
  sopsFile = ./secrets/secrets.yaml;
  owner = "yuexun";
};
```

**When to adopt:** When you need to manage API keys, SSH keys, or other secrets declaratively.
