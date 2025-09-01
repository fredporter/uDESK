#!/bin/bash
# Create USB-bootable uDESK directory structure

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/out"
BUILD_DIR="$PROJECT_ROOT/build"
USB_DIR="$OUTPUT_DIR/udesk-usb-boot"

echo "=== Creating uDESK USB Boot Structure ==="

# Create USB boot directory
rm -rf "$USB_DIR"
mkdir -p "$USB_DIR"/{boot,cde/optional,tce}

# Copy built packages
if [ -f "$BUILD_DIR/udos-core.tcz" ]; then
    cp "$BUILD_DIR"/*.tcz "$USB_DIR/cde/optional/"
    echo "✓ Copied uDESK packages to USB structure"
else
    echo "✗ Build packages first with: ./build.sh"
    exit 1
fi

# Create boot script
cat > "$USB_DIR/boot.sh" << 'EOF'
#!/bin/bash
echo "=== uDESK Boot Loader ==="
echo "Copy this directory to a USB drive and run on target system"
echo ""
echo "To install extensions:"
echo "tce-load -i cde/optional/udos-core.tcz"
echo "tce-load -i cde/optional/udos-role-admin.tcz"
echo ""
echo "Then run: udos-info"
EOF

chmod +x "$USB_DIR/boot.sh"

# Create installation guide
cat > "$USB_DIR/INSTALL.md" << EOF
# uDESK USB Installation

## Quick Start
1. Copy this entire directory to a USB drive
2. Boot target system with TinyCore Linux
3. Mount USB and run: \`./boot.sh\`

## Manual Installation
\`\`\`bash
# Load uDESK packages
tce-load -i cde/optional/udos-core.tcz
tce-load -i cde/optional/udos-role-admin.tcz

# Check installation
udos-info
\`\`\`

## Package Contents
$(ls -la cde/optional/ | grep -v "^total")

*Your markdown-focused OS is ready!*
EOF

echo "✓ USB boot structure created at: $USB_DIR"
echo ""
echo "Next steps:"
echo "1. Copy $USB_DIR to a USB drive"
echo "2. Boot TinyCore Linux on target system"  
echo "3. Run the installation from USB"