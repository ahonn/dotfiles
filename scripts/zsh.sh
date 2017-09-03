#!/usr/bin/env bash

OH_MY_ZSH=$HOME/.oh-my-zsh

echo -e "\nInstalling oh my zsh..."
echo "=============================="

if [ -e $OH_MY_ZSH ]; then
  echo "Oh my zsh already exists... skipping"
else
  git clone --depth 1 git://github.com/robbyrussell/oh-my-zsh.git $OH_MY_ZSH
fi
