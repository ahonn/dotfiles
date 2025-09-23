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
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      viAlias = true;
      vimAlias = true;
    };

    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ../../../config/nvim;
    };
  };
}
