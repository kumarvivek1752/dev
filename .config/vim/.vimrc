set guicursor=
set scrolloff=8
set number
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set clipboard=unnamedplus

call plug#begin('~/.vim/autoload')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
call plug#end()

" This was form the colorscheme section
set termguicolors     " enable true colors support
let ayucolor="dark"   " for dark version of theme
colorscheme ayu
let mapleader = " "
"nnoremap <leader>pv :Vex<CR>
nnoremap <leader><CR> :so ~/.config/vim/init.vim<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>pv :Files<CR>
vnoremap <leader>p "_dp
vnoremap <leader>y "+y
vnoremap <leader>Y gg"+yG


