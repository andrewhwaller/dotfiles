#!/usr/bin/env bash
# Fingerprint authentication setup for ThinkPad (and other supported hardware)
# Sets up fprintd, polkit authentication agent, and PAM configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

detect_os

echo "=== Fingerprint Authentication Setup ==="

# Only works on Linux
if [[ "$OS" != "arch" && "$OS" != "debian" ]]; then
    echo "This script only supports Linux systems"
    exit 1
fi

# Check for fingerprint scanner
echo "Checking for fingerprint scanner..."
if lsusb | grep -iq "fingerprint\|biometric"; then
    echo "✓ Fingerprint scanner detected"
    lsusb | grep -i "fingerprint\|biometric"
else
    echo "⚠ Warning: No fingerprint scanner detected"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# Install required packages
echo ""
echo "Installing required packages..."
if [[ "$OS" == "arch" ]]; then
    if ! command_exists fprintd; then
        echo "Installing fprintd..."
        sudo pacman -S --needed --noconfirm fprintd
    else
        echo "✓ fprintd already installed"
    fi

    if ! pacman -Qs polkit-gnome > /dev/null; then
        echo "Installing polkit-gnome..."
        sudo pacman -S --needed --noconfirm polkit-gnome
    else
        echo "✓ polkit-gnome already installed"
    fi
elif [[ "$OS" == "debian" ]]; then
    if ! command_exists fprintd; then
        echo "Installing fprintd..."
        sudo apt-get update
        sudo apt-get install -y fprintd libpam-fprintd
    else
        echo "✓ fprintd already installed"
    fi

    if ! dpkg -l | grep -q polkit-gnome-authentication-agent-1; then
        echo "Installing polkit-gnome..."
        sudo apt-get install -y polkit-gnome
    else
        echo "✓ polkit-gnome already installed"
    fi
fi

# Start polkit authentication agent if not running
echo ""
echo "Starting polkit authentication agent..."
if pgrep -f polkit-gnome-authentication-agent > /dev/null; then
    echo "✓ Polkit agent already running"
else
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    sleep 1
    echo "✓ Polkit agent started"
fi

# Enroll fingerprints
echo ""
echo "=== Fingerprint Enrollment ==="
echo "Available fingers:"
echo "  left-thumb, left-index-finger, left-middle-finger, left-ring-finger, left-little-finger"
echo "  right-thumb, right-index-finger, right-middle-finger, right-ring-finger, right-little-finger"
echo ""

while true; do
    read -p "Enter finger to enroll (or 'skip' to skip, 'done' to finish): " finger

    if [[ "$finger" == "skip" ]]; then
        echo "Skipping enrollment. You can enroll later with: fprintd-enroll -f <finger-name>"
        break
    elif [[ "$finger" == "done" ]]; then
        break
    elif [[ -n "$finger" ]]; then
        echo "Enrolling $finger..."
        if fprintd-enroll -f "$finger"; then
            echo "✓ Successfully enrolled $finger"
            read -p "Enroll another finger? (y/N) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && break
        else
            echo "✗ Failed to enroll $finger"
            read -p "Try again? (y/N) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && break
        fi
    fi
done

# List enrolled fingerprints
echo ""
echo "Currently enrolled fingerprints:"
fprintd-list "$USER" 2>/dev/null || echo "No fingerprints enrolled yet"

# Configure PAM
echo ""
echo "=== PAM Configuration ==="
PAM_FILE="/etc/pam.d/system-auth"

if [[ ! -f "$PAM_FILE" ]]; then
    echo "✗ $PAM_FILE not found. You may need to configure PAM manually."
    exit 1
fi

if grep -q "pam_fprintd.so" "$PAM_FILE"; then
    echo "✓ PAM already configured for fingerprint authentication"
else
    echo "Configuring PAM for fingerprint authentication..."
    echo "This requires sudo access to edit $PAM_FILE"

    # Create a temporary file with the new configuration
    TMP_FILE=$(mktemp)
    awk '
        /^auth.*pam_faillock.so.*preauth/ {
            print
            getline
            print
            getline
            print
            print "auth       sufficient                  pam_fprintd.so"
            next
        }
        { print }
    ' "$PAM_FILE" > "$TMP_FILE"

    # Show the diff
    echo ""
    echo "Changes to be made:"
    diff -u "$PAM_FILE" "$TMP_FILE" || true
    echo ""

    read -p "Apply these changes? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo cp "$TMP_FILE" "$PAM_FILE"
        echo "✓ PAM configuration updated"
    else
        echo "Skipped PAM configuration. You can add this line manually after 'pam_faillock.so preauth':"
        echo "  auth       sufficient                  pam_fprintd.so"
    fi

    rm "$TMP_FILE"
fi

# Configure Hyprland autostart
echo ""
echo "=== Hyprland Configuration ==="
HYPR_AUTOSTART="$HOME/.config/hypr/autostart.conf"

if [[ -f "$HYPR_AUTOSTART" ]]; then
    if grep -q "polkit-gnome-authentication-agent" "$HYPR_AUTOSTART"; then
        echo "✓ Polkit agent already in Hyprland autostart"
    else
        read -p "Add polkit agent to Hyprland autostart? (Y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo "" >> "$HYPR_AUTOSTART"
            echo "# Polkit authentication agent" >> "$HYPR_AUTOSTART"
            echo "exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" >> "$HYPR_AUTOSTART"
            echo "✓ Added polkit agent to Hyprland autostart"
        fi
    fi
else
    echo "⚠ Hyprland autostart config not found at $HYPR_AUTOSTART"
    echo "  To start the polkit agent automatically, add this to your Hyprland config:"
    echo "  exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
fi

# Test fingerprint authentication
echo ""
echo "=== Testing ==="
echo "You can now test fingerprint authentication with:"
echo "  sudo ls"
echo ""
echo "Fingerprint authentication will work for:"
echo "  ✓ sudo commands"
echo "  ✓ Screen unlock (hyprlock)"
echo "  ✓ Login (ly, GDM, SDDM, etc.)"
echo "  ✓ Other PAM-aware applications"
echo ""
echo "Useful commands:"
echo "  fprintd-list $USER              - List enrolled fingerprints"
echo "  fprintd-enroll -f <finger>      - Enroll another fingerprint"
echo "  fprintd-delete $USER <finger>   - Delete a specific fingerprint"
echo "  fprintd-delete $USER            - Delete all fingerprints"
echo ""
echo "✓ Fingerprint authentication setup complete!"
