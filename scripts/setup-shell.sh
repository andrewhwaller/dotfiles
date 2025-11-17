#!/usr/bin/env bash
# Fish shell and Fisher plugin manager setup

set -e

echo "=== Fish Shell Setup ==="

if ! command -v fish &> /dev/null; then
  echo "Fish shell not found. Skipping shell setup. Install fish and rerun this step."
  return 0 2>/dev/null || exit 0
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
if command -v fzf &> /dev/null; then
  echo "Installing fzf.fish plugin..."
  fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "  ✓ fzf.fish already installed"
fi

echo "✓ Fish shell setup complete"
echo ""
