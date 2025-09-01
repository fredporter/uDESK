#!/bin/sh
# Download and install uDOS from GitHub (UTM-friendly)
# Compatible with both sh and bash

set -e

echo "🚀 uDOS GitHub Installation..."

# Install bash first if not available
if ! command -v bash >/dev/null 2>&1; then
    echo "📦 Installing bash..."
    tce-load -wi bash
    
    # Verify bash installation
    if ! command -v bash >/dev/null 2>&1; then
        echo "❌ Failed to install bash. Continuing with sh..."
        USE_SH=true
    else
        echo "✅ bash installed successfully"
        USE_SH=false
    fi
else
    USE_SH=false
fi

# Install curl first if not available
if ! command -v curl >/dev/null 2>&1; then
    echo "📦 Installing curl..."
    tce-load -wi curl
    
    # Verify curl installation
    if ! command -v curl >/dev/null 2>&1; then
        echo "❌ Failed to install curl. Manual installation required."
        echo "Try: tce-load -wi curl"
        exit 1
    fi
    echo "✅ curl installed successfully"
fi

# Check internet connectivity
if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "❌ No internet connection"
    exit 1
fi

# GitHub raw URL base
GITHUB_RAW="https://raw.githubusercontent.com/fredporter/uDESK/main/build/uDOS-core/usr/local/bin"

echo "📥 Downloading uDOS CLI tools..."

# Create directories
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/local/share/udos/templates

# Download main CLI tools
echo "Downloading udos..."
curl -sL "${GITHUB_RAW}/udos" | sudo tee /usr/local/bin/udos > /dev/null

echo "Downloading uvar..."
curl -sL "${GITHUB_RAW}/uvar" | sudo tee /usr/local/bin/uvar > /dev/null

echo "Downloading udata..."
curl -sL "${GITHUB_RAW}/udata" | sudo tee /usr/local/bin/udata > /dev/null

echo "Downloading utpl..."
curl -sL "${GITHUB_RAW}/utpl" | sudo tee /usr/local/bin/utpl > /dev/null

# Make executable
sudo chmod +x /usr/local/bin/udos*
sudo chmod +x /usr/local/bin/uvar
sudo chmod +x /usr/local/bin/udata
sudo chmod +x /usr/local/bin/utpl

# Download default template
curl -sL "https://raw.githubusercontent.com/fredporter/uDESK/main/build/uDOS-core/usr/local/share/udos/templates/document.md" | \
    sudo tee /usr/local/share/udos/templates/document.md > /dev/null

# Add to persistence
if [ -f /opt/.filetool.lst ]; then
    grep -qxF 'usr/local/bin/udos' /opt/.filetool.lst || echo 'usr/local/bin/udos' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/uvar' /opt/.filetool.lst || echo 'usr/local/bin/uvar' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/udata' /opt/.filetool.lst || echo 'usr/local/bin/udata' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/utpl' /opt/.filetool.lst || echo 'usr/local/bin/utpl' >> /opt/.filetool.lst
    grep -qxF 'usr/local/share/udos' /opt/.filetool.lst || echo 'usr/local/share/udos' >> /opt/.filetool.lst
    grep -qxF 'home/tc/.udos' /opt/.filetool.lst || echo 'home/tc/.udos' >> /opt/.filetool.lst
fi

# Initialize uDOS
udos init

echo ""
echo "✅ uDOS GitHub Installation Complete!"
echo ""
echo "Test the installation:"
echo "  udos version"
echo "  udos info"
echo "  udos var set EDITOR=micro"
echo "  udos var list"
echo "  udos tpl list"
echo ""
echo "Full CLI tools available:"
echo "  udos  - Main CLI"
echo "  uvar  - Variables"
echo "  udata - Data management"
echo "  utpl  - Templates"
echo ""
