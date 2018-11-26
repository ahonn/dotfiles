#!/usr/bin/env bash

echo -e "\nInstalling nvm..."
echo "=============================="

if [ -e $HOME/.nvm ]; then
  echo "nvm already installed... skipping."
else
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

  nvm install --lts
  nvm use stable
fi

echo -e "\nInstalling nrm..."
echo "=============================="

if nrm -V >/dev/null 2>&1; then
  echo "nrm already installed... skipping."
else
  npm install nrm -g

  nrm ls
  nrm use taobao
fi

echo -e "\nInstalling npm packages..."
echo "=============================="

formulas=(
  neovim
  eslint
  prettier
  babel-eslint
  eslint-config-airbnb-base
  typescript
  gh-pages
  commitizen
  cz-conventional-changelog
  javascript-typescript-langserver
)

for formula in "${formulas[@]}"; do
  if npm list -g --depth=0 "$formula" >/dev/null 2>&1; then
    echo "$formula already installed... skipping."
  else
    npm install $formula -g
  fi
done
