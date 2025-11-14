#!/usr/bin/env bash
# Run the appropriate package installation script for the detected OS

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILES_DIR

source "$DOTFILES_DIR/scripts/common.sh"

# Respect existing $OS if supplied, otherwise detect
if [[ -z "$OS" ]]; then
  detect_os
fi

case "$OS" in
  macos)
    source "$DOTFILES_DIR/scripts/setup-packages-macos.sh"
    ;;
  arch)
    source "$DOTFILES_DIR/scripts/setup-packages-arch.sh"
    ;;
  debian)
    source "$DOTFILES_DIR/scripts/setup-packages-debian.sh"
    ;;
  *)
    echo "Unsupported OS: $OS"
    echo "Please install required packages manually (fish, starship, neovim, tmux, gh, eza, lazygit, mise, btop, fzf, ghostty)."
    exit 1
    ;;
esac
