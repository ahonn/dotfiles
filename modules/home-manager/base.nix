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
    ./programs/starship.nix
    ./programs/direnv.nix
    ./programs/claude-code.nix
  ];

  home.username = "yuexunjiang";
  home.homeDirectory = "/Users/yuexunjiang";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    difftastic
    devenv
    cz-cli
    codex
    rustup
    nodejs
    python3
    nodePackages.conventional-changelog-cli
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  home.file = {
    ".czrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/czrc.symlink";
    ".editorconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/editorconfig.symlink";
  };

  my.zsh.enable = true;
  my.git.enable = true;
  my.tmux.enable = true;
  my.starship.enable = true;
  my.direnv.enable = true;
  my.claude-code.enable = true;

}
