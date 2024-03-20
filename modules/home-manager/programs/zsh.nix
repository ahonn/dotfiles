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
        update = "darwin-rebuild switch --flake .#macbook";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";

      zplug = {
        enable = true;
        plugins = [
          { name = "plugins/git"; tags = [ from:oh-my-zsh ];}
          { name = "plugins/z"; tags = [ from:oh-my-zsh ];}
          { name = "jeffreytse/zsh-vi-mode"; }
        ];
      };

      antidote = {
        enable = true;
        plugins = [
          "z-shell/zsh-eza"
        ];
      };
    };
  };
}
