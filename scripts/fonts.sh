#!/usr/bin/env bash

font="font-sourcecodepro-nerd-font-mono"

echo -e "\nInstalling nerd font..."
echo "=============================="

# https://github.com/caskroom/homebrew-fonts
if brew cask list $font > /dev/null 2>&1; then
  echo "$font already installed... skipping"
else
  brew tap caskroom/fonts
  brew cask install 
fi
