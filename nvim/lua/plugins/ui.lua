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
  },
  {
    'mistricky/codesnap.nvim',
    build = 'make',
    config = function()
      require('codesnap').setup({
        has_breadcrumbs = true,
        has_line_number = true,
        bg_theme = 'bamboo',
        watermark = '',
        code_font_family = 'BerkeleyMono Nerd Font Mono',
      })
    end
  }
}
