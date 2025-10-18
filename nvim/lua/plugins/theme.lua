-- Dynamic theme loader that respects Omarchy theme switching on Hyprland systems
-- Falls back to Catppuccin Mocha on other systems

local omarchy_theme_path = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local use_omarchy_theme = vim.fn.filereadable(omarchy_theme_path) == 1

if use_omarchy_theme then
  -- Load Omarchy's current theme (supports theme switching)
  local ok, theme_config = pcall(dofile, omarchy_theme_path)
  if ok and theme_config and type(theme_config) == "table" then
    -- Validate it looks like a valid plugin spec
    -- Must have either indexed plugin name or 'name' field
    if theme_config[1] or theme_config.name then
      return theme_config
    end
  end
  -- If anything goes wrong, fall through to default Catppuccin
end

-- Fallback: Catppuccin Mocha (default for non-Hyprland systems)
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha',
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
