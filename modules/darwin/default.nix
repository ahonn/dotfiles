{ pkgs, vars, ... }:
{
  imports = [
    ./modules/skhd.nix
    ./modules/yabai.nix
  ];

  skhd.enable = true;
  yabai.enable = true;
}
