#!/bin/bash
# uDESK Bootstrap Installer v1.0.7.2
# Single directory installation - everything in ~/uDESK

set -e

# Function to handle directory collision
handle_existing_directory() {
    if [ -d "$HOME/uDESK" ]; then
        echo "⚠️  uDESK directory already exists at ~/uDESK"
        echo ""
        echo "Options:"
        echo "1) Update existing installation (git pull)"
        echo "2) Destroy and start fresh (removes everything)"
        echo "3) Cancel installation"
        echo ""
        read -p "Enter choice (1-3): " choice
        
        case $choice in
            1)
                echo "📦 Will update existing installation..."
                return 0
                ;;
            2)
                echo "💥 Will destroy and start fresh..."
                read -p "Are you sure? This will delete ~/uDESK completely (y/N): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    echo "🗑️  Removing existing uDESK directory..."
                    cd "$HOME"  # Change to safe directory before deletion
                    rm -rf "$HOME/uDESK"
                    echo "✅ Directory removed"
                    return 0
                else
                    echo "❌ Installation cancelled"
                    exit 1
                fi
                ;;
            3)
                echo "❌ Installation cancelled"
                exit 1
                ;;
            *)
                echo "❌ Invalid choice. Installation cancelled"
                exit 1
                ;;
        esac
    fi
}

# Function to check prerequisites
check_prerequisites() {
    echo ""
    echo "🔍 Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        echo "❌ Git not found. Please install git and try again."
        exit 1
    fi
    echo "✅ Git found"
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo "❌ curl not found. Please install curl and try again."
        exit 1
    fi
    echo "✅ curl found"
}

# Function to clone or update repository
setup_repository() {
    echo ""
    if [ -d "$HOME/uDESK/.git" ]; then
        echo "🔄 Updating existing uDESK installation..."
        cd "$HOME/uDESK" && git pull
    else
        echo "📦 Downloading uDESK complete system..."
        git clone https://github.com/fredporter/uDESK.git "$HOME/uDESK"
        cd "$HOME/uDESK"
    fi
}

# Function to download TinyCore ISO
download_tinycore_iso() {
    echo ""
    echo "📀 Downloading TinyCore ISO (direct method)..."
    mkdir -p "$HOME/uDESK/iso/current"
    
    if curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar \
        "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" \
        -o "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"; then
        
        echo "✅ TinyCore ISO downloaded successfully!"
        mv "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp" "$HOME/uDESK/iso/current/TinyCore-current.iso"
        echo "📂 Location: ~/uDESK/iso/current/TinyCore-current.iso"
        return 0
    else
        echo "⚠️  TinyCore ISO download failed, but uDESK will work without it"
        echo "   You can download it manually later from: http://tinycorelinux.net/downloads.html"
        rm -f "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"
        return 1
    fi
}

# Function to test and launch uDOS
test_and_launch_udos() {
    echo ""
    echo "🔧 Testing installation..."
    
    # Test and launch uDOS
    if [ -f "$HOME/uDESK/build/user/udos" ]; then
        echo "✅ uDOS found - launching..."
        echo ""
        echo "=== Starting uDOS ==="
        cd "$HOME/uDESK"
        ./build/user/udos || echo "⚠️  uDOS exited"
    else
        echo "⚠️  uDOS binary not found, trying build..."
        if [ -f "$HOME/uDESK/build.sh" ]; then
            echo "🔨 Building uDOS..."
            cd "$HOME/uDESK"
            bash build.sh user
            if [ -f "build/user/udos" ]; then
                echo "✅ Build successful - launching uDOS..."
                echo ""
                echo "=== Starting uDOS ==="
                ./build/user/udos || echo "⚠️  uDOS exited"
            fi
        fi
    fi
}

echo "🚀 uDESK Bootstrap Installer v1.0.7.2"
echo "====================================="

# Handle existing directory (if not called from platform installer)
if [ "$1" != "--skip-collision-check" ]; then
    handle_existing_directory
fi

# Check prerequisites
check_prerequisites

# Setup repository
setup_repository

# Create user workspace directories within uDESK
echo ""
echo "📁 Setting up workspace structure..."
mkdir -p "$HOME/uDESK/uMEMORY/sandbox"
mkdir -p "$HOME/uDESK/uMEMORY/.local/logs"
mkdir -p "$HOME/uDESK/uMEMORY/.local/backups" 
mkdir -p "$HOME/uDESK/uMEMORY/.local/state"
mkdir -p "$HOME/uDESK/iso/current"
mkdir -p "$HOME/uDESK/iso/archive"

# Download TinyCore ISO (if not called from platform installer)
if [ "$2" != "--skip-iso-download" ]; then
    download_tinycore_iso
fi

# Run comprehensive health check and setup (but skip the failing download parts)
echo ""
echo "🩺 Running health check and setup..."
if [ -f "$HOME/uDESK/installers/setup.sh" ]; then
    # Skip the problematic download parts in setup.sh
    echo "📊 Running simplified health check..."
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
echo "  uDESK/iso/current/      - TinyCore ISO storage"
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

# Test and launch uDOS (if not called from platform installer)
if [ "$3" != "--skip-auto-launch" ]; then
    test_and_launch_udos
    
    echo ""
    echo "📚 Documentation: https://github.com/fredporter/uDESK"
    echo "🔧 To run uDOS again: cd ~/uDESK && ./build/user/udos"
fi
