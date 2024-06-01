return {
  {
    'm-demare/hlargs.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  'numToStr/FTerm.nvim',
  'stevearc/dressing.nvim',
  {
    'catppuccin/nvim',
    name = 'catppuccin'
  },
  'nvim-lualine/lualine.nvim',           -- Fancier statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'abeldekat/harpoonline', version = '*'
    },
    config = function()
      local Harpoonline = require('harpoonline')
      Harpoonline.setup({
        on_update = function()
          require('lualine').refresh()
        end
      })

      require('lualine').setup {
        options = {
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
          theme = 'catppuccin',
        },
        sections = {
          lualine_c = {
            {
              Harpoonline.format,
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      }
    end
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  'numToStr/Comment.nvim',               -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth',                    -- Detect tabstop and shiftwidth automatically
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      {
        'tpope/vim-dadbod',
        lazy = true
      },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = {
          'sql',
          'mysql',
          'plsql',
        },
        lazy = true
      },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        auto_close = true,
        auto_preview = true,
      }
    end
  },
  'tpope/vim-endwise',
  'tpope/vim-surround',
  {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup {}
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
  }
}
