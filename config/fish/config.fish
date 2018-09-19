set -gx DOTFILES $HOME/.dotfiles

set -gx EDITOR 'nvim'
set -gx GIT_EDITOR 'nvim'

source $DOTFILES/config/fish/aliases.fish
source $DOTFILES/config/fish/path.fish

# vi mode
set -U fish_key_bindings fish_vi_key_bindings
set -U fish_cursor_insert line

# disable greeting
function fish_greeting
end
