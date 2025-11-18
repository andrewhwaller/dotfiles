#!/usr/bin/env bash
# macOS package installation via Homebrew

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== macOS Package Installation ==="

# Ensure Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⚠ Please complete the Xcode Command Line Tools installation in the dialog,"
  echo "  then press Enter to continue..."
  read -r
else
  echo "✓ Xcode Command Line Tools already installed"
fi

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Ensure Homebrew is in PATH for current session
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
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

# Note about Tailscale
if command -v tailscale &> /dev/null; then
  echo "Note: Tailscale CLI installed. To start:"
  echo "  sudo tailscaled install-system-daemon"
  echo "  tailscale up"
fi

# Optional: Install opencode
if command -v opencode &> /dev/null; then
  echo "opencode CLI already detected, skipping install."
else
  read -p "[Opencode] Install the sst/tap/opencode CLI helper? (Y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    brew install sst/tap/opencode
  fi
fi

echo "✓ macOS packages installed"
echo ""
