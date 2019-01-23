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

nnoremap <Leader>k :bn<Cr>
nnoremap <Leader>j :bp<Cr>

nnoremap <silent> \ :nohlsearch<Cr>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <Leader>ev :vsplit ~/.vim<Cr>
nnoremap <Leader>eo :vsplit ~/.vim/options.vim<Cr>
nnoremap <Leader>em :vsplit ~/.vim/mappings.vim<Cr>
nnoremap <Leader>ep :vsplit ~/.vim/plugins.vim<Cr>
nnoremap <Leader>sv :source $MYVIMRC<Cr>

