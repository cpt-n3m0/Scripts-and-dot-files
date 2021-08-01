

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'itchyny/lightline.vim'
Plugin 'preservim/nerdtree'
Plugin 'kana/vim-smartinput'
Plugin 'sheerun/vim-polyglot'
Plugin 'preservim/nerdcommenter'
Plugin 'dense-analysis/ale'
"Plugin 'ludovicchabant/vim-gutentags'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'sillybun/vim-repl'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'ycm-core/YouCompleteMe'


call vundle#end()            " required
filetype plugin indent on    " required

" setup plugins that run on start, order is important
au VimEnter * NERDTree | wincmd p
au BufReadPost,BufNew,BufNewFile * :exe 'RainbowLoad'

"Leave NERDTree if it's the only window left open
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

"prevent other buffers from being opened in the NERDTree window
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

"have the same NERDTree window open in all tabs
autocmd BufWinEnter * silent NERDTreeMirror

vnoremap kj <Esc>
vnoremap KJ <Esc>
inoremap kj <Esc>
inoremap KJ <Esc>

nnoremap <F2> :exe "NERDTreeToggle" <CR>
nnoremap <silent> <C-]> :YcmCompleter GoTo<cr>

set encoding=UTF-8

if !has('gui_running')
  set t_Co=256
endif

let vimDir = '$HOME/.vim/'

" setup swap backup dir (https://unix.stackexchange.com/questions/345494/vim-swap-file-issue)
let tmpDir = expand(vimDir . 'tmp')
if empty(glob(tmpDir))
    silent call system('mkdir -p ' . tmpDir)
endif
set directory=$HOME/.vim/tmp

" ------------------ start of persitent undo setup (https://stackoverflow.com/questions/5700389/using-vims-persistent-undo) ----
" Put plugins and dictionaries in this dir (also on Windows)

if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . 'undodir')
    " Create dirs
    silent call system('mkdir -p ' . vimDir)
    silent call system('mkdir -p ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif
" ------------------ end of persitent undo setup-----------------------------

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable
set foldlevel=1         "this is just what i use

let mapleader = ' '


"intuitive window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <tab> <C-w>w

" open tags definitions in a new hsplit window
nnoremap <C-w>] <C-w>]<C-w>H<C-w>R

" intuitive window resizing
nnoremap <silent> <F8> :exe "vertical resize +5" <CR>
nnoremap <silent> <F5> :exe "vertical resize -5" <CR>
nnoremap <silent> <F7> :exe "resize +5" <CR>
nnoremap <silent> <F6> :exe "resize -5" <CR>
nnoremap <silent> <F6> :exe "resize -5" <CR>
"minimize
nnoremap <silent> <C-F5> :exe "vertical resize 1" <CR>
nnoremap <silent> <C-F6> :exe "resize 1" <CR>



set tabstop=4
set nu rnu
set laststatus=2

let g:ale_fixers = {
\  '*' : ['remove_trailing_lines', 'trim_whitespace'],
\  'javascript' : ['eslint'],
\  'python': ['add_blank_lines_for_python_control_statements', 'autoimport', 'autopep8', 'isort', 'yapf']
\}
highlight ALEWarningSign ctermbg = Black
highlight ALEErrorSign ctermbg = Black
highlight ALEError ctermbg = grey
highlight ALEWarning ctermbg =grey
highlight SignColumn ctermbg =Black

highlight Folded ctermfg=Black
highlight Folded ctermbg=DarkGrey
"highlight LineNr ctermfg=DarkGrey
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" ALE error display customization
let g:ale_sign_error = '⛔️'
let g:ale_sign_warning = '🔔'
let g:ale_python_pylint_options='--max-line-length=180'
let g:ale_python_flake8_options='--max-line-length=180'
let g:ale_fix_on_save = 1
let g:ale_lsp_suggestions = 1
let g:ale_disable_lsp = 1


" Run currently open python script from within vim
command! Pyrun !python3 '%'

" Appearance
set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 1

colorscheme tokyonight
set bg=light
set bg=dark

let g:lightline= {'colorscheme' : 'tokyonight'}

"---- Enable Meta(Alt) key detection
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50

"---- Moving lines holding Alt
nnoremap <silent><M-j> :m .+1<CR>==
nnoremap <silent><M-k> :m .-2<CR>==
inoremap <silent><M-j> <Esc>:m .+1<CR>==gi
inoremap <silent><M-k> <Esc>:m .-2<CR>==gi
vnoremap <silent><M-j> :m '>+1<CR>gv=gv
vnoremap <silent><M-k> :m '<-2<CR>gv=gv


"---- Search
set grepprg=git\ grep
let g:grep_cmd_opts = ''
set ignorecase
set smartcase
set incsearch
set hlsearch

"---- Arrow key mappings
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <<
noremap <right> >>

" REPL Python config from repository
let g:repl_program = {
            \   'python': 'ipython',
            \   'default': 'bash',
            \   'r': 'R',
            \   'lua': 'lua',
            \   'vim': 'vim -e',
            \   }
let g:repl_predefine_python = {
            \   'numpy': 'import numpy as np',
            \   'matplotlib': 'from matplotlib import pyplot as plt'
            \   }
let g:repl_cursor_down = 1
let g:repl_python_automerge = 1
let g:repl_ipython_version = '7'
let g:repl_output_copy_to_register = "t"
nnoremap <leader>r :REPLToggle<Cr>
nnoremap <leader>e :REPLSendSession<Cr>
autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>
autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>
let g:repl_position = 3
