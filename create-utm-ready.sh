#!/bin/bash
# Create UTM-ready uDESK setup

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTM_DIR="$PROJECT_ROOT/utm-ready"

echo "=== Creating UTM-Ready uDESK ==="

# Create UTM directory structure
rm -rf "$UTM_DIR"
mkdir -p "$UTM_DIR"

# Download TinyCore if not present
TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
if [ ! -f "$TINYCORE_ISO" ]; then
    echo "Downloading TinyCore Linux..."
    curl -L -o "$TINYCORE_ISO" "http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
fi

# Copy TinyCore as base
cp "$TINYCORE_ISO" "$UTM_DIR/udesk-base.iso"

# Create uDESK extensions directory
mkdir -p "$UTM_DIR/udesk-extensions"

# Copy built packages
if [ -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
    cp "$PROJECT_ROOT/build"/*.tcz "$UTM_DIR/udesk-extensions/"
    echo "✓ Copied uDESK packages"
else
    echo "✗ Build packages first with: ./build.sh"
    exit 1
fi

# Create installation script
cat > "$UTM_DIR/install-udesk.sh" << 'EOF'
#!/bin/bash
# uDESK Installation Script (run inside TinyCore VM)

echo "=== Installing uDESK ==="

# Mount extensions if from external media
if [ -f "/mnt/sdb1/udesk-extensions/udos-core.tcz" ]; then
    EXT_DIR="/mnt/sdb1/udesk-extensions"
elif [ -f "/tmp/udesk-extensions/udos-core.tcz" ]; then
    EXT_DIR="/tmp/udesk-extensions"
else
    echo "✗ uDESK extensions not found"
    echo "Copy udesk-extensions directory to VM"
    exit 1
fi

# Install uDESK core
echo "Installing uDESK core..."
sudo cp "$EXT_DIR"/*.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" >> /mnt/sda1/tce/onboot.lst
echo "udos-role-admin.tcz" >> /mnt/sda1/tce/onboot.lst

# Load immediately
tce-load -i "$EXT_DIR/udos-core.tcz"
tce-load -i "$EXT_DIR/udos-role-admin.tcz"

echo "✓ uDESK installed successfully!"
echo ""
echo "Test with: udos-info"
echo "Reboot to load on startup: sudo reboot"
EOF

chmod +x "$UTM_DIR/install-udesk.sh"

# Create UTM setup instructions
cat > "$UTM_DIR/UTM-SETUP.md" << 'EOF'
# uDESK UTM Setup Instructions

## Step 1: Create UTM Virtual Machine
1. Open UTM
2. Create new VM → "Virtualize" → "Linux"
3. Use `udesk-base.iso` as installation media
4. Set RAM: 2GB, Storage: 8GB
5. Start VM

## Step 2: Install uDESK
1. Boot TinyCore Linux from the ISO
2. Copy `udesk-extensions` folder to VM (drag & drop or shared folder)
3. In TinyCore terminal, run:
   ```bash
   cd /path/to/udesk-extensions
   chmod +x ../install-udesk.sh
   ../install-udesk.sh
   ```

## Step 3: Test uDESK
```bash
# Check uDESK status
udos-info

# View system configuration  
udos-detect-role

# Test markdown tools (after installing)
echo "# Hello uDESK!" > test.md
micro test.md  # or nano test.md
```

## Step 4: Persistence (Optional)
To save changes between reboots:
```bash
# Create backup
filetool.sh -b

# Or enable automatic persistence
echo "opt/udos" >> /opt/.filetool.lst
```

## Troubleshooting
- If extensions don't load: Check `/mnt/sda1/tce/onboot.lst`
- If no persistence: Run `tce-setdrive` and select storage
- For networking: Run `sudo dhcp.sh`

Your markdown-focused OS is ready! 🚀
EOF

# Create package list
echo "uDESK Extensions:" > "$UTM_DIR/EXTENSIONS.txt"
ls -la "$UTM_DIR/udesk-extensions/" >> "$UTM_DIR/EXTENSIONS.txt"

echo ""
echo "✓ UTM-ready uDESK created at: $UTM_DIR"
echo ""
echo "Next steps:"
echo "1. Open UTM and create new Linux VM"
echo "2. Use $UTM_DIR/udesk-base.iso as boot media"
echo "3. Follow instructions in $UTM_DIR/UTM-SETUP.md"
echo ""
echo "Total size: $(du -sh "$UTM_DIR" | cut -f1)"