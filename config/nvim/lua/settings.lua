vim.g.nvcode_termcolors = 256
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.autoread = true
vim.o.autowrite = false

vim.o.laststatus = 2
vim.o.showmode = false

vim.o.wrap = true
vim.o.linebreak = true
vim.o.showbreak = "->"
vim.o.textwidth = 80
vim.o.colorcolumn = ""

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.autoindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- vim.o.list = true
-- vim.o.listchars = "tab:»·,trail:·,nbsp:·"
vim.o.fillchars = "vert:│,fold:▼"

vim.o.backspace = "indent,eol,start"

vim.o.foldenable = false
vim.o.foldmethod = "syntax"
vim.o.foldlevelstart = 2
vim.o.conceallevel = 0

vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.sessionoptions = "buffers,tabpages,winsize,winpos"

vim.o.cursorline = true
vim.o.scrolloff = 10

vim.o.encoding = "utf-8"
vim.o.fileencodings = "utf-8,gbk,gb2312,gb18030"

vim.o.updatetime = 250

vim.cmd([[syntax on]])

