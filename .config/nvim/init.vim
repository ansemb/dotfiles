
" PLUGIN MANAGER
if ! filereadable(system('echo -n "${CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        echo "Downloading junegunn/vim-plug to manage plugins..."
        silent !mkdir -p ${CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
        autocmd VimEnter * PlugInstall
endif


" PLUGINS
call plug#begin("$NVIMDIR/plugged")

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color scheme
" Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

call plug#end()

" color scheme
colorscheme nord

" coc config
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-pairs',
	\ 'coc-clangd',
	\ 'coc-python',
	\ 'coc-eslint',
	\ 'coc-git',
	\ 'coc-emoji',
	\ 'coc-tsserver',
	\ 'coc-json',
	\ 'coc-css',
	\ 'coc-html',
	\ 'coc-yaml'
	\ ]

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" settings
syntax enable
set nocompatible
filetype plugin on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set noexpandtab
set smartindent
set number relativenumber
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir="$NVIMUNDODIR"
set undofile
set incsearch
set scrolloff=6

" set colorcolumn=80
" highlight ColorColumn ctermbg=0 guibg=lightgrey


" newlines
nnoremap <C-j> o<ESC>j
nnoremap <C-k> O<ESC>k




