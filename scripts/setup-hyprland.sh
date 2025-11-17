#!/usr/bin/env bash
# Hyprland window manager configuration (Linux only)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Hyprland Configuration ==="

# Check if Hyprland is installed
if ! command -v hyprctl &> /dev/null; then
    echo "Hyprland not detected, skipping Hyprland configs"
    return 0
fi

echo "Hyprland detected ✓"
echo "Deploying Hyprland configuration..."

# Setup machine-specific configs
echo "Setting up machine-specific Hyprland configuration..."
setup_machine_config "envs" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/envs.machine.conf"
setup_machine_config "autostart" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/autostart.machine.conf"
setup_machine_config "monitors" "$DOTFILES_DIR/hypr" "$HOME/.config/hypr/monitors.machine.conf"

# Symlink hyprland.conf and discrete config files
create_symlink "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
create_symlink "$DOTFILES_DIR/hypr/monitors.conf" "$HOME/.config/hypr/monitors.conf"
create_symlink "$DOTFILES_DIR/hypr/input.conf" "$HOME/.config/hypr/input.conf"
create_symlink "$DOTFILES_DIR/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
create_symlink "$DOTFILES_DIR/hypr/envs.conf" "$HOME/.config/hypr/envs.conf"
create_symlink "$DOTFILES_DIR/hypr/looknfeel.conf" "$HOME/.config/hypr/looknfeel.conf"
create_symlink "$DOTFILES_DIR/hypr/autostart.conf" "$HOME/.config/hypr/autostart.conf"
create_symlink "$DOTFILES_DIR/hypr/mocha.conf" "$HOME/.config/hypr/mocha.conf"
create_symlink "$DOTFILES_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
create_symlink "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
create_symlink "$DOTFILES_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
create_symlink "$DOTFILES_DIR/walker" "$HOME/.config/walker"
create_symlink "$DOTFILES_DIR/elephant" "$HOME/.config/elephant"
create_symlink "$DOTFILES_DIR/hypr/scripts" "$HOME/.config/hypr/scripts"
create_symlink "$DOTFILES_DIR/hypr/wallpapers" "$HOME/.config/hypr/wallpapers"

# Symlink waybar configuration
create_symlink "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"

# Configure dark mode preferences for GTK apps
echo "Configuring dark mode preferences..."
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    echo "  ✓ GTK color scheme set to prefer-dark"
fi

# Restart portal service if running
if systemctl --user is-active --quiet xdg-desktop-portal.service; then
    echo "  Restarting xdg-desktop-portal service..."
    systemctl --user restart xdg-desktop-portal.service
    echo "  ✓ Portal service restarted"
fi

# Reload Hyprland configuration
echo "Reloading Hyprland configuration..."
if hyprctl reload &> /dev/null; then
    echo "  ✓ Hyprland configuration reloaded"
else
    echo "  ⚠ Could not reload Hyprland (not currently running or failed)"
fi

echo "✓ Hyprland configuration complete"
echo ""
