""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Plugins                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use scriptencoding when multibyte char exists
scriptencoding utf-8

" install plug.vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.vim/plugged')
  " Colorscheme
  " Plug 'w0ng/vim-hybrid'
  " Plug 'morhetz/gruvbox'

  " Language
  Plug 'ap/vim-css-color'
  Plug 'moll/vim-node'
  Plug 'pangloss/vim-javascript'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'SpaceVim/vim-swig'
  Plug 'godlygeek/tabular' " must before vim-markdown
  Plug 'plasticboy/vim-markdown'
  Plug 'posva/vim-vue'
  Plug 'yuezk/xtpl.vim'
  Plug 'othree/html5.vim'
  Plug 'dag/vim-fish'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'frozen': 1 }
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'cespare/vim-toml'
  Plug 'rust-lang/rust.vim'

  " Interface
  " Plug 'cocopon/colorswatch.vim'
  " Plug 'cocopon/pgmnt.vim'
  Plug 'majutsushi/tagbar'
  Plug 'ahonn/vim-fileheader'
  Plug 'luochen1990/rainbow'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'airblade/vim-gitgutter'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  Plug 'simeji/winresizer'
  Plug 'thaerkh/vim-workspace'

  " Integration
  Plug 'w0rp/ale'
  Plug 'Shougo/denite.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'rhysd/vim-fixjson', { 'for': 'json' }
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'lyokha/vim-xkbswitch'
  " Plug 'vim-jp/vital.vim'

  " Display
  Plug 'Yggdroot/indentLine'
  Plug 'scrooloose/nerdcommenter'
  Plug 'heavenshell/vim-jsdoc'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Valloric/MatchTagAlways'
  Plug 'sbdchd/neoformat'
  Plug 'snoe/nvim-parinfer.js', { 'for': 'clojure' }

  " Commands
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'easymotion/vim-easymotion'
  Plug 'kana/vim-textobj-user'
  Plug 'Julian/vim-textobj-brace'
  Plug 'sgur/vim-textobj-parameter'

  " Completion
  Plug 'ervandew/supertab'
  Plug 'alvan/vim-closetag'
  Plug 'mattn/emmet-vim'
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ 'frozen': 1,
    \ }
  Plug 'carlitux/deoplete-ternjs'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  Plug 'galooshi/vim-import-js', { 'do': 'npm install import-js -g' }
  Plug 'Shougo/neco-vim', { 'for': 'vim' }

  " Snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'VimSnippets/vim-web-snippets'

  " Analyze
  Plug 'wakatime/vim-wakatime'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Configure                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ----------------------------------------------------------------------------
" Colorscheme
" ----------------------------------------------------------------------------
" let g:hybrid_custom_term_colors = 1
" colorscheme hybrid
let g:gruvbox_bold = 0
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_selection = 0
colorscheme gruvbox

" ----------------------------------------------------------------------------
" Plugin
" ----------------------------------------------------------------------------
nnoremap <Leader>pi :PlugInstall<Cr>
nnoremap <Leader>pc :PlugClean<Cr>
nnoremap <Leader>pu :PlugUpdate<Cr>

" ----------------------------------------------------------------------------
" vim-javascript
" ----------------------------------------------------------------------------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:javascript_enable_domhtmlcss = 1

" vim-jsx-pretty
let g:vim_jsx_pretty_enable_jsx_highlight = 1
let g:vim_jsx_pretty_colorful_config = 1
augroup JSX
  autocmd!
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

" ----------------------------------------------------------------------------
" javascript-libraries-syntax.vim
" ----------------------------------------------------------------------------
let g:used_javascript_libs = 'underscore,jquery,react'

" ----------------------------------------------------------------------------
" vim-markdown
" ----------------------------------------------------------------------------
function! ToggleConceal() abort
  if &conceallevel
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction
nnoremap <Leader>m :call ToggleConceal()<Cr>
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_fenced_languages = ['js=javascript']

" ----------------------------------------------------------------------------
" wxapp.vim
" ----------------------------------------------------------------------------
augroup Wxapp
  autocmd!
  autocmd BufNewFile,BufRead *.wxss set filetype=wxss.css
augroup END

" ----------------------------------------------------------------------------
" vim-vue
" ----------------------------------------------------------------------------
augroup Vue
  autocmd BufRead,BufNewFile *.vue setlocal filetype=html.css.vue
augroup END

" ----------------------------------------------------------------------------
" rainbow
" ----------------------------------------------------------------------------
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\ }

