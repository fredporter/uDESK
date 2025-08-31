#!/bin/bash
# uDESK ISO/IMG Builder - Creates bootable images with markdown focus

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build"
OUTPUT_DIR="$PROJECT_ROOT/out"
VERSION="1.0.6"

# Default options
ROLE="standard"
WITH_DEVKIT=false
OUTPUT_FORMAT="iso"

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        --role)
            ROLE="$2"
            shift 2
            ;;
        --with-devkit)
            WITH_DEVKIT=true
            shift
            ;;
        --format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --role <basic|standard|admin>  Set default role (default: standard)"
            echo "  --with-devkit                  Include development kit"
            echo "  --format <iso|img>             Output format (default: iso)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "=== Building uDESK v$VERSION Image ==="
echo "Role: $ROLE"
echo "DevKit: $WITH_DEVKIT"
echo "Format: $OUTPUT_FORMAT"

# Ensure build directory exists
mkdir -p "$OUTPUT_DIR"

# Check for TinyCore base
TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
if [ ! -f "$TINYCORE_ISO" ]; then
    echo "Error: TinyCore base ISO not found at $TINYCORE_ISO"
    echo "Please download TinyCore ISO to project root"
    exit 1
fi

# Create work directory
WORK_DIR="/tmp/udos-build-$$"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Extracting TinyCore base..."
# Extract TinyCore ISO
mkdir -p tinycore-extract
if command -v 7z >/dev/null 2>&1; then
    7z x "$TINYCORE_ISO" -otinycore-extract
else
    # Fallback to mount (requires sudo)
    sudo mkdir -p /mnt/tinycore
    sudo mount -o loop "$TINYCORE_ISO" /mnt/tinycore
    cp -r /mnt/tinycore/* tinycore-extract/
    sudo umount /mnt/tinycore
fi

# Create custom filesystem
mkdir -p custom-fs/{etc/udos,opt/udos,usr/local/bin}

# Add uDESK configuration
cat > custom-fs/etc/udos/default-config.md << EOF
# uDESK Default Configuration

## Selected Role
**Role**: $ROLE

## Build Information
- **Version**: $VERSION
- **Built**: $(date)
- **DevKit**: $WITH_DEVKIT

## Boot Options
Add these to kernel command line:
- \`udos.role=basic\` - Force basic role
- \`udos.role=standard\` - Force standard role  
- \`udos.role=admin\` - Force admin role
- \`udos.gui=off\` - Disable GUI
- \`udos.debug=on\` - Enable debug mode

## Markdown Philosophy
Everything in uDESK is configured through markdown files for maximum readability and editability.
EOF

# Add markdown tools installation script
cat > custom-fs/opt/udos/install-markdown-tools.sh << 'EOF'
#!/bin/bash
# Install markdown development tools

echo "Installing markdown development environment..."

# Install micro editor
if ! command -v micro >/dev/null 2>&1; then
    echo "Installing micro editor..."
    cd /tmp
    curl -L https://github.com/zyedidia/micro/releases/latest/download/micro-2.0.11-linux64.tar.gz -o micro.tar.gz
    tar -xzf micro.tar.gz
    sudo mv micro-2.0.11/micro /usr/local/bin/
    rm -rf micro.tar.gz micro-2.0.11/
fi

# Install glow viewer
if ! command -v glow >/dev/null 2>&1; then
    echo "Installing glow markdown viewer..."
    cd /tmp
    curl -L https://github.com/charmbracelet/glow/releases/latest/download/glow_1.5.1_linux_x86_64.tar.gz -o glow.tar.gz
    tar -xzf glow.tar.gz
    sudo mv glow /usr/local/bin/
    rm glow.tar.gz
fi

echo "Markdown tools installed successfully!"
EOF
chmod +x custom-fs/opt/udos/install-markdown-tools.sh

# Add boot integration
cat > custom-fs/opt/udos/bootlocal-addon.sh << 'EOF'
#!/bin/bash
# uDESK boot integration

# Install markdown tools if not present
/opt/udos/install-markdown-tools.sh

# Run first-boot wizard if needed
if [ -f /opt/udos/first-boot.sh ]; then
    /opt/udos/first-boot.sh
fi

# Load role-specific configuration
ROLE=$(udos-detect-role 2>/dev/null || echo "basic")
ROLE_PROFILE="/opt/udos/roles/$ROLE/profile.sh"
if [ -f "$ROLE_PROFILE" ]; then
    source "$ROLE_PROFILE"
fi

echo "uDESK v$VERSION loaded with role: $ROLE"
EOF

# Create remastered ISO
echo "Remastering ISO with uDESK components..."

# This is a simplified version - in practice you'd use ezremaster or similar
mkdir -p remaster
cp -r tinycore-extract/* remaster/

# Add custom files to the remaster
if [ -d remaster/cde ]; then
    # Add to existing optional directory
    cp -r custom-fs/* remaster/cde/ 2>/dev/null || true
else
    # Create optional directory
    mkdir -p remaster/cde
    cp -r custom-fs/* remaster/cde/
fi

# Add uDESK packages to cde/optional if they exist
if [ -f "$BUILD_DIR/udos-core.tcz" ]; then
    cp "$BUILD_DIR"/*.tcz remaster/cde/optional/ 2>/dev/null || true
fi

# Update boot configuration
BOOT_CFG="remaster/boot/isolinux/isolinux.cfg"
if [ -f "$BOOT_CFG" ]; then
    # Add uDESK boot options
    cat >> "$BOOT_CFG" << EOF

label udesk-$ROLE
  kernel vmlinuz
  initrd core.gz
  append udos.role=$ROLE
EOF
fi

# Create new ISO
OUTPUT_FILE="$OUTPUT_DIR/udesk-v$VERSION-$ROLE.$OUTPUT_FORMAT"
echo "Creating final image: $OUTPUT_FILE"

if command -v genisoimage >/dev/null 2>&1; then
    genisoimage -l -J -R -V "uDESK-$VERSION" -no-emul-boot -boot-load-size 4 \
        -boot-info-table -b boot/isolinux/isolinux.bin \
        -c boot/isolinux/boot.cat -o "$OUTPUT_FILE" remaster/
elif command -v mkisofs >/dev/null 2>&1; then
    mkisofs -l -J -R -V "uDESK-$VERSION" -no-emul-boot -boot-load-size 4 \
        -boot-info-table -b boot/isolinux/isolinux.bin \
        -c boot/isolinux/boot.cat -o "$OUTPUT_FILE" remaster/
else
    echo "Warning: No ISO creation tool found. Creating directory image instead."
    cp -r remaster "$OUTPUT_DIR/udesk-v$VERSION-$ROLE-filesystem"
fi

# Cleanup
cd "$PROJECT_ROOT"
rm -rf "$WORK_DIR"

echo ""
echo "✓ uDESK image built successfully!"
echo "Output: $OUTPUT_FILE"
echo ""
echo "To test in QEMU:"
echo "./isos/run_qemu.sh --image '$OUTPUT_FILE'"
