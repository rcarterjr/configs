" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Theme
Plug 'morhetz/gruvbox'

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Find files using Telescope command-line sugar.
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Nav tree
Plug 'preservim/nerdtree' 
" Status
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'github/copilot.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " haven't tried this yet

" fuzzy finder fzf ----- I think I can remove this bc
" Telescope is better
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" A better search -- files and code
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Initialize plugin system
call plug#end()

" this is my <leader> for shortcuts
let mapleader=";"

let g:airline_theme="base16"

" auto format prettier on save
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERD tree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle
" let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
" ^^^^^^^^^ I can prob remove fzf because I like Telescope better

set rtp+=/usr/local/opt/fzf
set number
set relativenumber
set background=dark
set scrolloff=8
set tabstop=4
set shiftwidth=4
colorscheme gruvbox

" open NERDTree with spacebar
nnoremap <silent> <Space> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

" remap fzf to  CTRL P
nnoremap <silent> <C-p> :FZF<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>ts <cmd>Telescope treesitter<cr>
" nnoremap <leader>gc <cmd>Telescope git_commits<cr> <- uncomment when ready " 
nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" when making a change, source this file with :source
nnoremap <Leader>sv :source $MYVIMRC<CR>

