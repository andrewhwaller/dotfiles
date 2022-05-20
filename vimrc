set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
call plug#begin()
" The following are examples of different formats supported.
" plugin on GitHub repo
Plug 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plug 'janko/vim-test'
Plug 'tpope/vim-rails'
Plug 'airblade/vim-gitgutter'
Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-endwise'
Plug 'rhysd/vim-crystal'
Plug 'ddollar/nerdcommenter'
Plug 'ap/vim-css-color'
Plug 'wojciechkepka/vim-github-dark'
Plug 'posva/vim-vue'
Plug 'wesQ3/vim-windowswap'
" Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Write swp files to /tmp instead of current directory
set swapfile
set dir=/tmp

set guifont=hack_nerd_font:h11
" change the mapleader from \ to ,
let mapleader=","
" strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
" line numbers
set number
" highlight current line
set cursorline
" Two space tabs
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set encoding=UTF-8
" Set some file types
" Set the Ruby filetype for a number of common Ruby files without .rb
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set ft=ruby
" Monokai theme
syntax enable
colorscheme ghdark
" Allow using ctrl-j k l h to navigate between window splits
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND-T CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
"let g:CommandTFileScanner="git" " Controls the file scanner used
let g:CommandTMaxHeight=30      " Sets the maximum height of the results window
let g:CommandTTraverseSCM='pwd'
" Enable git gutter
let g:gitgutter_async=0
let g:coc_global_extensions = ['coc-solargraph', 'coc-vetur', 'coc-tsserver', 'coc-eslint', 'coc-json', 'coc-prettier', 'coc-css']

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=80
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" Nerdtree open by default
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
let NERDTreeQuitOnOpen = 0
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
let g:WebDevIconsDisableDefaultFileSymbolColorFromNERDTreeFile = 1
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
" Don't wrap long lines
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing
" Toggle nerdcommenter with command+/
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
