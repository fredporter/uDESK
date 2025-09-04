#!/bin/bash
# uDESK v1.0.7 - macOS Quickstart Launcher

echo "🍎 uDESK v1.0.7 - macOS Quickstart"
echo "=================================="

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This launcher is for macOS only"
    echo "   Use uDESK-Ubuntu.sh or uDESK-Windows.bat instead"
    exit 1
fi

# Check for Xcode Command Line Tools
if ! command -v gcc &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete installation and run this script again"
    exit 1
fi

# Set environment
export UDOS_ROLE="GHOST"
export UDOS_MODE="USER"

echo "🚀 Starting uDESK..."
echo "   Platform: macOS $(sw_vers -productVersion)"
echo "   Architecture: $(uname -m)"
echo "   Role: $UDOS_ROLE"

# Build and run
./build.sh user

echo ""
echo "✅ uDESK ready!"
echo ""
echo "🎯 Quick Commands:"
echo "   User Mode:     ./build/user/udos"
echo "   Wizard+ Mode:  UDOS_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus"
echo "   Developer:     ./build/developer/udos-developer"
echo ""
echo "📱 Tauri App:     cd app/udesk-app && npm run tauri dev"
echo "📖 Documentation: open README.md"

# Auto-start user mode
echo "🚀 Starting User Mode..."
./build/user/udos
