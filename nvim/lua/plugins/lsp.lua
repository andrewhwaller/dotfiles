-- Native LSP setup for Neovim 0.11 with blink.cmp integration

local capabilities
local ok, blink_cmp = pcall(require, 'blink.cmp')
if ok and blink_cmp.get_lsp_capabilities then
  capabilities = blink_cmp.get_lsp_capabilities()
else
  -- Fall back to vanilla capabilities during bootstrap or when blink.cmp is missing
  capabilities = vim.lsp.protocol.make_client_capabilities()
end

vim.lsp.config.rust_analyzer = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = 'clippy' },
    },
  },
}

vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
  capabilities = capabilities,
}

vim.lsp.config.cssls = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  capabilities = capabilities,
  settings = {
    css = { validate = true, lint = { unknownAtRules = 'ignore' } },
    scss = { validate = true },
    less = { validate = true, lint = { unknownAtRules = 'ignore' } },
  },
}

vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },
}

vim.lsp.config.stimulus_ls = {
  cmd = { 'stimulus-language-server', '--stdio' },
  filetypes = { 'html', 'eruby', 'blade', 'php', 'slim', 'haml', 'twig', 'liquid', 'vue', 'svelte' },
  root_markers = { 'package.json', 'Gemfile', '.git' },
  capabilities = capabilities,
}

local function detect_ruby_formatter()
  if vim.fn.filereadable('.standard.yml') == 1 then
    return 'standard'
  else
    return 'rubocop'
  end
end

vim.lsp.config.ruby_lsp = {
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
  capabilities = capabilities,
}

vim.lsp.enable({'ruby_lsp', 'rust_analyzer', 'ts_ls', 'cssls', 'lua_ls', 'stimulus_ls'})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('native-lsp-attach', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    
    -- Native completion disabled - using blink.cmp instead
    -- if client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end
    
    if client:supports_method('textDocument/formatting') then
      if vim.bo[bufnr].filetype == 'ruby' then
        local formatter = detect_ruby_formatter()
        if formatter ~= 'standard' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('native-lsp-format', {clear=false}),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
            end,
          })
        end
      else
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('native-lsp-format', {clear=false}),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
          end,
        })
      end
    end
    
    if vim.bo[bufnr].filetype == 'ruby' then
      local formatter = detect_ruby_formatter()
      if formatter == 'standard' then
        vim.diagnostic.enable(false, { bufnr = bufnr })
      end
    end
    
    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end
    
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      if vim.bo[bufnr].filetype == 'ruby' then
        local formatter = detect_ruby_formatter()
        if formatter == 'standard' then
          print("Format disabled for StandardRB projects")
        else
          vim.lsp.buf.format()
        end
      else
        vim.lsp.buf.format()
      end
    end, { desc = 'Format with LSP' })
    

  end,
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
  },
})

return {
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end
  },
  'kchmck/vim-coffee-script',
  'vim-scripts/dbext.vim'
}
