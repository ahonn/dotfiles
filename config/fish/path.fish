# ========== MIRROR ========== #
set -gx IOJS_ORG_MIRROR        https://npm.taobao.org/mirrors/iojs
set -gx NODIST_IOJS_MIRROR     https://npm.taobao.org/mirrors/iojs
set -gx NVM_IOJS_ORG_MIRROR    https://npm.taobao.org/mirrors/iojs
set -gx NVMW_IOJS_ORG_MIRROR   https://npm.taobao.org/mirrors/iojs
set -gx NODEJS_ORG_MIRROR      https://npm.taobao.org/mirrors/node
set -gx NODIST_NODE_MIRROR     https://npm.taobao.org/mirrors/node
set -gx NVM_NODEJS_ORG_MIRROR  https://npm.taobao.org/mirrors/node
set -gx NVMW_NODEJS_ORG_MIRROR https://npm.taobao.org/mirrors/node
set -gx NVMW_NPM_MIRROR        https://npm.taobao.org/mirrors/npm
set -gx ELECTRON_MIRROR        https://npm.taobao.org/mirrors/electron/

# ============ FZF =========== #
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,.undodir}/*" 2> /dev/null'

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
  set -gx fish_user_paths $HOME/.rvm/gems/ruby-head/bin $fish_user_paths
end
