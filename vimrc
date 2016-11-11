" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"Disable filetype for now, as required by vundle, it will be re-enabled later
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Shorten the length of messages to help avoid 'press Enter' messages
set shortmess=a

"The following require vim version >= 7.0
if v:version >= 700
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'vim-scripts/sudo.vim'
    Plugin 'nvie/vim-flake8'
    Plugin 'tmux-plugins/vim-tmux'
    Plugin 'xolox/vim-misc' " Required for vim-notes
    Plugin 'xolox/vim-notes'
    Plugin 'ludovicchabant/vim-lawrencium'
    Plugin 'tpope/vim-fugitive'
    Plugin 'derekwyatt/vim-scala'
    Plugin 'vim-scripts/vcscommand.vim'
endif

"The following require vim version >= 7.2
if v:version > '702'
    " This plugin will still need to be compiled manually
    Plugin 'Shougo/vimproc.vim'
    Plugin 'Shougo/unite.vim'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
endif

"The following require vim version >= 7.3
if v:version > '703'
    Plugin 'vim-scripts/ZoomWin'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Enable code folding.  Type za to open and close a fold
if has("folding")
    set foldmethod=indent
    set foldlevel=99
endif

" Enable the mouse only in normal mode.  This allows copy/paste to still work
" with right-click in putty in insert mode, and scrolling to work in normal mode
set mouse=n

" Enable syntax highlighting
syntax on

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autoindent		" always set autoindenting on
set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the line/column at the bottom of the file
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" Completely disable bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Added to conform with coding standards.
set tabstop=8	    " tabs show up as 8 spaces
set softtabstop=4   " make fake tabs (4 spaces) feel like real tabs
set shiftwidth=4    " insert 4 spaces instead of a tab
set expandtab	    " always insert spaces instead of tabs
set ignorecase      " needed for smartcase
set smartcase	    " search is case insensitive if all lower case
set hlsearch        " when searching, highlight instances of search phrase
set modelines=0     " don't mess with my editor, people!!
au filetype make setlocal noexpandtab " insert real tabs in makefiles

" Don't use Ex mode, use Q for formatting
map Q gq

""""""""""""""""""""""""""""""
" zoomwin
""""""""""""""""""""""""""""""
" Disable optimizations for compatibility with powerline
let g:zoomwin_localoptlist = []

""""""""""""""""""""""""""""""
" flake8
""""""""""""""""""""""""""""""
" Remap the flake8 command to F8 (which really should have been the default!)
autocmd FileType python map <buffer> <F8> :call Flake8()<CR>

""""""""""""""""""""""""""""""
" unite.vim
""""""""""""""""""""""""""""""
"search local directory recursively
nnoremap <C-p> :Unite -start-insert file_rec/async<cr>
"search local directory non-recursively
nnoremap <leader>f :Unite -silent -start-insert file<cr>
"grep in current directory
nnoremap <space>/ :Unite grep:.<cr>
"let g:unite_source_grep_command = "ggrep"
let g:unite_source_history_yank_enable = 1
"search yanked text
nnoremap <space>y :Unite -silent history/yank<cr>
"search opened buffers
nnoremap <space>s :Unite -quick-match -silent buffer<cr>

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif " has("autocmd")

" Print the name of the current function by hitting f in normal mode
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

""""""""""""""""""""""""""""""
" airline
""""""""""""""""""""""""""""""
set encoding=utf-8
set laststatus=2
let g:airline_theme             = 'solarized'
set noshowmode
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline_detect_spell=0
let g:airline#extensions#branch#enabled = 1

"fix delay when pressing escape with powerline
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

if v:version >= 700
    set t_Co=256
    let g:solarized_termcolors=16
    silent colorscheme solarized
    set background=dark
endif

noremap a :set invnumber<cr>"
"Turn off automatic indentation for perl and python files when using # 
"for comments
autocmd BufRead *.py inoremap # X<c-h>#
autocmd BufRead *.pl inoremap # X<c-h>#
nnoremap <M-,> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <M-.> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

""""""""""""""""""""""""""""""
" fugitive/lawrencium
""""""""""""""""""""""""""""""
" Function to call a fugitive function if the current file is under a git
" repository, and call the equivalent lawrencium command otherwise
au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
function! GitMercurial(git_name, hg_name)
        if fugitive#head("show detached") == ""
            execute a:hg_name
        else
            execute a:git_name
        endif
endfunction

nnoremap <leader>gs :call GitMercurial("Gstatus", "Hgstatus")<CR>
nnoremap <leader>gd :call GitMercurial("Gvdiff", "Hgvdiff")<CR>
nnoremap <leader>gb :call GitMercurial("Gblame", "VCSBlame!")<CR>
if !exists(":Greview")
    command Greview :Git! diff --staged
endif
nnoremap <leader>gv :Greview<cr>
nnoremap <leader>gc :call GitMercurial("Gcommit -v -q", "Hgcommit")<CR>
" :Gread is a variant of git checkout -- filename that operates on the buffer rather than the filename
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>ga :call GitMercurial("Git add %:p", "Hg add %:p")<CR>:redraw!<CR>
nnoremap <Leader>gl :call GitMercurial("silent! Glog", "Hglog")<CR>

" Use a spell file for storing dictionary exceptions
set spellfile=~/.vim/spell/exceptions.utf-8.add
" Set up spell checking by default
set spell spelllang=en_us
