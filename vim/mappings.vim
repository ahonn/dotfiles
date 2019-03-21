""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Mappings                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

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

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <silent> \ :nohlsearch<Cr>

if has('nvim')
  nnoremap <silent> <C-t> :bo sp term://fish\|resize 8<Cr>i
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  tnoremap <C-c> <C-\><C-n>:q<Cr>
endif

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <silent> <Leader>sv :source $MYVIMRC<Cr>
