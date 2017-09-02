#!/usr/bin/env bash

if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo -e "\nInstalling homebrew packages..."
echo "=============================="

formulas=(
    macvim
    ack
    fzf
    git
    markdown
    neovim/neovim/neovim
    node
    nginx
    the_silver_searcher
    tmux
    tree
    wget
    z
    zsh
)

for formula in "${formulas[@]}"; do
  if brew list "$formula" > /dev/null 2>&1; then
      echo "$formula already installed... skipping."
  else
      brew install $formula
  fi
done

source scripts/fonts.sh
