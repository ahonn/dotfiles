{ ... }:
{
  imports = [
    ../../modules/home-manager/base.nix
    ../../modules/home-manager/programs/neovim-stable.nix
  ];

  # homelab-specific: use stable neovim for macOS 13 compatibility
  my.neovim-stable.enable = true;
}
