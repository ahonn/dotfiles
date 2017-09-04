""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Options                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Search {{{ "
  set ignorecase
  set smartcase
  set hlsearch
  set incsearch
" }}} Search "

" Edit {{{ "
  " Tab and indent
  set smartindent
  set autoindent
  set smarttab
  set expandtab
  set shiftwidth=2
  set tabstop=2

  set autoread
  set autowrite

  " Line Wrap
  " set wrap
  set linebreak
  set showbreak=->
  set textwidth=120
  set colorcolumn=120
  autocmd WinLeave * set nocursorline nocursorcolumn
  autocmd WinEnter * set cursorline cursorcolumn

  " Backspace
  set backspace=eol,start,indent

  " Folding
  set foldenable
  set foldmethod=manual
  set foldcolumn=0

  " Mouse
  set mouse=a

  " Cursor
  set cursorcolumn
  set cursorline
  set scrolloff=10

  " Clipboard
  set clipboard+=unnamed

  " session
  set sessionoptions=buffers,curdir,folds,tabpages,winpos,winsize

  " Complete
  set wildmenu
  set wildmode=longest,full
  set completeopt=menu,menuone,preview
" }}} Edit "

" View {{{ "
  " Background
  set background=dark

  " Line number
  set number
  set relativenumber

  " Status line
  set laststatus=1
  set noshowmode

  " Backup
  set noswapfile
  set nobackup
  set nowritebackup

  " Language
  set helplang=cn
  set encoding=utf-8
  set fileencodings=utf-8,gbk,gb2312,gb18030
" }}} View "

" GUI {{{ "
  if has('gui_running')
    " Font
    set guifont=Sauce_Code_Pro_Nerd_Font_Complete:h12

    " Display scrollbar
    set guioptions-=r
    set guioptions-=l
    set guioptions-=L
  endif
" }}} GUI "

" Syntax {{{ "
  syntax on
  syntax enable
" }}} Syntax "

" Filetype {{{ "
  filetype plugin on
  filetype indent on
" }}} Filetype "

" Cursor {{{ "
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" }}} Cursor "
