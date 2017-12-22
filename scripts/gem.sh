#!/usr/bin/env bash

gem update --system

echo -e "\nInstalling rvm..."
echo "=============================="

if rvm > /dev/null 2>&1; then
  echo "rvm already installed... skipping."
else
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm

  # ruby china gem
  echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db
fi

rvm install ruby-2.4.1

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
