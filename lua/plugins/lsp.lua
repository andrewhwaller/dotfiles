return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        tag = 'legacy'
      },
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },
  'kchmck/vim-coffee-script',
  'lervag/vimtex',
  'jxnblk/vim-mdx-js',
  'jalvesaq/zotcite',
  {
    'j-hui/fidget.nvim',
    tag = 'legacy'
  }
}
