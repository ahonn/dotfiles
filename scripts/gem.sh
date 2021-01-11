#!/usr/bin/env bash


# echo -e "\nInstalling rvm..."
# echo "=============================="

# if [ -e $HOME/.rvm ]; then
#   echo "rvm already installed... skipping."
# else
#   curl -sSL https://get.rvm.io | bash -s stable
# fi

# rvm list
# rvm install ruby-head
# rvm use ruby-head

# gem update
# gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
# gem sources -l

echo -e "\nInstalling gem packages..."
echo "=============================="

formulas=(
  neovim
)

for formula in "${formulas[@]}"; do
  if gem list "$formula" >/dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    gem install $formula
  fi
done
