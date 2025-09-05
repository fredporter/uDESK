#!/bin/bash
# uDESK v1.0.7 TinyCore Extension Builder
# Builds proper .tcz package for TinyCore distribution

set -e

VERSION="1.0.7"
PACKAGE_NAME="udesk"
BUILD_DIR="/tmp/udesk-build"
TCZ_DIR="${BUILD_DIR}/${PACKAGE_NAME}"

echo "Building uDESK v${VERSION} TinyCore Extension..."

# Clean previous builds
rm -rf "${BUILD_DIR}"
mkdir -p "${TCZ_DIR}"

# Create directory structure
mkdir -p "${TCZ_DIR}/usr/local/udesk"
mkdir -p "${TCZ_DIR}/usr/local/bin"
mkdir -p "${TCZ_DIR}/usr/local/share/applications"
mkdir -p "${TCZ_DIR}/usr/local/share/pixmaps"
mkdir -p "${TCZ_DIR}/usr/local/udesk/scripts"

# Copy application files
echo "Copying application files..."
cp -r ../app/udesk-app/dist/* "${TCZ_DIR}/usr/local/udesk/"

# Copy integration files
cp udesk.desktop "${TCZ_DIR}/usr/local/share/applications/"
cp udesk.png "${TCZ_DIR}/usr/local/share/pixmaps/" 2>/dev/null || echo "Warning: udesk.png not found"

# Create launcher script
cat > "${TCZ_DIR}/usr/local/bin/udesk" << 'EOF'
#!/bin/bash
# uDESK v1.0.7 Launcher

UDESK_HOME="/usr/local/udesk"
export UDESK_VERSION="1.0.7"
export UDESK_CONFIG_DIR="${HOME}/.udesk"

# Create user config directory
mkdir -p "${UDESK_CONFIG_DIR}"

# Check for TinyCore environment
if [ -f /opt/bootlocal.sh ]; then
    export UDESK_TINYCORE=1
    export UDESK_TCE_DIR="/tmp/tce"
else
    export UDESK_TINYCORE=0
fi

# Launch application
cd "${UDESK_HOME}"
exec ./udesk-app "$@"
EOF

chmod +x "${TCZ_DIR}/usr/local/bin/udesk"

# Create uCODE command line tool
cat > "${TCZ_DIR}/usr/local/bin/ucode" << 'EOF'
#!/bin/bash
# uCODE Command Line Interface

COMMAND="$1"

if [ -z "$COMMAND" ]; then
    echo "uCODE v1.0.7 - Universal Command Operations"
    echo "Usage: ucode [COMMAND|OPTION*PARAMETER]"
    echo "Example: ucode '[STATUS]'"
    echo "         ucode '[BACKUP|FULL]'"
    echo "         ucode '[THEME|SET*C64]'"
    exit 1
fi

# Format command for uDESK
if [[ ! "$COMMAND" =~ ^\[.*\]$ ]]; then
    COMMAND="[$COMMAND]"
fi

# Send to uDESK application
if pgrep -f udesk-app > /dev/null; then
    # Application is running, send command via IPC
    echo "$COMMAND" > "${HOME}/.udesk/command_pipe"
else
    # Start application in command mode
    udesk --command "$COMMAND"
fi
EOF

chmod +x "${TCZ_DIR}/usr/local/bin/ucode"

# Create TinyCore integration scripts
cat > "${TCZ_DIR}/usr/local/udesk/scripts/udos-backup" << 'EOF'
#!/bin/bash
# uDOS Backup Command
exec filetool.sh -b "$@"
EOF

cat > "${TCZ_DIR}/usr/local/udesk/scripts/udos-restore" << 'EOF'
#!/bin/bash
# uDOS Restore Command  
exec filetool.sh -r "$@"
EOF

cat > "${TCZ_DIR}/usr/local/udesk/scripts/udos-repair" << 'EOF'
#!/bin/bash
# uDOS Repair Command
echo "Running TinyCore system repair..."
sudo fsck -y /dev/sda1 2>/dev/null || true
tce-load -i base
sudo depmod -a
sudo ldconfig
echo "Repair complete"
EOF

chmod +x "${TCZ_DIR}/usr/local/udesk/scripts/"*

# Create .tcz package
echo "Creating .tcz package..."
cd "${BUILD_DIR}"
mksquashfs "${PACKAGE_NAME}" "${PACKAGE_NAME}.tcz" -noappend

# Copy metadata files
cp "../${PACKAGE_NAME}.tcz.info" "${BUILD_DIR}/"
cp "../${PACKAGE_NAME}.tcz.dep" "${BUILD_DIR}/"

# Create checksums
cd "${BUILD_DIR}"
md5sum "${PACKAGE_NAME}.tcz" > "${PACKAGE_NAME}.tcz.md5.txt"

echo "Build complete!"
echo "Files created:"
echo "  ${BUILD_DIR}/${PACKAGE_NAME}.tcz"
echo "  ${BUILD_DIR}/${PACKAGE_NAME}.tcz.info"
echo "  ${BUILD_DIR}/${PACKAGE_NAME}.tcz.dep"
echo "  ${BUILD_DIR}/${PACKAGE_NAME}.tcz.md5.txt"

echo ""
echo "To install on TinyCore:"
echo "  1. Copy .tcz files to /tmp/tce/optional/"
echo "  2. Run: tce-load -i udesk"
echo "  3. Launch: udesk"
