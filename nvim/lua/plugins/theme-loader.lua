-- Dynamic theme loader that respects Omarchy theme switching on Hyprland systems
-- Also respects NVIM_THEME forwarded from SSH client
-- Falls back to Catppuccin on other systems
--
-- Note: All theme plugins are installed in themes.lua

-- Check if theme was forwarded via SSH (from client machine)
local forwarded_theme = vim.env.NVIM_THEME
if forwarded_theme then
  -- Don't install anything - themes.lua already has all themes installed
  -- Just activate the colorscheme with a dummy plugin spec
  return {
    'nvim-lua/plenary.nvim', -- Use an already-installed plugin as placeholder
    lazy = false,
    priority = 1000,
    config = function()
      -- Try to load the forwarded theme, fall back to habamax if not installed
      local ok = pcall(vim.cmd.colorscheme, forwarded_theme)
      if not ok then
        vim.notify('Theme "' .. forwarded_theme .. '" not found, falling back to habamax', vim.log.levels.WARN)
        vim.cmd.colorscheme('habamax')
      end
    end
  }
end

-- Check if Omarchy theme config exists
local omarchy_theme_path = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(omarchy_theme_path) == 1 then
  -- Load Omarchy's current theme (supports theme switching)
  local ok, theme_config = pcall(dofile, omarchy_theme_path)
  if ok and theme_config and type(theme_config) == "table" then
    -- Validate it looks like a valid plugin spec
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
