#!/bin/sh
# uDOS Installation with UTM Shared Folder Integration
# Solves copy-paste problems on Mac UTM

set -e

VERSION="1.0.5"

# ASCII Art Banner
show_banner() {
    cat << 'BANNER_EOF'

    ██╗   ██╗██████╗  ██████╗ ███████╗
    ██║   ██║██╔══██╗██╔═══██╗██╔════╝
    ██║   ██║██║  ██║██║   ██║███████╗
    ██║   ██║██║  ██║██║   ██║╚════██║
    ╚██████╔╝██████╔╝╚██████╔╝███████║
     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝

    Universal Device Operating System
    UTM Integration Installer v1.0.5

BANNER_EOF
}

# Install uDOS core system
install_udos_core() {
    echo "Installing uDOS core system..."
    
    # Check if we have the standalone installer
    if [ -f "./install-udos.sh" ]; then
        echo "  Using local installer..."
        ./install-udos.sh
    else
        echo "  Downloading installer..."
        # Try different methods based on available tools
        if command -v curl >/dev/null 2>&1; then
            curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install-udos.sh | sh
        elif command -v wget >/dev/null 2>&1; then
            wget -qO- https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install-udos.sh | sh
        else
            echo "  Error: No download tool available (curl/wget)"
            echo "  Please install uDOS manually or setup shared folder first"
            return 1
        fi
    fi
    
    echo "  ✓ uDOS core installation completed"
}

# Setup UTM shared folder integration
setup_utm_integration() {
    echo "Setting up UTM shared folder integration..."
    
    # Check if we have the setup script locally
    if [ -f "./setup-utm-share.sh" ]; then
        echo "  Using local UTM setup script..."
        ./setup-utm-share.sh
    else
        echo "  Creating UTM setup script..."
        
        # Create the setup script inline
        cat > /tmp/setup-utm-share.sh << 'UTM_SETUP_EOF'
#!/bin/sh
echo "Installing 9P support for UTM shared folders..."

# Install 9P modules if available
if command -v tce-load >/dev/null 2>&1; then
    tce-load -wi 9p.tcz 2>/dev/null || echo "9p.tcz not available, trying manual load"
fi

# Load kernel modules
sudo modprobe 9p 2>/dev/null || true
sudo modprobe 9pnet 2>/dev/null || true
sudo modprobe 9pnet_virtio 2>/dev/null || true

# Create mount point
sudo mkdir -p /mnt/shared

# Create mount script
sudo tee /usr/local/bin/mount-utm-share > /dev/null << 'MOUNT_EOF'
#!/bin/sh
MOUNT_POINT="/mnt/shared"
for tag in uDESK udeskshare share shared hostshare; do
    echo "Trying UTM share tag: $tag"
    if sudo mount -t 9p -o trans=virtio,version=9p2000.L "$tag" "$MOUNT_POINT" 2>/dev/null; then
        echo "✓ UTM shared folder mounted at $MOUNT_POINT"
        echo "Share tag: $tag"
        ls -la "$MOUNT_POINT"
        return 0
    fi
done
echo "Failed to mount UTM shared folder"
echo "Check UTM VM Settings → Sharing"
return 1
MOUNT_EOF

sudo chmod +x /usr/local/bin/mount-utm-share

# Create helper commands
sudo tee /usr/local/bin/copy-from-mac > /dev/null << 'COPY_FROM_EOF'
#!/bin/sh
if [ ! -d /mnt/shared ]; then
    echo "Run: mount-utm-share"
    exit 1
fi
echo "Files in Mac shared folder:"
ls -la /mnt/shared
COPY_FROM_EOF

sudo chmod +x /usr/local/bin/copy-from-mac

# Add to boot
if [ -f /opt/bootlocal.sh ]; then
    grep -q "mount-utm-share" /opt/bootlocal.sh || echo "/usr/local/bin/mount-utm-share" | sudo tee -a /opt/bootlocal.sh
else
    echo "/usr/local/bin/mount-utm-share" | sudo tee /opt/bootlocal.sh
fi

echo "✓ UTM shared folder setup complete"
echo ""
echo "Commands:"
echo "  mount-utm-share    # Mount shared folder"
echo "  copy-from-mac      # List shared files"
echo "  ls /mnt/shared     # Browse shared files"
UTM_SETUP_EOF

        chmod +x /tmp/setup-utm-share.sh
        /tmp/setup-utm-share.sh
    fi
    
    echo "  ✓ UTM integration setup completed"
}

# Test the installation
test_installation() {
    echo "Testing installation and integration..."
    
    # Test uDOS
    if command -v udos >/dev/null 2>&1; then
        echo "  ✓ uDOS installed: $(udos version)"
    else
        echo "  ⚠ uDOS installation may have issues"
    fi
    
    # Test UTM mount
    if /usr/local/bin/mount-utm-share 2>/dev/null; then
        echo "  ✓ UTM shared folder working"
        SHARED_WORKING=true
    else
        echo "  ⚠ UTM shared folder needs configuration"
        SHARED_WORKING=false
    fi
    
    return 0
}

# Show final instructions
show_final_instructions() {
    echo ""
    echo "🎉 Installation Complete!"
    echo "========================"
    echo ""
    echo "uDOS Universal Device Operating System v$VERSION is now installed"
    echo "with UTM shared folder integration."
    echo ""
    
    echo "✅ Available Commands:"
    echo "  udos help              # uDOS command reference"
    echo "  udos info              # System information"
    echo "  udos version           # Version information"
    echo "  mount-utm-share        # Mount Mac shared folder"
    echo "  copy-from-mac          # List Mac shared files"
    echo ""
    
    if [ "$SHARED_WORKING" = "true" ]; then
        echo "✅ UTM Shared Folder: Working!"
        echo "  Location: /mnt/shared"
        echo "  Your copy-paste problem is solved! 🎉"
    else
        echo "⚠️  UTM Shared Folder: Needs Configuration"
        echo ""
        echo "To complete setup:"
        echo "1. UTM VM Settings → Sharing"
        echo "2. Add Directory → Select your uDESK folder"
        echo "3. Share name: 'udeskshare'"
        echo "4. Save and restart VM"
        echo "5. Run: mount-utm-share"
    fi
    
    echo ""
    echo "🚀 Quick Start:"
    echo "  udos help"
    echo "  ls /mnt/shared"
    echo "  copy-from-mac"
    echo ""
    echo "Copy files between Mac and TinyCore:"
    echo "  cp /mnt/shared/file.txt /tmp/    # Mac → TinyCore"
    echo "  cp /tmp/file.txt /mnt/shared/    # TinyCore → Mac"
}

# Main execution
main() {
    show_banner
    
    echo "This installer will:"
    echo "1. Install uDOS Universal Device Operating System"
    echo "2. Setup UTM shared folder integration"
    echo "3. Solve your copy-paste problem!"
    echo ""
    
    install_udos_core
    echo ""
    
    setup_utm_integration
    echo ""
    
    test_installation
    echo ""
    
    show_final_instructions
}

main "$@"
