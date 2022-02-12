if !has("nvim")
    " Necessary for lots of cool vim things
    set nocompatible
    " set proper terminal colors
    set term=xterm-256color
endif

set termguicolors

syntax on
set encoding=utf-8

" Search settings: ignore case unless there are
" uppercase chars in search string
set ignorecase
set smartcase

" Project wide searching with ripgrep
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
endif

" Automatic population of the quickfix list from grep and open it.
" Stolen from https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3#file-grep-md
function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" Avoid annoying 'No write since last change'-messages
set hidden

" Use mouse for scrolling
set mouse=a

" Fix empty Screen asking for 'ENTER or type command to continue'
" (At least on Windows with WSL2)
set shortmess=a

" Deactivate info buffer at startup
set shortmess+=I
"
" Avoid showing extra messages when using completion
set shortmess+=c

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Fancy autocomplete suggestions using tab key
set wildmenu
set wildmode=list:longest,full
set wildignorecase
set wildignore+=*.swp,*.bak,*.o,*.s,*.d

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

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

" Highlight column 80 to avoid long lines
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" Show line numbers
set number relativenumber

" Higlight matching search patterns
set hlsearch

" Enable incremental search
set incsearch

" Visualize insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

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
  Plug 'vim-airline/vim-airline'
  Plug 'rust-lang/rust.vim'
  Plug 'vimwiki/vimwiki'
if has("nvim")
  Plug 'neovim/nvim-lspconfig'
endif
call plug#end()

" use gruvbox colorscheme with transparent bg
autocmd VimEnter * colorscheme gruvbox
set background=dark

" Auto rust fmt on save
let g:rustfmt_autosave = 1

" Avoid vimwiki mess up .md files during editing
let g:vimwiki_global_ext = 0

" Use Markdown for syntax for vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" Remove unwanted trailing whitespaces in some file types.
autocmd FileType c,cpp,h,hpp,rs,py,md,vimwiki autocmd BufWritePre <buffer> %s/\s\+$//e

" Custom mapppings
nnoremap ö <C-]>
nnoremap Ö :! ctags -R .<cr>
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
nnoremap <Leader>/ :Grep<space>
nnoremap <Leader>* :Grep <cword> <cr>:copen<cr>
nnoremap <Leader>b :ls<cr>:b<space>
nnoremap <Leader>f :find<space>

if has("nvim")
    lua require('lspconfig').rust_analyzer.setup({})
    lua vim.api.nvim_set_keymap('n', '<Leader> ', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
    lua vim.api.nvim_set_keymap('n', '<Leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    lua vim.api.nvim_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
    lua vim.api.nvim_set_keymap('n', '<Leader>R', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
    lua vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    lua vim.api.nvim_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')
endif
