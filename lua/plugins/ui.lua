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
  'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'numToStr/Comment.nvim',               -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth',                    -- Detect tabstop and shiftwidth automatically
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
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
    'Pocco81/true-zen.nvim',
    config = function()
      require('true-zen').setup {}
    end
  }
}
