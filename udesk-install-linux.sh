#!/bin/bash
# uDESK Ubuntu/Linux Desktop Installer
# Download and run to install uDESK v1.0.7.2

# Make sure we exit on any error
set -e

# Clear screen and show banner
clear
echo "🐧 uDESK Ubuntu/Linux Installer v1.0.7.2"
echo "========================================="
echo ""
echo "This installer will:"
echo "• Download uDESK complete system to ~/uDESK"
echo "• Set up embedded uMEMORY workspace"
echo "• Download TinyCore Linux ISO (direct curl)"
echo "• Configure the unified environment"
echo ""

# Check if uDESK directory already exists
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
            ;;
        2)
            echo "💥 Will destroy and start fresh..."
            read -p "Are you sure? This will delete ~/uDESK completely (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo "🗑️  Removing existing uDESK directory..."
                cd "$HOME"  # Change to safe directory before deletion
                rm -rf "$HOME/uDESK"
                echo "✅ Directory removed"
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
else
    read -p "Press Enter to continue or Ctrl+C to cancel..."
fi

# Check prerequisites
echo ""
echo "🔍 Checking prerequisites..."

# Check for git
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    elif command -v yum &> /dev/null; then
        sudo yum install -y git
    elif command -v pacman &> /dev/null; then
        sudo pacman -S git
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y git
    else
        echo "❌ Unable to install git automatically. Please install git manually."
        exit 1
    fi
fi
echo "✅ Git found"

# Check for curl
if ! command -v curl &> /dev/null; then
    echo "❌ curl not found. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y curl
    elif command -v yum &> /dev/null; then
        sudo yum install -y curl
    elif command -v pacman &> /dev/null; then
        sudo pacman -S curl
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y curl
    else
        echo "❌ Unable to install curl automatically. Please install curl manually."
        exit 1
    fi
fi
echo "✅ curl found"

# Check for essential build tools
echo "🔧 Checking build tools..."
if ! command -v gcc &> /dev/null; then
    echo "⚠️  GCC not found - installing build essentials..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y build-essential
    elif command -v yum &> /dev/null; then
        sudo yum groupinstall -y "Development Tools"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S base-devel
    elif command -v dnf &> /dev/null; then
        sudo dnf groupinstall -y "Development Tools"
    fi
fi

# Clone or update uDESK to unified directory
echo ""
if [ -d "$HOME/uDESK/.git" ]; then
    echo "🔄 Updating existing uDESK installation..."
    cd "$HOME/uDESK" && git pull
else
    echo "📦 Downloading uDESK complete system..."
    git clone https://github.com/fredporter/uDESK.git "$HOME/uDESK"
fi

# Run the main installer
echo ""
echo "🚀 Running main installer..."
cd "$HOME/uDESK"
bash install.sh

# Download TinyCore ISO using the working curl method
echo ""
echo "📀 Downloading TinyCore ISO (direct method)..."
mkdir -p "$HOME/uDESK/iso/current"

if curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar \
    "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" \
    -o "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"; then
    
    echo "✅ TinyCore ISO downloaded successfully!"
    mv "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp" "$HOME/uDESK/iso/current/TinyCore-current.iso"
    echo "📂 Location: ~/uDESK/iso/current/TinyCore-current.iso"
else
    echo "⚠️  TinyCore ISO download failed, but uDESK will work without it"
    echo "   You can download it manually later from: http://tinycorelinux.net/downloads.html"
    rm -f "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"
fi

echo ""
echo "🎉 Installation Complete!"
echo ""
echo "📂 Your unified uDESK installation:"
echo "   Complete system: ~/uDESK/"
echo "   User workspace:  ~/uDESK/uMEMORY/sandbox/"
echo "   ISOs:           ~/uDESK/iso/"
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

echo ""
echo "📚 Documentation: https://github.com/fredporter/uDESK"
echo "🔧 To run uDOS again: cd ~/uDESK && ./build/user/udos"
echo ""
echo "💡 To create a desktop shortcut:"
echo "   cp ~/uDESK/udesk-install-linux.sh ~/Desktop/"
echo ""
echo "Press any key to close this installer..."
read -n 1 -s
