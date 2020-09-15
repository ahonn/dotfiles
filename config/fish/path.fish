# ========== MIRROR ========== #
# set -gx ELECTRON_MIRROR https://npm.taobao.org/mirrors/electron/

# flutter
set -gx PUB_HOSTED_URL https://pub.flutter-io.cn
set -gx FLUTTER_STORAGE_BASE_URL https://storage.flutter-io.cn

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

if test -d $HOME/Library/Python/2.7/bin
  set -gx fish_user_paths $HOME/Library/Python/2.7/bin $fish_user_paths
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

# rvm
# if test -d $HOME/.rvm
#   if test -d $HOME/.rvm/bin
#     set -gx fish_user_paths $HOME/.rvm/bin $fish_user_paths
#   end
#   if test -d $HOME/.rvm/gems/ruby-head/bin
#     set -gx fish_user_paths $HOME/.rvm/gems/ruby-head/bin $fish_user_paths
#   end
# end

# ruby
if test -d /usr/local/opt/ruby/bin
  set -gx fish_user_paths /usr/local/opt/ruby/bin $fish_user_paths
end
if test -d /usr/local/lib/ruby/gems/2.7.0/bin
  set -gx fish_user_paths /usr/local/lib/ruby/gems/2.7.0/bin $fish_user_paths
end

# deno
if test -d $HOME/.deno/bin
  set -gx fish_user_paths $HOME/.deno/bin $fish_user_paths
end

# llvm
if test -d /usr/local/opt/llvm/bin
  set -g fish_user_paths /usr/local/opt/llvm/bin $fish_user_paths
end

if test -d ~/emsdk
  set -g fish_user_paths $HOME/emsdk $fish_user_paths
  set -g fish_user_paths $HOME/emsdk/emscripten/incoming $fish_user_paths
  # set -g fish_user_paths $HOME/emsdk/node/8.9.1_64bit/bin $fish_user_paths
  set -g fish_user_paths $HOME/emsdk/clang/fastcomp/build_incoming_64 $fish_user_paths
  set -g fish_user_paths $HOME/emsdk/binaryen/master_64bit_binaryen/bin $fish_user_paths
end

# just env path
if test -d $HOME/.just-installs/bin
  set -gx fish_user_paths $HOME/.just-installs/bin $fish_user_paths
end
