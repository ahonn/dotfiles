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
  set autoindent
  set smarttab
  set expandtab
  set shiftwidth=2
  set list
  set listchars=eol:¬,tab:▸\ ,trail:·

  set autoread
  set autowrite

  " Line Wrap
  set wrap
  set linebreak
  set showbreak=->
  set textwidth=120
  set colorcolumn=120
  augroup Cursor
    autocmd!
    autocmd WinLeave * set nocursorline
    autocmd WinEnter * set cursorline
  augroup END

  " Backspace
  set backspace=eol,start,indent

  " Folding
  set nofoldenable
  set foldmethod=marker

  " Mouse
  set mouse=a

  " Clipboard
  set clipboard^=unnamed

  " Session
  set sessionoptions=buffers,curdir,folds,tabpages,winpos,winsize

  " Undo
  if !isdirectory($HOME."/.undodir")
    call mkdir($HOME."/.undodir", 0770)
  endif
  set undodir=~/.undodir
  set undofile

  " Complete
  set wildmenu
  set wildmode=longest,full
  set completeopt=menu,menuone
" }}} Edit "

" View {{{ "
  " Colors
  set termguicolors
  set background=dark

  if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
  endif

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
    set guifont=Sauce_Code_Pro_Nerd_Font_Complete_Mono:h12

    " Display scrollbar
    set guioptions-=r
    set guioptions-=l
    set guioptions-=L
  endif
" }}} GUI "

" Filetype {{{ "
  filetype plugin indent on
" }}} Filetype "

" Syntax {{{ "
  if !exists('g:syntax_on')
    syntax enable
  endif

  augroup CSSSyntax
    autocmd!
    autocmd FileType css setlocal iskeyword+=-
    autocmd FileType scss setlocal iskeyword+=-
    autocmd FileType javascript setlocal iskeyword+=-
  augroup END
" }}} Syntax "

" Cursor {{{ "
  " set cursorcolumn
  set cursorline
  set scrolloff=10
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" }}} Cursor "
