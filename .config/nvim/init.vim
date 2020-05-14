
" PLUGIN
if ! filereadable(system('echo -n "${CONFIG_HOME:-$HOME/.config}/nvim/site/autoload/plug.vim"'))
        echo "Downloading junegunn/vim-plug to manage plugins..."
        silent !mkdir -p ${CONFIG_HOME:-$HOME/.config}/nvim/site/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${CONFIG_HOME:-$HOME/.config}/nvim/site/autoload/plug.vim
        autocmd VimEnter * PlugInstall
endif


syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab!
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir="$NVIMUNDODIR"
set undofile
set incsearch

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey



" PLUGINS
call plug#begin("$NVIMDIR/plugged")

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'ycm-core/YouCompleteMe'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color scheme
Plug 'morhetz/gruvbox'

call plug#end()
