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
            signingkey = "43EAF127BC5EEB2FA0C4134FBD5538FCA987E538";
          };
          core = {
            ignoreCase = false;
            excludesfile = "~/.gitignore_global";
          };
          push = {
            default = "current";
          };
          alias = {
            cai = "!git commit -m \"$(claude -p 'Look at the staged git changes and create a summarizing git commit title. Only respond with the title and no affirmation.')\"";
          };
          commit = {
            gpgsign = true;
          };
          gpg = {
            program = "${pkgs.gnupg}/bin/gpg";
            format = "openpgp";
            openpgp.program = "${pkgs.gnupg}/bin/gpg";
          };
        };
        difftastic.enable = true;
      };

      home.file.".gitignore_global" = {
        source = config.lib.file.mkOutOfStoreSymlink ../../../symlink/gitignore_global.symlink;
      };
    };
  }