" ----------------------------------------------------------------------------
" vim-devicons
" ----------------------------------------------------------------------------
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
" if exists('g:loaded_webdevicons')
  " call webdevicons#refresh()
" endif

" ----------------------------------------------------------------------------
" nerdtree
" ----------------------------------------------------------------------------
noremap <C-b> :NERDTreeToggle<Cr>
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
augroup Nerdtree
  autocmd!
  autocmd FileType nerdtree setlocal nocursorcolumn
  autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif
  if has('gui_running')
    autocmd FileType nerdtree setlocal nolist
  endif
augroup END

" ----------------------------------------------------------------------------
" vim-airline
" ----------------------------------------------------------------------------
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#xkblayout#enabled = 0

" ----------------------------------------------------------------------------
" gundo
" ----------------------------------------------------------------------------
nnoremap <Leader>ud :GundoToggle<Cr>
let g:gundo_width = 50
let g:gundo_preview_height = 40
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" ----------------------------------------------------------------------------
" winresizer
" ----------------------------------------------------------------------------
let g:winresizer_start_key = '<Leader>r'

" ----------------------------------------------------------------------------
" tagbar
" ----------------------------------------------------------------------------
nnoremap <Leader>t :TagbarToggle<Cr>
let g:tagbar_sort = 0
let g:tagbar_compact = 1

" ----------------------------------------------------------------------------
" vim-workspace
" ----------------------------------------------------------------------------
nnoremap <Leader>s :ToggleWorkspace<Cr>
let g:workspace_autocreate = 1
let g:workspace_autosave = 0
let g:workspace_persist_undo_history = 1
let g:workspace_session_name = '.vimworkspace'
let g:workspace_undodir = '.undodir'

" ----------------------------------------------------------------------------
" denite
" ----------------------------------------------------------------------------
nnoremap <silent> <Leader><Leader> :<C-u>Denite buffer<Cr>
nnoremap <silent> <C-t> :<C-u>Denite outline<Cr>
nnoremap <silent> <C-f> :<C-u>Denite grep<Cr>
nnoremap <silent> <C-p> :<C-u>Denite `finddir('.git', ';') != '' ? 'file/rec/git' : 'file/rec'`<Cr>

