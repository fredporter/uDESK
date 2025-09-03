#!/bin/sh
# Quick UTM Setup for uDOS
# Copy this entire script and paste into TinyCore VM

echo "Quick UTM + uDOS Setup"
echo "====================="

# Enable networking
echo "Enabling networking..."
sudo dhcp.sh

# Create simple UTM mount
echo "Setting up UTM shared folder..."
sudo mkdir -p /mnt/shared

# Try to mount common UTM share names (uDESK first)
for tag in uDESK udeskshare share shared; do
    echo "Trying: $tag"
    if sudo mount -t 9p -o trans=virtio,version=9p2000.L "$tag" /mnt/shared 2>/dev/null; then
        echo "✓ Mounted UTM share: $tag"
        echo "Contents:"
        ls -la /mnt/shared
        break
    fi
done

# If we have a mounted share, try to install from it
if mountpoint -q /mnt/shared 2>/dev/null; then
    echo ""
    echo "✓ Shared folder working! Checking for installation files..."
    
    if [ -f /mnt/shared/udos-offline-bundle.tar.gz ]; then
        echo "Found offline bundle, installing..."
        cd /tmp
        cp /mnt/shared/udos-offline-bundle.tar.gz .
        tar xzf udos-offline-bundle.tar.gz
        cd udos-offline
        ./udos-offline-install.sh
    elif [ -f /mnt/shared/install-udos-with-utm.sh ]; then
        echo "Found UTM installer, running..."
        cp /mnt/shared/install-udos-with-utm.sh /tmp/
        chmod +x /tmp/install-udos-with-utm.sh
        /tmp/install-udos-with-utm.sh
    else
        echo "No installation files found in shared folder"
        echo "Available files:"
        ls -la /mnt/shared
    fi
else
    echo "No shared folder mounted"
    echo ""
    echo "Configure UTM:"
    echo "1. VM Settings → Sharing"
    echo "2. Add Directory → Select uDESK folder"
    echo "3. Share name will be 'uDESK' (folder name)"
    echo "4. Restart VM and run this script again"
fi

echo ""
echo "Setup complete!"
