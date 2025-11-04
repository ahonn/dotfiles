 { lib, pkgs, config, ... }:
  with lib;
  let
    cfg = config.services.git;
  in {
    options.services.git = {
      enable = mkEnableOption "Git version control with difftastic integration";
    };

    config = mkIf cfg.enable {
      programs.git = {
        enable = true;
        settings = {
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
          alias = {
            cai = "!git commit -m \"$(claude -p '/commit')\"";
          };
        };
      };

      programs.difftastic = {
        enable = true;
        git.enable = true;
      };

      home.file.".gitignore_global" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../../symlink/gitignore_global.symlink;
      };
    };
  }
