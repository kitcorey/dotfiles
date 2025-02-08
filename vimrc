" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"encoding sets how vim shall represent characters internally. Utf-8 is
"necessary for most flavors of Unicode
set encoding=utf-8

call plug#begin()

"The following require vim version >= 7.0
if v:version >= 700
    Plug 'nvie/vim-flake8'
    Plug 'xolox/vim-misc' " Required for vim-notes
    Plug 'xolox/vim-notes'
    Plug 'AndrewRadev/linediff.vim'
    Plug 'ludovicchabant/vim-lawrencium'
    Plug 'tpope/vim-fugitive'
    Plug 'derekwyatt/vim-scala'
    Plug 'vim-scripts/vcscommand.vim'
    Plug 'godlygeek/tabular'
    Plug 'Rykka/riv.vim'
    Plug 'chazy/cscope_maps'
    Plug 'tpope/vim-abolish'
    Plug 'chrisbra/csv.vim'
    Plug 'andymass/vim-matchup'
    Plug 'elzr/vim-json'
    Plug 'vim-scripts/repmo.vim'
    Plug 'PProvost/vim-ps1'
    Plug 'tpope/vim-unimpaired'
    Plug 'tommcdo/vim-lion'
    Plug 'AndrewRadev/sideways.vim'
endif

"The following require vim version >= 7.2
if v:version >= '702'
    " This plugin will still need to be compiled manually
    Plug 'Shougo/vimproc.vim'
    Plug 'Shougo/unite.vim'
    Plug 'Shougo/neoyank.vim'
endif

" All of your Plugs must be added before the following line
call plug#end()

"Shorten the length of messages to help avoid 'press Enter' messages
set shortmess=a

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

" Scrolling
" Enable the mouse only in normal mode.  This allows copy/paste to still work
" with right-click in putty in insert mode, and scrolling to work in normal mode
set mouse=n
" Force vim to use advanced mouse features from the future (dragging)
if has("mouse_sgr")
    set ttymouse=sgr
elseif !has('nvim')
    set ttymouse=xterm2
end
" Keep three lines between the cursor and the edge of the screen
set scrolloff=3
" Move between displayed lines instead of physical lines
nnoremap k gk
nnoremap j gj

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set hidden
set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" Completely disable bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Added to conform with coding standards.
set autoindent		" always set autoindenting on
set tabstop=4	    " tabs show up as 4 spaces
set softtabstop=4   " make fake tabs (4 spaces) feel like real tabs
set shiftwidth=4    " insert 4 spaces instead of a tab
set expandtab	    " always insert spaces instead of tabs
set ignorecase      " needed for smartcase
set modelines=0     " don't mess with my editor, people!!
au filetype make setlocal noexpandtab " insert real tabs in makefiles
set cinoptions+=g0  " don't indent access specifiers

" Search options
set smartcase	    " search is case insensitive if all lower case
set hlsearch        " when searching, highlight instances of search phrase

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
" ack.vim
""""""""""""""""""""""""""""""
"let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackprg = 'rg --vimgrep --no-heading'

""""""""""""""""""""""""""""""
" fzf.vim
""""""""""""""""""""""""""""""
let $FZF_DEFAULT_COMMAND = 'rg --files'
"nnoremap <c-p> :Files<cr>
set grepprg=rg\ --vimgrep
"command! -bang -nargs=* Find call fzf#vim#grep('rg --column --no-heading --fixed-strings --ignore-case --follow --color "always" '.shellescape(<q-args>), 1, <bang>0)
"command! -bang -nargs=* Find call fzf#vim#grep('rg --column --no-heading --fixed-strings --ignore-case --follow --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
"nnoremap <space>/ :Find<Space>
"nnoremap <space>b :Buffer<CR>

""""""""""""""""""""""""""""""
" json.vim
""""""""""""""""""""""""""""""
map <leader>l :silent exec &conceallevel ? "set conceallevel=0" : "set conceallevel=2"<CR>
" =j will use python to reformat json text
" (Use python3 because python 3.5 has the desirable behavior of not re-ordering
" keys alphabetically)
nmap =j :%!python3 -m json.tool<CR>

""""""""""""""""""""""""""""""
" unite.vim
""""""""""""""""""""""""""""""
"search local directory recursively (handled by fzf)
"nnoremap <C-p> :Unite -start-insert file_rec/async<cr>
"search local directory non-recursively
nnoremap <leader>f :Unite -silent -start-insert file<cr>
"grep in current directory
"grep local directory recusively (handled by ack)
"nnoremap <space>/ :Unite grep:.<cr>
"let g:unite_source_grep_command = "ggrep"
let g:unite_source_history_yank_enable = 1
"search yanked text
nnoremap <space>y :Unite -silent history/yank<cr>
"search opened buffers
"nnoremap <space>s :Unite -quick-match -silent buffer<cr>

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif " has("autocmd")

