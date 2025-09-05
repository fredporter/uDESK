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
echo "• Test and launch uDOS"
echo ""

# If no uDESK directory exists, show continue prompt
if [ ! -d "$HOME/uDESK" ]; then
    read -p "Press Enter to continue or Ctrl+C to cancel..."
fi

# Check for essential build tools first
echo "🔧 Checking build tools..."
if ! command -v gcc &> /dev/null; then
    echo "⚠️  GCC not found - installing build essentials..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y build-essential
    elif command -v yum &> /dev/null; then
        sudo yum groupinstall -y "Development Tools"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S base-devel
    elif command -v dnf &> /dev/null; then
        sudo dnf groupinstall -y "Development Tools"
    fi
fi

# Download the installer if we don't have it locally
if [ ! -f "install.sh" ]; then
    echo "📦 Downloading installer..."
    curl -L "https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh" -o "/tmp/udesk-install.sh"
    bash "/tmp/udesk-install.sh"
else
    # Run the comprehensive installer
    bash install.sh
fi

echo ""
echo "🎉 Installation Complete!"
echo ""
echo "📂 Your unified uDESK installation:"
echo "   Complete system: ~/uDESK/"
echo "   User workspace:  ~/uDESK/uMEMORY/sandbox/"
echo "   ISOs:           ~/uDESK/iso/"
echo ""
echo "📚 Documentation: https://github.com/fredporter/uDESK"
echo "🔧 To run uDOS again: cd ~/uDESK && ./build/user/udos"
echo ""
echo "💡 To create a desktop shortcut:"
echo "   cp ~/uDESK/udesk-install-linux.sh ~/Desktop/"
echo ""
echo "Press any key to close this installer..."
read -n 1 -s
