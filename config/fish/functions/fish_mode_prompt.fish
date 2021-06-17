function fish_mode_prompt
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
    set_color black
    switch $fish_bind_mode
      case default
        set_color --background red
        echo "[N]"
      case insert
        set_color --background green
        echo "[I]"
      case replace_one
        set_color --background green
        echo "[R]"
      case replace
        set_color --background cyan
        echo "[R]"
      case visual
        set_color --background magenta
        echo "[V]"
    end
    set_color normal
    echo -n ' '
  end
end
