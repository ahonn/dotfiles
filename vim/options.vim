""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Options                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
  set listchars=eol:¬,tab:▸\ ,trail:·

  set autoread
  set noautowrite

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

  set backspace=eol,start,indent

  set conceallevel=0

  set nofoldenable
  set foldmethod=syntax
  set foldlevelstart=2

  set mouse=a

  set clipboard+=unnamed

  set sessionoptions=buffers,curdir,folds,tabpages,winpos,winsize

  set undofile

  set wildmenu
  set wildmode=longest,full
  set completeopt=menu,menuone

  set termguicolors
  set background=dark

  if (empty($TMUX))
    if (has('nvim'))
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has('termguicolors'))
      set termguicolors
    endif
  endif

  set number
  set relativenumber

  set laststatus=2
  set noshowmode

  set noswapfile
  set nobackup
  set nowritebackup

  set encoding=utf-8
  set fileencodings=utf-8,gbk,gb2312,gb18030

  if has('gui_running')
    set guifont=OperatorMono_Nerd_Font:h13

    set guioptions-=r
    set guioptions-=l
    set guioptions-=L
  endif

  filetype plugin indent on

  if !exists('g:syntax_on')
    syntax enable
  endif

  augroup CSSSyntax
    autocmd!
    autocmd FileType css setlocal iskeyword+=-
    autocmd FileType scss setlocal iskeyword+=-
    autocmd FileType javascript setlocal iskeyword+=-
  augroup END

  set cursorline
  set scrolloff=10
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
