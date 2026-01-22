{
  config,
  pkgs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";
in
{
  imports = [
    ../../modules/home-manager/base.nix
    ../../modules/home-manager/programs/zellij.nix
    ../../modules/home-manager/programs/neovim.nix
    ../../modules/home-manager/programs/hyprspace.nix
    ../../modules/home-manager/programs/zed-editor.nix
    ../../modules/home-manager/programs/ghostty.nix
  ];

  # workstation-specific packages
  home.packages = with pkgs; [
    cloc
    python3Packages.pipx
    nodePackages.repomix
  ];

  home.file = {
    ".prettierrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/prettierrc.symlink";
  };

  # workstation-specific programs
  my.zellij.enable = false;
  my.neovim.enable = true;
  my.hyprspace.enable = true;
  my.zed-editor.enable = false;
  my.ghostty.enable = true;
}
