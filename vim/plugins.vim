if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.vim/plugged')
  " Colorscheme
  Plug 'w0ng/vim-hybrid'
  Plug 'gruvbox-community/gruvbox'

  " Language
  Plug 'dag/vim-fish'
  Plug 'pangloss/vim-javascript'
  Plug 'neoclide/vim-jsx-improve'
  Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'typescript'] }
  Plug 'herringtondarkholme/yats.vim', { 'for': 'typescript' }
  Plug 'groenewege/vim-less'
  Plug 'ap/vim-css-color'
  Plug 'hail2u/vim-css3-syntax'
  " Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release', 'for': ['clojure'] }
  " Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
  " Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  " Plug 'evanleck/vim-svelte', { 'for': 'svelte' }
  Plug 'leafo/moonscript-vim', { 'for': 'moon' }

  " UI
  Plug 'luochen1990/rainbow'
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-gitgutter'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  Plug 'ahonn/resize.vim'
  Plug 'Yggdroot/LeaderF'

  " Integration
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'easymotion/vim-easymotion'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Valloric/MatchTagAlways'
  Plug 'alvan/vim-closetag'
  Plug 'ahonn/vim-fileheader'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'wakatime/vim-wakatime'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'tpope/vim-fugitive'
  Plug 'rhysd/git-messenger.vim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'thaerkh/vim-workspace'
  Plug 'chaoren/vim-wordmotion'
  Plug 'kana/vim-textobj-user'
  Plug 'sgur/vim-textobj-parameter'
  Plug 'kkoomen/vim-doge'

  " Completion
  Plug 'mattn/emmet-vim'
  Plug 'neoclide/coc.nvim', { 'do': 'yarn install' }
call plug#end()

nnoremap <silent> <Leader>pi :PlugInstall<Cr>
nnoremap <silent> <Leader>pc :PlugClean<Cr>
nnoremap <silent> <Leader>pu :PlugUpdate<Cr>

" ----------------------------------------------------------------------------
" Colorscheme
" ----------------------------------------------------------------------------

" hybrid
let g:hybrid_custom_term_colors = 1
" colorscheme hybrid

" gruvbox
let g:gruvbox_bold = 0
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_selection = 0

colorscheme gruvbox

" ----------------------------------------------------------------------------
" Language
" ----------------------------------------------------------------------------

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:javascript_enable_domhtmlcss = 1

" javascript-libraries-syntax.vim
let g:used_javascript_libs = 'underscore,jquery,react'

" vim-clojure-static
let g:clojure_syntax_keywords = {
  \ 'clojureMacro': ['deftest', 'defnc'],
  \ }

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------

" indentLine
nnoremap <silent> <Leader><Tab> :IndentLinesToggle<Cr>
let g:indentLine_enabled = 1
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#504945'
let g:indentLine_faster = 1
" let g:indentLine_char = '┊'

" vim-devicons
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" nerdtree
noremap <silent> <C-b> :NERDTreeToggle<Cr>
" let NERDTreeIgnore=['_.*$[[dir]]']
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

" vim-airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#hunks#enabled = 0

" gundo
nnoremap <silent> <Leader>ud :GundoToggle<Cr>
let g:gundo_width = 50
let g:gundo_preview_height = 40
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" LeaderF
nnoremap <silent> <C-p> :Leaderf file<Cr>
nnoremap <silent> <C-f> :Leaderf rg<Cr>
nnoremap <silent> <C-q> :Leaderf line<Cr>
nnoremap <silent> <Leader><Leader> :Leaderf buffer<Cr>

" ----------------------------------------------------------------------------
" Integration
" ----------------------------------------------------------------------------

" nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultNesting = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {
  \   'clojure': { 'left': ';;' },
  \ }

" vim-surround
nmap <silent> , ysiw
let g:surround_35 = "#{\r}"
let g:surround_36 = "${\r}"

" vim-easymotion
map <silent> <Leader>h <Plug>(easymotion-linebackward)
map <silent> <Leader>j <Plug>(easymotion-w)
map <silent> <Leader>k <Plug>(easymotion-b)
map <silent> <Leader>l <Plug>(easymotion-lineforward)
let g:EasyMotion_keys = 'asdhjkl;qwer'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_grouping = 2
let g:EasyMotion_smartcase = 1

" MatchTagAlways
let g:mta_filetypes = {
  \  'javascript': 1,
  \  'javascript.jsx': 1,
  \  'typescript': 1,
  \ }

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.js,*.jsx,*.html.erb,*.md'

" vim-fileheader
let g:fileheader_auto_add = 0
let g:fileheader_show_email = 0

" vim-trailing-whitespace
let g:extra_whitespace_ignored_filetypes = ['denite', 'help', 'grep', 'search']
augroup TrailingSpace
  autocmd!
  autocmd BufWritePre * FixWhitespace
augroup END

" gutentags
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_exclude_filetypes = ['gitcommit']
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif

" git-messenger.vim
nnoremap gm :GitMessenger<Cr>

" vim-textobj-parameter
let g:vim_textobj_parameter_mapping = 'a'

" vim-doge
let g:doge_mapping = '<Leader>dc'

" vim-workspace
nnoremap <Leader>s :ToggleWorkspace<Cr>
let g:workspace_autocreate = 1
let g:workspace_autosave = 0
let g:workspace_persist_undo_history = 1
let g:workspace_session_name = '.vimworkspace'
let g:workspace_undodir = '.undodir'

" ----------------------------------------------------------------------------
" Completion
"----------------------------------------------------------------------------

" Emmet.vim
imap <silent> <C-e> <Space><BS><plug>(emmet-expand-abbr)
let g:user_emmet_install_global = 1
let g:user_emmet_settings = {
  \ 'javascript.jsx' : {
  \   'extends' : 'jsx',
  \  },
  \ 'javascript' : {
  \   'extends' : 'jsx',
  \  },
  \ }

" coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gh :call CocAction('doHover')<CR>
nnoremap <silent> ga :CocList actions --normal<CR>

nmap <silent> <Leader>r <Plug>(coc-rename)
nmap <silent> <Leader>f <Plug>(coc-format)
nmap <silent> <leader>p <Plug>(coc-format-selected)
vmap <silent> <leader>p <Plug>(coc-format-selected)

vmap <silent> <Tab> <Plug>(coc-snippets-select)
inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<Cr>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

call coc#add_extension(
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-vimlsp',
  \ 'coc-snippets',
  \ 'coc-word',
  \ 'coc-prettier',
  \ 'coc-diagnostic',
  \ 'coc-eslint'
  \ )
