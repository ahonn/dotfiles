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
    ./programs/zellij.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/aerospace.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/zed-editor.nix
    ./programs/claude-code.nix
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
    # Core CLI tools
    bat
    eza
    cloc
    ripgrep
    difftastic

    # Development tools
    devbox
    cz-cli
    codex
    rustup
    nodejs
    python3
    python3Packages.pipx
    nodePackages.conventional-changelog-cli

    # Fonts
    # https://www.reddit.com/r/NixOS/comments/1h1nc2a/comment/lzdxhx5/
    # (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  home.file = {
    ".czrc".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/czrc.symlink;
    ".editorconfig".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/editorconfig.symlink;
    ".prettierrc".source = config.lib.file.mkOutOfStoreSymlink ../../symlink/prettierrc.symlink;
  };

  services.zsh.enable = true;
  services.git.enable = true;
  services.tmux.enable = true;
  services.zellij.enable = false;
  services.neovim.enable = true;
  services.aerospace.enable = true;
  services.alacritty.enable = true;
  services.starship.enable = true;
  services.direnv.enable = true;
  services.zed-editor.enable = false;
  services.claude-code.enable = true;
}
