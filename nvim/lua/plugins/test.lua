return {
  {
    'vim-test/vim-test',
    config = function()
      vim.keymap.set('n', '<leader>t', ':TestNearest<CR>', { desc = 'Run test nearest', silent = true })
      vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = 'Run test file', silent = true })
      vim.keymap.set('n', '<leader>T', ':TestSuite<CR>', { desc = 'Run test suite', silent = true })
      vim.keymap.set('n', '<leader>tt', ':TestClass<CR>', { desc = 'Run test last', silent = true })
      vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = 'Run test last', silent = true })
      vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>', { desc = 'Visit test file', silent = true })
    end
  }
}
