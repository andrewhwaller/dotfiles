return {
  {
    'jalvesaq/zotcite',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- Find the Zotero database automatically
      local zotero_data_dir
      if vim.fn.has('mac') == 1 then
        zotero_data_dir = vim.fn.expand('~/Zotero')
      elseif vim.fn.has('unix') == 1 then
        zotero_data_dir = vim.fn.expand('~/.zotero/zotero')
      elseif vim.fn.has('win32') == 1 then
        zotero_data_dir = vim.fn.expand('~/Zotero')
      end

      local zotero_db_path
      if zotero_data_dir and vim.fn.isdirectory(zotero_data_dir) == 1 then
        zotero_db_path = zotero_data_dir .. '/zotero.sqlite'
        if vim.fn.filereadable(zotero_db_path) == 0 then
          -- Try alternative locations
          local profiles_dir = zotero_data_dir .. '/Profiles'
          if vim.fn.isdirectory(profiles_dir) == 1 then
            local profiles = vim.fn.glob(profiles_dir .. '/*', false, true)
            for _, profile in ipairs(profiles) do
              local db_path = profile .. '/zotero.sqlite'
              if vim.fn.filereadable(db_path) == 1 then
                zotero_db_path = db_path
                break
              end
            end
          end
        end
      end

      if not zotero_db_path then
        vim.notify('zotcite: could not locate zotero.sqlite automatically', vim.log.levels.WARN)
      end

      local setup_opts = {
        filetypes = { 'tex', 'latex' },
      }

      if zotero_db_path then
        setup_opts.zotero_SQL_path = zotero_db_path
      end

      require('zotcite').setup(setup_opts)
    end,
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    version = '1.*',
    config = function()
      local config = {
        keymap = {
          preset = 'none', -- Use custom keymaps
          ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<S-Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          ['<M-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        },

        appearance = {
          nerd_font_variant = 'mono',
          kind_icons = {
            Text = '󰉿',
            Method = '󰊕',
            Function = '󰊕',
            Constructor = '󰒓',
            Field = '󰜢',
            Variable = '󰆦',
            Property = '󰖷',
            Class = '󱡠',
            Interface = '󱡠',
            Struct = '󱡠',
            Module = '󰅩',
            Unit = '󰪚',
            Value = '󰦨',
            Keyword = '󰻾',
            File = '󰈔',
            Reference = '󰬲',
            Folder = '󰉋',
            Color = '󰏘',
            Constant = '󰏿',
            Enum = '󰦨',
            EnumMember = '󰦨',
            Event = '󱐋',
            Operator = '󰪚',
            TypeParameter = '󰬛',
          },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          per_filetype = {
            tex = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
            latex = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
          },
          providers = {},
        },

        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            auto_show = true,
            scrollbar = true,
            draw = {
              treesitter = {},
              columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
            },
            winblend = 0,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            treesitter_highlighting = false,
          },
        },

        signature = {
          enabled = true,
        },

        fuzzy = {
          implementation = 'prefer_rust_with_warning',
        },
      }

      require('blink.cmp').setup(config)
    end,
  },
}
