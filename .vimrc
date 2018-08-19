" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" TODO: this may not be in the correct place. It is intended to allow overriding <Leader>.
" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ================ General Config ====================

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","

" =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
endif
au BufNewFile,BufRead *.vundle set filetype=vim

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:･

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Custom Settings ========================
so ~/.yadr/vim/settings.vim

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/unite.vim')
  "call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  let g:deoplete#enable_at_startup = 1

  " call dein#add("edkolev/tmuxline.vim")
  call dein#add('vim-scripts/OmniCppComplete')
  call dein#add('cohama/lexima.vim')
  call dein#add('Valloric/YouCompleteMe')
  call dein#add('davidhalter/jedi-vim')
  call dein#add('thinca/vim-quickrun')
  call dein#add('majutsushi/tagbar')
  call dein#add('lervag/vimtex')
  call dein#add('KeitaNakamura/tex-conceal.vim')
  call dein#add('airblade/vim-gitgutter')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
  "call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"neosnippet Scripts-----------------------
let g:neosnippet#snippets_directory = '~/.vim/bundle/neosnippet-snippets/snippets/'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1

" Expand the completed snippet trigger by <CR>.
"imap <expr><CR>
"\ (pumvisible() && neosnippet#expandable()) ?
"\ "\<Plug>(neosnippet_expand)" : "\<CR>"

"End neosnippet Scripts------------------

"original Scripts------------------------

" let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" Powerline
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup
set laststatus=2
set showtabline=2
set noshowmode

set mouse=a
set ttymouse=xterm2
set whichwrap=b,s,h,l,<,>,[,],~
set clipboard+=unnamed
"set clipboard+=autoselect

nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
nnoremap <space>gs :r! oj g/s -s 
nnoremap <silent><C-e> :NERDTreeToggle<CR>

"autocmd BufWritePost * :call AddExecmod()
"function AddExecmod()
"    let line = getline(1)
"    if strpart(line, 0, 2) == "#!"
"        call system("chmod +x ". expand("%"))
"    endif
"endfunction
"
" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/qt4
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

let g:ycm_python_binary_path = 'python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

let g:quickrun_config = {
\  "_" : {
\    "hook/time/enable" : 1,
\    "outputter" : "error",
\    "outputter/error/success" : "buffer",
\    "outputter/error/error"   : "quickfix",
\    "outputter/buffer/close_on_empty" : 1,
\  },
\  "cpp" : {
\    "command" : "g++",
\  },
\  "tex": {
\    "command": "latexmk",
\    "exec": ["%c -pdfdvi %s", "open %s:r.pdf"],
\  },
\}

let g:quickrun_no_default_key_mapping = 1
au FileType qf nnoremap <silent><buffer>q :quit<CR>
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
nnoremap \r :write<CR>:QuickRun -mode n<CR>
xnoremap \r :<C-U>write<CR>gv:QuickRun -mode v<CR>

let g:tagbar_width = 20
nnoremap <silent><C-y> :TagbarToggle<CR>

autocmd FileType tex setlocal conceallevel=1 concealcursor=nc
let g:polyglot_disabled = ['latex']
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdgm'
