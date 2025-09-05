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
echo "• Download TinyCore Linux ISO"
echo "• Configure the unified environment"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

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

echo ""
echo "🎉 Installation Complete!"
echo ""
echo "📂 Your unified uDESK installation:"
echo "   Complete system: ~/uDESK/"
echo "   User workspace:  ~/uDESK/uMEMORY/sandbox/"
echo "   ISOs:           ~/uDESK/iso/"
echo ""
echo "🔧 To use uDESK:"
echo "   cd ~/uDESK && udos version - Check installation"
echo "   cd ~/uDESK && udos test    - Run system test"
echo ""
echo "📚 Documentation: https://github.com/fredporter/uDESK"
echo ""
echo "💡 To create a desktop shortcut:"
echo "   cp ~/uDESK/udesk-install-ubuntu.sh ~/Desktop/"
echo ""
read -p "Press any key to close this installer..."
