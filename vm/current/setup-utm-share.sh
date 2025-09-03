#!/bin/sh
# UTM 9P Shared Folder Setup for uDOS
# Native UTM directory sharing solution

set -e

echo "UTM 9P Shared Folder Setup v1.0.5"
echo "=================================="
echo ""

# Install 9P filesystem support
install_9p_support() {
    echo "Installing 9P filesystem support..."
    
    # Load 9P kernel modules
    if command -v tce-load >/dev/null 2>&1; then
        echo "  Loading 9P modules via TCE..."
        tce-load -wi 9p.tcz 2>/dev/null || echo "  Warning: 9p.tcz not found, trying manual load"
    fi
    
    # Try to load modules manually
    echo "  Loading 9P kernel modules..."
    sudo modprobe 9p 2>/dev/null || echo "  Warning: 9p module load failed"
    sudo modprobe 9pnet 2>/dev/null || echo "  Warning: 9pnet module load failed"
    sudo modprobe 9pnet_virtio 2>/dev/null || echo "  Warning: 9pnet_virtio module load failed"
    
    echo "  ✓ 9P support installation attempted"
}

# Create mount point and scripts
setup_mount_system() {
    echo "Setting up mount system..."
    
    # Create mount point
    MOUNT_POINT="/mnt/shared"
    sudo mkdir -p "$MOUNT_POINT"
    echo "  Created mount point: $MOUNT_POINT"
    
    # Create mount script
    echo "  Creating mount script..."
    sudo tee /usr/local/bin/mount-utm-share > /dev/null << 'MOUNT_SCRIPT_EOF'
#!/bin/sh
# Mount UTM shared folder via 9P/VirtFS

MOUNT_POINT="/mnt/shared"
SUCCESS=0

echo "Attempting to mount UTM shared folder..."

# Common UTM share tags to try (uDESK first as likely folder name)
SHARE_TAGS="uDESK udeskshare share shared hostshare utm_share vm_share"

for tag in $SHARE_TAGS; do
    echo "  Trying share tag: $tag"
    
    if sudo mount -t 9p -o trans=virtio,version=9p2000.L,cache=loose "$tag" "$MOUNT_POINT" 2>/dev/null; then
        echo "  ✓ Successfully mounted UTM shared folder!"
        echo "  Share tag: $tag"
        echo "  Mount point: $MOUNT_POINT"
        echo ""
        echo "Contents:"
        ls -la "$MOUNT_POINT" | head -10
        SUCCESS=1
        break
    fi
done

if [ $SUCCESS -eq 0 ]; then
    echo "  ✗ Failed to mount any shared folder"
    echo ""
    echo "Troubleshooting:"
    echo "1. Check UTM VM Settings → Sharing → Directory Sharing"
    echo "2. Ensure a folder is shared (e.g., uDESK directory)"
    echo "3. Note the share name/tag"
    echo "4. Restart VM after changing settings"
    echo ""
    echo "Available 9P shares:"
    cat /proc/mounts | grep 9p || echo "  No 9P mounts found"
    
    return 1
else
    echo ""
    echo "Success! You can now:"
    echo "  - Copy files to/from: $MOUNT_POINT"
    echo "  - Access Mac files from TinyCore"
    echo "  - Transfer uDOS installation files"
    echo ""
    return 0
fi
MOUNT_SCRIPT_EOF

    sudo chmod +x /usr/local/bin/mount-utm-share
    echo "  ✓ Mount script created: /usr/local/bin/mount-utm-share"
}

# Create unmount script
create_unmount_script() {
    echo "Creating unmount script..."
    
    sudo tee /usr/local/bin/unmount-utm-share > /dev/null << 'UNMOUNT_SCRIPT_EOF'
#!/bin/sh
# Unmount UTM shared folder

MOUNT_POINT="/mnt/shared"

echo "Unmounting UTM shared folder..."

if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
    sudo umount "$MOUNT_POINT"
    echo "✓ Shared folder unmounted from $MOUNT_POINT"
else
    echo "No shared folder mounted at $MOUNT_POINT"
fi
UNMOUNT_SCRIPT_EOF

    sudo chmod +x /usr/local/bin/unmount-utm-share
    echo "  ✓ Unmount script created: /usr/local/bin/unmount-utm-share"
}

