{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.neovim;
in {
  options.my.neovim = {
    enable = mkEnableOption "Neovim editor with language support and plugins";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = [ pkgs.tree-sitter ];
    };

    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/config/nvim";
    };
  };
}
