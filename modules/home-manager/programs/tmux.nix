{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.tmux;
in {
  options.services.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer with custom keybindings";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        yank
      ];
      extraConfig =
        ''
          set -g default-command "zsh"
          set -g mouse on

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
          bind Space choose-tree -w
          bind C-a last-window
          bind C-j previous-window
          bind C-k next-window

          # fast switch session
          bind C-s run-shell "tmux list-session | fzf-tmux | cut -d \":\" -f 1 | xargs tmux switch-client -t"

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
