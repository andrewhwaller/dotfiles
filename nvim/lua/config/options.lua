-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = false
-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'

-- Set scrolloff
vim.o.scrolloff = 8
-- Set colorscheme
vim.o.termguicolors = true
-- Only use catppuccin on macOS
if vim.fn.has('mac') == 1 then
  vim.cmd('colorscheme catppuccin')
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Yank to system clipboard
vim.o.clipboard = 'unnamedplus'

-- Netrw settings
vim.g.netrw_banner = 0

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.o.synmaxcol = 0

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd([[ set nofoldenable ]])

vim.filetype.add({
  pattern = {
    ['.*%.blade%.php'] = 'blade',
  },
})

-- Diagnostic configuration moved to lsp.lua to avoid conflicts
