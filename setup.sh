#!/usr/bin/env bash
# Main dotfiles setup orchestrator
# This script coordinates all setup subscripts

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

echo "=================================="
echo "Dotfiles Setup"
echo "=================================="
echo ""

# Source common functions
source "$DOTFILES_DIR/scripts/common.sh"

# Detect OS
detect_os
echo "Detected OS: $OS"
echo "Dotfiles: $DOTFILES_DIR"
echo ""

# ==========================================
# 1. Install Packages (OS-specific)
# ==========================================
read -p "Install/update packages? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  case "$OS" in
    macos)
      source "$DOTFILES_DIR/scripts/setup-packages-macos.sh"
      ;;
    arch)
      source "$DOTFILES_DIR/scripts/setup-packages-arch.sh"
      ;;
    debian)
      source "$DOTFILES_DIR/scripts/setup-packages-debian.sh"
      ;;
    *)
      echo "Unsupported OS. Please install dependencies manually:"
      echo "  - fish, starship, neovim, tmux, gh (GitHub CLI)"
      echo "  - eza, lazygit, mise, btop, fzf, ghostty"
      exit 1
      ;;
  esac
fi

# ==========================================
# 2. Setup Shell (Fish + Fisher)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-shell.sh"

# ==========================================
# 3. Create Symlinks (Common Configs)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-symlinks.sh"

# ==========================================
# 4. Platform-Specific Configs
# ==========================================
if [[ "$OS" == "arch" ]]; then
  source "$DOTFILES_DIR/scripts/setup-hyprland.sh"
fi

# ==========================================
# 5. Optional Configs
# ==========================================
source "$DOTFILES_DIR/scripts/setup-optional.sh"

# ==========================================
# Done!
# ==========================================
echo "=================================="
echo "✓ Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec fish"
echo "  2. Open Neovim and let Lazy.nvim install plugins"
echo "  3. Configure gh: gh auth login"
if command_exists hyprctl; then
    echo "  4. Reload Hyprland: hyprctl reload"
fi
echo ""
