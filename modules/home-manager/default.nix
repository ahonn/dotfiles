{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/wezterm.nix
  ];

  home.username = "yuexunjiang";
  home.homeDirectory = "/Users/yuexunjiang";
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  home.packages = with pkgs; [
    zsh
    git
    neovim
    tmux
    bat
    reattach-to-user-namespace
    ripgrep
    wezterm
  ];

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
    };
    ".config/fish" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../config/fish;
    };
    ".czrc" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../symlink/czrc.symlink;
    };
    ".editorconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../symlink/editorconfig.symlink;
    };
    ".prettierrc" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../symlink/prettierrc.symlink;
    };
  };

  services.zsh.enable = true;
  services.git.enable = true;
  services.tmux.enable = true;
  services.wezterm.enable = true;
}
