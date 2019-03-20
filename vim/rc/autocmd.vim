augroup Common
  autocmd!

  " cursorline
  autocmd WinLeave * set nocursorline
  autocmd WinEnter * set cursorline

  " term
  autocmd TermOpen * setlocal nonumber norelativenumber
  autocmd WinEnter term://* startinsert

  " css/less/scss keyword
  autocmd FileType css,less,scss setlocal iskeyword+=-
augroup end
