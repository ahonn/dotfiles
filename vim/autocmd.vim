augroup Common
  autocmd!

  " cursorline
  autocmd WinLeave * set nocursorline
  autocmd WinEnter * set cursorline

  if has('nvim')
    " term
    autocmd TermOpen * setlocal nonumber norelativenumber nohlsearch
    autocmd WinEnter term://* startinsert
    autocmd WinLeave term://* stopinsert
  endif

  " css/less/scss keyword
  autocmd FileType css,less,scss setlocal iskeyword+=-
augroup end
