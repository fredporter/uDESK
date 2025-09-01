#!/bin/bash
echo "🚀 Installing uDESK in TinyCore..."
echo "================================="

# Check if we're in TinyCore
if ! command -v tce-load >/dev/null 2>&1; then
    echo "❌ This script must run inside TinyCore Linux"
    echo "Boot TinyCore first, then run this script"
    exit 1
fi

# Set up persistence directory
echo "📁 Setting up persistence..."
sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}
sudo chmod 775 /mnt/sda1/tce

# Find package directory (could be /tmp, /mnt/sdb1, etc.)
PKG_DIR=""
for dir in "$(pwd)" /tmp /mnt/sdb1 /home/tc; do
    if [ -f "$dir/udos-core.tcz" ]; then
        PKG_DIR="$dir"
        break
    fi
done

if [ -z "$PKG_DIR" ]; then
    echo "❌ uDESK packages not found!"
    echo "Make sure .tcz files are in current directory"
    exit 1
fi

echo "📦 Installing uDESK packages from: $PKG_DIR"

# Install packages
echo "Loading udos-core..."
tce-load -i "$PKG_DIR/udos-core.tcz"

echo "Loading udos-role-admin..."
tce-load -i "$PKG_DIR/udos-role-admin.tcz"

# Test installation
if command -v udos-info >/dev/null 2>&1; then
    echo "✅ uDESK installed successfully!"
    echo ""
    echo "🎉 Welcome to uDESK!"
    echo "==================="
    udos-info
    echo ""
    echo "Current role: $(udos-detect-role)"
    echo ""
else
    echo "❌ Installation failed"
    exit 1
fi

# Make persistent
echo "💾 Making installation persistent..."
sudo cp "$PKG_DIR"/*.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null
echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null

echo "✅ uDESK will now load automatically on boot"
echo ""
echo "🔄 Reboot to test: sudo reboot"
echo "🎯 Or continue using uDESK now!"
