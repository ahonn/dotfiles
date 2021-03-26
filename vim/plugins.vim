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
  Plug 'leafo/moonscript-vim', { 'for': 'moon' }
  Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release' }

  " UI
  Plug 'luochen1990/rainbow'
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-gitgutter'
  if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'kristijanhusak/defx-icons'
  Plug 'kristijanhusak/defx-git'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  Plug 'mhinz/vim-startify'

  " Integration
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'easymotion/vim-easymotion'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Valloric/MatchTagAlways'
  Plug 'alvan/vim-closetag'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'wakatime/vim-wakatime'
  Plug 'tpope/vim-fugitive'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'chaoren/vim-wordmotion'
  Plug 'matze/vim-move'
  Plug 'kana/vim-textobj-user'
  Plug 'sgur/vim-textobj-parameter'
  Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
  Plug 'vim-test/vim-test'

  " Completion
  Plug 'mattn/emmet-vim'
  Plug 'neoclide/coc.nvim', { 'do': 'yarn install' }
  Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}

  Plug 'nathangrigg/vim-beancount'
call plug#end()

nnoremap <silent> <Leader>pi :PlugInstall<CR>
nnoremap <silent> <Leader>pc :PlugClean<CR>
nnoremap <silent> <Leader>pu :PlugUpdate<CR>

" ----------------------------------------------------------------------------
" Colorscheme
" ----------------------------------------------------------------------------

" hybrid
let g:hybrid_custom_term_colors = 1
" colorscheme hybrid

" gruvbox
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
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

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------

" indentLine
nnoremap <silent> <Leader><Tab> :IndentLinesToggle<CR>
let g:indentLine_enabled = 1
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#504945'
let g:indentLine_faster = 1
" let g:indentLine_char = '┊'

" vim-gitgutter
let g:gitgutter_enabled = 0

" defx.nvim
nnoremap <silent> <C-b> :<C-u>Defx -search=`expand('%:p')`<CR>
" nnoremap <silent> <Leader>b :<C-u>Defx -search=`expand('%:p')`<CR>
call defx#custom#option('_', {
  \ 'winwidth': 30,
  \ 'split': 'vertical',
  \ 'direction': 'topleft',
  \ 'show_ignored_files': 1,
  \ 'buffer_name': '',
  \ 'toggle': 1,
  \ 'resume': 1,
  \ 'columns': 'mark:indent:git:icons:filename:type:size',
  \ })

call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })
function! s:defx_mappings() abort
  nnoremap <silent><buffer> l <Nop>
  nnoremap <silent><buffer> h <Nop>
  nnoremap <silent><buffer><expr> o defx#is_directory() ?  defx#do_action('open_or_close_tree') : defx#do_action('drop',)
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> C defx#do_action('open_directory')
  nnoremap <silent><buffer><expr> U defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> x defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> ma defx#do_action('new_file')
  nnoremap <silent><buffer><expr> md defx#do_action('remove')
  nnoremap <silent><buffer><expr> mm defx#do_action('rename')
  nnoremap <silent><buffer><expr> y defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> s defx#do_action('drop', 'split')
  nnoremap <silent><buffer><expr> i defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> r defx#do_action('redraw')
endfunction
augroup Defx
  autocmd BufWritePost * call defx#redraw()
  autocmd BufEnter * call defx#redraw()
  autocmd BufWritePost * setlocal cursorline
  autocmd BufEnter * setlocal cursorline
  autocmd FileType defx match ExtraWhitespace /^^/
  autocmd FileType defx call s:defx_mappings()
  autocmd FileType defx setlocal nonumber
  autocmd FileType defx setlocal norelativenumber
augroup END

" defx-icons
let g:defx_icons_enable_syntax_highlight = 1

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
nnoremap <silent> <Leader>ud :GundoToggle<CR>
let g:gundo_width = 50
let g:gundo_preview_height = 40
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" vim-startify
let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]
let g:startify_change_to_dir = 0
let g:startify_session_dir = '$DOTFILES/vim/sessions'

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

" vim-trailing-whitespace
let g:extra_whitespace_ignored_filetypes = ['defx', 'help', 'grep', 'search']
augroup TrailingSpace
  autocmd!
  autocmd BufWritePre * FixWhitespace
augroup END

" vim-move
let g:move_map_keys = 0
vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp
vmap <C-h> <Plug>MoveBlockLeft
vmap <C-l> <Plug>MoveBlockRight

" vim-textobj-parameter
let g:vim_textobj_parameter_mapping = 'a'

" vim-doge
let g:doge_mapping = '<Leader>dc'

" vim-test
nnoremap <silent> <Leader>tn :TestNearest<Cr>
nnoremap <silent> <Leader>tf :TestFile<Cr>
nnoremap <silent> <Leader>ts :TestSuite<Cr>

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
nnoremap <silent> ga :CocAction<CR>

nmap <silent> <Leader>r <Plug>(coc-rename)
nmap <silent> <Leader>f <Plug>(coc-format)
nmap <silent> <Leader>p <Plug>(coc-format-selected)
vmap <silent> <Leader>p <Plug>(coc-format-selected)

" coc-git
nmap <silent> <Leader>g :<C-u>CocList --normal gstatus<CR>
nmap <silent> <Leader>c :<C-u>CocList commits<CR>

" coc-lists
nmap <silent> <C-p> :<C-u>CocList files<CR>
nmap <silent> <C-f> :<C-u>CocList grep<CR>
nmap <silent> <Leader><Space> :<C-u>CocList buffers<CR>

inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

call coc#add_extension(
  \ 'coc-tsserver',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-vimlsp',
  \ 'coc-snippets',
  \ 'coc-word',
  \ 'coc-prettier',
  \ 'coc-diagnostic',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-lists',
  \ 'coc-tabnine'
  \ )
