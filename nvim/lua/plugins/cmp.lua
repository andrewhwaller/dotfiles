return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-omni',
      'onsails/lspkind-nvim',
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'jalvesaq/cmp-zotcite',
      'micangl/cmp-vimtex',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<M-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        -- formatting = {
        --   format = function(entry, vim_item)
        --     vim_item.menu = ({
        --       omni = (vim.inspect(vim_item.menu)),
        --       luasnip = "[LuaSnip]",
        --       buffer = "[Buffer]",
        --     })[entry.source.name]
        --     return require('lspkind').cmp_format({ mode = 'symbol_text' })(entry, vim_item)
        --   end,
        -- },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.menu = ({
              vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
              luasnip = "[Snippet]",
              nvim_lsp = "[LSP]",
              buffer = "[Buffer]",
              cmdline = "[CMD]",
              path = "[Path]",
            })[entry.source.name]
            return require('lspkind').cmp_format({ mode = 'symbol_text' })(entry, vim_item)
          end,
        },
        sources = {
          -- Other Sources
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'orgmode' },
          {
            name = 'omni',
            keyword_length = 0
          },
          { name = 'nvim_lsp_signature_help' },
          { name = 'vim-dadbod-completion' },
          {
            name = 'cmp_zotcite',
            filetypes = {
              'tex',
              'org',
              'markdown',
              'pandoc',
              'latex'
            }
          },
          {
            name = 'supermaven'
          }
        }
      }
    end
  },
  {
    'OrangeT/vim-csharp',
  },
  {
    'jlcrochet/vim-razor',
  }
}
