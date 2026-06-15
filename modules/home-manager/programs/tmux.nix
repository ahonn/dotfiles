{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.my.tmux;

  # craftzdog/tmux-claude-session-manager: list, monitor, and jump across nested
  # Claude Code sessions from a single popup. Not in nixpkgs, so package it here.
  # rtpFilePath is explicit because the entry file uses an underscore, which the
  # default "${pluginName}.tmux" glob would miss.
  claude-session-manager = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "claude-session-manager";
    version = "unstable-2026-06-15";
    rtpFilePath = "claude_session_manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "craftzdog";
      repo = "tmux-claude-session-manager";
      rev = "25373ee521ca473f068fb7f7de9f1007db0fbb6d";
      hash = "sha256-+I4y4Jrihq1ShFYP6qGdbMRHCwdWBUzcPi8eQjpdgCo=";
    };
  };
in
{
  options.my.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer with custom keybindings";
  };

  config = mkIf cfg.enable {
    # fzf powers the session picker (and the existing C-s session switcher).
    home.packages = [ pkgs.fzf ];

    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        yank
        claude-session-manager
      ];
      extraConfig = ''
        set -g default-command "zsh"
        set -g mouse on
        set -g focus-events on

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

        # ========== window =========== #
        # create window in current path
        unbind c
        bind c new-window -c "#{pane_current_path}"

        # create session
        bind n new-session

        # clean screen
        bind C-l send-keys 'C-l'

        # fast switch windows
        # -f filter: hide C-a+y managed claude-* sessions from the tree (reach them via C-a u)
        bind Space choose-tree -w -f '#{?#{m:claude-*,#{session_name}},0,1}'
        bind C-a last-window
        bind C-j previous-window
        bind C-k next-window

        # override default session (s) / window (w) choosers to hide claude-* sessions too
        bind s choose-tree -Zs -f '#{?#{m:claude-*,#{session_name}},0,1}'
        bind w choose-tree -Zw -f '#{?#{m:claude-*,#{session_name}},0,1}'

        # fast switch session (exclude claude-* managed sessions)
        bind C-s run-shell "tmux list-sessions | grep -v '^claude-' | cut -d ':' -f 1 | fzf-tmux | xargs -r tmux switch-client -t"

        # ========== pane ========== #
        # split window
        unbind %
        bind - split-window -v -c '#{pane_current_path}'
        unbind '"'
        bind '\' split-window -h -c '#{pane_current_path}'

        # select pane
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # resize pane
        bind -r K resizep -U 5
        bind -r J resizep -D 5
        bind -r H resizep -L 5
        bind -r L resizep -R 5

        # swap panes
        bind C-u swap-pane -U
        bind C-d swap-pane -D
        bind C-x rotate-window

        # kill pane/window/session
        bind q kill-pane
        bind C-q kill-window
        bind Q kill-session

        # ========== Colorscheme ========== #
        # mode
        set -g mode-style fg=brightblue,bg=brightblack

        # panes
        set -g pane-border-style fg=brightblack
        set -g pane-active-border-style fg=cyan

        # message
        set -g message-style fg=brightblue,bg=default

        # status bar
        set -g status-justify left
        set -g status-position top

        set -g status-style fg=white,bg=default

        set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
        set -g window-status-current-format "#[fg=black,bg=brightblue,nobold,noitalics,nounderscore] #[fg=black,bg=brightblue]#I #[fg=black,bg=brightblue,nobold,noitalics,nounderscore] #[fg=black,bg=brightblue]#W #F #[fg=brightblue,bg=black,nobold,noitalics,nounderscore]"
        set -g window-status-separator ""

        set -g window-status-current-style fg=cyan,bg=black
        set -g window-status-style fg=cyan,bg=black

        set -g status-left "#[fg=black,bg=cyan] #S #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
        set -g status-right "#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=cyan,bg=brightblack] %Y-%m-%d %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan] #H "
      '';
    };
  };
}
