#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
BACKUP_DIR=$HOME/.dotfiles_backup

echo "Creating backup directory at $BACKUP_DIR"
mkdir -p $BACKUP_DIR

lineables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $lineables; do
  filename=".$( basename $file '.symlink' )"
  target="$HOME/$filename"
  if [ -f $target ]; then
    echo "backing up $filename"
    cp $target $BACKUP_DIR
  else
    echo -e "$filename does not exist at this location or is a symlink"
  fi
done

vimfiles=("$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc")
for filename in $vimfiles; do
  if [ ! -L $filename ]; then
    echo "backing up $filename"
    cp -rf $filename $BACKUP_DIR
  else
    echo -e "$filename does not exist at this location or is a symlink"
  fi
done
