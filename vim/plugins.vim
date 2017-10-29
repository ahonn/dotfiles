""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Plugins                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'junegunn/vim-plug'

  " Colorscheme
  Plug 'w0ng/vim-hybrid'

  " Language
  Plug 'SpaceVim/vim-swig'
  Plug 'godlygeek/tabular' " must before vim-markdown
  Plug 'plasticboy/vim-markdown'
  Plug 'sheerun/vim-polyglot'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'styled-components/vim-styled-components'

  " Interface
  Plug 'ap/vim-css-color'
  Plug 'luochen1990/rainbow'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'sjl/gundo.vim'
  Plug 'majutsushi/tagbar'
  Plug 'thaerkh/vim-workspace'

  " Integration
  Plug 'w0rp/ale'
  Plug 'dyng/ctrlsf.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'christoomey/vim-tmux-navigator'

  " Display
  Plug 'Yggdroot/indentLine'
  Plug 'scrooloose/nerdcommenter'
  Plug 'heavenshell/vim-jsdoc'
  Plug 'Chiel92/vim-autoformat'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Valloric/MatchTagAlways'
  Plug 'bhurlow/vim-parinfer'

  " Commands
  Plug 'danro/rename.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'easymotion/vim-easymotion'

  " Completion
  Plug 'ervandew/supertab'
  Plug 'mattn/emmet-vim'
  Plug 'alvan/vim-closetag'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all', 'frozen': 1 }
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
  Plug 'SirVer/ultisnips'
  Plug 'VimSnippets/vim-snippets'
  Plug 'VimSnippets/vim-react-snippets'
  Plug 'VimSnippets/vim-clojure-snippets'

  " Analyze
  Plug 'wakatime/vim-wakatime'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Configure                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ----------------------------------------------------------------------------
" Plugin
" ----------------------------------------------------------------------------
nnoremap <Leader>pi :PlugInstall<Cr>
nnoremap <Leader>pc :PlugClean<Cr>
nnoremap <Leader>pu :PlugUpdate<Cr>

" ----------------------------------------------------------------------------
" Colorscheme
" ----------------------------------------------------------------------------
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" ----------------------------------------------------------------------------
"	vim-markdown
" ----------------------------------------------------------------------------
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_frontmatter = 1

" ----------------------------------------------------------------------------
"	vim-javascript
" ----------------------------------------------------------------------------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let javascript_enable_domhtmlcss = 1

" ----------------------------------------------------------------------------
"	rainbow
" ----------------------------------------------------------------------------
let g:rainbow_active = 1

" ----------------------------------------------------------------------------
"	nerdtree
" ----------------------------------------------------------------------------
noremap <C-b> :NERDTreeToggle<Cr>
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif
let NERDTreeShowHidden=1
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

" ----------------------------------------------------------------------------
"	vim-airline
" ----------------------------------------------------------------------------
let g:airline_theme='jellybeans'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" ----------------------------------------------------------------------------
"	gundo
" ----------------------------------------------------------------------------
nnoremap <Leader>ud :GundoToggle<Cr>
let g:gundo_width = 50
let g:gundo_preview_height = 40
let g:gundo_right = 1

" ----------------------------------------------------------------------------
"	tagbar
" ----------------------------------------------------------------------------
nnoremap <Leader>tb :TagbarToggle<Cr>

" ----------------------------------------------------------------------------
"	vim-workspace
" ----------------------------------------------------------------------------
nnoremap <leader>ws :ToggleWorkspace<Cr>
let g:workspace_session_name = '.vimworkspace'
let g:workspace_autosave = 1

" ----------------------------------------------------------------------------
"	ale
" ----------------------------------------------------------------------------
nnoremap <leader>al :ALEToggle<Cr>
let g:ale_sign_error = '💥'
let g:ale_sign_warning = '✨'
highlight clear ALEErrorSign
let g:ale_echo_msg_error_str = '✷ Error'
let g:ale_echo_msg_warning_str = '⚠ Warning'
let g:ale_echo_msg_format = '[%severity%] %s'
let g:ale_javascript_eslint_use_global = 1
let g:ale_linter_aliases = {
  \ 'javascript.jsx': 'javascript',
  \ 'jsx': 'javascript'
  \ }
