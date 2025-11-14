#!/usr/bin/env bash
# COSMIC desktop environment installation (Arch Linux only)

set -e

echo "=== COSMIC Desktop Environment ==="

# Check if Cosmic is already installed
if pacman -Qq cosmic-session &>/dev/null; then
    echo "COSMIC is already installed ✓"
    echo ""
    return 0
fi

echo "COSMIC is not currently installed."
echo "COSMIC is System76's new Rust-based desktop environment."
echo ""
read -p "Install COSMIC desktop environment? (y/n) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping COSMIC installation"
    echo ""
    return 0
fi

echo "Installing COSMIC packages..."
sudo pacman -S --needed cosmic

echo ""
echo "✓ COSMIC installation complete"
echo ""
echo "COSMIC session is now available in Ly display manager."
echo "Press F2 at the Ly login screen to select COSMIC."
echo ""