# Setup auto-mount on boot
setup_auto_mount() {
    echo "Setting up auto-mount on boot..."
    
    # Add to bootlocal.sh
    BOOTLOCAL="/opt/bootlocal.sh"
    
    if [ -f "$BOOTLOCAL" ]; then
        if ! grep -q "mount-utm-share" "$BOOTLOCAL"; then
            echo "" | sudo tee -a "$BOOTLOCAL"
            echo "# UTM Shared Folder Auto-Mount" | sudo tee -a "$BOOTLOCAL"
            echo "/usr/local/bin/mount-utm-share" | sudo tee -a "$BOOTLOCAL"
            echo "  ✓ Added auto-mount to bootlocal.sh"
        else
            echo "  Auto-mount already configured"
        fi
    else
        echo "# UTM Shared Folder Auto-Mount" | sudo tee "$BOOTLOCAL"
        echo "/usr/local/bin/mount-utm-share" | sudo tee -a "$BOOTLOCAL"
        sudo chmod +x "$BOOTLOCAL"
        echo "  ✓ Created bootlocal.sh with auto-mount"
    fi
    
    # Add to filetool.lst for persistence
    FILETOOL="/opt/.filetool.lst"
    if [ -f "$FILETOOL" ]; then
        if ! grep -q "opt/bootlocal.sh" "$FILETOOL"; then
            echo "opt/bootlocal.sh" | sudo tee -a "$FILETOOL"
        fi
        if ! grep -q "usr/local/bin/mount-utm-share" "$FILETOOL"; then
            echo "usr/local/bin/mount-utm-share" | sudo tee -a "$FILETOOL"
            echo "usr/local/bin/unmount-utm-share" | sudo tee -a "$FILETOOL"
        fi
    else
        echo "opt/bootlocal.sh" | sudo tee "$FILETOOL"
        echo "usr/local/bin/mount-utm-share" | sudo tee -a "$FILETOOL"
        echo "usr/local/bin/unmount-utm-share" | sudo tee -a "$FILETOOL"
    fi
    
    echo "  ✓ Auto-mount persistence configured"
}

