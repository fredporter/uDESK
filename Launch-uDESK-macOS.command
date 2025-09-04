#!/bin/bash
# uDESK v1.0.7 - macOS Double-Click Launcher
# This file can be double-clicked in Finder to launch uDESK

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🍎 uDESK v1.0.7 - macOS Launcher"
echo "================================"
echo "📁 Working directory: $SCRIPT_DIR"
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This launcher is for macOS only"
    echo "   Use uDESK-Ubuntu.sh or uDESK-Windows.bat instead"
    read -p "Press any key to exit..."
    exit 1
fi

# Check for Xcode Command Line Tools
if ! command -v gcc &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    echo "   This will open a dialog - please follow the installation steps"
    echo ""
    xcode-select --install
    echo ""
    echo "⏳ Please complete the Xcode tools installation and run this launcher again"
    echo "   You can find this launcher in your uDESK folder"
    read -p "Press any key to exit..."
    exit 1
fi

# Set environment
export UDESK_ROLE="GHOST"
export UDESK_MODE="USER"

echo "🚀 Starting uDESK..."
echo "   Platform: macOS $(sw_vers -productVersion 2>/dev/null || echo 'Unknown')"
echo "   Architecture: $(uname -m)"
echo "   Role: $UDESK_ROLE"
echo "   Mode: $UDESK_MODE"
echo ""

# Check if build.sh exists
if [ ! -f "./build.sh" ]; then
    echo "❌ build.sh not found in current directory"
    echo "   Make sure this launcher is in your uDESK folder"
    read -p "Press any key to exit..."
    exit 1
fi

# Build and run
echo "🔨 Building uDESK User Mode..."
if ./build.sh user; then
    echo ""
    echo "✅ uDESK Build Complete!"
    echo ""
    echo "🎯 Available Commands:"
    echo "   User Mode:     ./build/user/udos"
    echo "   Wizard+ Mode:  UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus"
    echo "   Developer:     ./build/developer/udos-developer"
    echo ""
    echo "📱 Modern Interface:"
    echo "   Tauri App:     cd app/udesk-app && npm run tauri dev"
    echo ""
    echo "📖 Documentation:"
    echo "   README:        open README.md"
    echo "   User Manual:   open core/docs/UCODE-MANUAL.md"
    echo ""
    
    # Auto-start user mode
    echo "🚀 Launching uDESK User Mode..."
    echo "   Type 'exit' to quit, [HELP] for commands"
    echo ""
    
    if [ -f "./build/user/udos" ]; then
        ./build/user/udos
    else
        echo "❌ User mode binary not found after build"
        echo "   Build may have failed - check error messages above"
    fi
else
    echo ""
    echo "❌ Build failed! Check error messages above"
    read -p "Press any key to exit..."
    exit 1
fi

echo ""
echo "👋 uDESK session ended"
echo "   Double-click this launcher again to restart"
read -p "Press any key to close..."
