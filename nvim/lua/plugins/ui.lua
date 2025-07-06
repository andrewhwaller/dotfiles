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
