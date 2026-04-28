{
  config,
  lib,
  pkgs,
  user,
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
    ./programs/rtk.nix
  ];

  home.username = user.username;
  home.homeDirectory = user.homeDirectory;
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
    bun
    nodejs
    python3
    gh
    uv
    rtk
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  home.activation.installAcpx = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="${pkgs.nodejs}/bin:$PATH"
    if ! npm list -g acpx &>/dev/null; then
      npm install -g acpx
    fi
  '';

  home.file = {
    ".czrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/czrc.symlink";
    ".editorconfig".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/symlink/editorconfig.symlink";
  };

  my.zsh.enable = true;
  my.git.enable = true;
  my.tmux.enable = true;
  my.starship.enable = true;
  my.direnv.enable = true;
  my.claude-code.enable = true;
  my.rtk.enable = true;

}
