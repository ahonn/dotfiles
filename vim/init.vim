""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Ahonn's vimrc                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mapleader = "\<Space>"
let g:vimrc_root_path = "~/.dotfile/vim"

if !exists('g:vscode')
  runtime! mappings.vim
  runtime! plugins.vim
else
  runtime! vscode/mappings.vim
  runtime! vscode/plugins.vim
endif
runtime! general.vim
runtime! autocmd.vim
