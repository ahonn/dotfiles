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

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "z"
          "vi-mode"
        ];
        theme = "robbyrussell";
      };
    };
  };
}
