#!/usr/bin/env bash

sudo gem update --system

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
sudo gem update

echo -e "\nInstalling gem packages..."
echo "=============================="

formulas=(
  tmuxinator
  neovim
)

for formula in "${formulas[@]}"; do
  if gem list "$formula" >/dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    gem install $formula
  fi
done
