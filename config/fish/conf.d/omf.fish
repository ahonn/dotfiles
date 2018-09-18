# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
set -gx OMF_CONFIG '/Users/ahonn/.dotfiles/config/fish/omf'

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
