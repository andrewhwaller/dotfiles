return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'abeldekat/harpoonline', version = '*'
    },
    config = function()
      local Harpoonline = require('harpoonline')
      Harpoonline.setup({
        on_update = function()
          require('lualine').refresh()
        end
      })

      require('lualine').setup {
        options = {
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
          theme = 'catppuccin',
        },
        sections = {
          lualine_b = {
            {
              function()
                local harpoon_status = Harpoonline.format()
                local filename = vim.fn.expand('%:.')
                return string.format('%s | %s', harpoon_status, filename)
              end,
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          },
          lualine_c = {'filetype', 'diagnostics'},
          lualine_x = {'branch', 'diff'},
        }
      }
    end
  }
}
