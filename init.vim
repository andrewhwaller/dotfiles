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
  let g:coc_global_extensions = ['coc-emmet', 'coc-tailwindcss', 'coc-eslint', 'coc-solargraph', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-svelte', 'coc-rust-analyzer']
  Plug 'leafgarland/typescript-vim'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-fugitive'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'dense-analysis/ale'
  Plug 'glepnir/dashboard-nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'preservim/tagbar'
  Plug 'github/copilot.vim'
  Plug 'tpope/vim-markdown'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
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

" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" for path with space
" valid: `/path/with\ space/xxx`
" invalid: `/path/with\\ space/xxx`
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or empty for random
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'dark'

nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle
