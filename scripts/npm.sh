#!/usr/bin/env bash

echo -e "\nInstalling nrm..."
echo "=============================="

if nrm -V > /dev/null 2>&1; then
  echo "nrm already installed... skipping."
else
  npm install nrm -g
fi

nrm ls
nrm use cnpm

echo -e "\nInstalling npm packages..."
echo "=============================="

formulas=(
  eslint
  babel-eslint
  eslint-config-airbnb-base
  mirror-config-china
  neovim
  prettier
  typescript
)

for formula in "${formulas[@]}"; do
  if npm list -g --depth=0 "$formula" > /dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    npm install $formula -g
  fi
done

# https://www.npmjs.com/package/mirror-config-china
cd ~
mirror-config-china --registry=https://registry.npm.taobao.org
cd $DOTFILES
