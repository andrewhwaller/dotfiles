set mouse=a
call plug#begin("~/.vim/plugged")
  " Plugin Section
  Plug 'wojciechkepka/vim-github-dark'
  Plug 'airblade/vim-gitgutter'
  Plug 'pangloss/vim-javascript'
  Plug 'evanleck/vim-svelte'
  Plug 'othree/html5.vim'
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
  Plug 'airblade/vim-rooter'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
<<<<<<< HEAD
<<<<<<< HEAD
  let g:coc_global_extensions = ['coc-emmet', 'coc-tailwindcss', 'coc-eslint', 'coc-solargraph', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-rust-analyzer']
=======
  let g:coc_global_extensions = ['coc-emmet', 'coc-tailwindcss', 'coc-eslint', 'coc-solargraph', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-svelte']
>>>>>>> f5fb3313d435f347dd1ece5e11a42284a2ddc426
=======
  let g:coc_global_extensions = ['coc-emmet', 'coc-tailwindcss', 'coc-eslint', 'coc-solargraph', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-svelte']
>>>>>>> f5fb3313d435f347dd1ece5e11a42284a2ddc426
  Plug 'leafgarland/typescript-vim'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-fugitive'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'dense-analysis/ale'
  Plug 'glepnir/dashboard-nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'preservim/tagbar'
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
nmap <F8> :TagbarToggle<CR>
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
let g:airline_theme='base16_railscasts'
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0
let g:svelte_preprocessors = ['typescript']
let g:svelte_preprocessor_tags = [
  \ { 'name': 'postcss', 'tag': 'style', 'as': 'scss' }
  \ ]
let g:svelte_preprocessors = ['postcss']
