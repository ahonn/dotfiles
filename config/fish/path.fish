# ========== MIRROR ========== #
# set -gx ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

# =========== PATH =========== #
if test -d /usr/local/sbin
  set -g fish_user_paths /usr/local/sbin $fish_user_paths
end

if test -d $HOME/bin
  set -gx fish_user_paths $HOME/bin $fish_user_paths
end

if test -d $DOTFILES/bin
  set -gx fish_user_paths $DOTFILES/bin $fish_user_paths
end

if test -d /usr/local/bin
  set -gx fish_user_paths /usr/local/bin $fish_user_paths
end

# Brew
if test -d /opt/homebrew/bin
  set -gx fish_user_paths /opt/homebrew/bin $fish_user_paths
end

# Rust
if test -d $HOME/.cargo/bin
  set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

# Ruby
if test -d /usr/local/opt/ruby/bin
  set -gx fish_user_paths /usr/local/opt/ruby/bin $fish_user_paths
end
if test -d /usr/local/lib/ruby/gems/2.7.0/bin
  set -gx fish_user_paths /usr/local/lib/ruby/gems/2.7.0/bin $fish_user_paths
end

# nix-drawin
if test -d /run/current-system/sw/bin
  set -g fish_user_paths /run/current-system/sw/bin $fish_user_paths
end
