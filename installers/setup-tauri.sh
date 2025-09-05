#!/bin/bash
# uDESK v1.0.7 - Tauri Desktop App Setup Script
# Sets up the modern Tauri-based desktop interface

set -e

echo "📱 uDESK v1.0.7 - Tauri Desktop App Setup"
echo "=========================================="
echo ""
echo "💡 Note: This setup automatically syncs with the latest uDESK repository"
echo "   Repository location: uDESK/repository/"
echo "   Documentation: uDESK/docs/"
echo "   Workspace: uMEMORY/"
echo ""

# Check if we're in the right directory
if [ ! -f "build.sh" ] || [ ! -d "app" ]; then
    echo "❌ Please run this script from the uDESK root directory"
    echo "   Current: $(pwd)"
    echo "   Expected: Directory containing build.sh and app/"
    exit 1
fi

# Navigate to the Tauri app directory
cd app

echo "🔍 Checking Tauri prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found"
    echo "   Install with: brew install node (macOS) or apt install nodejs (Ubuntu)"
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found"
    echo "   Install with: brew install npm (macOS) or apt install npm (Ubuntu)"
    exit 1
fi

# Check Rust
if ! command -v cargo &> /dev/null; then
    echo "❌ Rust not found"
    echo "   Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

echo "✅ Prerequisites found:"
echo "   Node.js: $(node --version)"
echo "   npm: $(npm --version)"
echo "   Rust: $(cargo --version | head -1)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in app/"
    echo "   Creating basic Tauri project structure..."
    
    # Initialize basic Tauri project
    npm create tauri-app@latest . --yes --template react-ts --package-manager npm
fi

echo "📥 Installing npm dependencies..."
npm install

echo "🦀 Installing Tauri dependencies..."
npm install @tauri-apps/api @tauri-apps/cli

echo ""
echo "🎯 Setup Options:"
echo ""
echo "1) 🚀 Launch Development Mode"
echo "2) 🔨 Build Production Version"
echo "3) 🧪 Test Tauri Configuration"
echo "4) 📖 Show Launch Commands"
echo "5) 🔄 Return to uDESK root"
echo ""

read -p "Choose option (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Launching Tauri development mode..."
        echo "   This will open the uDESK desktop app in development mode"
        echo "   Hot reload enabled - changes will update automatically"
        echo ""
        npm run tauri dev
        ;;
    2)
        echo ""
        echo "🔨 Building production version..."
        npm run tauri build
        echo ""
        echo "✅ Production build complete!"
        echo "📁 Binary location: src-tauri/target/release/"
        ls -la src-tauri/target/release/ | grep -E "(udesk|udos)"
        ;;
    3)
        echo ""
        echo "🧪 Testing Tauri configuration..."
        npm run tauri info
        echo ""
        echo "🔍 Checking build dependencies..."
        npm run tauri check
        ;;
    4)
        echo ""
        echo "📖 Tauri Launch Commands:"
        echo ""
        echo "Development Mode:"
        echo "   cd app && npm run tauri dev"
        echo ""
        echo "Production Build:"
        echo "   cd app && npm run tauri build"
        echo "   ./app/src-tauri/target/release/udesk-app"
        echo ""
        echo "Configuration:"
        echo "   cd app && npm run tauri info"
        echo ""
        echo "Update Dependencies:"
        echo "   cd app && npm update"
        echo ""
        ;;
    5)
        echo ""
        echo "🔄 Returning to uDESK root directory..."
        cd ../..
        echo "📁 Current directory: $(pwd)"
        echo ""
        echo "💡 To launch Tauri later:"
        echo "   cd app && npm run tauri dev"
        ;;
    *)
        echo ""
        echo "❌ Invalid option. Returning to uDESK root..."
        cd ../..
        ;;
esac

echo ""
echo "✅ Tauri setup complete!"
echo ""
echo "🎯 Next Steps:"
echo "   • Development: cd app && npm run tauri dev"
echo "   • Production:  cd app && npm run tauri build"
echo "   • uDESK CLI:   ./build.sh user && ./build/user/udos"
echo ""
