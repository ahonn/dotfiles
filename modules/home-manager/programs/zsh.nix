{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zsh;
in {
  options.services.zsh = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion = {
        enable = true;
      };

      shellAliases = {
        vim = "nvim";
        cat = "bat";
        dev = "devbox shell";
      };

      initExtra =
        ''
          ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
        '';

      zplug = {
        enable = true;
        plugins = [
          { name = "plugins/git"; tags = [ from:oh-my-zsh ];}
          { name = "plugins/z"; tags = [ from:oh-my-zsh ];}
          { name = "jeffreytse/zsh-vi-mode"; }
          { name = "birdhackor/zsh-exa-ls-plugin"; }
        ];
      };
    };
  };
}
