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

  " Language
  Plug 'ap/vim-css-color'
  Plug 'pangloss/vim-javascript'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
  Plug 'hail2u/vim-css3-syntax'
  Plug 'SpaceVim/vim-swig', { 'for': 'swig' }
  Plug 'godlygeek/tabular', { 'for': 'markdown' } " must before vim-markdown
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'posva/vim-vue', { 'for': 'vue' }
  Plug 'yuezk/xtpl.vim', { 'for': 'xtpl' }

  " Interface
  " Plug 'cocopon/colorswatch.vim'
  " Plug 'cocopon/pgmnt.vim'
  Plug 'luochen1990/rainbow'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'airblade/vim-gitgutter'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'sjl/gundo.vim'
  Plug 'majutsushi/tagbar', { 'do': 'npm install -g jsctags', 'on': 'TagbarToggle' }
  Plug 'simeji/winresizer'
  Plug 'thaerkh/vim-workspace'
  Plug 'vimwiki/vimwiki'

  " Integration
  Plug 'w0rp/ale'
  Plug 'mileszs/ack.vim'
  if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
  endif
  Plug 'tpope/vim-fugitive'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'bronson/vim-trailing-whitespace'

  " Display
  Plug 'Yggdroot/indentLine'
  Plug 'scrooloose/nerdcommenter'
  Plug 'heavenshell/vim-jsdoc'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Valloric/MatchTagAlways'
  Plug 'Chiel92/vim-autoformat'
  Plug 'snoe/nvim-parinfer.js', { 'for': 'clojure' }

  " Commands
  Plug 'ahonn/fileheader.nvim'
  Plug 'danro/rename.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'easymotion/vim-easymotion'
  Plug 'kana/vim-textobj-user'
  Plug 'Julian/vim-textobj-brace'

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
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install -g tern' }
  Plug 'carlitux/deoplete-ternjs'
  Plug 'mhartington/nvim-typescript', { 'for': 'typescript' }
  Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
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
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

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
" vim-devicons
" ----------------------------------------------------------------------------
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" ----------------------------------------------------------------------------
" vim-airline
" ----------------------------------------------------------------------------
let g:airline_theme='jellybeans'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 1

" ----------------------------------------------------------------------------
" gundo
" ----------------------------------------------------------------------------
nnoremap <Leader>ud :GundoToggle<Cr>
let g:gundo_width = 50
let g:gundo_preview_height = 40
let g:gundo_right = 1
let g:gundo_prefer_python3 = 1

" ----------------------------------------------------------------------------
" tagbar
" ----------------------------------------------------------------------------
nnoremap <Leader>tb :TagbarToggle<Cr>
let g:tagbar_sort = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_type_vimwiki = {
  \  'ctagstype':'vimwiki',
  \  'kinds':['h:header'],
  \  'sro':'&&&',
  \  'kind2scope':{'h':'header'},
  \  'sort':0,
  \  'ctagsbin':'vwtags',
  \  'ctagsargs': 'default',
  \ }

" ----------------------------------------------------------------------------
" winresizer
" ----------------------------------------------------------------------------
let g:winresizer_start_key = '<Leader>r'

" ----------------------------------------------------------------------------
" vim-workspace
" ----------------------------------------------------------------------------
nnoremap <Leader>s :ToggleWorkspace<Cr>
let g:workspace_session_name = '.vimworkspace'
let g:workspace_undodir = $HOME.'/.undodir'
let g:workspace_autosave = 0

" ----------------------------------------------------------------------------
" vimwiki
" ----------------------------------------------------------------------------
let s:wiki = {}
let s:wiki.path = '~/vimwiki/source'
let s:wiki.path_html = '~/vimwiki/docs/'
let s:wiki.template_path = '~/vimwiki/docs/assets/'
let s:wiki.template_default = 'default'
let s:wiki.template_ext = '.tpl'
let s:wiki.css_name = ''
let g:vimwiki_list = [s:wiki]
let g:vimwiki_toc_header = 'TOC'
function! SyncToWikiSite()
  execute ':!git add .'
  execute ':!git commit -m "Syn at `date`"'
  execute ':!git push -f origin master'
endfunction
function! DeployVimwiki()
  VimwikiAll2HTML
  call SyncToWikiSite()
  set filetype=vimwiki
endfunction
function! SetVimwikiMapping()
  nmap <buffer> <Leader>wha :VimwikiAll2HTML<Cr>
  nmap <buffer> <Leader>whd :call DeployVimwiki()<Cr>
  nmap <buffer> <Leader>tt <Plug>VimwikiToggleListItem
  nmap <buffer> <Leader>td <Plug>VimwikiRemoveSingleCB
endfunction
augroup Vimwiki
  autocmd!
  autocmd FileType vimwiki call SetVimwikiMapping()
  autocmd BufWritePost *.wiki VimwikiTOC
augroup END

" ----------------------------------------------------------------------------
" ale
" ----------------------------------------------------------------------------
nnoremap <leader>al :ALEToggle<Cr>
let g:ale_sign_error = '◉'
let g:ale_sign_warning = '◉'
highlight! ALEErrorSign ctermfg=9 guifg=#C30500
highlight! ALEWarningSign ctermfg=11 guifg=#F0C674
" let g:ale_javascript_eslint_use_global = 1
let g:ale_linter_aliases = {
  \ 'javascript.jsx': 'javascript',
  \ 'jsx': 'javascript'
  \ }
