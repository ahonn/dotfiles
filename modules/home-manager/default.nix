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
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/zellij.nix
    ./programs/neovim.nix
    ./programs/hyprspace.nix
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/zed-editor.nix
    ./programs/claude-code.nix
    ./programs/ghostty.nix
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
    devenv
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
    ".czrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/czrc.symlink";
    ".editorconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/editorconfig.symlink";
    ".prettierrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/prettierrc.symlink";
  };

  my.zsh.enable = true;
  my.git.enable = true;
  my.tmux.enable = true;
  my.zellij.enable = false;
  my.neovim.enable = true;
  my.hyprspace.enable = true;
  my.starship.enable = true;
  my.direnv.enable = true;
  my.zed-editor.enable = false;
  my.claude-code.enable = true;
  my.ghostty.enable = true;
}
