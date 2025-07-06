return {
  'mistricky/codesnap.nvim',
  build = 'make',
  config = function()
    require('codesnap').setup({
      has_breadcrumbs = true,
      has_line_number = true,
      bg_theme = 'bamboo',
      watermark = '',
      code_font_family = 'TX-02',
    })
  end
}
