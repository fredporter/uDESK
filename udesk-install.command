#!/bin/bash
# uDESK macOS Desktop Installer (Minimal Wrapper)
# Download and run to install uDESK v1.0.7.x

set -e

clear
echo "🍏 uDESK macOS Installer v1.0.7.x"
echo "====================================="
echo ""
echo "This installer will:"
echo "• Install Xcode Command Line Tools (if needed)"
echo "• Download and run the cross-platform install.sh"
echo "• Set up your uDESK system in ~/uDESK"
echo ""

# Install Xcode Command Line Tools if not present
if ! xcode-select -p &>/dev/null; then
    echo "🔧 Installing Xcode Command Line Tools..."
    xcode-select --install || true
    echo "Please complete the Xcode Command Line Tools installation, then re-run this script."
    exit 1
fi

echo "✅ Xcode Command Line Tools installed."

# Install Homebrew if not present (optional, for git/curl/node)
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew (for git, curl, node)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure git, curl, and node are installed
brew install git curl node

# Download and run the main cross-platform installer
cd "$HOME"
if [ ! -f "uDESK/install.sh" ]; then
    echo "📦 Downloading install.sh..."
    mkdir -p "$HOME/uDESK"
    curl -L "https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh" -o "$HOME/uDESK/install.sh"
    chmod +x "$HOME/uDESK/install.sh"
fi

echo "🚀 Running main uDESK installer (cross-platform logic in install.sh)..."
bash "$HOME/uDESK/install.sh" dev

# All output and next steps are handled by install.sh
