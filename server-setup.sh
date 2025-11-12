#!/usr/bin/env bash
# Server dotfiles setup (Ubuntu/Debian headless servers)
# This script is optimized for servers - non-interactive, minimal GUI deps

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

echo "=================================="
echo "Dotfiles Server Installation"
echo "=================================="
echo "Target: Ubuntu/Debian Server"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# Source common functions
source "$DOTFILES_DIR/scripts/common.sh"

# Set OS to debian for server installs
export OS="debian"

# Check if running on a Debian/Ubuntu system
if ! command -v apt &> /dev/null; then
    echo "Error: This script is for Ubuntu/Debian systems with apt package manager"
    exit 1
fi

# ==========================================
# 1. Install Packages (Debian)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-packages-debian.sh"

# ==========================================
# 2. Setup Shell (Fish + Fisher)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-shell.sh"

# ==========================================
# 3. Symlink Server Configs
# ==========================================
echo "=== Core Server Configuration Files ==="

# Core configs (no GUI apps)
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Optional: Zsh fallback
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    echo "Setting up Zsh fallback configs..."
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    if [[ -d "$DOTFILES_DIR/zsh" ]]; then
        create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
    fi
fi

echo "✓ Server configuration symlinks created"
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
echo "  - No GUI applications installed (headless server)"
echo "  - Tmux configured for remote session management"
echo "  - Fish shell is now your default"
echo ""
