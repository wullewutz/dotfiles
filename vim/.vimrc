" Necesarry for lots of cool vim things
set nocompatible

" Avoid ugly background color issues after scrolling
set term=screen-256color

syntax on
set encoding=utf-8

" Avoid annoying 'No write since last change'-messages
set hidden

" Deactivate info buffer at startup
set shortmess+=I

" Fancy autocomplete suggestions using tab key
set wildmenu
set wildmode=list:longest,full

" Split new windows below or right of the current one
set splitbelow
set splitright

" Leader Key
let mapleader = " "

" Faster escaping from insert mode
set timeoutlen=2000
set ttimeoutlen=5

" Execute project-local .vimrc, but in a secure way
" (No write-to-file or execution of shell commands)
set exrc
set secure

" Default tabs and spaces
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Show line numbers
set number relativenumber

" Higlight matching search patterns
set hlsearch

" Enable incremental search
set incsearch

" Visualize insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Change cursor shape in different modes
let &t_EI = "\033[2 q" " Normal mode: full rectangle
let &t_SI = "\033[5 q" " Insert mode: |
let &t_SR = "\033[3 q" " Replace mode: _

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
  Plug 'ycm-core/YouCompleteMe'
  Plug 'rust-lang/rust.vim'
  Plug 'vimwiki/vimwiki'
call plug#end()

autocmd VimEnter * colorscheme gruvbox
set background=dark

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* RgCursor
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:ycm_language_server =
  \ [
  \   {
  \     'name': 'rust',
  \     'cmdline': ['rust-analyzer'],
  \     'filetypes': ['rust'],
  \     'project_root_files': ['Cargo.toml']
  \   }
  \ ]

" Auto rust fmt on save
let g:rustfmt_autosave = 1

" Remove unwanted trailing whitespaces in some file types.
autocmd FileType c,cpp,h,hpp,py,md autocmd BufWritePre <buffer> %s/\s\+$//e

" Custom mapppings
nnoremap <Leader>/ :Rg<cr>
nnoremap <Leader>* :RgCursor<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>gf :GFiles<cr>
nnoremap <Leader>gs :GFiles?<cr>
nnoremap <Leader>jd :YcmCompleter GoTo<cr>
nnoremap <Leader>jr :YcmCompleter GoToReferences<cr>
nnoremap <Leader>jt :YcmCompleter GoToType<cr>
" Type ii fast to leave insert/visual mode
:imap ii <Esc>
