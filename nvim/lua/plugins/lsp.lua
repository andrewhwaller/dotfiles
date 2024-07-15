return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
          require('fidget').setup()
        end
      },
      {
        'folke/neodev.nvim',
        config = function()
          require('neodev').setup()
        end
      },
    },
  },
  'kchmck/vim-coffee-script',
  'lervag/vimtex',
  'jalvesaq/zotcite',
  {
    'j-hui/fidget.nvim',
    tag = 'legacy'
  },
  'vim-scripts/dbext.vim'
}
