# dotfiles

Personal dotfiles for macOS and Linux (with Omarchy support)

## What's Included

Configuration files for:
- [Fish](https://fishshell.com/) - Primary shell
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Neovim](https://neovim.io/) - Text editor with Lazy.nvim
- [Tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [Kitty](https://sw.kovidgoyal.net/kitty/) - Alternative terminal
- [Hyprland](https://hyprland.org/) - Wayland compositor (Linux only)
- [opencode](https://opencode.ai/) - AI code assistant

## Quick Start

### One-Line Install

```bash
git clone https://github.com/andrewhwaller/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

The install script will:
1. Detect your OS (macOS or Linux)
2. Install Fish shell if needed and set it as default
3. Install Starship and mise if needed
4. Symlink all configs to appropriate locations
5. On Linux with Hyprland: Deploy Hyprland configs

## Platform Differences

### macOS
- Uses Homebrew for package installation
- No Hyprland (macOS window management)
- Core dev tools only

### Linux
- Hyprland with modular configuration (if Hyprland is installed)
- Works on any Arch-based system
- Can integrate with system utilities if available

## Hyprland Configuration (Linux)

Your Hyprland config now uses Omarchy's modular structure:

```
~/.config/hypr/
├── hyprland.conf       # Main config (sources everything)
├── monitors.conf       # Monitor setup
├── input.conf          # Keyboard/mouse settings
├── bindings.conf       # Your custom keybindings
├── envs.conf           # Environment variables
├── looknfeel.conf      # Appearance (gaps, borders, animations)
├── autostart.conf      # Programs to launch
└── mocha.conf          # Catppuccin Mocha colors
```

**How it works**: If you're using a system with default configs (like Omarchy), those are sourced first from `~/.local/share/omarchy/default/hypr/`, then your configs override specific settings. On vanilla Hyprland, only your configs are used.

## Key Features

### Fish Shell
- Tmux auto-start on interactive sessions
- mise for version management
- Starship prompt with git integration
- Custom aliases: `v` (nvim), `lg` (lazygit), `ez` (eza)

### Neovim
- Lazy.nvim plugin manager
- Custom plugin configuration
- LSP, Treesitter, Telescope, and more
- Completely replaces LazyVim on Omarchy systems

### Hyprland Keybindings (Linux)
- `Super + hjkl` - Vim-style window focus
- `Super + Space` - Walker launcher
- `Super + Return` - Terminal
- `Super + B` - Browser
- `Super + K` - Show keybindings menu
- `Print` - Screenshot tools
- See `hypr/bindings.conf` for full list

## System Integration

This dotfiles setup is designed to work with or without system-provided defaults:

### On Omarchy (Arch Linux)
Your configs layer on top of Omarchy's base system:
- **Replaces**: LazyVim, Starship config, Bash shell
- **Keeps**: System utilities (omarchy-menu, screenshot tools, etc.)
- **Overrides**: Hyprland aesthetics, keybindings, monitor setup

See [OMARCHY_INTEGRATION.md](OMARCHY_INTEGRATION.md) for Omarchy-specific details.

### On vanilla Hyprland
Your configs work standalone without any base system.

## Manual Installation (Advanced)

If you prefer manual setup:

### Required Tools
```bash
# macOS
brew install fish starship neovim tmux

# Linux (Arch/Omarchy)
sudo pacman -S fish starship neovim tmux
```

### Symlinks
```bash
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -s ~/dotfiles/nvim/lua ~/.config/nvim/lua
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/ghostty ~/.config/ghostty

# Linux only
ln -s ~/dotfiles/hypr ~/.config/hypr
```

### Set Fish as Default Shell
```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh
```

## Troubleshooting

### Fish not activating tmux
Make sure tmux is installed: `brew install tmux` or `sudo pacman -S tmux`

### Neovim plugins not loading
Open nvim and run `:Lazy sync`

### Hyprland config errors (Linux)
If using vanilla Hyprland (not Omarchy), comment out the Omarchy source lines in `hypr/hyprland.conf` (lines 6-14)

### Keybindings reference
See `hypr/bindings.conf` for your custom keybindings

## Structure

```
dotfiles/
├── fish/              # Fish shell config
├── starship/          # Starship prompt config
├── nvim/              # Neovim config (Lazy.nvim)
├── tmux/              # Tmux configuration
├── hypr/              # Hyprland configs (modular)
├── ghostty/           # Ghostty terminal config
├── kitty/             # Kitty terminal config
├── zsh/               # Zsh (optional fallback)
├── gh-dash/           # GitHub CLI dashboard
├── opencode/          # OpenCode AI config
├── install.sh         # Universal installer
└── OMARCHY_INTEGRATION.md  # Detailed integration docs
```

## License

MIT
