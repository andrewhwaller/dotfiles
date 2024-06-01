return {
  {
    'm-demare/hlargs.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('hlargs').setup()
    end
  },
  'numToStr/FTerm.nvim',
  'stevearc/dressing.nvim',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        integrations = {
          cmp = true,
          treesitter = true,
          harpoon = true,
          mason = true,
          telescope = {
            enabled = true,
          },
          lsp_trouble = true,
          gitsigns = true,
        }
      })
    end
  },
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
          lualine_b = {
            {
              function()
                local harpoon_status = Harpoonline.format()
                local filename = vim.fn.expand('%:.')
                return string.format('%s | %s', harpoon_status, filename)
              end,
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          },
          lualine_c = {'filetype', 'diagnostics'},
          lualine_x = {'branch', 'diff'},
        }
      }
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function()
      require('ibl').setup()
    end
  },
  {
    'numToStr/Comment.nvim',               -- "gc" to comment visual regions/lines
    config = function()
      require('Comment').setup()
    end
  },
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
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('trouble').setup {
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
      require('nvim-autopairs').setup {}
    end
  },
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {},
  }
}
