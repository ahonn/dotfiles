#!/usr/bin/env bash

echo -e "\nInstalling nerd font..."
echo "=============================="

formulas=(
  font-fira-code-nerd-font
  font-jetbrains-mono-nerd-font
)

brew tap homebrew/cask-fonts
for formula in "${formulas[@]}"; do
  # https://github.com/caskroom/homebrew-fonts
  if brew cask list $formula >/dev/null 2>&1; then
    echo "$formula already installed... skipping"
  else
    brew install $formula --cask
  fi
done
