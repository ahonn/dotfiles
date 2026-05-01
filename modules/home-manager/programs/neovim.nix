{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.my.neovim;
in
{
  options.my.neovim = {
    enable = mkEnableOption "Neovim editor with language support and plugins";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      tree-sitter
    ];

    programs.zsh.shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    home.file.".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/config/nvim";
  };
}
