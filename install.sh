#!/bin/bash
# uDOS Clean Installer
# Single-file installer replacing multiple scattered install scripts

set -e

INSTALL_PREFIX="${INSTALL_PREFIX:-/usr/local}"
UDOS_CONFIG_DIR="${UDOS_CONFIG_DIR:-/etc/udos}"

echo "🚀 uDOS Installer"
echo "================"
echo "Installing to: $INSTALL_PREFIX"
echo "Config dir: $UDOS_CONFIG_DIR"
echo ""

# Create directories
echo "📁 Creating directories..."
sudo mkdir -p "$INSTALL_PREFIX/bin"
sudo mkdir -p "$INSTALL_PREFIX/share/udos"
sudo mkdir -p "$UDOS_CONFIG_DIR"

# Install binaries
echo "📦 Installing binaries..."
sudo cp usr/bin/udos "$INSTALL_PREFIX/bin/"
sudo cp usr/bin/uvar "$INSTALL_PREFIX/bin/"
sudo cp usr/bin/udata "$INSTALL_PREFIX/bin/"
sudo cp usr/bin/utpl "$INSTALL_PREFIX/bin/"
sudo chmod +x "$INSTALL_PREFIX/bin/udos" "$INSTALL_PREFIX/bin/uvar" "$INSTALL_PREFIX/bin/udata" "$INSTALL_PREFIX/bin/utpl"

# Install shared components
echo "🔧 Installing shared components..."
sudo cp -r usr/share/udos/* "$INSTALL_PREFIX/share/udos/"

# Install configuration
echo "⚙️  Installing configuration..."
sudo cp etc/udos/* "$UDOS_CONFIG_DIR/"

echo ""
echo "✅ uDOS installed successfully!"
echo ""
echo "Quick test: udos version"
echo "Full test: udos test"
echo ""
echo "Available commands:"
echo "  udos    - Main uDOS interface"
echo "  uvar    - Variable management"
echo "  udata   - Data management"  
echo "  utpl    - Template management"
