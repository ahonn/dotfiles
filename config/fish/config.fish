set -gx DOTFILES $HOME/.dotfiles

set -gx EDITOR 'nvim'
set -gx GIT_EDITOR 'nvim'

source $DOTFILES/config/fish/aliases.fish
source $DOTFILES/config/fish/path.fish

set -g fish_key_bindings fish_vi_key_bindings

