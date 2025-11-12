#!/usr/bin/env bash
# macOS package installation via Homebrew

set -e

echo "=== macOS Package Installation ==="

# Install Homebrew if needed
if ! command_exists brew; then
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
  fzf

brew install --cask ghostty

# Optional: Install opencode
read -p "Install opencode? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install sst/tap/opencode
fi

echo "✓ macOS packages installed"
echo ""
