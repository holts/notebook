" Holts's init.vim
"
"{ Variable
"{{ Builtin variables
" Path to Python 3 interpreter (must be an absolute path), make startup
" faster. See https://neovim.io/doc/user/provider.html. Change this variable
" in accordance with your system.
if executable('python')
    " The output of `system()` function contains a newline character which
    " should be removed, see https://vi.stackexchange.com/a/2868/15292
    if has('win32')
        let g:python3_host_prog=substitute(system('where python'), '.exe\n\+$', '', 'g')
    elseif has('unix')
        let g:python3_host_prog=substitute(system('which python'), '\n\+$', '', 'g')
    endif
else
    echoerr 'Python executable not found! You must install Python and set its PATH!'
endif

" Custom mapping <leader> (see `:h mapleader` for more info)
let mapleader = ','
"}}

"{{ Disable loading certain plugins
" Do not load netrw by default since I do not use it, see
" https://github.com/bling/dotvim/issues/4
let g:loaded_netrwPlugin = 1

" Do not load tohtml.vim
let g:loaded_2html_plugin = 1

" Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
" related to checking files inside compressed files)
let g:loaded_zipPlugin = 1
let loaded_gzip = 1
let g:loaded_tarPlugin = 1

" Do not use builtin matchit.vim and matchparen.vim
let loaded_matchit = 1
let g:loaded_matchparen = 1
"}}
"}

"{ Builtin options and settings
" Changing fillchars for folding, so there is no garbage charactes
set fillchars=fold:\ ,vert:\|

" Paste mode toggle, it seems that Neovim's bracketed paste mode
" does not work very well for nvim-qt, so we use good-old paste mode
set pastetoggle=<F12>

" Split window below/right when creating horizontal/vertical windows
set splitbelow splitright

" Time in milliseconds to wait for a mapped sequence to complete,
" see https://goo.gl/vHvyu8 for more info
set timeoutlen=500

" For CursorHold events
set updatetime=2000

" Clipboard settings, always use clipboard for all delete, yank, change, put
" operation, see https://goo.gl/YAHBbJ
set clipboard+=unnamedplus

" Disable creating swapfiles, see https://goo.gl/FA6m6h
set noswapfile

" General tab settings
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " expand tab to spaces so that tabs are spaces

" Set matching pairs of characters and highlight matching brackets
set matchpairs+=<:>,「:」

" Show line number and relative line number
set number relativenumber

" Ignore case in general, but become case-sensitive when uppercase is present
set ignorecase smartcase

" File and script encoding settings for vim
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
scriptencoding utf-8

" Break line at predefined characters
set linebreak
" Character to show before the lines that have been soft-wrapped
set showbreak=↪

" List all items and start selecting matches in cmd completion
set wildmode=list:full

" Show current line where the cursor is
set cursorline
" Set a ruler at column 80, see https://goo.gl/vEkF5i
set colorcolumn=80

" Minimum lines to keep above and below cursor when scrolling
set scrolloff=3

" Use mouse to select and resize windows, etc.
if has('mouse')
    set mouse=nv  " Enable mouse in several mode
    set mousemodel=popup  " Set the behaviour of mouse
endif

" Do not show mode on command line since vim-airline can show it
set noshowmode

" Fileformats to use for new files
set fileformats=unix,dos

" The mode in which cursorline text can be concealed
set concealcursor=nc

" The way to show the result of substitution in real time for preview
set inccommand=nosplit

" Ignore certain files and folders when globbing
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.jpg,*.png,*.jpeg,*.gif,*.bmp,*.tiff
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.pdf

" Ask for confirmation when handling unsaved or read-only files
set confirm

" Use visual bells to indicate errors, do not use errorbells
set visualbell noerrorbells

" The level we start to fold
set foldlevel=0

" The number of command and search history to keep
set history=500

" Use list mode and customized listchars
set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:+

" Auto-write the file based on some condition
set autowrite

