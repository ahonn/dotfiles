#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo -e "\nCreating dotfile symlinks"
echo "=============================="
linkables=$(find -H "$DOTFILES" -not -path "$DOTFILES/.undodir/*" -maxdepth 3 -name '*.symlink')

for file in $linkables; do
  filename=".$(basename $file '.symlink')"
  target="$HOME/$filename"
  if [ -e $target ]; then
    echo "$target already exists... Skipping."
  else
    echo "Creating symlink for $file"
    ln -s $file $target
  fi
done

echo -e "\nCreating config symlinks"
echo "=============================="
if [ ! -d $HOME/.config ]; then
  echo "Creating ~/.config"
  mkdir -p $HOME/.config
fi

for config in $DOTFILES/config/*; do
  filename="$(basename $config)"
  target="$HOME/.config/$filename"
  if [ -e $target ]; then
    echo "$target already exists... Skipping."
  else
    echo "Creating symlink for $config"
    ln -s $config $target
  fi
done

echo -e "\nCreating vim symlinks"
echo "=============================="
VIMFILES=("$HOME/.vim:$DOTFILES/vim"
  "$HOME/.vimrc:$DOTFILES/vim/init.vim")

for file in "${VIMFILES[@]}"; do
  KEY=${file%%:*}
  VALUE=${file#*:}
  if [ -e ${KEY} ]; then
    echo "${KEY} already exists... skipping."
  else
    echo "Creating symlink for $KEY"
    ln -s ${VALUE} ${KEY}
  fi
done

echo -e "\nCreating hammerspoon symlinks"
echo "=============================="
if [ -e $HOME/.hammerspoon ]; then
  echo "$HOME/.hammerspoon already exists... skipping."
else
  echo "Creating symlink for $HOME/.hammerspoon"
  ln -s $DOTFILES/hammerspoon $HOME/.hammerspoon
fi
