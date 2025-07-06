# Native LSP Setup

This configuration uses Neovim 0.11's native LSP features exclusively - no nvim-lspconfig or Mason needed!

## Installation

Install LSP servers manually using your package manager:

**macOS (Homebrew + npm/gem):**
```bash
# Language servers
brew install rust-analyzer lua-language-server
npm install -g typescript-language-server typescript vscode-langservers-extracted stimulus-language-server
gem install ruby-lsp
```

**Ubuntu/Debian:**
```bash
# TypeScript/JavaScript + CSS + Stimulus
npm install -g typescript-language-server typescript vscode-langservers-extracted stimulus-language-server

# Ruby
gem install ruby-lsp

# Rust (via rustup recommended)
rustup component add rust-analyzer

# Lua (manual download or build from source)
# See: https://github.com/LuaLS/lua-language-server/releases
```

## LSP Servers Configured

- **rust-analyzer** - Rust language support with Clippy
- **typescript-language-server** - TypeScript/JavaScript support  
- **lua-language-server** - Lua language support (vim globals configured)
- **vscode-css-language-server** - CSS/SCSS/Less support
- **ruby-lsp** - Ruby language support with smart StandardRB handling
- **stimulus-language-server** - Stimulus data attribute completions

## Features

### Native Auto-completion
- Built-in LSP completion with `autotrigger = true`
- No external completion plugins needed

### Default Keymaps (Neovim 0.11)
- `grn` - Rename symbol (Normal mode)
- `grr` - Find references (Normal mode)
- `gri` - Go to implementation (Normal mode)
- `gra` - Code actions (Normal + Visual mode)
- `gO` - Document symbols (Normal mode)
- `CTRL-S` - Signature help (Insert mode)
- `K` - Hover documentation (Normal mode)

### Custom Keymaps
- `gd` - Go to definition
- `gr` - Find references  
- `<leader>D` - Type definition

### Smart Ruby Handling
- **StandardRB projects** (`.standard.yml` detected):
  - Format-on-save **disabled** (no unwanted quote conversions)
  - Diagnostics/virtual text **disabled** (clean editing)
  - Manual `:Format` disabled with message
- **RuboCop projects** (no `.standard.yml`):
  - Format-on-save **enabled** via Ruby LSP
  - Full diagnostics and virtual text
  - Manual `:Format` works normally

### Enhanced Diagnostics
- Virtual text with improved styling (except StandardRB projects)
- Floating diagnostics with rounded borders
- Signs in gutter with severity sorting
- Auto-format on save (except StandardRB projects)

### Commands
- `:Format` - Format current buffer (respects StandardRB vs RuboCop projects)
- `:checkhealth vim.lsp` - Check LSP status

## Ruby Project Configuration

For StandardRB projects, ensure your project has:
- `.standard.yml` file in project root
- `standard` gem in your project's `Gemfile` or installed globally
- Bundle installed: `bundle install`

For RuboCop projects:
- `.rubocop.yml` file (optional, Ruby LSP will auto-detect)
- Ruby LSP handles RuboCop integration automatically

## Troubleshooting

1. **Check if server is installed**: `:lua print(vim.fn.executable('ruby-lsp'))`
2. **View LSP logs**: `:lua vim.cmd('edit ' .. vim.fn.stdpath('state') .. '/lsp.log')`
3. **Restart LSP**: `:LspRestart` (if available) or restart Neovim
4. **Check health**: `:checkhealth vim.lsp`
5. **Verify StandardRB detection**: In Ruby project, run `:lua print(vim.fn.filereadable('.standard.yml') == 1 and 'StandardRB project' or 'RuboCop project')`