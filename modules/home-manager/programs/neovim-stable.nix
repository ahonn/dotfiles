{ lib, pkgs, pkgs-stable, config, ... }:
with lib;
let
  cfg = config.my.neovim-stable;
in {
  options.my.neovim-stable = {
    enable = mkEnableOption "Neovim editor (stable version for macOS 13 compatibility)";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs-stable.neovim
      pkgs.nodejs
      pkgs.python3
      pkgs.ruby
    ];

    home.shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin/config/nvim";
    };
  };
}