" Show hostname, full path of file and last-mod time on the window title.
" The meaning of the format str for strftime can be found in
" http://tinyurl.com/l9nuj4a. The function to get lastmod time is drawn from
" http://tinyurl.com/yxd23vo8
set title
set titlestring=%{hostname()}\ \ %{expand('%:p')}\ \ %{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

" Persistent undo even after you close a file and re-open it
set undofile

" Do not show "match xx of xx" and other messages during auto-completion
set shortmess+=c

" Completion behaviour
set completeopt+=noinsert  " Auto select the first completion entry
set completeopt+=menuone  " Show menu even if there is only one item
set completeopt-=preview  " Disable the preview window

" Scan files given by `dictionary` option
set complete+=k,kspell complete-=w complete-=b complete-=u complete-=t

set spelllang=en,cjk  " Spell languages

" Align indent to next multiple value of shiftwidth. For its meaning,
" see http://tinyurl.com/y5n87a6m
set shiftround

" Virtual edit is useful for visual block edit
set virtualedit=block

" Correctly break multi-byte characters such as CJK,
" see http://tinyurl.com/y4sq6vf3
set formatoptions+=mM

" Tilde (~) is an operator, thus must be followed by motions like `e` or `w`.
set tildeop

" Do not add two space after a period when joining lines or formatting texts,
" see https://tinyurl.com/y3yy9kov
set nojoinspaces

set ambiwidth=double
"}

"{ Custom key mappings
" Quicker way to open command window
nnoremap q; q:

" Quicker <Esc> in insert mode
inoremap <silent> jk <Esc>

" Turn the word under cursor to upper case
inoremap <silent> <c-u> <Esc>viwUea

" Turn the current word into title case
inoremap <silent> <c-t> <Esc>b~lea

" Paste non-linewise text above or below current cursor,
" see https://stackoverflow.com/a/1346777/6064933
nnoremap <leader>p m`o<ESC>p``
nnoremap <leader>P m`O<ESC>p``

" Shortcut for faster save and quit
nnoremap <silent> <leader>w :update<CR>
" Saves the file if modified and quit
nnoremap <silent> <leader>q :x<CR>
" Quit all opened buffers
nnoremap <silent> <leader>Q :qa<CR>

" Navigation in the location and quickfix list
nnoremap [l :lprevious<CR>zv
nnoremap ]l :lnext<CR>zv
nnoremap [L :lfirst<CR>zv
nnoremap ]L :llast<CR>zv
nnoremap [q :cprevious<CR>zv
nnoremap ]q :cnext<CR>zv
nnoremap [Q :cfirst<CR>zv
nnoremap ]Q :clast<CR>zv

" Close location list or quickfix list if they are present,
" see https://goo.gl/uXncnS
nnoremap<silent> \x :windo lclose <bar> cclose<CR>

" Close a buffer and switching to another buffer, do not close the
" window, see https://goo.gl/Wd8yZJ
nnoremap <silent> \d :bprevious <bar> bdelete #<CR>

" Toggle search highlight, see https://goo.gl/3H85hh
nnoremap <silent><expr> <Leader>hl (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Disable arrow key in vim, see https://goo.gl/s1yfh4.
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" Insert a blank line below or above current line (do not move the cursor),
" see https://stackoverflow.com/a/16136133/6064933
nnoremap <expr> oo 'm`' . v:count1 . 'o<Esc>``'
nnoremap <expr> OO 'm`' . v:count1 . 'O<Esc>``'

" nnoremap oo @='m`o<c-v><Esc>``'<cr>
" nnoremap OO @='m`O<c-v><Esc>``'<cr>

" the following two mappings work, but if you change double quote to single, it
" will not work
" nnoremap oo @="m`o\<lt>Esc>``"<cr>
" nnoremap oo @="m`o\e``"<cr>

" Insert a space after current character
nnoremap <silent> <Space><Space> a<Space><ESC>h

" Yank from current cursor position to the end of the line (make it
" consistent with the behavior of D, C)
nnoremap Y y$

" Move the cursor based on physical lines, not the actual lines.
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> ^ g^
nnoremap <silent> 0 g0

" Do not include white space characters when using $ in visual mode,
" see https://goo.gl/PkuZox
xnoremap $ g_

" Jump to matching pairs easily in normal mode
nnoremap <Tab> %

" Go to start or end of line easier
nnoremap H ^
xnoremap H ^
nnoremap L g_
xnoremap L g_

" Resize windows using <Alt> and h,j,k,l, inspiration from
" https://goo.gl/vVQebo (bottom page).
" If you enable mouse support, shorcuts below may not be necessary.
nnoremap <silent> <M-h> <C-w><
nnoremap <silent> <M-l> <C-w>>
nnoremap <silent> <M-j> <C-W>-
nnoremap <silent> <M-k> <C-W>+

" Fast window switching, inspiration from
" https://stackoverflow.com/a/4373470/6064933
nnoremap <silent> <M-left> <C-w>h
nnoremap <silent> <M-right> <C-w>l
nnoremap <silent> <M-down> <C-w>j
nnoremap <silent> <M-up> <C-w>k

" Continuous visual shifting (does not exit Visual mode), `gv` means
" to reselect previous visual area, see https://goo.gl/m1UeiT
xnoremap < <gv
xnoremap > >gv

" When completion menu is shown, use <cr> to select an item
" and do not add an annoying newline. Otherwise, <enter> is what it is.
" For more info , see https://goo.gl/KTHtrr and https://goo.gl/MH7w3b
inoremap <expr> <cr> ((pumvisible())?("\<C-Y>"):("\<cr>"))
" Use <esc> to close auto-completion menu
inoremap <expr> <esc> ((pumvisible())?("\<C-e>"):("\<esc>"))

" Edit and reload init.vim quickly
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :silent update $MYVIMRC <bar> source $MYVIMRC <bar>
    \ echomsg "Nvim config successfully reloaded!"<cr>

" Reselect the text that has just been pasted
nnoremap <leader>v `[V`]

" Use sane regex expression (see `:h magic` for more info)
nnoremap / /\v

" Find and replace (like Sublime Text 3)
nnoremap <C-H> :%s/
xnoremap <C-H> :s/

" Change current working directory locally and print cwd after that,
" see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
nnoremap <silent> <leader>cd :lcd %:p:h<CR>:pwd<CR>

" Use Esc to quit builtin terminal
tnoremap <ESC>   <C-\><C-n>

" Toggle spell checking (autosave does not play well with z=, so we disable it
" when we are doing spell checking)
nnoremap <silent> <F11> :set spell! <bar> :AutoSaveToggle<cr>
inoremap <silent> <F11> <C-O>:set spell! <bar> :AutoSaveToggle<cr>

" Decrease indent level in insert mode with shift+tab
inoremap <S-Tab> <ESC><<i

" Change text without putting the text into register,
" see http://tinyurl.com/y2ap4h69
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc

"}

"{ Auto commands
" Do not use smart case in command line mode,
" extracted from https://goo.gl/vCTYdK
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END

" Set textwidth for text file types
augroup text_file_width
    autocmd!
    " Sometimes, automatic filetype detection is not right, so we need to
    " detect the filetype based on the file extensions
    autocmd BufNewFile,BufRead *.md,*.MD,*.markdown setlocal textwidth=79
augroup END

augroup term_settings
    autocmd!
    " Do not use number and relative number for terminal inside nvim
    autocmd TermOpen * setlocal norelativenumber nonumber
    " Go to insert mode by default to start typing command
    autocmd TermOpen * startinsert
augroup END

" More accurate syntax highlighting? (see `:h syn-sync`)
augroup accurate_syn_highlight
    autocmd!
    autocmd BufEnter * :syntax sync fromstart
augroup END

" Return to last edit position when opening a file
augroup resume_edit_position
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ | execute "normal! g`\"zvzz"
        \ | endif
augroup END

" Display a message when the current file is not in utf-8 format.
" Note that we need to use `unsilent` command here because of this issue:
" https://github.com/vim/vim/issues/4379
augroup non_utf8_file_warn
    autocmd!
    autocmd BufRead * if &fileencoding != 'utf-8'
                \ | unsilent echomsg 'File not in UTF-8 format!' | endif
augroup END

" Automatically reload the file if it is changed outside of Nvim, see
" https://unix.stackexchange.com/a/383044/221410. It seems that `checktime`
" command does not work in command line. We need to check if we are in command
" line before executing this command. See also http://tinyurl.com/y6av4sy9.
augroup auto_read
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
                \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg
                \ | echo "File changed on disk. Buffer reloaded!" | echohl None
augroup END
"}

"{ Plugin installation

"{{ Vim-plug Install and related settings
" Auto-install vim-plug on different systems if it does not exist.
" For Windows, only Windows 10 with curl installed are supported (after
" Windows 10 build 17063, source: http://tinyurl.com/y23972tt).
" The following script to install vim-plug is adapted from vim-plug
" wiki: https://github.com/junegunn/vim-plug/wiki/tips#tips
if !executable('curl')
    echomsg 'You have to install curl to install vim-plug. Or install '
            \ . 'vim-plug yourself following the guide on vim-plug git repo'
else
    "let g:VIM_PLUG_PATH = expand(stdpath('config') . '/autoload/plug.vim')
    let g:VIM_PLUG_PATH = '~/.local/share/nvim/site/autoload/plug.vim'
    if empty(glob(g:VIM_PLUG_PATH))
        echomsg 'Installing Vim-plug on your system'
        silent execute '!curl -fLo ' . g:VIM_PLUG_PATH . ' --create-dirs '
            \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

        augroup plug_init
            autocmd!
            autocmd VimEnter * PlugInstall --sync | quit |source $MYVIMRC
        augroup END
    endif
endif

" Set up directory to install the plugins based on the platform
let g:PLUGIN_HOME=expand(stdpath('data') . '/plugged')
"}}

"{{ Autocompletion related plugins to ~/.config/nvim/plugged/
call plug#begin()
"call plug#begin(g:PLUGIN_HOME)

"{{ UI: Color, theme etc.
" A list of colorscheme plugin you may want to try. Find what suits you.
Plug 'arcticicestudio/nord-vim'
" Plug 'sainnhe/vim-color-desert-night'
" Plug 'YorickPeterse/happy_hacking.vim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'sickill/vim-monokai'
" Plug 'whatyouhide/vim-gotham'
" Plug 'rakr/vim-one'
" Plug 'kaicataldo/material.vim'

" colorful status line and theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"}}

