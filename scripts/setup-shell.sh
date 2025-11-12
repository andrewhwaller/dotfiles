#!/usr/bin/env bash
# Fish shell and Fisher plugin manager setup

set -e

echo "=== Fish Shell Setup ==="

if ! command_exists fish; then
  echo "Fish shell not found. Please install it first."
  exit 1
fi

# Set Fish as default shell
FISH_PATH=$(command -v fish)
if [[ "$SHELL" != "$FISH_PATH" ]]; then
  read -p "Set fish as default shell? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
      echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$FISH_PATH"
    echo "  ✓ Fish set as default shell (restart terminal to apply)"
  fi
fi

# Install Fisher plugin manager
echo "=== Fisher & Fish Plugins ==="
if [[ ! -f "$HOME/.config/fish/functions/fisher.fish" ]]; then
    echo "Installing Fisher plugin manager..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    echo "  ✓ Fisher installed"
else
    echo "Fisher already installed ✓"
fi

# Install fzf.fish plugin
if command_exists fzf; then
  echo "Installing fzf.fish plugin..."
  fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "  ✓ fzf.fish already installed"
fi

echo "✓ Fish shell setup complete"
echo ""
