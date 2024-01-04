-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

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

-- FTerm
vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })
vim.keymap.set('n', '<leader>t', ':FTermToggle<CR>', { silent = true })
vim.keymap.set('t', '<ESC>', require('FTerm').close, { silent = true })

-- lazygit.nvim
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true, noremap = true })

-- Harpoon keymaps
vim.keymap.set('n', '<leader>f', ':lua require("harpoon.ui").toggle_quick_menu()<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>m', ':lua require("harpoon.mark").add_file()<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>h', ':lua require("harpoon.ui").nav_file(1)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>j', ':lua require("harpoon.ui").nav_file(2)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>k', ':lua require("harpoon.ui").nav_file(3)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>l', ':lua require("harpoon.ui").nav_file(4)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>vh', ':vsplit<CR> | :lua require("harpoon.ui").nav_file(1)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>vj', ':vsplit<CR> | :lua require("harpoon.ui").nav_file(2)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>vk', ':vsplit<CR> | :lua require("harpoon.ui").nav_file(3)<CR>',
  { silent = true, noremap = true }
)
vim.keymap.set('n', '<leader>vl', ':vsplit<CR> | :lua require("harpoon.ui").nav_file(4)<CR>',
  { silent = true, noremap = true }
)

-- DBUI keymaps
vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', { silent = true, noremap = true })

-- Trouble keymaps
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  { silent = true, noremap = true }
)

-- Netrw keymaps
vim.keymap.set("n", "<leader>e", ":Lexplore %:p:h<CR>",
  { silent = true, noremap = true }
)
