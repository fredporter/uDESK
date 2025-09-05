#!/bin/bash
# uDESK Mac Desktop Installer (.command file)
# Double-click from Finder to install

# Make sure we exit on any error
set -e

# Clear screen and show banner
clear
echo "🍎 uDESK Mac Installer v1.0.7.2"
echo "================================"
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
    echo "Ready to install uDESK v1.0.7.2"
    read -p "Continue with installation? [YES|NO]: " choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    if [[ ! "$choice" =~ ^(Y|YES)$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
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
echo "Press any key to close this installer..."
read -n 1 -s
