#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo "Installing dotfiles..."

echo "Initializing submodule(s)..."
git submodule update --init --recursive

source $DOTFILES/scripts/link.sh
source $DOTFILES/scripts/gem.sh

if [ "$(uname)" == "Darwin" ]; then
  source $DOTFILES/scripts/brew.sh
  source $DOTFILES/scripts/fonts.sh
fi
