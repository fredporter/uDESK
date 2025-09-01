#!/bin/bash
# Simplified UTM Setup (No QEMU dependencies)

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$PROJECT_ROOT/utm-ready"

echo "🚀 uDESK Simple UTM Setup"
echo "========================="

# Find TinyCore ISO - check multiple locations
TINYCORE_ISO=""

# Check Code directory first (user specified location)
if [ -f "/Users/fredbook/Code/TinyCore-current.iso" ]; then
    TINYCORE_ISO="/Users/fredbook/Code/TinyCore-current.iso"
    echo "✅ Using TinyCore ISO from Code directory"
# Check project directory
elif [ -f "$PROJECT_ROOT/TinyCore-current.iso" ]; then
    TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
    echo "✅ Using TinyCore ISO from project directory"
# Check for any ISO in project
else
    for iso in "$PROJECT_ROOT"/*.iso; do
        if [ -f "$iso" ]; then
            TINYCORE_ISO="$iso"
            echo "✅ Using ISO: $(basename "$iso")"
            break
        fi
    done
fi

if [ -z "$TINYCORE_ISO" ]; then
    echo "❌ No TinyCore ISO found!"
    echo ""
    echo "Expected locations:"
    echo "  - /Users/fredbook/Code/TinyCore-current.iso ⭐ (preferred)"
    echo "  - $PROJECT_ROOT/TinyCore-current.iso"
    echo ""
    echo "Please copy your working TinyCore ISO to one of these locations."
    exit 1
fi

echo "📀 Found ISO: $(basename "$TINYCORE_ISO")"

# Prepare packages
echo "📦 Preparing uDESK packages..."
if [ ! -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
    echo "Building packages first..."
    ./build.sh --clean
fi

# Create setup directory
rm -rf "$SETUP_DIR"
mkdir -p "$SETUP_DIR/udesk-packages"

# Copy everything needed
cp "$TINYCORE_ISO" "$SETUP_DIR/"
cp "$PROJECT_ROOT/build"/*.tcz "$SETUP_DIR/udesk-packages/"

# Create installation script
cat > "$SETUP_DIR/udesk-packages/install.sh" << 'INSTALL_EOF'
#!/bin/bash
echo "🚀 Installing uDESK..."

# Set up persistence
sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}

# Install packages
echo "Loading uDESK core..."
tce-load -i udos-core.tcz
tce-load -i udos-role-admin.tcz

# Make persistent
sudo cp *.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst
echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst

echo "✅ uDESK installed! Test with: udos-info"
INSTALL_EOF

chmod +x "$SETUP_DIR/udesk-packages/install.sh"

# Create simple instructions
cat > "$SETUP_DIR/INSTRUCTIONS.txt" << 'INSTRUCTIONS_EOF'
🚀 uDESK UTM Setup - Simple Method

1. OPEN UTM
   - Create New VM → Virtualize → Linux

2. VM SETTINGS:
   - ISO: Use TinyCore-current.iso (in this folder)
   - RAM: 1024 MB
   - Storage: 4 GB
   - Display: Console Only (important!)

3. START VM
   - TinyCore will boot to desktop

4. INSTALL uDESK:
   - Drag udesk-packages folder into VM
   - In terminal: cd /tmp/udesk-packages
   - Run: ./install.sh

5. TEST:
   - udos-info
   - udos-detect-role

Done! Your markdown OS is ready! 🎉
INSTRUCTIONS_EOF

echo ""
echo "✅ Simple UTM setup ready!"
echo "=========================="
echo ""
echo "📁 Location: $SETUP_DIR"
echo "💿 ISO: $(basename "$TINYCORE_ISO")"
echo "📦 Packages: $(ls "$SETUP_DIR/udesk-packages"/*.tcz | wc -l | tr -d ' ') files"
echo ""
echo "🚀 Next steps:"
echo "1. Open UTM"
echo "2. Create VM with Console Only display"
echo "3. Use the ISO and follow INSTRUCTIONS.txt"
echo ""

# Open the folder
if command -v open >/dev/null 2>&1; then
    open "$SETUP_DIR"
fi

echo "Your simplified uDESK setup is ready! 🎉"