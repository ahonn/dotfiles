function fish_user_key_bindings
  # vi mode esc mapping
  # bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
  # bind -M visual jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

  # clear line
  bind -M insert \cc kill-whole-line force-repaint

  # accept autosuggestion
  bind -M insert \cn accept-autosuggestion

  # faster beginning & end of line
  bind -M default H beginning-of-line
  bind -M visual H beginning-of-line
  bind -M default L end-of-line
  bind -M visual L end-of-line
end
