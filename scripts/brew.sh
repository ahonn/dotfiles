#!/usr/bin/env bash

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
# cd "$(brew --repo)"
# git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

# cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
# git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

echo -e "\nUpgrade homebrew packages..."
brew update
brew upgrade

echo -e "\nInstalling homebrew packages..."
echo "=============================="

formulas=(
  lua
  luarocks
  fish
  ripgrep
  fzf
  nginx
  tmux
  git
  tree
  wget
  neovim
  cmake
  reattach-to-user-namespace
  clojure-lsp
  borkdude/brew/clj-kondo
)

for formula in "${formulas[@]}"; do
  if brew list "$formula" >/dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    brew install $formula
  fi
done

echo -e "\nInstalling homebrew casks..."
echo "=============================="
casks=(
  squirrel
  upic
  kitty
  fork
  dash
  wireshark
  raycast
  karabiner-elements
)

for cask in "${casks[@]}"; do
  if brew list "$cask" >/dev/null 2>&1; then
    echo "$cask already installed... skipping."
  else
    brew install $cask --cask
  fi
done
