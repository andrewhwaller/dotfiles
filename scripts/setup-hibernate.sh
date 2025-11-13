#!/bin/bash
# Setup full hibernation with LUKS encryption
set -e

echo "=== Setting up hibernation on encrypted btrfs ==="
echo ""

# Step 1: Create swap file
echo "Step 1: Creating 8GB swap file..."
sudo mkdir -p /swap
if [ -f /swap/swapfile ]; then
    echo "Swap file already exists, skipping creation"
else
    sudo btrfs filesystem mkswapfile --size 8g --uuid clear /swap/swapfile
    echo "✓ Swap file created"
fi
echo ""

# Step 2: Get resume offset
echo "Step 2: Getting resume offset..."
RESUME_OFFSET=$(sudo btrfs inspect-internal map-swapfile -r /swap/swapfile)
echo "Resume offset: $RESUME_OFFSET"
echo ""

# Step 3: Enable swap file
echo "Step 3: Enabling swap file..."
if swapon --show | grep -q "/swap/swapfile"; then
    echo "Swap file already enabled"
else
    sudo swapon /swap/swapfile
    echo "✓ Swap file enabled"
fi
echo ""

# Step 4: Add to fstab
echo "Step 4: Adding to /etc/fstab..."
if ! grep -q "/swap/swapfile" /etc/fstab; then
    echo "/swap/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
    echo "✓ Added to fstab"
else
    echo "Already in fstab"
fi
echo ""

# Step 5: Update mkinitcpio.conf
echo "Step 5: Updating /etc/mkinitcpio.conf..."
if ! grep -q "^HOOKS=.*resume" /etc/mkinitcpio.conf; then
    echo "Adding 'resume' hook after 'filesystems'..."
    sudo sed -i 's/\(HOOKS=.*filesystems\)/\1 resume/' /etc/mkinitcpio.conf
    echo "✓ Added resume hook"
else
    echo "'resume' hook already present"
fi
echo ""

# Step 6: Update Limine bootloader config automatically
echo "Step 6: Updating bootloader config..."
echo ""

if grep -q "resume=/dev/mapper/root" /boot/limine/limine.conf; then
    echo "Resume parameters already present in bootloader config"
    # Update offset if different
    CURRENT_OFFSET=$(grep -oP 'resume_offset=\K[0-9]+' /boot/limine/limine.conf | head -1)
    if [ "$CURRENT_OFFSET" != "$RESUME_OFFSET" ]; then
        echo "Updating resume_offset from $CURRENT_OFFSET to $RESUME_OFFSET..."
        sudo sed -i "s/resume_offset=[0-9]*/resume_offset=$RESUME_OFFSET/g" /boot/limine/limine.conf
        echo "✓ Updated resume offset"
    fi
else
    echo "Adding: resume=/dev/mapper/root resume_offset=$RESUME_OFFSET"

    # Backup original config
    sudo cp /boot/limine/limine.conf /boot/limine/limine.conf.bak
    echo "✓ Backed up to limine.conf.bak"

    # Add resume parameters to all cmdline entries
    sudo sed -i "/^[[:space:]]*cmdline:/ s/$/ resume=\/dev\/mapper\/root resume_offset=$RESUME_OFFSET/" /boot/limine/limine.conf

    echo "✓ Updated bootloader config"
    echo ""
    echo "Changes made:"
    diff /boot/limine/limine.conf.bak /boot/limine/limine.conf || true
fi
echo ""

# Step 7: Regenerate initramfs
echo "Step 7: Regenerating initramfs..."
sudo mkinitcpio -P
echo "✓ Initramfs regenerated"
echo ""

echo "=== Hibernation setup complete! ==="
echo ""
echo "Next steps:"
echo "1. Reboot to load new kernel parameters"
echo "2. Test with: systemctl hibernate"
echo "3. Press power button to wake"
echo "4. Enter LUKS password at boot"
echo ""
