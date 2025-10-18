#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
fi

echo "=================================="
echo "Dotfiles Installation"
echo "=================================="
echo "OS: $OS"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to create symlink safely
create_symlink() {
    local src="$1"
    local dest="$2"
    local dest_dir=$(dirname "$dest")

    # Create parent directory if needed
    mkdir -p "$dest_dir"

    # Backup existing files
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "  Backing up: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Remove old symlink if it exists
    [[ -L "$dest" ]] && rm "$dest"

    # Create symlink
    ln -s "$src" "$dest"
    echo "  ✓ Linked: $dest"
}

# ==========================================
# 1. Install Fish Shell
# ==========================================
echo "=== Fish Shell ==="
if ! command_exists fish; then
    echo "Fish not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install fish
        else
            echo "Error: Homebrew not found. Please install Homebrew first."
            exit 1
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Check if on Omarchy (has pacman)
        if command_exists pacman; then
            sudo pacman -S --needed --noconfirm fish
        else
            echo "Error: Unsupported package manager. Please install fish manually."
            exit 1
        fi
    fi
else
    echo "Fish already installed ✓"
fi

# Set Fish as default shell
FISH_PATH=$(command -v fish)
if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "Setting Fish as default shell..."
    # Add fish to /etc/shells if not already there
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$FISH_PATH"
    echo "  ✓ Fish set as default shell"
else
    echo "Fish is already default shell ✓"
fi
echo ""

# ==========================================
# 2. Install Starship (if needed)
# ==========================================
echo "=== Starship Prompt ==="
if ! command_exists starship; then
    echo "Starship not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        brew install starship
    elif [[ "$OS" == "linux" ]]; then
        if command_exists pacman; then
            sudo pacman -S --needed --noconfirm starship
        fi
    fi
else
    echo "Starship already installed ✓"
fi
echo ""

# ==========================================
# 3. Install mise (if needed)
# ==========================================
echo "=== mise ==="
if ! command_exists mise; then
    echo "mise not found. Installing..."
    curl https://mise.run | sh
else
    echo "mise already installed ✓"
fi
echo ""

# ==========================================
# 4. Symlink Core Configs (All Platforms)
# ==========================================
echo "=== Core Configuration Files ==="
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/gh-dash" "$HOME/.config/gh-dash"
create_symlink "$DOTFILES_DIR/opencode" "$HOME/.config/opencode"
echo ""

# ==========================================
# 5. Linux-Specific (Hyprland)
# ==========================================
if [[ "$OS" == "linux" ]]; then
    echo "=== Linux-Specific Configs ==="

    # Check if Hyprland is installed
    if command_exists hyprctl; then
        echo "Hyprland detected ✓"
        echo "Deploying Hyprland configuration..."
        create_symlink "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
        create_symlink "$DOTFILES_DIR/hypr/monitors.conf" "$HOME/.config/hypr/monitors.conf"
        create_symlink "$DOTFILES_DIR/hypr/input.conf" "$HOME/.config/hypr/input.conf"
        create_symlink "$DOTFILES_DIR/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
        create_symlink "$DOTFILES_DIR/hypr/envs.conf" "$HOME/.config/hypr/envs.conf"
        create_symlink "$DOTFILES_DIR/hypr/looknfeel.conf" "$HOME/.config/hypr/looknfeel.conf"
        create_symlink "$DOTFILES_DIR/hypr/autostart.conf" "$HOME/.config/hypr/autostart.conf"
        create_symlink "$DOTFILES_DIR/hypr/mocha.conf" "$HOME/.config/hypr/mocha.conf"
        create_symlink "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
        create_symlink "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
        create_symlink "$DOTFILES_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
        create_symlink "$DOTFILES_DIR/hypr/wofi" "$HOME/.config/hypr/wofi"
        create_symlink "$DOTFILES_DIR/hypr/scripts" "$HOME/.config/hypr/scripts"
        create_symlink "$DOTFILES_DIR/hypr/wallpapers" "$HOME/.config/hypr/wallpapers"
    else
        echo "Hyprland not detected, skipping Hyprland configs"
    fi
    echo ""
fi

# ==========================================
# 6. Optional Configs
# ==========================================
echo "=== Optional Configs ==="

# Doom Emacs (if doom exists)
if [[ -d "$HOME/.config/doom" ]]; then
    create_symlink "$DOTFILES_DIR/doom/config.el" "$HOME/.config/doom/config.el"
fi

# Zsh (optional fallback)
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
fi

# Kitty (if you use it)
if command_exists kitty || [[ "$OS" == "linux" ]]; then
    create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
fi
echo ""

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins"
if command_exists hyprctl; then
    echo "  3. Reload Hyprland: hyprctl reload"
fi
echo ""
