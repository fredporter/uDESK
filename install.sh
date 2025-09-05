#!/bin/bash
# uDESK Bootstrap Installer v1.0.7.2
# Single directory installation - everything in ~/uDESK

set -e

echo "🚀 uDESK Bootstrap Installer v1.0.7.2"
echo "====================================="

# Check if we're already in a uDESK directory (called from installer)
if [ -f "udesk-install.command" ] && [ -d ".git" ]; then
    echo "✓ uDESK installation ready"
elif [ -d "$HOME/uDESK/.git" ]; then
    echo "✓ uDESK found - updating repository..."
    cd "$HOME/uDESK" && git pull
else
    echo "📦 Installing uDESK to ~/uDESK..."
    git clone https://github.com/fredporter/uDESK.git "$HOME/uDESK"
    cd "$HOME/uDESK"
fi

# Create user workspace directories within uDESK
echo "� Setting up workspace structure..."
mkdir -p "$HOME/uDESK/uMEMORY/sandbox"
mkdir -p "$HOME/uDESK/uMEMORY/.local/logs"
mkdir -p "$HOME/uDESK/uMEMORY/.local/backups" 
mkdir -p "$HOME/uDESK/uMEMORY/.local/state"
mkdir -p "$HOME/uDESK/iso/current"
mkdir -p "$HOME/uDESK/iso/archive"

# Download TinyCore ISO with mirror fallback
echo ""
echo "📀 Checking TinyCore ISO..."
if [ -f "$HOME/uDESK/installers/download-tinycore.sh" ]; then
    bash "$HOME/uDESK/installers/download-tinycore.sh"
else
    echo "⚠️  TinyCore downloader not found - will be available after repository setup"
fi

# Run comprehensive health check and setup
echo ""
echo "🩺 Running health check and setup..."
if [ -f "$HOME/uDESK/installers/setup.sh" ]; then
    bash "$HOME/uDESK/installers/setup.sh"
else
    echo "⚠️  Setup script not found - proceeding with legacy installation"
fi

# Legacy system installation (backward compatibility)
INSTALL_PREFIX="${INSTALL_PREFIX:-/usr/local}"
UDESK_CONFIG_DIR="${UDESK_CONFIG_DIR:-/etc/udesk}"

echo ""
echo "� Installing legacy system components..."
echo "Installing to: $INSTALL_PREFIX"
echo "Config dir: $UDESK_CONFIG_DIR"

# Create system directories
sudo mkdir -p "$INSTALL_PREFIX/bin"
sudo mkdir -p "$INSTALL_PREFIX/share/udos"
sudo mkdir -p "$UDESK_CONFIG_DIR"

# Install binaries (if they exist)
if [ -f "usr/bin/udos" ]; then
    echo "📦 Installing binaries..."
    sudo cp usr/bin/udos "$INSTALL_PREFIX/bin/"
    sudo cp usr/bin/uvar "$INSTALL_PREFIX/bin/"
    sudo cp usr/bin/udata "$INSTALL_PREFIX/bin/"
    sudo cp usr/bin/utpl "$INSTALL_PREFIX/bin/"
    sudo chmod +x "$INSTALL_PREFIX/bin/udos" "$INSTALL_PREFIX/bin/uvar" "$INSTALL_PREFIX/bin/udata" "$INSTALL_PREFIX/bin/utpl"
    echo "✅ Legacy binaries installed"
else
    echo "⚠️  Legacy binaries not found - repository-only installation"
fi

# Install shared components (if they exist)
if [ -d "usr/share/udos" ]; then
    echo "🔧 Installing shared components..."
    sudo cp -r usr/share/udos/* "$INSTALL_PREFIX/share/udos/"
    echo "✅ Shared components installed"
fi

# Install configuration (if it exists)
if [ -d "etc/udesk" ]; then
    echo "⚙️  Installing configuration..."
    sudo cp etc/udesk/* "$UDESK_CONFIG_DIR/"
    echo "✅ Configuration installed"
fi

echo ""
echo "✅ uDESK v1.0.7.2 installation complete!"
echo ""
echo "📂 Unified Directory Structure:"
echo "  uDESK/                  - Complete system (root)"
echo "  uDESK/uMEMORY/sandbox   - User workspace"
echo "  uDESK/uMEMORY/.local/   - Logs, backups, state (XDG)"
echo "  uDESK/system/tinycore/  - TinyCore ISO storage"
echo "  uDESK/docs/             - Documentation"
echo "  ~/uDESK/dev/            - Development tools"
echo ""
echo "🔧 Available Commands:"
echo "  udos    - Main uDOS interface"
echo "  uvar    - Variable management"
echo "  udata   - Data management"
echo "  utpl    - Template management"
echo ""
echo "🧪 Quick Tests:"
echo "  cd ~/uDESK && udos version  - Check installation"
echo "  cd ~/uDESK && udos test     - Full system test"
