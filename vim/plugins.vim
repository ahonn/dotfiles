""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Plugins & Config                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim-plug {{{ "
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}} Vim-plug "

" Plugins {{{ "
  call plug#begin('~/.vim/plugged')
    Plug 'junegunn/vim-plug'

    " interface
    Plug 'majutsushi/tagbar'
    Plug 'ap/vim-css-color'
    Plug 'luochen1990/rainbow'
    Plug 'mbbill/undotree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'thaerkh/vim-workspace'

    " integration
    Plug 'w0rp/ale'
    Plug 'dyng/ctrlsf.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive'

    " display
    Plug 'Yggdroot/indentLine'
    Plug 'scrooloose/nerdcommenter'
    Plug 'heavenshell/vim-jsdoc'
    Plug 'jiangmiao/auto-pairs'
    Plug 'Valloric/MatchTagAlways'

    " commands
    Plug 'danro/rename.vim'
    Plug 'tpope/vim-surround'

    " completion
    Plug 'ervandew/supertab'
    Plug 'mattn/emmet-vim'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all', 'frozen': 1 }
    Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }

    " snippets
    Plug 'SirVer/ultisnips'
    Plug 'VimSnippets/vim-snippets'
    Plug 'VimSnippets/vim-react-snippets'

    " language
    Plug 'tpope/vim-markdown'
    Plug 'pangloss/vim-javascript'
    Plug 'briancollins/vim-jst'
    Plug 'SpaceVim/vim-swig'
    Plug 'othree/html5.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'othree/javascript-libraries-syntax.vim'
    " Clojure REPL Support
    Plug 'tpope/vim-fireplace'

    " color scheme
    Plug 'w0ng/vim-hybrid'

    " analyze
    Plug 'wakatime/vim-wakatime'
  call plug#end()
" }}} Plugins "

" Configure {{{ "
  " Colorscheme
  let g:hybrid_custom_term_colors = 1
  colorscheme hybrid

  " rainbow
  let g:rainbow_active = 1
  " markdown
  let g:vim_markdown_folding_disabled = 1
  " vim-javascript
  let g:javascript_plugin_jsdoc = 1
  let javascript_enable_domhtmlcss = 1

  " FZF
  nnoremap <C-p> :Files<Cr>
  nnoremap <Leader><Leader> :Buffers<cr>
  let $FZF_DEFAULT_COMMAND= 'ag --ignore node_modules --skip-vcs-ignores -g ""'

  " CtrlSF
  nnoremap <C-f> :CtrlSF<Space>
  nnoremap <Leader>f yiw:CtrlSF <C-r>"<Cr>
  let g:ctrlsf_default_view_mode = 'compact'
  let g:ctrlsf_ignore_dir = ["node_modules"]
  let g:ctrlsf_mapping = {
    \ "vplit": "<C-v>",
    \ "quit": "<Esc>",
    \ }

  " YouCompleteMe
  let g:ycm_auto_trigger = 1
  let g:ycm_min_num_of_chars_for_completion = 1
  let g:ycm_autoclose_preview_window_after_completion=1
  let g:ycm_complete_in_comments = 1
  let g:ycm_key_list_select_completion = ['<C-n>', '<C-j>']
  let g:ycm_key_list_previous_completion = ['<C-k>']
  let g:ycm_key_list_stop_completion = ['<C-l>']
  let g:ycm_server_python_interpreter = '/usr/bin/python'
  let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'markdown' : 1,
    \ 'text' : 1,
    \ 'gitcommit' : 1,
    \ }
  let g:ycm_semantic_triggers = {
    \ 'css,less,scss': [ 're!^\s{2}', 're!:\s+' ],
    \ 'javascript.jsx,typescript': [ '.' ],
    \ }

  " UltiSnips
  let g:UltiSnipsExpandTrigger = '<Tab>'
  let g:UltiSnipsJumpForwardTrigger = '<Tab>'
  let g:snips_author='Ahonn Jiang'
  let g:snips_email='ahonn95@outlook.com'
  let g:snips_github='https://github.com/ahonn'

  " SuperTab
  let g:SuperTabDefaultCompletionType = '<C-n>'

  " Emmet.vim
  let g:user_emmet_install_global = 0
  let g:user_emmet_expandabbr_key = '<C-e>'
  autocmd FileType html,css,javascript EmmetInstall

  " ale
  nnoremap <leader>al :ALEToggle<Cr>
  let g:ale_linter_aliases = {
    \ 'javascript.jsx': 'javascript',
    \ 'jsx': 'javascript'
    \ }
  let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ }

  " Tagbar
  nnoremap <Leader>tl :TagbarToggle<Cr>

  " Undotree
  nnoremap <Leader>ud :UndotreeToggle<Cr> :UndotreeFocus<Cr>
  function! g:Undotree_CustomMap()
     map <buffer> j J
     map <buffer> k K
  endfunction

  " NERDTree
  let NERDTreeShowHidden=1
  noremap <C-b> :NERDTreeToggle<Cr>
  "  autocmd vimenter * NERDTree
  autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif
  " nerdtree syntax highlight
  let g:NERDTreeFileExtensionHighlightFullName = 1
  let g:NERDTreeExactMatchHighlightFullName = 1
  let g:NERDTreePatternMatchHighlightFullName = 1
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
  let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
  if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
  endif
  autocmd FileType nerdtree setlocal nocursorcolumn
  if has('gui_running')
    autocmd FileType nerdtree setlocal nolist
    autocmd FileType nerdtree setlocal ambiwidth=double
  endif

  " airline
  let g:airline_theme='jellybeans'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
  if has('gui_running')
    let g:airline_right_sep = '⮂'
  endif

  " nerdcommenter
  let g:NERDSpaceDelims=1

  " jsdoc
  nnoremap <Leader>dc :JsDoc<Cr>
  let g:jsdoc_allow_input_prompt = 1

  " workspace
  nnoremap <leader>ws :ToggleWorkspace<Cr>
  let g:workspace_session_name = '.vimworkspace'
  let g:workspace_autosave = 1
" }}} Configure "

