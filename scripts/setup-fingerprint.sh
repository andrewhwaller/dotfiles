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
    read -p "[Scanner] No fingerprint device detected. Continue with setup anyway? (Y/n) " -n 1 -r
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
            read -p "[Enroll] Enroll another finger? (Y/n) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && break
        else
            echo "✗ Failed to enroll $finger"
            read -p "[Enroll] Retry enrolling this finger? (Y/n) " -n 1 -r
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
    echo "✓ PAM system-auth already configured for fingerprint authentication"
else
    echo "Configuring PAM system-auth for fingerprint authentication..."
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
            print "auth       optional                    pam_fprintd.so"
            next
        }
        { print }
    ' "$PAM_FILE" > "$TMP_FILE"

    # Show the diff
    echo ""
    echo "Changes to be made to system-auth:"
    diff -u "$PAM_FILE" "$TMP_FILE" || true
    echo ""

    read -p "[PAM] Apply these PAM changes via sudo cp? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo cp "$TMP_FILE" "$PAM_FILE"
        echo "✓ PAM system-auth configuration updated"
    else
        echo "Skipped PAM configuration. You can add this line manually after 'pam_faillock.so preauth':"
        echo "  auth       optional                    pam_fprintd.so"
    fi

    rm "$TMP_FILE"
fi

# Configure hyprlock-specific PAM for password-first, fingerprint-fallback
echo ""
HYPRLOCK_PAM="/etc/pam.d/hyprlock"

if [[ -f "$HYPRLOCK_PAM" ]] && grep -q "pam_fprintd.so" "$HYPRLOCK_PAM"; then
    echo "✓ Hyprlock PAM already configured for fingerprint authentication"
else
    echo "Configuring hyprlock PAM for password-first, fingerprint-fallback..."

    TMP_FILE=$(mktemp)
    cat > "$TMP_FILE" << 'EOF'
#%PAM-1.0
# PAM configuration file for hyprlock
# Try password first, then fingerprint

auth       required                    pam_faillock.so      preauth
-auth      [success=3 default=ignore]  pam_systemd_home.so
auth       sufficient                  pam_unix.so          nullok
auth       sufficient                  pam_fprintd.so
auth       [default=die]               pam_faillock.so      authfail
auth       optional                    pam_permit.so
auth       required                    pam_env.so
auth       required                    pam_faillock.so      authsucc

-account   [success=1 default=ignore]  pam_systemd_home.so
account    required                    pam_unix.so
account    optional                    pam_permit.so

-password  [success=1 default=ignore]  pam_systemd_home.so
password   required                    pam_unix.so          try_first_pass nullok shadow
password   optional                    pam_permit.so

-session   optional                    pam_systemd_home.so
session    required                    pam_limits.so
session    required                    pam_unix.so
session    optional                    pam_permit.so
EOF

    if [[ -f "$HYPRLOCK_PAM" ]]; then
        echo ""
        echo "Changes to be made to hyprlock PAM:"
        diff -u "$HYPRLOCK_PAM" "$TMP_FILE" || true
        echo ""
    fi

    read -p "[PAM] Apply hyprlock PAM configuration via sudo cp? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo cp "$TMP_FILE" "$HYPRLOCK_PAM"
        echo "✓ Hyprlock PAM configuration updated"
        echo "  - Password first (type password to unlock immediately)"
        echo "  - Fingerprint fallback (leave blank and scan to unlock)"
    else
        echo "Skipped hyprlock PAM configuration."
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
        read -p "[Hyprland] Add polkit agent to Hyprland autostart config? (Y/n) " -n 1 -r
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
