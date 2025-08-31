#!/bin/bash
# Download TinyCore base ISO for uDESK development

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TINYCORE_URL="http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"

echo "=== Downloading TinyCore Base ISO ==="
echo "URL: $TINYCORE_URL"
echo "Target: $TINYCORE_ISO"
echo ""

if [ -f "$TINYCORE_ISO" ]; then
    echo "✓ TinyCore ISO already exists"
    echo "Size: $(du -h "$TINYCORE_ISO" | cut -f1)"
    echo ""
    echo "To re-download, delete the file first:"
    echo "rm '$TINYCORE_ISO'"
    exit 0
fi

echo "Downloading TinyCore Linux..."
if command -v wget >/dev/null 2>&1; then
    wget -O "$TINYCORE_ISO" "$TINYCORE_URL"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$TINYCORE_ISO" "$TINYCORE_URL"
else
    echo "Error: Neither wget nor curl found"
    echo "Please install wget or curl first"
    exit 1
fi

if [ -f "$TINYCORE_ISO" ]; then
    echo ""
    echo "✓ Download complete!"
    echo "Size: $(du -h "$TINYCORE_ISO" | cut -f1)"
    echo ""
    echo "Ready to build uDESK! Run:"
    echo "  ./dev.sh build"
else
    echo "✗ Download failed"
    exit 1
fi
