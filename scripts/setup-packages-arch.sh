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
  inetutils \
  github-cli \
  eza \
  lazygit \
  mise \
  btop \
  fzf \
  ghostty

install_tpm

# Optional: Hyprland ecosystem
if command_exists hyprctl; then
  echo "Hyprland already detected, skipping optional Hyprland install prompt."
else
  read -p "[Hyprland] Install Hyprland desktop stack (hyprland, hyprpaper, hyprlock, waybar, walker, etc.)? (Y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing Hyprland core..."
    yay -S --needed hyprland hyprpaper hyprlock hypridle waybar xdg-desktop-portal-gtk iwd impala

    echo "Installing walker application launcher and dependencies..."
    yay -S --needed \
      walker \
      elephant-bin \
      elephant-desktopapplications-bin \
      elephant-files-bin \
      elephant-calc-bin \
      elephant-runner-bin \
      elephant-websearch-bin \
      elephant-clipboard-bin \
      elephant-providerlist-bin \
      fd \
      ttf-nerd-fonts-symbols-mono
  fi
fi

echo "✓ Arch Linux packages installed"
echo ""
