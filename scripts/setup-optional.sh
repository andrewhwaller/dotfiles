#!/usr/bin/env bash
# Optional configuration files

set -e

echo "=== Optional Configs ==="

# Doom Emacs (if doom exists)
if [[ -d "$HOME/.config/doom" ]]; then
    echo "Doom Emacs detected, symlinking config..."
    create_symlink "$DOTFILES_DIR/doom/config.el" "$HOME/.config/doom/config.el"
fi

# Zsh (optional fallback)
if [[ -f "$DOTFILES_DIR/zshrc" ]]; then
    echo "Setting up Zsh fallback configs..."
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
fi

echo "✓ Optional configs complete"
echo ""
