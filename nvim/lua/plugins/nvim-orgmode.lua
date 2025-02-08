return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  dependencies = {
    'nvim-orgmode/org-bullets.nvim',
  },
  config = function()
    require('orgmode').setup({
      org_agenda_files = '~/github/org/**/*',
      org_default_notes_file = '~/github/org/refile.org',
    })

    require('org-bullets').setup()

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}
