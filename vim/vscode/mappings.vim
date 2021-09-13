""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                          VS Code Mappings                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

noremap H ^
noremap L $
nnoremap J G
nnoremap K gg

vnoremap J G
vnoremap K gg

nnoremap <silent> <C-j> :<C-u>call VSCodeNotify('workbench.action.focusBelowGroup')<Cr>
nnoremap <silent> <C-k> :<C-u>call VSCodeNotify('workbench.action.focusAboveGroup')<Cr>
nnoremap <silent> <C-h> :<C-u>call VSCodeNotify('workbench.action.focusLeftGroup')<Cr>
nnoremap <silent> <C-l> :<C-u>call VSCodeNotify('workbench.action.focusRightGroup')<Cr>

nnoremap <silent> <C-b> :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<Cr>

nnoremap <silent> <C-w>H :<C-u>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<Cr>
nnoremap <silent> <C-w>L :<C-u>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<Cr>

nnoremap <silent> <Leader>f :<C-u>call VSCodeNotify('editor.action.formatDocument')<Cr>
