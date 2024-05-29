{
  config,
  pkgs,
  stdenv,
  ...
}:
{
  imports = [
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/starship.nix
    ./programs/direnv.nix
  ];

  home.username = "yuexunjiang";
  home.homeDirectory = "/Users/yuexunjiang";
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    cloc
    devbox
    ripgrep
    cz-cli
    nodePackages.conventional-changelog-cli
    difftastic
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  home.file = {
    ".czrc".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/czrc.symlink;
    ".editorconfig".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/editorconfig.symlink;
    ".prettierrc".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/prettierrc.symlink;

    # RIME
    "Library/Rime/default.custom.yaml".source = config.lib.file.mkOutOfStoreSymlink ../../rime/default.custom.yaml;
    "Library/Rime/squirrel.custom.yaml".source = config.lib.file.mkOutOfStoreSymlink ../../rime/squirrel.custom.yaml;
  };

  services.zsh.enable = true;
  services.git.enable = true;
  services.tmux.enable = true;
  services.neovim.enable = true;
  services.alacritty.enable = true;
  services.starship.enable = true;
  services.direnv.enable = true;
}
