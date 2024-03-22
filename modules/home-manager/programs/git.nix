{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.git;
in {
  options.services.git = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        user = {
          name = "ahonn";
          email = "yuexunjiang@gmail.com";
        };
        core = {
          ignoreCase = false;
          excludesfile = "~/.gitignore_global";
        };
        push = {
          default = "current";
        };
      };
      difftastic.enable = true;
    };

    home.file.".gitignore_global" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../../symlink/gitignore_global.symlink;
    };
  };
}
