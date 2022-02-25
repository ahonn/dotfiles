#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo "Installing dotfiles..."

echo "Initializing submodule(s)..."
git submodule update --init --recursive

# fish
chsh -s /usr/local/bin/fish
curl -L https://get.oh-my.fish | fish
echo /usr/local/bin/fish | sudo tee -a /etc/shells

source $DOTFILES/scripts/link.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  source $DOTFILES/scripts/brew.sh
  source $DOTFILES/scripts/rime.sh
fi
