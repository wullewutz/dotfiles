" Avoid ugly background color issues after scrolling
set term=screen-256color

syntax on
set encoding=utf-8

" Show line numbers
set number relativenumber

" Higlight matching search patterns
set hlsearch

" Enable incremental search
set incsearch

" Visualize insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Store info from no more than 100 files at a time, 9999 lines of text, 
" 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Always show status line
set laststatus=2

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
  Plug 'morhetz/gruvbox'
  Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
  Plug 'lotabout/skim.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
call plug#end()

autocmd VimEnter * colorscheme gruvbox
set background=dark

command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
