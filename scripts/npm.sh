#!/usr/bin/env bash

echo -e "\nInstalling nvm..."
echo "=============================="

if [ -e $HOME/.nvm ]; then
  echo "nvm already installed... skipping."
else
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
fi

source ~/.zshrc 2>/dev/null
nvm install --lts
nvm use stable

echo -e "\nInstalling nrm..."
echo "=============================="

if nrm -V >/dev/null 2>&1; then
  echo "nrm already installed... skipping."
else
  npm install nrm -g
fi

nrm ls
nrm use taobao

echo -e "\nInstalling npm packages..."
echo "=============================="

formulas=(
  eslint
  babel-eslint
  eslint-config-airbnb-base
  mirror-config-china
  neovim
  typescript
  js-beautify
)

for formula in "${formulas[@]}"; do
  if npm list -g --depth=0 "$formula" >/dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    npm install $formula -g
  fi
done

# https://www.npmjs.com/package/mirror-config-china
cd ~
mirror-config-china --registry=https://registry.npm.taobao.org
cd $DOTFILES
