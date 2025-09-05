#!/bin/bash
# uDESK Bootstrap Installer v1.0.7.2
# Repository management + legacy system installation + self-healing

set -e

echo "🚀 uDESK Bootstrap Installer v1.0.7.2"
echo "====================================="

# Create base directories for new repository structure
echo "📁 Creating base structure..."
mkdir -p "$HOME/uDESK/iso/current" "$HOME/uDESK/iso/archive" "$HOME/uMEMORY"

# Provision uDESK core repository
if [ -d "$HOME/uDESK/repo/.git" ]; then
    echo "✓ uDESK repo found - updating..."
    cd "$HOME/uDESK/repo" && git pull
else
    echo "📦 Installing uDESK core repository..."
    git clone https://github.com/fredporter/uDESK.git "$HOME/uDESK/repo"
fi

# Provision uMEMORY workspace from bundled structure
if [ -d "$HOME/uMEMORY/repo" ]; then
    echo "✓ uMEMORY workspace found - updating templates..."
    # Copy latest templates from bundled structure
    cp -r "$HOME/uDESK/repo/uMEMORY/templates" "$HOME/uMEMORY/repo/" 2>/dev/null || true
    cp -r "$HOME/uDESK/repo/uMEMORY/config" "$HOME/uMEMORY/repo/" 2>/dev/null || true
else
    echo "📦 Creating uMEMORY workspace from bundled structure..."
    mkdir -p "$HOME/uMEMORY/repo"
    # Copy bundled structure to user workspace
    cp -r "$HOME/uDESK/repo/uMEMORY/templates" "$HOME/uMEMORY/repo/" 2>/dev/null || true
    cp -r "$HOME/uDESK/repo/uMEMORY/config" "$HOME/uMEMORY/repo/" 2>/dev/null || true
    
    # Create XDG-compliant directories
    mkdir -p "$HOME/uMEMORY/.local/logs" "$HOME/uMEMORY/.local/backups" "$HOME/uMEMORY/.local/state"
    mkdir -p "$HOME/uMEMORY/sandbox"
    echo "✅ uMEMORY workspace structure created"
fi

# Download TinyCore ISO with mirror fallback
echo ""
echo "📀 Checking TinyCore ISO..."
if [ -f "$HOME/uDESK/repo/system/scripts/download-tinycore.sh" ]; then
    bash "$HOME/uDESK/repo/system/scripts/download-tinycore.sh"
else
    echo "⚠️  TinyCore downloader not found - will be available after repository setup"
fi

# Run comprehensive health check and setup
echo ""
echo "🩺 Running health check and setup..."
if [ -f "$HOME/uDESK/repo/system/scripts/setup.sh" ]; then
    bash "$HOME/uDESK/repo/system/scripts/setup.sh"
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
echo "📂 New Repository Structure:"
echo "  ~/uDESK/repo/       - Core system repository"
echo "  ~/uDESK/iso/        - TinyCore ISO storage"
echo "  ~/uMEMORY/repo/     - Templates and configuration"
echo "  ~/uMEMORY/.local/   - Logs, backups, state (XDG)"
echo "  ~/uMEMORY/sandbox/  - User workspace"
echo ""
echo "🔧 Available Commands:"
echo "  udos    - Main uDOS interface"
echo "  uvar    - Variable management"
echo "  udata   - Data management"
echo "  utpl    - Template management"
echo ""
echo "🧪 Quick Tests:"
echo "  udos version  - Check installation"
echo "  udos test     - Full system test"