"{{ Plugin to deal with URL
" Highlight URLs inside vim
Plug 'itchyny/vim-highlighturl'

" For Windows and Mac, we can open an URL in the browser. For Linux, it may
" not be possible since we maybe in a server which disables GUI.
if has('win32') || has('macunix')
    " open URL in browser
    Plug 'tyru/open-browser.vim'
endif
"}}

"{{ Text object plugins
" Additional powerful text object for vim, this plugin should be studied
" carefully to use its full power
Plug 'wellle/targets.vim'

" Plugin to manipulate characer pairs quickly
Plug 'tpope/vim-surround'

" Add indent object for vim (useful for languages like Python)
Plug 'michaeljsmith/vim-indent-object'
"}}

"{{ Navigation and tags plugin
" File explorer for vim
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
"}}

"{{ Git related plugins
" Show git change (change, delete, add) signs in vim sign column
Plug 'mhinz/vim-signify'
" Another similar plugin
" Plug 'airblade/vim-gitgutter'

" Git command inside vim
Plug 'tpope/vim-fugitive'

" Git commit browser
Plug 'junegunn/gv.vim', { 'on': 'GV' }
"}}

call plug#end()
"}

"{ Plugin settings
"{{ URL related
""""""""""""""""""""""""""""open-browser.vim settings"""""""""""""""""""
if has('win32') || has('macunix')
    " Disable netrw's gx mapping.
    let g:netrw_nogx = 1

    " Use another mapping for the open URL method
    nmap ob <Plug>(openbrowser-smart-search)
    vmap ob <Plug>(openbrowser-smart-search)
endif
"}}

"{{ Navigation and tags
""""""""""""""""""""""" nerdtree settings """"""""""""""""""""""""""
" Toggle nerdtree window and keep cursor in file window,
" adapted from http://tinyurl.com/y2kt8cy9
nnoremap <silent> <Space>s :NERDTreeToggle<CR>:wincmd p<CR>

