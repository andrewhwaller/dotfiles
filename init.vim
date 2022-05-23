set mouse=a
call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'wojciechkepka/vim-github-dark'
  Plug 'airblade/vim-gitgutter'
  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-endwise'
  Plug 'posva/vim-vue'
  Plug 'wesQ3/vim-windowswap'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'rking/ag.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
  let g:coc_global_extensions = ['coc-emmet', 'coc-tailwindcss', 'coc-eslint', 'coc-solargraph', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
  Plug 'leafgarland/typescript-vim'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-fugitive'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'dense-analysis/ale'
  Plug 'glepnir/dashboard-nvim'
call plug#end()
"Config Section
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme ghdark
set number
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_sign_column_always = 1
let g:ale_fixers = {
 \ 'javascript': ['prettier', 'eslint'],
 \ 'typescript': ['prettier', 'eslint'],
 \ 'vue': ['prettier', 'eslint'],
 \ 'javascriptreact': ['prettier', 'eslint'],
 \ 'typescriptreact': ['prettier', 'eslint'],
 \ }
let g:ale_sign_error = '💀'
let g:ale_sign_warning = '🌞'
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:dashboard_default_executive ='fzf'
