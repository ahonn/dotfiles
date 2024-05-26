{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.neovim;
  lazy-nix-helper-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy-nix-helper.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "b-src";
      repo = "lazy-nix-helper.nvim";
      rev = "main";
      hash = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
    };
  };
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
