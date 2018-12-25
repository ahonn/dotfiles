# ========== MIRROR ========== #
set -gx ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

# =========== PATH =========== #
if test -d $HOME/bin
    set -gx fish_user_paths $HOME/bin $fish_user_paths
end

if test -d $DOTFILES/bin
    set -gx fish_user_paths $DOTFILES/bin $fish_user_paths
end

set -gx GOPATH $HOME/go
if test -d $GOPATH/bin
    set -gx fish_user_paths $GOPATH/bin $fish_user_paths
end

# flutter
if test -d $HOME/flutter/bin
    set -gx fish_user_paths $HOME/flutter/bin $fish_user_paths
end

# sqlite
set -gx fish_user_paths "/usr/local/opt/sqlite/bin" $fish_user_paths
set -gx LDFLAGS "-L/usr/local/opt/sqlite/lib"
set -gx CPPFLAGS "-I/usr/local/opt/sqlite/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/sqlite/lib/pkgconfig"

# rust
if test -d $HOME/.cargo/bin
    set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

# ruby rvm
if test -d $HOME/.rvm
    set -gx fish_user_paths $HOME/.rvm/bin $fish_user_paths
    if test -d $HOME/.rvm/gems/ruby-head/bin
        set -gx fish_user_paths $HOME/.rvm/gems/ruby-head/bin $fish_user_paths
    end
end
