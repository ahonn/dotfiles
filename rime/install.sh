#!/usr/bin/env bash

RIME_CONFIG=$HOME/Library/Rime

if [ ! -d $RIME_CONFIG/plum ]; then
  echo "Install Rime Plum"
  git clone --depth 1 https://github.com/rime/plum.git $RIME_CONFIG/plum
fi

$RIME_CONFIG/plum/rime-install double-pinyin
$RIME_CONFIG/plum/rime-install iDvel/rime-ice:others/recipes/full

