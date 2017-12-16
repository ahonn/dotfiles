#!/usr/bin/env bash


echo -e "\nInstalling gem packages..."
echo "=============================="

formulas=(
  tmuxinator
)

for formula in "${formulas[@]}"; do
  if gem list "$formula" > /dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    gem install $formula
  fi
done
