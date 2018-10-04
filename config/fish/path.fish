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
  set -gx PATH $HOME/bin $PATH
end

if test -d $DOTFILES/bin
  set -gx PATH $DOTFILES/bin $PATH
end

set -gx GOPATH $HOME/go
if test -d $GOPATH/bin
  set -gx PATH $GOPATH/bin $PATH
end

# Flutter
if test -d $HOME/flutter/bin
  set -gx PATH $HOME/flutter/bin $PATH
end

# Sqlite
set -gx PATH "/usr/local/opt/sqlite/bin" $PATH
set -gx LDFLAGS "-L/usr/local/opt/sqlite/lib"
set -gx CPPFLAGS "-I/usr/local/opt/sqlite/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/sqlite/lib/pkgconfig"
