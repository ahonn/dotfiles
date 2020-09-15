""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Ahonn's vimrc                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mapleader = "\<Space>"
let g:vimrc_root_path = "~/.dotfile/vim"

" pyenv install 3.4.4
" pyenv virtualenv 3.4.4 py3nvim
" pyenv activate py3nvim
" pip install pynvim
" pyenv which python
if !empty(glob("~/.pyenv/versions/py3nvim/bin/python"))
  let g:python3_host_prog = "~/.pyenv/versions/py3nvim/bin/python"
endif

if !empty(glob("~/.pyenv/versions/py2nvim/bin/python"))
  let g:python2_host_prog = "~/.pyenv/versions/py2nvim/bin/python"
endif

if !exists('g:vscode')
  runtime! mappings.vim
  runtime! plugins.vim
  runtime! general.vim
else
  runtime! vscode/mappings.vim
  runtime! vscode/plugins.vim
  runtime! vscode/general.vim
endif
runtime! autocmd.vim
