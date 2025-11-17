#!/usr/bin/env bash
# macOS package installation via Homebrew

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== macOS Package Installation ==="

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing packages via Homebrew..."
brew install \
  fish \
  starship \
  neovim \
  tmux \
  gh \
  eza \
  lazygit \
  mise \
  btop \
  fzf \
  tailscale

brew install --cask ghostty

install_tpm

# Optional: Install opencode
if command -v opencode &> /dev/null; then
  echo "opencode CLI already detected, skipping install."
else
  read -p "[Opencode] Install the sst/tap/opencode CLI helper? (Y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install sst/tap/opencode
  fi
fi

echo "✓ macOS packages installed"
echo ""
