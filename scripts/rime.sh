RIME_CONFIG=$HOME/Library/Rime

for config in $DOTFILES/rime/*; do
  filename="$(basename $config)"
  target="$RIME_CONFIG/$filename"
  if [ -e $target ]; then
    echo "$target already exists... Skipping."
  else
    echo "Creating symlink for $config"
    ln -s $config $target
  fi
done

if [ ! -d $RIME_CONFIG/plum ]; then
  echo "Install Rime Plum"
  git clone --depth 1 https://github.com/rime/plum.git $RIME_CONFIG/plum
fi
$RIME_CONFIG/plum/rime-install double-pinyin emoji
# $RIME_CONFIG/plum/rime-install emoji:customize:schema=double_pinyin_flypy
