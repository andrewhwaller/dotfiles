#!/usr/bin/env bash
# ============================================================
#  Wi-Fi setup for Arch Linux using iwd + Impala + systemd-resolved
# ============================================================

set -euo pipefail

echo "==> Installing required packages..."
sudo pacman -S --noconfirm --needed iwd impala

echo "==> Enabling iwd service..."
sudo systemctl enable --now iwd

echo "==> Creating /etc/iwd/main.conf..."
sudo mkdir -p /etc/iwd
cat > /tmp/iwd-main.conf <<'EOF'
[General]
EnableNetworkConfiguration=true

[Network]
EnableIPv6=true
RoutePriorityOffset=300
NameResolvingService=systemd
EOF
sudo mv /tmp/iwd-main.conf /etc/iwd/main.conf

echo "==> Enabling systemd-resolved..."
sudo systemctl enable --now systemd-resolved

echo "==> Linking resolv.conf..."
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo "==> Restarting iwd to apply settings..."
sudo systemctl restart iwd

echo "==> Wi-Fi setup complete!"
echo
echo "You can now connect using either:"
echo "  • impala   (interactive TUI)"
echo "  • iwctl station wlan0 connect <SSID>"
echo
echo "After connecting, verify with:"
echo "  ip addr show wlan0"
echo "  ping -c3 8.8.8.8"
echo "  ping -c3 archlinux.org"
echo
echo "✅  If those work, your Wi-Fi + DNS are fully functional."
