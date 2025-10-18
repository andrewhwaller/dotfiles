#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=================================="
echo "Dotfiles Server Installation"
echo "=================================="
echo "Target: Ubuntu/Debian Server"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# Check if running on a Debian/Ubuntu system
if ! command -v apt &> /dev/null; then
    echo "Error: This script is for Ubuntu/Debian systems with apt package manager"
    exit 1
fi

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
# 1. Update package list
# ==========================================
echo "=== Updating Package List ==="
sudo apt update
echo ""

# ==========================================
# 2. Install Core Tools
# ==========================================
echo "=== Installing Core Tools ==="

# Fish shell
if ! command_exists fish; then
    echo "Installing Fish..."
    sudo apt install -y fish
else
    echo "Fish already installed ✓"
fi

# Neovim
if ! command_exists nvim; then
    echo "Installing Neovim..."
    # Try to install latest neovim
    sudo apt install -y neovim
else
    echo "Neovim already installed ✓"
fi

# Tmux
if ! command_exists tmux; then
    echo "Installing Tmux..."
    sudo apt install -y tmux
else
    echo "Tmux already installed ✓"
fi

# Curl (for installing other tools)
if ! command_exists curl; then
    echo "Installing Curl..."
    sudo apt install -y curl
else
    echo "Curl already installed ✓"
fi
echo ""

# ==========================================
# 3. Install Starship
# ==========================================
echo "=== Starship Prompt ==="
if ! command_exists starship; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship already installed ✓"
fi
echo ""

# ==========================================
# 4. Install mise
# ==========================================
echo "=== mise ==="
if ! command_exists mise; then
    echo "Installing mise..."
    curl https://mise.run | sh
    # Add mise to path for this session
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "mise already installed ✓"
fi
echo ""

# ==========================================
# 5. Set Fish as Default Shell
# ==========================================
echo "=== Fish Shell Setup ==="
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
# 6. Symlink Core Server Configs
# ==========================================
echo "=== Core Configuration Files ==="
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo ""

# ==========================================
# 7. Optional Configs
# ==========================================
echo "=== Optional Configs ==="

# Zsh (optional fallback)
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    if [[ -d "$DOTFILES_DIR/zsh" ]]; then
        create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
    fi
fi

# Git config (if you have one)
if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi
echo ""

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Server Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins: nvim"
echo "  3. (Optional) Install additional tools with mise: mise use -g node@latest"
echo ""
echo "Server-specific notes:"
echo "  - No GUI applications installed (this is a headless server)"
echo "  - Tmux is configured for remote session management"
echo "  - Fish shell is now your default"
echo ""
