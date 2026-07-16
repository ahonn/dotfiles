{ ... }:
{
  imports = [
    ../../modules/home-manager/base.nix
    ../../modules/home-manager/programs/neovim.nix
  ];

  my.neovim.enable = true;
}
