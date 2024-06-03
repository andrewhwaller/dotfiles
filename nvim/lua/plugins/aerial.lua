return {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('aerial').setup({
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
      end,
      layout = {
        min_width = 30,
        default_direction = 'prefer_left',
        placement = 'edge'
      },
      autojump = true
    })

    local function toggle_aerial_and_focus()
      local aerial = require('aerial')
      aerial.toggle()
      aerial.focus()
    end

    vim.api.nvim_set_keymap('n', '<leader>a', '', {callback = toggle_aerial_and_focus, noremap = true, silent = true})
  end
}
