#!/bin/sh
# Enhanced UTM Setup for uDOS - Mac Copy-Paste Friendly
# Copy this entire script and paste into TinyCore VM terminal

echo "🍎 Mac UTM + uDOS Setup"
echo "======================"

# Function to check success
check_success() {
    if [ $? -eq 0 ]; then
        echo "✅ $1"
    else
        echo "❌ $1 failed"
    fi
}

# Step 1: Enable networking
echo "📡 Enabling networking..."
sudo dhcp.sh
check_success "Network setup"

# Step 2: Install essential tools if not present
echo "🔧 Installing essential tools..."
tce-load -wi git bash curl wget 2>/dev/null
check_success "Tools installation"

# Step 3: Setup UTM shared folder
echo "📁 Setting up UTM shared folder..."
sudo mkdir -p /mnt/shared

# Try multiple UTM share tags
for tag in uDESK udeskshare share shared mac-share; do
    echo "Trying mount tag: $tag"
    if sudo mount -t 9p -o trans=virtio,version=9p2000.L "$tag" /mnt/shared 2>/dev/null; then
        echo "✅ Mounted UTM share: $tag"
        echo "📋 Share contents:"
        ls -la /mnt/shared
        
        # Create convenience commands
        echo "alias share='cd /mnt/shared && ls -la'" >> ~/.profile
        echo "alias copy-from-mac='ls -la /mnt/shared'" >> ~/.profile
        
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
