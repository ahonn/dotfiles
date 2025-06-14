{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zsh;
in {
  options.services.zsh = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    home.sessionPath = [ "$HOME/.claude/local" ];
    
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion = {
        enable = true;
      };

      shellAliases = {
        cat = "bat";
        dev = "devbox shell";
      };

      initExtra =
        ''
          export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
          export DIRENV_LOG_FORMAT=""

          if [[ -r ~/env.zsh ]]; then
            source ~/env.zsh
          fi

          if [[ $(uname -m) == 'arm64' ]]; then
             eval "$(/opt/homebrew/bin/brew shellenv)"
          fi

          export PATH=~/.cargo/bin:$PATH
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
