return {
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
}