" Reveal currently editted file in nerdtree widnow,
" see https://goo.gl/kbxDVK
nnoremap <silent> <Space>f :NERDTreeFind<CR>

" Ignore certain files and folders
let NERDTreeIgnore = ['\.pyc$', '^__pycache__$']

" Automatically show nerdtree window on entering nvim,
" see https://github.com/scrooloose/nerdtree. But now the cursor
" is in nerdtree window, so we need to change it to the file window,
" extracted from https://goo.gl/vumpvo
" autocmd VimEnter * NERDTree | wincmd l

" Delete a file buffer when you have deleted it in nerdtree
let NERDTreeAutoDeleteBuffer = 1

" Show current root as realtive path from HOME in status bar,
" see https://github.com/scrooloose/nerdtree/issues/891
let NERDTreeStatusline="%{exists('b:NERDTree')?fnamemodify(b:NERDTree.root.path.str(), ':~'):''}"

" Disable bookmark and 'press ? for help' text
let NERDTreeMinimalUI=0

""""""""""""""""""""""""""" tagbar settings """""""""""""""""""""""""""""""
" Shortcut to toggle tagbar window
nnoremap <silent> <Space>t :TagbarToggle<CR>
"}}

"{{ Git-related
"""""""""""""""""""""""""vim-signify settings""""""""""""""""""""""""""""""
" The VCS to use
let g:signify_vcs_list = [ 'git' ]

" Change the sign for certain operations
let g:signify_sign_change = '~'
"}}

"{{ UI: Status line, look
"""""""""""""""""""""""""""vim-airline setting""""""""""""""""""""""""""""""
" Set airline theme to a random one if it exists
"let s:candidate_airlinetheme = ['ayu_mirage', 'base16_flat',
"    \ 'base16_grayscale', 'lucius', 'base16_tomorrow', 'ayu_dark',
"    \ 'base16_adwaita', 'biogoo', 'distinguished', 'jellybeans',
"    \ 'luna', 'raven', 'seagull', 'term', 'vice', 'zenburn', 'tomorrow']
"let s:idx = utils#RandInt(0, len(s:candidate_airlinetheme)-1)
"let s:theme = s:candidate_airlinetheme[s:idx]