" persistent undo
if has('persistent_undo')
    if !isdirectory($HOME."/.vim/undo")
        call mkdir($HOME."/.vim/undo", "p")
    endif
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000 "maximum number of changes that can be undone
    set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

" Turn off backup files so they don't clutter the file system, since
" persistent undo should be sufficient. Another option would be to use the
" backupdir option to consolidate backup files in a single directory.
" Unfortunately there is an outstanding bug with that option that hasn't been
" patched.  As of 2017-03-08 the backupdir option does not support trailing
" double slashes to guarantee that each file is unique.
"if !isdirectory($HOME."/.vim/backup")
"    call mkdir($HOME."/.vim/backup", "p")
"endif
"set backupdir=~/.vim/backup//
if has('persistent_undo')
    set nobackup
endif

""""""""""""""""""""""""""""""
" General shortcuts
""""""""""""""""""""""""""""""
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

" Maximize the current window (by moving to a new tab)
"nnoremap <C-W>m :wincmd _<Bar>wincmd <Bar><CR>
nnoremap <C-W>m :tab split<CR>

" Show line numbers with a in normal mode
noremap a :set invnumber<cr>"

if &term =~ '256color'
  " Enable true (24-bit) colors instead of (8-bit) 256 colors.
  " :h true-color
  if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
endif

"fix delay when pressing escape with airline
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Enable syntax highlighting
syntax enable

"Turn off automatic indentation for perl and python files when using # 
"for comments
autocmd BufRead *.py inoremap # X<c-h>#
autocmd BufRead *.pl inoremap # X<c-h>#
nnoremap <M-,> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap <M-.> :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

""""""""""""""""""""""""""""""
" Highlight long lines
"""""""""""""""""""""""""""""
"autocmd FileType vim let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
"autocmd FileType python let w:m2=matchadd('ErrorMsg', '\%>105v.\+', -1)

""""""""""""""""""""""""""""""
" YouCompleteMe
""""""""""""""""""""""""""""""
let g:ycm_filetype_whitelist = { 'c': 1, 'cpp': 1 }
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/repos/*']
" completions
set completeopt=longest,menuone
set wildmode=longest,list:longest

""""""""""""""""""""""""""""""
" rtags
""""""""""""""""""""""""""""""
" Use the quickfix window instead
let g:rtagsUseLocationList = 0


""""""""""""""""""""""""""""""
" fugitive/lawrencium
""""""""""""""""""""""""""""""
" Function to call a fugitive function if the current file is under a git
" repository, and call the equivalent lawrencium command otherwise
function! GitMercurial(git_name, hg_name)
        if fugitive#Head("show detached") == ""
            execute a:hg_name
        else
            execute a:git_name
        endif
endfunction
nnoremap <leader>gs :call GitMercurial("Gstatus", "Hgstatus")<CR>
nnoremap <leader>gd :call GitMercurial("Gvdiff", "Hgvdiff")<CR>
nnoremap <leader>gb :call GitMercurial("Git blame", "VCSBlame!")<CR>
if !exists(":Greview")
    command Greview :Git! diff --staged
endif
nnoremap <leader>gv :Greview<cr>
nnoremap <leader>gc :call GitMercurial("Gcommit -v -q", "Hgcommit")<CR>
" :Gread is a variant of git checkout -- filename that operates on the buffer
" instead of the filename
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>ga :call GitMercurial("Git add %:p", "Hg add %:p")<CR>:redraw!<CR>
nnoremap <Leader>gl :call GitMercurial("silent! Glog", "Hglog")<CR>

"Redirector

" Set up spell checking by default
"set spell spelllang=en_us
" Use a spell file for storing dictionary exceptions
"set spellfile=$HOME/.vim/spell/exceptions.utf-8.add

" Use C-s to save the current file (only works if flow control is disabled)
noremap <silent> <C-s>          :update<CR>
vnoremap <silent> <C-s>         <C-C>:update<CR>
inoremap <silent> <C-s>         <C-O>:update<CR>

" proper indentation for yaml files with home assistant
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

""""""""""""""""""""""""""""""
" riv.vim 
""""""""""""""""""""""""""""""
" riv currently has a bug where syntax-based spell checking does not
" work correctly when an existing buffer is re-edited.  This workaround
" forces complete spell checking always
autocmd FileType rst syntax spell toplevel
if v:version >= 700
  let g:riv_auto_format_table = 0
endif

" format tabs as >--- when using :set list
set listchars=tab:>-
