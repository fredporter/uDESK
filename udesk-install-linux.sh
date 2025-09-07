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
    echo "Ready to install uDESK v1.0.7.2"
    read -p "Continue with installation? [YES|NO]: " choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    if [[ ! "$choice" =~ ^(Y|YES)$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
fi


# Minimal Linux installer: only install dependencies, fetch and run install.sh
echo "🔧 Installing required dependencies (build-essential, git, curl, npm, nodejs)..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y build-essential git curl npm nodejs
elif command -v yum &> /dev/null; then
    sudo yum groupinstall -y "Development Tools"
    sudo yum install -y git curl npm nodejs
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm base-devel git curl npm nodejs
elif command -v dnf &> /dev/null; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y git curl npm nodejs
else
    echo "❌ Unsupported package manager. Please install build-essential, git, curl, npm, and nodejs manually."
    exit 1
fi


# Ensure ~/uDESK exists and run everything in that directory (subshell for piped execution)
mkdir -p "$HOME/uDESK"
(
    cd "$HOME/uDESK"
    if [ ! -f "install.sh" ]; then
            echo "📦 Downloading install.sh..."
            curl -L "https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh" -o install.sh
            chmod +x install.sh
    fi

    echo "🚀 Running main uDESK installer (cross-platform logic in install.sh)..."
    bash install.sh dev
)

# All output and next steps are handled by install.sh
