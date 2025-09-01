#!/bin/bash
# Automated UTM VM Creation and uDESK Setup Script

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTM_CONFIG_DIR="$HOME/Library/Containers/com.utmapp.UTM/Data/Documents"
VM_NAME="uDESK-Auto"
VM_UUID="$(uuidgen)"

echo "🚀 uDESK UTM Auto-Setup Script"
echo "=============================="

# Find existing TinyCore ISO - check multiple locations
TINYCORE_ISO=""

# Check Code directory first (user specified location)
if [ -f "/Users/fredbook/Code/TinyCore-current.iso" ]; then
    TINYCORE_ISO="/Users/fredbook/Code/TinyCore-current.iso"
# Check project directory
elif [ -f "$PROJECT_ROOT/TinyCore-current.iso" ]; then
    TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
# Check for any ISO in project
else
    for iso in "$PROJECT_ROOT"/*.iso; do
        if [ -f "$iso" ]; then
            TINYCORE_ISO="$iso"
            break
        fi
    done
fi

if [ -z "$TINYCORE_ISO" ]; then
    echo "❌ No TinyCore ISO found!"
    echo "Expected locations:"
    echo "  - /Users/fredbook/Code/TinyCore-current.iso"
    echo "  - $PROJECT_ROOT/TinyCore-current.iso"
    echo ""
    echo "Please ensure TinyCore ISO is in one of these locations."
    exit 1
fi

echo "📀 Found ISO: $(basename "$TINYCORE_ISO")"

# Check if UTM is installed
if [ ! -d "/Applications/UTM.app" ]; then
    echo "❌ UTM not found in Applications"
    echo "Please install UTM from: https://mac.getutm.app/"
    exit 1
fi

# Prepare uDESK packages
echo "📦 Preparing uDESK packages..."
if [ ! -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
    echo "Building uDESK packages..."
    cd "$PROJECT_ROOT"
    ./build.sh --clean
fi

# Create UTM VM directory
VM_DIR="$UTM_CONFIG_DIR/$VM_NAME.utm"
mkdir -p "$VM_DIR"

echo "🔧 Creating UTM VM configuration..."

# Create VM configuration file
cat > "$VM_DIR/config.plist" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Information</key>
    <dict>
        <key>Name</key>
        <string>$VM_NAME</string>
        <key>UUID</key>
        <string>$VM_UUID</string>
        <key>Architecture</key>
        <string>x86_64</string>
        <key>OperatingSystem</key>
        <string>Linux</string>
        <key>Notes</key>
        <string>uDESK - Markdown-focused Linux OS</string>
    </dict>
    <key>System</key>
    <dict>
        <key>Architecture</key>
        <string>x86_64</string>
        <key>Memory</key>
        <integer>1024</integer>
        <key>CPU</key>
        <integer>2</integer>
    </dict>
    <key>QEMU</key>
    <dict>
        <key>Arguments</key>
        <array>
            <string>-machine</string>
            <string>q35</string>
            <string>-accel</string>
            <string>hvf</string>
            <string>-cpu</string>
            <string>host</string>
            <string>-smp</string>
            <string>2</string>
            <string>-m</string>
            <string>1024</string>
            <string>-nographic</string>
            <string>-monitor</string>
            <string>none</string>
            <string>-serial</string>
            <string>stdio</string>
        </array>
    </dict>
    <key>Drives</key>
    <array>
        <dict>
            <key>Identifier</key>
            <string>drive0</string>
            <key>ImageName</key>
            <string>disk.qcow2</string>
            <key>ImageType</key>
            <string>disk</string>
            <key>Interface</key>
            <string>virtio</string>
            <key>Removable</key>
            <false/>
            <key>Size</key>
            <integer>4294967296</integer>
        </dict>
        <dict>
            <key>Identifier</key>
            <string>cdrom0</string>
            <key>ImageName</key>
            <string>$(basename "$TINYCORE_ISO")</string>
            <key>ImageType</key>
            <string>cd</string>
            <key>Interface</key>
            <string>ide</string>
            <key>Removable</key>
            <true/>
        </dict>
    </array>
    <key>Display</key>
    <dict>
        <key>ConsoleMode</key>
        <true/>
        <key>FixedResolution</key>
        <false/>
        <key>Zoom</key>
        <real>1</real>
    </dict>
    <key>Input</key>
    <dict>
        <key>USB</key>
        <true/>
    </dict>
    <key>Networking</key>
    <dict>
        <key>Mode</key>
        <string>emulated</string>
        <key>Card</key>
        <string>virtio-net-pci</string>
    </dict>
</dict>
</plist>
PLIST_EOF

# Copy ISO to VM directory
cp "$TINYCORE_ISO" "$VM_DIR/$(basename "$TINYCORE_ISO")"

# Create virtual disk
echo "💾 Creating virtual disk..."
if command -v qemu-img >/dev/null 2>&1; then
    qemu-img create -f qcow2 "$VM_DIR/disk.qcow2" 4G
else
    echo "⚠️  qemu-img not found. Installing QEMU..."
    echo "Run: brew install qemu"
    echo ""
    echo "Alternative: Use ./utm-simple-setup.sh for manual setup"
    exit 1
fi

# Create shared directory with uDESK packages
SHARED_DIR="$VM_DIR/shared"
mkdir -p "$SHARED_DIR"
cp "$PROJECT_ROOT/build"/*.tcz "$SHARED_DIR/"

# Create auto-install script for inside VM
cat > "$SHARED_DIR/install-udesk.sh" << 'INSTALL_SCRIPT_EOF'
#!/bin/bash
# Auto-install uDESK in TinyCore VM

echo "🚀 Installing uDESK..."

# Set up persistence
sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}
sudo chmod 775 /mnt/sda1/tce

# Install uDESK packages
echo "Installing core packages..."
tce-load -i /mnt/sdb1/udos-core.tcz
tce-load -i /mnt/sdb1/udos-role-admin.tcz

# Make persistent
sudo cp /mnt/sdb1/*.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst
echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst

# Test installation
if command -v udos-info >/dev/null 2>&1; then
    echo "✅ uDESK installed successfully!"
    udos-info
else
    echo "❌ Installation failed"
fi

echo ""
echo "🎉 Setup complete! Reboot to test persistence:"
echo "sudo reboot"
INSTALL_SCRIPT_EOF

chmod +x "$SHARED_DIR/install-udesk.sh"

# Create quick start guide
cat > "$SHARED_DIR/QUICKSTART.md" << 'QUICKSTART_EOF'
# uDESK Quick Start

## Installation Commands (run in TinyCore):
```bash
# Mount shared directory
sudo mkdir -p /mnt/sdb1
sudo mount /dev/sdb1 /mnt/sdb1

# Install uDESK
cd /mnt/sdb1
./install-udesk.sh
```

## Test uDESK:
```bash
udos-info              # System information
udos-detect-role       # Current role
```

## Make Changes Persistent:
```bash
sudo reboot            # Test persistence
```

Your markdown-focused OS is ready! 🚀
QUICKSTART_EOF

echo ""
echo "✅ UTM VM Created Successfully!"
echo "==============================="
echo ""
echo "📁 VM Location: $VM_DIR"
echo "💿 ISO: $(basename "$TINYCORE_ISO")"
echo "📦 uDESK Packages: $(ls "$SHARED_DIR"/*.tcz | wc -l | tr -d ' ') files"
echo ""
echo "🚀 Next Steps:"
echo "1. Open UTM app"
echo "2. VM '$VM_NAME' should appear in the list"
echo "3. Start the VM (console mode, no graphics issues!)"
echo "4. In TinyCore, run:"
echo "   sudo mount /dev/sdb1 /mnt/sdb1"
echo "   /mnt/sdb1/install-udesk.sh"
echo ""
echo "📖 Full instructions: $SHARED_DIR/QUICKSTART.md"

# Try to open UTM
if command -v open >/dev/null 2>&1; then
    echo ""
    echo "Opening UTM..."
    open -a UTM
fi

echo ""
echo "🎉 Your automated uDESK VM is ready!"