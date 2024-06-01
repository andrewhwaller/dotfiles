return {
  'f-person/git-blame.nvim',
  config = function()
    require('gitblame').setup {
      enabled = false,
      use_blame_commit_file_urls = true,
    }
  end
}
