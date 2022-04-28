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
