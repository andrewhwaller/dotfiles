return {
  {
    'm-demare/hlargs.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  'numToStr/FTerm.nvim',
  'stevearc/dressing.nvim',
  {
    'catppuccin/nvim',
    name = 'catppuccin'
  },
  'nvim-lualine/lualine.nvim',           -- Fancier statusline
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
