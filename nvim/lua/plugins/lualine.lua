return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'abeldekat/harpoonline'
    },
    config = function()
      local Harpoonline = require('harpoonline')
      Harpoonline.setup({
        on_update = function()
          require('lualine').refresh()
        end
      })

      local function lsp_clients()
        local clients = vim.lsp.get_clients()

        if next(clients) == nil then
          return 'No LSP attached!'
        end

        local client_names = {}

        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end

        return table.concat(client_names, ', ')
      end

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
          lualine_c = {
            'filetype',
            'diagnostics',
            lsp_clients
          },
          lualine_x = {
            'branch',
            'diff'
          },
        }
      }
    end
  }
}
