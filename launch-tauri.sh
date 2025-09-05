#!/bin/bash
# uDESK Tauri App Launcher for macOS
# Creates and launches the Tauri desktop application

set -e

UDESK_DIR="$HOME/uDESK"
APP_DIR="$UDESK_DIR/app"
LAUNCHER_DIR="$HOME/.local/bin"

echo "🎨 uDESK Tauri App Launcher"
echo "=========================="

# Check if uDESK is installed
if [ ! -d "$UDESK_DIR" ]; then
    echo "❌ uDESK not found at $UDESK_DIR"
    echo "   Please run the uDESK installer first"
    exit 1
fi

# Check if app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "❌ Tauri app not found at $APP_DIR"
    echo "   The modern desktop interface is not installed"
    exit 1
fi

cd "$APP_DIR"

# Check for Node.js
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found - Node.js is required"
    echo "   Install from: https://nodejs.org/"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Tauri dependencies..."
    npm install
fi

# Check if we should build production app
if [ "$1" = "--build" ] || [ "$1" = "-b" ]; then
    echo "🏗️  Building production Tauri app..."
    echo "   This may take a few minutes..."
    
    npm run tauri:build
    
    if [ $? -eq 0 ]; then
        echo "✅ Production app built successfully!"
        echo "📂 Location: $APP_DIR/target/release/bundle/macos/"
        
        # Find the .app bundle
        APP_BUNDLE=$(find "$APP_DIR/target/release/bundle/macos/" -name "*.app" -type d | head -1)
        
        if [ -n "$APP_BUNDLE" ]; then
            echo "🚀 Opening production app..."
            open "$APP_BUNDLE"
        else
            echo "⚠️  App bundle not found - check build output"
        fi
    else
        echo "❌ Build failed - falling back to development mode"
        npm run tauri:dev
    fi
else
    echo "🚀 Launching development Tauri app..."
    echo "   Use --build flag to create production app with dock icon"
    npm run tauri:dev
fi
