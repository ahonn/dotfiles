#! /bin/sh
if [ ! -d ~/.vim ]
then
  mkdir ~/.vim
fi

ln -f $PWD/init.vim ~/.vimrc
ln -f $PWD/init.vim ~/.vim/init.vim
ln -f $PWD/options.vim ~/.vim/options.vim
ln -f $PWD/mappings.vim ~/.vim/mappings.vim
ln -f $PWD/plugins.vim ~/.vim/plugins.vim
ln -sf $PWD/UltiSnips ~/.vim/UltiSnips

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall
