return {
  'lervag/vimtex',
  config = function()
    local os_name = vim.loop.os_uname().sysname

    vim.api.nvim_create_autocmd("User", {
      pattern = "VimtexEventCompileSuccess",
      callback = function()
        vim.cmd("VimtexView")
      end,
    })

    if os_name == 'Darwin' then
      vim.g.vimtex_view_method = 'skim'
    elseif os_name == 'Linux' then
      vim.g.vimtex_view_method = 'zathura'

      vim.api.nvim_create_autocmd("CursorMoved", {
        pattern = "*.tex",
        callback = function()
          vim.cmd("VimtexView")
        end,
      })
    end
  end
}
