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
local FTerm = require('FTerm')
function OpenFTermAtCurrentFileDirectory()
  local current_file_directory = vim.fn.expand('%:p:h')
  local terminal = FTerm:new({
    cmd = 'cd ' .. current_file_directory .. ' && $SHELL',
    dimensions = {
      height = 0.9,
      width = 0.9
    }
  })

  terminal:toggle()
end
vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })
vim.keymap.set('n', '<leader>t', ':lua OpenFTermAtCurrentFileDirectory()<CR>', { silent = true })
vim.keymap.set('t', '<ESC>', require('FTerm').close, { silent = true })

-- lazygit.nvim
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true, noremap = true })
--
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

local telescope_builtin = require('telescope.builtin')
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.current_buffer_fuzzy_find, { desc = '[ ] Find in current buffer' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

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