call denite#custom#option('default', 'unique', 1)
call denite#custom#option('default', 'reversed', 1)
call denite#custom#option('default', 'auto-resize', 1)
call denite#custom#option('default', 'highlight_matched_char', 'Underlined')

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-s>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('insert', '<C-i>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('_', '<C-x>', '<denite:do_action:delete>', 'noremap')

" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--path-to-ignore=~/.gitignore_global'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" ----------------------------------------------------------------------------
" ale
" ----------------------------------------------------------------------------
nnoremap <leader>al :ALEToggle<Cr>
" let g:ale_sign_error = '◉'
" let g:ale_sign_warning = '◉'
let g:ale_sign_warning = '●'
let g:ale_sign_error = '●'
highlight! ALEErrorSign ctermfg=9 guifg=#C30500
highlight! ALEWarningSign ctermfg=11 guifg=#F0C674
" let g:ale_javascript_eslint_use_global = 1
let g:ale_linter_aliases = {
  \ 'javascript.jsx': 'javascript',
  \ 'jsx': 'javascript'
  \ }
let g:ale_linters = {
  \ 'typescript': ['tslint'],
  \ 'javascript': ['eslint'],
  \ }
let g:ale_fixers = {
  \ 'javascript': 'eslint',
  \ 'vue': 'eslint',
  \ 'typescript': 'tslint',
  \ }
nmap <silent> <Leader>f <Plug>(ale_fix)

" ----------------------------------------------------------------------------
" vim-trailing-whitespace
" ----------------------------------------------------------------------------
let g:extra_whitespace_ignored_filetypes = ['denite', 'help', 'grep', 'search']
augroup TrailingSpace
  autocmd!
  autocmd BufWritePre * FixWhitespace
augroup END

" ----------------------------------------------------------------------------
" gutentags
" ----------------------------------------------------------------------------
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = $DOTFILES.'/lib/libxkbswitch.dylib'

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
nnoremap <Leader><Tab> :IndentLinesToggle<Cr>
let g:indentLine_enabled = 1
let g:indentLine_color_term = 235
let g:indentLine_faster = 1
let g:indentLine_char = '¦'

" ----------------------------------------------------------------------------
" nerdcommenter
" ----------------------------------------------------------------------------
let g:NERDSpaceDelims = 1
let g:NERDDefaultNesting = 1
let g:NERDDefaultAlign = 'left'

" ----------------------------------------------------------------------------
" jsdoc
" ----------------------------------------------------------------------------
nmap <silent> <Leader>dc <Plug>(jsdoc)
let g:jsdoc_enable_es6 = 1
let g:jsdoc_access_descriptions = 2
let g:jsdoc_underscore_private = 1

" ----------------------------------------------------------------------------
" neoformat
" ----------------------------------------------------------------------------
noremap <silent> <Leader>af :Neoformat<Cr>

" ----------------------------------------------------------------------------
" MatchTagAlways
" ----------------------------------------------------------------------------
let g:mta_filetypes = {
  \  'javascript.jsx': 1,
  \ }

" ----------------------------------------------------------------------------
" nvim-parinfer
" ----------------------------------------------------------------------------
let g:parinfer_mode = 'indent'

" ----------------------------------------------------------------------------
" vim-easymotion
" ----------------------------------------------------------------------------
map fh <Plug>(easymotion-linebackward)
map fj <Plug>(easymotion-w)
map fk <Plug>(easymotion-b)
map fl <Plug>(easymotion-lineforward)
let g:EasyMotion_keys = 'asdhjkl;qwer'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_grouping = 2
let g:EasyMotion_smartcase = 1

" ----------------------------------------------------------------------------
" vim-textobj-parameter
" ----------------------------------------------------------------------------
let g:vim_textobj_parameter_mapping = 'a'

" ----------------------------------------------------------------------------
" vim-fileheader
" ----------------------------------------------------------------------------
let g:fileheader_auto_add = 1
let g:fileheader_show_email = 0

" ----------------------------------------------------------------------------
" vim-surround
" ----------------------------------------------------------------------------
nmap <silent> , ysiw
let g:surround_35 = "#{\r}"
let g:surround_36 = "${\r}"

" ----------------------------------------------------------------------------
" SuperTab
" ----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

" ----------------------------------------------------------------------------
" Emmet.vim
" ----------------------------------------------------------------------------
imap <C-e> <Space><BS><plug>(emmet-expand-abbr)
let g:user_emmet_install_global = 1
let g:user_emmet_settings = {
  \ 'javascript.jsx' : {
  \   'extends' : 'jsx',
  \  },
  \ 'javascript' : {
  \   'extends' : 'jsx',
  \  },
  \ }

" ----------------------------------------------------------------------------
" vim-closetag
" ----------------------------------------------------------------------------
let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.js,*.jsx,*.html.erb,*.md'

" ----------------------------------------------------------------------------
" deoplete.nvim
" ----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_menu_width = 60
call deoplete#custom#source('_', 'matchers', ['matcher_head', 'matcher_length'])

" ----------------------------------------------------------------------------
" tern_for_vim
" ----------------------------------------------------------------------------
let g:tern_show_argument_hints='on_hold'
let g:tern_show_signature_in_pum = 1

" ----------------------------------------------------------------------------
" deoplete-ternjs
" ----------------------------------------------------------------------------
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0
" Use tern_for_vim.
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent', '--no-port-file']

" ----------------------------------------------------------------------------
" vim-import-js
" ----------------------------------------------------------------------------
nnoremap <Leader>i :ImportJSWord<Cr>
nnoremap <Leader>g :ImportJSGoto<Cr>

" ----------------------------------------------------------------------------
" LanguageClient
" ----------------------------------------------------------------------------
let g:LanguageClient_serverCommands = {
  \   'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
  \   'typescript': ['javascript-typescript-stdio'],
  \   'javascript': ['javascript-typescript-stdio'],
  \   'go': ['go-langserver'],
  \ }
let g:LanguageClient_completionPreferTextEdit = 1
let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_diagnosticsDisplay = {
  \   1: {
  \     'name': 'Error',
  \     'texthl': 'ALEError',
  \     'signText': g:ale_sign_error,
  \     'signTexthl': 'ALEErrorSign',
  \   },
  \   2: {
  \     'name': 'Warning',
  \     'texthl': 'ALEWarning',
  \     'signText': g:ale_sign_warning,
  \     'signTexthl': 'ALEWarningSign',
  \   },
  \ }

function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<Cr>
    nnoremap <silent> gr :call LanguageClient#textDocument_rename()<Cr>
  endif
endfunction

augroup LanguageClient
  autocmd FileType * call LC_maps()
augroup END

" ----------------------------------------------------------------------------
" UltiSnips
" ----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'