let g:ale_linters = {
  \ 'javascript': ['eslint']
  \ }
nmap <silent> <Leader>j <Plug>(ale_next_wrap)
nmap <silent> <Leader>k <Plug>(ale_previous_wrap)

" ----------------------------------------------------------------------------
"	ctrlsf
" ----------------------------------------------------------------------------
nnoremap <C-f> :CtrlSF<Space>
nnoremap <Leader>f yiw:CtrlSF <C-r>"<Cr>
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_ignore_dir = ["node_modules"]
let g:ctrlsf_mapping = {
  \ "vplit": "<C-v>",
  \ "quit": "<Esc>",
  \ }

" ----------------------------------------------------------------------------
"	fzf.vim
" ----------------------------------------------------------------------------
nnoremap <C-p> :Files<Cr>
nnoremap <Leader>l :BLines<Cr>
nnoremap <Leader><Leader> :Buffers<Cr>
nnoremap <Leader>mp :Maps<Cr>

" ----------------------------------------------------------------------------
"	indentLine
" ----------------------------------------------------------------------------
nnoremap <Leader><Tab> :IndentLinesToggle<Cr>
let g:indentLine_enabled = 1

" ----------------------------------------------------------------------------
"	nerdcommenter
" ----------------------------------------------------------------------------
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
  \ 'javascript.jsx': {
      \ 'left': '//',
      \ 'leftAlt': '{/*',
      \ 'rightAlt': '*/}' }
  \ }

" ----------------------------------------------------------------------------
"	jsdoc
" ----------------------------------------------------------------------------
nmap <silent> <Leader>dc <Plug>(jsdoc)

" ----------------------------------------------------------------------------
"	vim-autoformat
" ----------------------------------------------------------------------------
nnoremap <Leader>af :Autoformat<Cr>
autocmd FileType vim let b:autoformat_autoindent=0

" ----------------------------------------------------------------------------
"	MatchTagAlways
" ----------------------------------------------------------------------------
let g:mta_filetypes = {
  \  "javascript.jsx": 1,
  \ }

" ----------------------------------------------------------------------------
"	vim-easymotion
" ----------------------------------------------------------------------------
nmap f <Plug>(easymotion-prefix)
nmap ff <Plug>(easymotion-s)
nmap fh <Plug>(easymotion-linebackward)
nmap fj <Plug>(easymotion-j)
nmap fk <Plug>(easymotion-k)
nmap fl <Plug>(easymotion-lineforward)
nmap / <Plug>(easymotion-sn)
let g:EasyMotion_smartcase = 1

" ----------------------------------------------------------------------------
"	vim-surround
" ----------------------------------------------------------------------------
nmap , ysiw
let g:surround_35 = "#{\r}"
let g:surround_36 = "${\r}"

" ----------------------------------------------------------------------------
"	SuperTab
" ----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<C-n>'

" ----------------------------------------------------------------------------
"	Emmet.vim
" ----------------------------------------------------------------------------
let g:user_emmet_install_global = 1
let g:user_emmet_expandabbr_key = '<C-e>'

" ----------------------------------------------------------------------------
"	vim-closetag
" ----------------------------------------------------------------------------
let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.js,*.jsx,*.html.erb,*.md'

" ----------------------------------------------------------------------------
"	tern_for_vim
" ----------------------------------------------------------------------------
nnoremap <Leader>td :TernDef<Cr>
nnoremap <Leader>tdp :TernDefPreview<Cr>
nnoremap <Leader>tds :TernDefSplit<Cr>

" ----------------------------------------------------------------------------
"	YouCompleteMe
" ----------------------------------------------------------------------------
let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_key_list_previous_completion = ['<C-p>']
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
  \ 'clojure': [ 're!:' ]
  \ }

" ----------------------------------------------------------------------------
"	UltiSnips
" ----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:snips_author='Ahonn Jiang'
let g:snips_email='ahonn95@outlook.com'
let g:snips_github='https://github.com/ahonn'