# Create helper scripts for file transfer
create_transfer_helpers() {
    echo "Creating file transfer helpers..."
    
    # Copy from Mac to TinyCore
    sudo tee /usr/local/bin/copy-from-mac > /dev/null << 'COPY_FROM_EOF'
#!/bin/sh
# Copy files from Mac shared folder to TinyCore

SHARED="/mnt/shared"
DEST="${1:-/tmp}"

if [ ! -d "$SHARED" ]; then
    echo "Error: Shared folder not mounted at $SHARED"
    echo "Run: mount-utm-share"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Usage: copy-from-mac [destination]"
    echo ""
    echo "Available files in shared folder:"
    ls -la "$SHARED"
    exit 0
fi

echo "Copying from Mac shared folder to $DEST..."
cp -r "$SHARED"/* "$DEST"/
echo "✓ Files copied successfully"
COPY_FROM_EOF

    # Copy from TinyCore to Mac
    sudo tee /usr/local/bin/copy-to-mac > /dev/null << 'COPY_TO_EOF'
#!/bin/sh
# Copy files from TinyCore to Mac shared folder

SHARED="/mnt/shared"
SOURCE="${1:-}"

if [ ! -d "$SHARED" ]; then
    echo "Error: Shared folder not mounted at $SHARED"
    echo "Run: mount-utm-share"
    exit 1
fi

if [ -z "$SOURCE" ]; then
    echo "Usage: copy-to-mac <file_or_directory>"
    echo ""
    echo "This will copy files to Mac shared folder"
    exit 1
fi

if [ ! -e "$SOURCE" ]; then
    echo "Error: Source '$SOURCE' does not exist"
    exit 1
fi

echo "Copying $SOURCE to Mac shared folder..."
cp -r "$SOURCE" "$SHARED"/
echo "✓ Files copied to Mac successfully"
echo "Check your Mac's shared folder for the files"
COPY_TO_EOF

    sudo chmod +x /usr/local/bin/copy-from-mac
    sudo chmod +x /usr/local/bin/copy-to-mac
    
    echo "  ✓ Transfer helpers created:"
    echo "    - copy-from-mac [destination]"
    echo "    - copy-to-mac <file_or_directory>"
}

# Test the setup
test_setup() {
    echo "Testing UTM shared folder setup..."
    
    # Try to mount
    if /usr/local/bin/mount-utm-share; then
        echo "  ✓ Mount test successful"
        
        # Test write access
        TEST_FILE="/mnt/shared/utm-test-$(date +%s).txt"
        if echo "UTM shared folder test - $(date)" > "$TEST_FILE" 2>/dev/null; then
            echo "  ✓ Write test successful"
            rm -f "$TEST_FILE" 2>/dev/null
        else
            echo "  ⚠ Write test failed (may be read-only)"
        fi
        
        return 0
    else
        echo "  ✗ Mount test failed"
        return 1
    fi
}

# Create usage documentation
create_documentation() {
    echo "Creating usage documentation..."
    
    tee /tmp/utm-share-usage.md > /dev/null << 'USAGE_EOF'
# UTM Shared Folder Usage Guide

## Setup Complete!

Your TinyCore VM now has UTM shared folder support configured.

## Commands

### Mount/Unmount
```bash
mount-utm-share          # Mount shared folder
unmount-utm-share        # Unmount shared folder
```

### File Transfer
```bash
copy-from-mac [dest]     # Copy from Mac to TinyCore
copy-to-mac <source>     # Copy from TinyCore to Mac
```

### Manual Access
```bash
ls /mnt/shared           # List shared files
cd /mnt/shared           # Navigate to shared folder
```

## UTM Configuration

1. **UTM VM Settings** → **Sharing**
2. **Add Directory** → Select folder to share
3. **Share name**: Use "udeskshare" or "share"
4. **Save and restart VM**

## Usage Examples

```bash
# Install uDOS from shared folder
copy-from-mac /tmp
cd /tmp && tar xzf udos-offline-bundle.tar.gz
cd udos-offline && ./udos-offline-install.sh

# Copy logs to Mac
copy-to-mac /var/log/messages

# Access files directly
nano /mnt/shared/config.txt
```

## Troubleshooting

```bash
# Check mount status
mountpoint /mnt/shared

# Check available shares
cat /proc/mounts | grep 9p

# Re-mount manually
unmount-utm-share && mount-utm-share

# Check UTM VM settings for shared directories
```

## Auto-Mount

The shared folder will automatically mount on boot.
No manual intervention required after setup.
USAGE_EOF

    echo "  ✓ Usage guide created: /tmp/utm-share-usage.md"
}

# Main execution
main() {
    install_9p_support
    setup_mount_system
    create_unmount_script
    setup_auto_mount
    create_transfer_helpers
    create_documentation
    
    echo ""
    echo "UTM 9P Shared Folder Setup Complete!"
    echo "===================================="
    echo ""
    
    # Test the setup
    if test_setup; then
        echo "🎉 SUCCESS: UTM shared folder is working!"
        echo ""
        echo "Your copy-paste problem is solved! You can now:"
        echo "  1. Copy files between Mac and TinyCore"
        echo "  2. Transfer uDOS installation files"
        echo "  3. Share configurations and logs"
        echo ""
        echo "Quick commands:"
        echo "  mount-utm-share    # Mount shared folder"
        echo "  copy-from-mac      # Copy from Mac"
        echo "  copy-to-mac <file> # Copy to Mac"
        echo ""
        echo "Shared folder location: /mnt/shared"
    else
        echo "⚠️  Setup complete but test failed"
        echo ""
        echo "Next steps:"
        echo "1. Check UTM VM Settings → Sharing"
        echo "2. Add a directory to share"
        echo "3. Set share name to 'udeskshare' or 'share'"
        echo "4. Restart VM"
        echo "5. Run: mount-utm-share"
    fi
    
    echo ""
    echo "View usage guide: cat /tmp/utm-share-usage.md"
}

main "$@"
