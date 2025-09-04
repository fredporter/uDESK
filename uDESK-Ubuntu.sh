#!/bin/bash
# uDESK v1.0.7 - Ubuntu/Debian Quickstart Launcher

echo "🐧 uDESK v1.0.7 - Ubuntu Quickstart"
echo "===================================="

# Check if we're on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ This launcher is for Ubuntu/Debian systems"
    echo "   Use uDESK-macOS.sh or uDESK-Windows.bat instead"
    exit 1
fi

# Install build essentials if needed
if ! command -v gcc &> /dev/null; then
    echo "📦 Installing build essentials..."
    sudo apt update
    sudo apt install -y build-essential git
fi

# Set environment
export UDOS_ROLE="GHOST"
export UDOS_MODE="USER"

echo "🚀 Starting uDESK..."
echo "   Platform: Ubuntu $(lsb_release -rs 2>/dev/null || echo 'Unknown')"
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
echo "📱 Tauri App (if Node.js installed):"
echo "   cd app/udesk-app && npm install && npm run tauri dev"
echo ""
echo "📖 Documentation: cat README.md"

# Auto-start user mode
echo "🚀 Starting User Mode..."
./build/user/udos
