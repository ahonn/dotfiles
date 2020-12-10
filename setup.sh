#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo "Installing dotfiles..."

echo "Initializing submodule(s)..."
git submodule update --init --recursive

source $DOTFILES/scripts/link.sh
source $DOTFILES/scripts/brew.sh

# fish
chsh -s /usr/local/bin/fish
curl -L https://get.oh-my.fish | fish
echo /usr/local/bin/fish | sudo tee -a /etc/shells

source $DOTFILES/scripts/gem.sh
source $DOTFILES/scripts/npm.sh
source $DOTFILES/scripts/fonts.sh

source $DOTFILES/scripts/rime.sh
source $DOTFILES/scripts/hammerspoon.sh
