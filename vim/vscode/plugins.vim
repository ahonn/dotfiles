if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/nerdcommenter'
  Plug 'kana/vim-textobj-user'
  Plug 'sgur/vim-textobj-parameter'
  Plug 'kkoomen/vim-doge'
call plug#end()

nnoremap <silent> <Leader>pi :PlugInstall<Cr>
nnoremap <silent> <Leader>pc :PlugClean<Cr>
nnoremap <silent> <Leader>pu :PlugUpdate<Cr>

" vim-textobj-parameter
let g:vim_textobj_parameter_mapping = 'a'

" vim-doge
let g:doge_mapping = '<Leader>dc'
