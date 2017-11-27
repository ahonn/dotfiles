#!/usr/bin/env bash

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade --all

echo -e "\nInstalling homebrew packages..."
echo "=============================="

formulas=(
  z
  autojump
  macvim
  neovim/neovim/neovim
  ack
  the_silver_searcher
  ripgrep
  ctags
  fzf
  node
  nvm
  nginx
  tmux
  git
  zsh
  tree
  wget
  rmtrash
  thefuck
)

for formula in "${formulas[@]}"; do
  if brew list "$formula" > /dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    brew install $formula
  fi
done

