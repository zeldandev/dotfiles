set nocompatible " no compatible with vi

set history=1000 " number of command stored in history to go back


set autoindent " automatically indent new lines

set expandtab " replace tabs with spaces automatically

set tabstop=2 " number of spaces to replace a tab with when expandtab

set softtabstop=2 " remove a full pseudo-TAB when i press <BS>

set shiftwidth=2 " sapaces for autoindenting

set title " shows the name of the file in the terminal window

set cursorline " highlight the current line

set ruler " show the line and column number of the cursor position

set showmode " show command and insert mode

set encoding=utf-8 "always use unicode

set backspace=indent,eol,start " allow backspacing over everything in insert mode

set hidden "to hide warning when opening files

set number " show absolute line numbers

set foldmethod=manual " To avoid performance issues, I never fold anything so...


" disable swap files in vim
set nobackup
set nowritebackup
set noswapfile

set showmatch      " higlight matching parentheses and brackets

set hlsearch " when there is a previous search pattern highlight all its matches

set incsearch " show matches while typing a serch command

set ignorecase " ignore case when searching

set smartcase " NOT ignore case in searchs when intentionalliy contains mayus

set wildmenu       " enable visual wildmenu

set nowrap " to show long text in the same line

set laststatus=2 "always show status bar

set spelllang=en,es " spell check dictionary
