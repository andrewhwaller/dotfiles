#!/usr/bin/env bash
# Fish shell and Fisher plugin manager setup

set -e

echo "=== Fish Shell Setup ==="

if ! command -v fish &> /dev/null; then
  echo "Fish shell not found. Skipping shell setup. Install fish and rerun this step."
  return 0 2>/dev/null || exit 0
fi

# Set Fish as default shell if requested
if [[ "${SET_DEFAULT_SHELL:-false}" == "true" ]]; then
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "Setting fish as default shell..."
    if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
      echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$FISH_PATH"
    echo "  ✓ Fish set as default shell (restart terminal to apply)"
  else
    echo "  ✓ Fish is already your default shell"
  fi
else
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "⚠ Fish is installed but not set as default shell"
    echo "  To set it later, run: chsh -s $(command -v fish)"
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
if command -v fzf &> /dev/null; then
  echo "Installing fzf.fish plugin..."
  fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || echo "  ✓ fzf.fish already installed"
fi

echo "✓ Fish shell setup complete"
echo ""
