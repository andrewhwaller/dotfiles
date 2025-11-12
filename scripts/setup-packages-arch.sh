#!/usr/bin/env bash
# Arch Linux package installation via pacman/yay

set -e

echo "=== Arch Linux Package Installation ==="

# Check if yay is installed, install if not
if ! command_exists yay; then
  echo "Installing yay..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi

# Install packages
echo "Installing packages via yay..."
yay -S --needed \
  fish \
  starship \
  neovim \
  tmux \
  github-cli \
  eza \
  lazygit \
  mise \
  btop \
  fzf \
  ghostty

# Optional: Hyprland ecosystem
read -p "Install Hyprland and related tools? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  yay -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-gtk
fi

echo "✓ Arch Linux packages installed"
echo ""
