 { lib, pkgs, config, ... }:
  with lib;
  let
    cfg = config.my.git;
  in {
    options.my.git = {
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
            cai = "claude -p '/commit' --model haiku";
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
