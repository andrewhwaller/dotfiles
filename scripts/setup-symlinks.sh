#!/usr/bin/env bash
# Create symlinks for common configuration files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Core Configuration Files ==="

# Core configs
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
create_symlink "$DOTFILES_DIR/gh-dash" "$HOME/.config/gh-dash"
create_symlink "$DOTFILES_DIR/opencode" "$HOME/.config/opencode"
create_symlink "$DOTFILES_DIR/btop" "$HOME/.config/btop"

# GTK dark theme preference (Linux)
if [[ "$OS" == "arch" || "$OS" == "debian" ]]; then
  create_symlink "$DOTFILES_DIR/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
  create_symlink "$DOTFILES_DIR/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
fi

# On macOS, copy theme.conf example if it doesn't exist
if [[ "$OS" == "macos" && ! -f "$HOME/.config/ghostty/theme.conf" ]]; then
    echo "  Creating Ghostty theme.conf from example..."
    cp "$DOTFILES_DIR/ghostty/theme.conf.example" "$HOME/.config/ghostty/theme.conf"
fi

echo "✓ Core configuration symlinks created"
echo ""