let g:ale_fixers = {
  \ 'javascript': 'eslint',
  \ }
nmap <silent> <Leader>f <Plug>(ale_fix)

" ----------------------------------------------------------------------------
" ack.vim
" ----------------------------------------------------------------------------
nnoremap <C-f> :Ack!<Space>
let g:ackprg = 'rg --vimgrep --no-heading'
let g:ack_autoclose = 1
let g:ack_mappings = {
  \ 'x': '<C-W><CR><C-W>K',
  \ 'gx': '<C-W><CR><C-W>K<C-W>b'
  \ }

" ----------------------------------------------------------------------------
" fzf.vim
" ----------------------------------------------------------------------------
nnoremap <silent> <C-p> :Files<Cr>
nnoremap <silent> <C-i> :BLines<Cr>
nnoremap <silent> <Leader><Leader> :Buffers<Cr>

" ----------------------------------------------------------------------------
" vim-trailing-whitespace
" ----------------------------------------------------------------------------
augroup TrailingSpace
  autocmd!
  autocmd BufWritePre * FixWhitespace
augroup END

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
nnoremap <Leader><Tab> :IndentLinesToggle<Cr>
let g:indentLine_enabled = 1
let g:indentLine_color_term = 236
let g:indentLine_faster = 1

" ----------------------------------------------------------------------------
" nerdcommenter
" ----------------------------------------------------------------------------
let g:NERDSpaceDelims = 1
let g:NERDDefaultNesting = 1
let g:NERDCustomDelimiters = {
  \ 'javascript': {
      \ 'left': '//',
      \ 'leftAlt': '{/*',
      \ 'rightAlt': '*/}'
    \ },
    \ 'clojure': {
      \ 'left': ';;',
    \ },
    \ 'haskell': {
      \ 'left': '--',
    \ }
  \ }

" ----------------------------------------------------------------------------
" jsdoc
" ----------------------------------------------------------------------------
nmap <silent> <Leader>dc <Plug>(jsdoc)
let g:jsdoc_enable_es6 = 1
let g:jsdoc_custom_args_regex_only = 1
let g:jsdoc_custom_args_hook = {
  \   '^\$': {
  \     'type': '{jQuery}'
  \   },
  \   'data': {
  \     'type': '{Object}'
  \   },
  \   '^e$': {
  \     'type': '{Event}'
  \   },
  \   'el$': {
  \     'type': '{Element}'
  \   },
  \   '\(err\|error\)$': {
  \     'type': '{Error}'
  \   },
  \   'handler$': {
  \     'type': '{Function}'
  \   },
  \   '^i$': {
  \     'type': '{Number}'
  \   },
  \   '^_\?is': {
  \     'type': '{Boolean}'
  \   },
  \   'options$': {
  \     'type': '{Object}'
  \   },
  \ }

" ----------------------------------------------------------------------------
" vim-autoformat
" ----------------------------------------------------------------------------
noremap <Leader>af :Autoformat<Cr>
let g:autoformat_retab = 1
let g:autoformat_remove_trailing_spaces = 1

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
map fj <Plug>(easymotion-j)
map fk <Plug>(easymotion-k)
map fl <Plug>(easymotion-lineforward)
nmap / <Plug>(easymotion-sn)
let g:EasyMotion_keys = 'asdhjkl;'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_grouping = 2
let g:EasyMotion_smartcase = 1


" ----------------------------------------------------------------------------
" fileheader.nvim
" ----------------------------------------------------------------------------
let g:fileheader_auto_add = 1
let g:fileheader_auto_update = 1
let g:fileheader_default_author = 'ahonn'
let g:fileheader_show_email = 0
let g:fileheader_by_git_config = 1

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
"  fix emmet when ycm preview not close
imap <C-e> <plug>(emmet-expand-abbr)
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
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ ]
let g:deoplete#omni#functions.haskell = [
  \ 'necoghc#omnifunc',
  \ ]

" ----------------------------------------------------------------------------
" tern_for_vim
" ----------------------------------------------------------------------------
let g:tern_show_argument_hints='on_hold'
let g:tern_show_signature_in_pum = 1
function! SetJSDef() abort
  nnoremap <buffer> <C-]> :TernDefPreview<Cr>
endfunction
augroup JSDef
  autocmd!
  autocmd FileType javascript.jsx,javascript call SetJSDef()
augroup END

" ----------------------------------------------------------------------------
" deoplete-ternjs
" ----------------------------------------------------------------------------
let g:deoplete#sources#ternjs#types = 1
" Use tern_for_vim.
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" ----------------------------------------------------------------------------
" nvim-typescript
" ----------------------------------------------------------------------------
let g:nvim_typescript#type_info_on_hold = 1
let g:nvim_typescript#signature_complete = 1
function! SetTSDef() abort
  nnoremap <buffer> <C-]> :TSDefPreview<Cr>
endfunction
augroup TSDef
  autocmd!
  autocmd FileType typescript call SetTSDef()
augroup END

" ----------------------------------------------------------------------------
" neco-ghc
" ----------------------------------------------------------------------------
let g:haskellmode_completion_ghc = 0
let g:necoghc_enable_detailed_browse = 1
augroup Haskell
  autocmd!
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

" ----------------------------------------------------------------------------
" UltiSnips
" ----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:snips_author='Ahonn Jiang'
let g:snips_email='ahonn95@outlook.com'
let g:snips_github='https://github.com/ahonn'

