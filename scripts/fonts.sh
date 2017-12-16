#!/usr/bin/env bash

echo -e "\nInstalling nerd font..."
echo "=============================="

formulas=(
  font-sourcecodepro-nerd-font-mono
)

for formula in "${formulas[@]}"; do
  # https://github.com/caskroom/homebrew-fonts
  if brew cask list $formula > /dev/null 2>&1; then
    echo "$formula already installed... skipping"
  else
    brew tap caskroom/fonts
    brew cask install $formula
  fi
done

