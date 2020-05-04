set nocompatible             "sanely reset options when resourcing
"colorscheme badwolf 
colorscheme molokai
syntax enable                "enables syntax processing

set tabstop=4                "number of visual spaces per TAB
set softtabstop=4            "number of spaces in a tab when editing
set expandtab                "tabs are spaces

set number                   "show line numbers
set showcmd                  "displays last command
set cursorline               "highlights current line

filetype indent plugin on    "load filetype-specific indent files and plugins
set wildmenu                 "displays visual autocomplete menu
set lazyredraw               "redraw only when necessary
set showmatch                "highlights matching [{()}]
set hidden                   "allows to switch from an unsaved buffer without saving

set incsearch                "search as characters are entered
set hlsearch                 "highlight matches

set ignorecase               "use case insensitive search
set smartcase                "except when using capital letters

set autoindent               "keep same indent as the line you're on
set nostartofline            "stop certain movements always going to the start of line
set ruler                    "display cursor position
set confirm                  "ask to save changed files instead of failing
set visualbell               "use visual bell instead of dinging
set t_vb=                    "reset terminal code for visual bell
set mouse=a                  "enable mouse

set textwidth=80             "set width t0 80 and make it 
set colorcolumn=+1           "obvious where that is

" Plugins
" Install plugin manager if it's not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plugins

" Css Color Plugin
Plug 'ap/vim-css-color'

" Vue Plugin
Plug 'posva/vim-vue'

" Initialize plugin system
call plug#end()
