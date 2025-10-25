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

-- Write current colorscheme to file for SSH forwarding
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local theme_file = vim.fn.expand('~/.config/current_nvim_theme')
    local file = io.open(theme_file, 'w')
    if file then
      file:write(vim.g.colors_name or '')
      file:close()
    end
  end,
})
