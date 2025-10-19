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

-- Fallback: Catppuccin with auto light/dark switching
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    -- Detect macOS theme on startup to prevent flash
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
      flavour = 'auto', -- auto-switches based on vim.o.background
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
