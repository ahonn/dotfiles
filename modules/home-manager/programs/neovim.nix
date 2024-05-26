{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.neovim;
in {
  options.services.neovim = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    home.file = {
      ".config/nvim/init.lua" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../../config/nvim/init.lua;
      };
      ".config/nvim/lua" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../../config/nvim/lua;
      };
    };
  };
}
