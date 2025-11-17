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

    # Ensure fish is in /etc/shells
    if ! grep -qx "$FISH_PATH" /etc/shells 2>/dev/null; then
      echo "  Adding $FISH_PATH to /etc/shells..."
      echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi

    # Change default shell
    if chsh -s "$FISH_PATH" "$USER"; then
      echo "  ✓ Fish set as default shell for $USER"
      echo "  ⚠ You MUST log out and log back in (or reboot) for this to take effect"
      echo "  ⚠ Opening a new terminal is NOT enough - you need to log out!"
    else
      echo "  ✗ Failed to set fish as default shell"
      echo "  Try manually: sudo chsh -s $FISH_PATH $USER"
      exit 1
    fi
  else
    echo "  ✓ Fish is already your default shell"
  fi
else
  FISH_PATH=$(command -v fish)
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "⚠ Fish is installed but not set as default shell"
    echo "  To set it later, run: chsh -s $(command -v fish) $USER"
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
