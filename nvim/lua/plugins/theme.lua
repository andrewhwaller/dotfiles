return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    if vim.fn.has('mac') == 1 then
      local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
      if handle then
        local result = handle:read('*a')
        handle:close()
        if result:match('Dark') then
          vim.o.background = 'dark'
        else
          vim.o.background = 'light'
        end
      end
    end

    require('catppuccin').setup({
      flavour = 'auto',
      integrations = {
        blink_cmp = true,
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
    vim.cmd.colorscheme('catppuccin')
  end
}
