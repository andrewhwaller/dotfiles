-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Window navigation keymaps
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window', silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window', silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window', silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window', silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for moving blocks in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Center cursor on half-page move
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'j', 'jzz')
vim.keymap.set('n', 'k', 'kzz')
vim.keymap.set('n', '{', '{zz')
vim.keymap.set('n', '}', '}zz')

-- lazygit.nvim
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true, noremap = true })
--
-- DBUI keymaps
vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', { silent = true, noremap = true })

-- Netrw keymaps
vim.keymap.set("n", "<leader>e", ":Lexplore %:p:h<CR>",
  { silent = true, noremap = true }
)

local harpoon = require("harpoon")
-- Harpoon keymaps
vim.keymap.set("n", "<leader>m", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>f", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>h", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>j", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>k", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>l", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("n", "<leader>sa", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", {})

vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", {})
vim.keymap.set("n", "<leader>gg", ":GitBlameOpenCommitURL<CR>", {})

-- Netrw keymaps
vim.keymap.set("n", "<leader>ee", ":Explore %:p:h<CR>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>ev", ":Vexplore %:p:h<CR>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>es", ":Sexplore %:p:h<CR>",
  { silent = true, noremap = true }
)

vim.keymap.set('v', '<leader>gs', ':CodeSnap<CR>', { silent = true })

-- Toggle between light and dark mode
vim.keymap.set('n', '<leader>bg', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end, { desc = 'Toggle light/dark mode' })
