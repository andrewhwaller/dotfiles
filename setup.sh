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
read -p "[Packages] Install or update core CLI/GUI tools (fish, neovim, gh, ghostty, firefox, etc.)? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  "$DOTFILES_DIR/install-packages.sh"
fi

# ==========================================
# 2. Setup Shell (Fish + Fisher)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-shell.sh"

# Set fish as default shell (separate explicit step)
if command -v fish &> /dev/null; then
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo ""
    read -p "[Shell] Set fish as your default shell? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
      echo "Setting fish as default shell..."
      if ! grep -qx "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "  Adding $FISH_PATH to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
      fi
      if chsh -s "$FISH_PATH" "$USER"; then
        echo "  ✓ Fish set as default shell for $USER"
        echo "  ⚠ You MUST log out and log back in (or reboot) for this to take effect"
      else
        echo "  ✗ Failed to set fish as default shell"
        echo "  Try manually: sudo chsh -s $FISH_PATH $USER"
      fi
    fi
  fi
fi

# ==========================================
# 3. Create Symlinks (Common Configs)
# ==========================================
source "$DOTFILES_DIR/scripts/setup-symlinks.sh"

# ==========================================
# 4. Platform-Specific Configs
# ==========================================
if [[ "$OS" == "arch" ]]; then
  source "$DOTFILES_DIR/scripts/setup-hyprland.sh"

  # Setup fingerprint authentication if scanner detected
  if lsusb 2>/dev/null | grep -iq "fingerprint\|biometric"; then
    echo ""
    echo "Fingerprint scanner detected!"
    read -p "[Fingerprint] Configure fingerprint authentication (fprintd enrol, PAM updates)? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
      source "$DOTFILES_DIR/scripts/setup-fingerprint.sh"
    fi
  fi

  # Optional: Install COSMIC desktop environment
  echo ""
  read -p "[COSMIC] Install System76 COSMIC desktop packages (~1.5GB download)? (Y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    source "$DOTFILES_DIR/scripts/setup-cosmic.sh"
  fi
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
if command -v hyprctl &> /dev/null; then
    echo "  4. Reload Hyprland: hyprctl reload"
fi
echo ""
