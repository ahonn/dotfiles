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

# =========== PATH =========== #
if test -d $HOME/bin
  set -gx PATH $HOME/bin $PATH
end

if test -d $DOTFILES/bin
  set -gx PATH $DOTFILES/bin $PATH
end

