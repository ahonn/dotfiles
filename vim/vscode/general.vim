""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  General                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark

set number
set relativenumber

set autoread
set noautowrite

set laststatus=2
" set noshowmode

set wrap
set linebreak
set showbreak=->
set textwidth=80
set colorcolumn=100

set ignorecase
set smartcase
set hlsearch
set incsearch

set autoindent
set smarttab
set expandtab
set shiftwidth=2
set tabstop=2

set list
set listchars=tab:▸\ ,eol:\ ,trail:·,extends:↷,precedes:↶
set fillchars=vert:│,fold:·

set backspace=indent,eol,start

set nofoldenable
set foldmethod=syntax
set foldlevelstart=2
set conceallevel=0

set mouse=a
set clipboard+=unnamed

set noswapfile
set nobackup
set nowritebackup
set undofile
set sessionoptions=buffers,curdir,folds,tabpages,winpos,winsize

set wildmenu
set wildmode=longest,full
set completeopt=menu,menuone

set cursorline
set scrolloff=10

set encoding=utf-8
set fileencodings=utf-8,gbk,gb2312,gb18030

" use scriptencoding when multibyte char exists
scriptencoding utf-8

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif
