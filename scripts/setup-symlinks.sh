#!/usr/bin/env bash
# Create symlinks for common configuration files

set -e

echo "=== Core Configuration Files ==="

# Setup terminal emulator machine-specific configs (before symlinking directories)
echo "Setting up terminal emulator machine-specific configuration..."
setup_machine_config "config" "$DOTFILES_DIR/ghostty" "$DOTFILES_DIR/ghostty/config.machine.conf"
setup_machine_config "config" "$DOTFILES_DIR/alacritty" "$DOTFILES_DIR/alacritty/config.machine.toml" "toml"
setup_machine_config "config" "$DOTFILES_DIR/kitty" "$DOTFILES_DIR/kitty/config.machine.conf"

# Core configs
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
create_symlink "$DOTFILES_DIR/gh-dash" "$HOME/.config/gh-dash"
create_symlink "$DOTFILES_DIR/opencode" "$HOME/.config/opencode"

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
