vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local harpoon = require('harpoon')

    if vim.fn.argv(0) == '' then
      vim.cmd('Explore')

      if harpoon:list():length() > 0 then
        harpoon.ui:toggle_quick_menu(harpoon:list())
      else
        require('telescope.builtin').find_files()
      end
    end
  end,
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "BladeFiletypeRelated",
  pattern = "*.blade.php",
  command = "set ft=blade",
})
