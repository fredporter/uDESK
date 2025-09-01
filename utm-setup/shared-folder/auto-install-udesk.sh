#!/bin/bash
# Auto-install uDESK inside TinyCore VM
# Run this script inside the TinyCore VM

set -e

echo "🚀 Installing uDESK in TinyCore..."
echo "================================="

# Find uDESK packages
PKG_DIR="/mnt/sdb1"  # Common USB/shared mount point
if [ ! -d "$PKG_DIR" ] || [ ! -f "$PKG_DIR/udos-core.tcz" ]; then
    # Try other common locations
    for dir in /tmp/tce /mnt/sr0 /tmp /home/tc; do
        if [ -f "$dir/udos-core.tcz" ]; then
            PKG_DIR="$dir"
            break
        fi
    done
fi

if [ ! -f "$PKG_DIR/udos-core.tcz" ]; then
    echo "❌ uDESK packages not found!"
    echo "Please ensure the shared folder with .tcz files is mounted"
    echo "Try: ls /mnt/sdb1/ or drag the files to /tmp/"
    exit 1
fi

echo "📦 Found uDESK packages in: $PKG_DIR"

# Set up TCE directory for persistence
if [ ! -d "/mnt/sda1/tce" ]; then
    echo "Setting up TCE persistence..."
    sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}
    sudo chmod 775 /mnt/sda1/tce
fi

# Install packages
echo "Installing uDESK core..."
tce-load -i "$PKG_DIR/udos-core.tcz"

echo "Installing uDESK admin role..."
tce-load -i "$PKG_DIR/udos-role-admin.tcz"

echo "Testing uDESK installation..."
if command -v udos-info >/dev/null 2>&1; then
    echo "✅ uDESK installed successfully!"
    echo ""
    udos-info
    echo ""
else
    echo "❌ uDESK installation failed"
    exit 1
fi

# Make persistent across reboots
echo "Making uDESK persistent..."
sudo cp "$PKG_DIR"/*.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst
echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst

# Create welcome script
cat > /home/tc/udesk-welcome.sh << 'WELCOME_EOF'
#!/bin/bash
clear
echo "🎉 Welcome to uDESK!"
echo "==================="
echo ""
echo "Your markdown-focused OS is ready!"
echo ""
echo "Quick commands:"
echo "  udos-info          - System information"
echo "  udos-detect-role   - Current role"
echo "  udos-service list  - Available services"
echo ""
echo "To install markdown tools:"
echo "  tce-load -wi micro.tcz     - Micro editor"
echo "  tce-load -wi git.tcz       - Git version control"
echo ""
echo "Create your first markdown file:"
echo "  echo '# Hello uDESK!' > welcome.md"
echo "  cat welcome.md"
echo ""
WELCOME_EOF

chmod +x /home/tc/udesk-welcome.sh

# Add to .profile for auto-run
echo "/home/tc/udesk-welcome.sh" >> /home/tc/.profile

echo ""
echo "🎉 uDESK installation complete!"
echo ""
echo "Next steps:"
echo "1. Reboot to test persistence: sudo reboot"
echo "2. Run: ./udesk-welcome.sh for a tour"
echo "3. Start creating with markdown!"
echo ""
echo "Your markdown-everything OS is ready! ✨"

