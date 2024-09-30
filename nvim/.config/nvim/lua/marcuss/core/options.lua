vim.cmd("let g:netrw_liststyle = 3") -- show more of the tree

local opt = vim.opt

opt.confirm = true -- operations that would normally fail due to unsaved changes will instead ask to confirm

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- use 2 spaces for indent width
opt.expandtab = true -- convert tabs to spaces
opt.autoindent = true -- copy indent from current line when starting a new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- assumes case-sensitive when search uses mixed case
opt.hlsearch = false -- remove search highlighting
opt.incsearch = true -- enable incremental searches

vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- cursor line
opt.cursorline = true -- highlight the cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- split windows
opt.splitright = true
opt.splitbelow = true

-- turn off swapfile
opt.swapfile = false

vim.opt.scrolloff = 8
