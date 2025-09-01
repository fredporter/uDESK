#!/bin/bash
# Automated UTM + uDESK Setup Script
# Run this on macOS to prepare everything for UTM

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTM_DIR="$PROJECT_ROOT/utm-setup"
TINYCORE_URL="http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
TINYCORE_ISO="$UTM_DIR/TinyCore-current.iso"

echo "🚀 uDESK UTM Setup Automation"
echo "=============================="

# Create UTM directory
rm -rf "$UTM_DIR"
mkdir -p "$UTM_DIR"/{shared-folder,scripts}

echo "📦 Step 1: Checking uDESK packages..."
if [ ! -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
    echo "Building uDESK packages..."
    cd "$PROJECT_ROOT"
    ./build.sh --clean
fi

# Copy packages to shared folder
cp "$PROJECT_ROOT/build"/*.tcz "$UTM_DIR/shared-folder/"

# Copy Claude Code installer if it exists
if [ -f "$PROJECT_ROOT/utm-setup/shared-folder/install-claude-code.sh" ]; then
    cp "$PROJECT_ROOT/utm-setup/shared-folder/install-claude-code.sh" "$UTM_DIR/shared-folder/"
    chmod +x "$UTM_DIR/shared-folder/install-claude-code.sh"
fi

echo "✓ uDESK packages and tools copied to UTM shared folder"

echo "💿 Step 2: Downloading TinyCore ISO..."
if [ ! -f "$TINYCORE_ISO" ]; then
    echo "Downloading TinyCore Linux (this may take a few minutes)..."
    curl -L -o "$TINYCORE_ISO" "$TINYCORE_URL"
    echo "✓ TinyCore ISO downloaded"
else
    echo "✓ TinyCore ISO already exists"
fi

echo "🔧 Step 3: Creating installation scripts..."

# Create auto-install script for inside TinyCore VM
cat > "$UTM_DIR/shared-folder/auto-install-udesk.sh" << 'INSTALL_EOF'
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
echo "Install Claude Code AI assistant:"
echo "  ./install-claude-code.sh   - Install Claude Code CLI"
echo ""
echo "To install markdown tools:"
echo "  tce-load -wi micro.tcz     - Micro editor"
echo "  tce-load -wi git.tcz       - Git version control"
echo ""
echo "Create your first markdown file:"
echo "  echo '# Hello uDESK!' > welcome.md"
echo "  cat welcome.md"
echo ""
echo "Get AI help with development:"
echo "  claude-code                - Start Claude Code (after install)"
echo ""
WELCOME_EOF

chmod +x /home/tc/udesk-welcome.sh

# Add to .profile for auto-run
echo "/home/tc/udesk-welcome.sh" >> /home/tc/.profile

echo ""
echo "🎉 uDESK installation complete!"
echo ""
echo "Next steps:"
echo "1. Install Claude Code: ./install-claude-code.sh"
echo "2. Reboot to test persistence: sudo reboot"
echo "3. Run: ./udesk-welcome.sh for a tour"
echo "4. Start creating with markdown!"
echo ""
echo "Optional: Enable networking for Claude Code:"
echo "  sudo dhcp.sh"
echo ""
echo "Your markdown-everything OS is ready! ✨"

INSTALL_EOF

chmod +x "$UTM_DIR/shared-folder/auto-install-udesk.sh"

# Create UTM instructions
cat > "$UTM_DIR/UTM-INSTRUCTIONS.md" << 'INSTRUCTIONS_EOF'
# 🚀 uDESK UTM Setup Instructions

## Step 1: Create UTM Virtual Machine

1. **Open UTM** on your Mac
2. **Create New VM** → "Virtualize" → "Linux"
3. **Settings:**
   - **Boot ISO Image:** `TinyCore-current.iso` (in this folder)
   - **RAM:** 2GB (2048 MB)
   - **Storage:** 8GB
   - **Shared Directory:** Select the `shared-folder` directory

## Step 2: Boot and Install

1. **Start the VM** with TinyCore ISO
2. **Wait for TinyCore to boot** (should show desktop)
3. **Mount shared folder:**
   ```bash
   sudo mkdir -p /mnt/sdb1
   sudo mount /dev/sdb1 /mnt/sdb1
   ```
4. **Run auto-installer:**
   ```bash
   cd /mnt/sdb1
   ./auto-install-udesk.sh
   ```

## Step 3: Test uDESK

After installation:
```bash
udos-info              # Check system status
udos-detect-role       # Should show "admin"
./udesk-welcome.sh     # Welcome tour
```

## Step 4: Persistence (Optional)

To save changes between reboots:
```bash
sudo reboot            # Test that uDESK loads automatically
```

## Troubleshooting

**If shared folder not working:**
1. Try dragging .tcz files directly into VM
2. Copy to /tmp/ and run installer from there

**If packages don't load:**
1. Check: `ls /mnt/sda1/tce/onboot.lst`
2. Reload: `tce-load -i /mnt/sda1/tce/optional/udos-core.tcz`

**For networking:**
```bash
sudo dhcp.sh           # Enable internet access
```

## Success! 🎉

Your markdown-focused operating system is now running in UTM!

INSTRUCTIONS_EOF

# Create quick start script
cat > "$UTM_DIR/quick-start.sh" << 'QUICK_EOF'
#!/bin/bash
echo "🚀 uDESK UTM Quick Start"
echo ""
echo "Everything is ready! Follow these steps:"
echo ""
echo "1. Open UTM"
echo "2. Create new Linux VM"
echo "3. Use TinyCore-current.iso as boot media"
echo "4. Set shared-folder as shared directory"
echo "5. Boot VM and run: ./auto-install-udesk.sh"
echo ""
echo "Files prepared:"
ls -la "$UTM_DIR"
echo ""
echo "Read UTM-INSTRUCTIONS.md for detailed steps"
QUICK_EOF

chmod +x "$UTM_DIR/quick-start.sh"

# Create package info
echo "uDESK Packages for UTM:" > "$UTM_DIR/PACKAGES.txt"
echo "=======================" >> "$UTM_DIR/PACKAGES.txt"
ls -la "$UTM_DIR/shared-folder/" >> "$UTM_DIR/PACKAGES.txt"
echo "" >> "$UTM_DIR/PACKAGES.txt"
echo "Total size: $(du -sh "$UTM_DIR" | cut -f1)" >> "$UTM_DIR/PACKAGES.txt"

echo ""
echo "✅ UTM Setup Complete!"
echo "======================"
echo ""
echo "📁 UTM directory: $UTM_DIR"
echo "💿 TinyCore ISO: $(basename "$TINYCORE_ISO")"
echo "📦 uDESK packages: $(ls "$UTM_DIR/shared-folder"/*.tcz | wc -l | tr -d ' ') files"
echo "📏 Total size: $(du -sh "$UTM_DIR" | cut -f1)"
echo ""
echo "🚀 Next steps:"
echo "1. cd $UTM_DIR && ./quick-start.sh"
echo "2. Follow UTM-INSTRUCTIONS.md"
echo "3. Enjoy your markdown-focused OS!"
echo ""

# Open UTM directory in Finder
if command -v open >/dev/null 2>&1; then
    echo "Opening UTM setup directory..."
    open "$UTM_DIR"
fi