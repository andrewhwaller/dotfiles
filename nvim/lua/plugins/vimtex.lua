return {
  'lervag/vimtex',
  config = function()
    vim.g.vimtex_view_method = 'zathura'

    local os_name = vim.loop.os_uname().sysname
    if os_name == 'Darwin' then
      vim.g.vimtex_view_method = 'skim'
    end

    vim.api.nvim_create_autocmd({"CursorMoved", "BufWritePost"}, {
      pattern = "*.tex",
      callback = function()
        vim.cmd("VimtexView")
      end,
    })
  end
}
