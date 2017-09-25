""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Mappings                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Esc & Exit {{{ "
  inoremap jk <Esc>
" }}} Esc "

" Nop {{{ "
  nnoremap <Left> <Nop>
  nnoremap <Right> <Nop>
  nnoremap <Up> <Nop>
  nnoremap <Down> <Nop>
" }}} Nop "

" Indent {{{ "
  nnoremap < <<
  nnoremap > >>
  vnoremap < <gv
  vnoremap > >gv
" }}} Indent "

" Motion {{{ "
  " Treat long lines as break lines
  nnoremap k gk
  nnoremap gk k
  nnoremap j gj
  nnoremap gj j

  noremap H ^
  noremap L $
  nnoremap J G
  nnoremap K gg

  vnoremap J G
  vnoremap K gg
" }}} Motion "

" Window {{{ "
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-h> <C-w>h
  nnoremap <C-l> <C-w>l
  " }}} Window "

" Buffer {{{ "
  nnoremap ,x :bn<Cr>
  nnoremap ,z :bp<Cr>
  nnoremap ,d :bufdo bd<Cr>
" }}} Buffer "

" Neovim {{{ "
  if has('nvim')
    nnoremap <C-t> :bo sp term://zsh\|resize 8<Cr>i
    tnoremap jk <C-\><C-n>
  endif
" }}} Neovim "

" Search {{{ "
  nnoremap F yiw/<C-r>"<Cr>
  vnoremap F <Esc>yiw/<C-r>"<Cr>
  nnoremap \ :let @/ = ""<Cr>
" }}} Search

" Vimrc {{{ "
  nnoremap <Leader>ev :vsplit ~/.vim<Cr>
  nnoremap <Leader>eo :vsplit ~/.vim/options.vim<Cr>
  nnoremap <Leader>em :vsplit ~/.vim/mappings.vim<Cr>
  nnoremap <Leader>ep :vsplit ~/.vim/plugins.vim<Cr>
  nnoremap <Leader>sv :source $MYVIMRC<Cr>
" }}} Vimrc "
