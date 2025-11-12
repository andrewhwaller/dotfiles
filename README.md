# dotfiles

Personal dotfiles for macOS and Linux

## What's Included

Configuration files for:
- [Fish](https://fishshell.com/) - Primary shell
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Neovim](https://neovim.io/) - Text editor with Lazy.nvim
- [Tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [Alacritty](https://alacritty.org/) - GPU-accelerated terminal
- [Kitty](https://sw.kovidgoyal.net/kitty/) - Alternative terminal
- [Hyprland](https://hyprland.org/) - Wayland compositor (Linux only)
- [opencode](https://opencode.ai/) - AI code assistant

## Quick Start

### Desktop/Laptop Install (macOS or Linux with GUI)

```bash
git clone https://github.com/andrewhwaller/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

The setup script will:
1. Detect your OS (macOS or Linux)
2. Install Fish shell if needed and set it as default
3. Install Starship and mise if needed
4. Symlink all configs to appropriate locations
5. On Linux with Hyprland: Deploy Hyprland configs

### Ubuntu Server Install

```bash
# Install GitHub CLI
sudo apt update
sudo apt install -y gh

# Authenticate with GitHub
gh auth login

# Clone repo
gh repo clone andrewhwaller/dotfiles ~/dotfiles

# Run install
cd ~/dotfiles
./server-setup.sh
```

Installs Fish, Neovim, Tmux, Starship, and mise. Symlinks server configs only (no GUI).

## Platform Differences

### macOS
- Uses Homebrew for package installation
- No Hyprland (macOS window management)
- Core dev tools only
- Install with: `./setup.sh`

### Linux Desktop (Arch/Hyprland)
- Hyprland with modular configuration (if Hyprland is installed)
- Works on any Arch-based system
- Can integrate with system utilities if available
- Install with: `./setup.sh`

### Ubuntu Server
- Core tools: Fish, Neovim, Tmux, Starship, mise
- No GUI applications
- Uses apt package manager
- Install with: `./server-setup.sh`

## Hyprland Configuration (Linux)

Your Hyprland config uses a modular structure:

```
~/.config/hypr/
├── hyprland.conf       # Main config (sources everything)
├── monitors.conf       # Monitor setup (created from example on first install)
├── input.conf          # Keyboard/mouse settings
├── bindings.conf       # Your custom keybindings
├── envs.conf           # Environment variables
├── looknfeel.conf      # Appearance (gaps, borders, animations)
├── autostart.conf      # Programs to launch
└── mocha.conf          # Catppuccin Mocha colors
```

**How it works**: Your configs provide a complete Hyprland configuration in a clean, modular structure.

### Per-Machine Monitor Configuration

On first install, `monitors.conf` is created from the example template at `~/.config/hypr/monitors.conf`. Edit this file to match your monitor setup - it won't be overwritten on subsequent installs.

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

### Hyprland Keybindings (Linux)
- `Super + hjkl` - Vim-style window focus
- `Super + Space` - Walker launcher
- `Super + Return` - Terminal
- `Super + B` - Browser
- `Super + K` - Show keybindings menu
- `Print` - Screenshot tools
- See `hypr/bindings.conf` for full list

## Manual Installation (Advanced)

If you prefer manual setup:

### Required Tools
```bash
# macOS
brew install fish starship neovim tmux

# Linux (Arch)
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
./setup.sh
```

## Troubleshooting

### Fish not activating tmux
Make sure tmux is installed: `brew install tmux` or `sudo pacman -S tmux`

### Neovim plugins not loading
Open nvim and run `:Lazy sync`

### Keybindings reference
See `hypr/bindings.conf` for your custom keybindings

## Structure

```
dotfiles/
├── fish/                      # Fish shell config
├── starship/                  # Starship prompt config
├── nvim/                      # Neovim config (Lazy.nvim)
├── tmux/                      # Tmux configuration
├── hypr/                      # Hyprland configs (modular)
│   └── monitors.conf.example  # Monitor setup template
├── ghostty/                   # Ghostty terminal config
├── alacritty/                 # Alacritty terminal config
├── kitty/                     # Kitty terminal config
├── zsh/                       # Zsh (optional fallback)
├── gh-dash/                   # GitHub CLI dashboard
├── opencode/                  # OpenCode AI config
├── scripts/                   # Setup scripts (modular)
│   ├── common.sh              # Shared functions
│   ├── setup-packages-*.sh    # OS-specific package installation
│   ├── setup-shell.sh         # Fish + Fisher setup
│   ├── setup-symlinks.sh      # Config symlinks
│   ├── setup-hyprland.sh      # Hyprland setup (Arch)
│   └── setup-optional.sh      # Optional configs
├── setup.sh                   # Main setup script (desktop/laptop)
└── server-setup.sh            # Server setup script (headless)
```

## License

MIT