"if utils#HasAirlinetheme(s:theme)
"    let g:airline_theme=s:theme
"endif

" Tabline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Show buffer number for easier switching between buffer,
" see https://github.com/vim-airline/vim-airline/issues/1149
let g:airline#extensions#tabline#buffer_nr_show = 1

" Buffer number display format
let g:airline#extensions#tabline#buffer_nr_format = '%s. '

" Whether to show function or other tags on status line
let g:airline#extensions#tagbar#enabled = 1

" Skip empty sections if there are nothing to show,
" extracted from https://vi.stackexchange.com/a/9637/15292
let g:airline_skip_empty_sections = 1

" Whether to use powerline symbols, see https://goo.gl/XLY19H.
let g:airline_powerline_fonts = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'

" Only show git hunks which are non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" Speed up airline
let g:airline_highlighting_cache = 1
"}}
"}

"{ Colorscheme and highlight settings
"{{ General settings about colors
" Enable true colors support (Do not use this option if your terminal does not
" support true colors! For a comprehensive list of terminals supporting true
" colors, see https://github.com/termstandard/colors and
" https://bit.ly/2InF97t)
set termguicolors

" Use dark background
set background=dark
"}}

"{{ Colorscheme settings
""""""""""""""""""""""""""" nord settings"""""""""""""""""""""""""""""""
" We should check if theme exists before using it, otherwise you will get
" error message when starting Nvim
"if utils#HasColorscheme('nord')
    " see https://github.com/arcticicestudio/nord-vim.git 
    colorscheme nord
"else
"    colorscheme desert
"endif

b2

""""""""""""""""""""""""""" solarized8 settings"""""""""""""""""""""""""
" Solarized colorscheme without bullshit
" let g:solarized_term_italics=1
" let g:solarized_visibility="high"
" colorscheme solarized8_high

"{ A list of resources which inspire me
" This list is non-exhaustive as I can not remember the source of many
" settings.

" - https://jdhao.github.io/
" - http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" - https://github.com/tamlok/tvim/blob/master/.vimrc
" - https://nvie.com/posts/how-i-boosted-my-vim/
" - https://blog.carbonfive.com/2011/10/17/vim-text-objects-the-definitive-guide/
" - https://sanctum.geek.nz/arabesque/vim-anti-patterns/
" - https://github.com/gkapfham/dotfiles/blob/master/.vimrc
"}
