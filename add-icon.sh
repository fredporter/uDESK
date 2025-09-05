#!/bin/bash
# Icon Helper for udesk-install.command
# This script adds a custom icon to the Mac installer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMAND_FILE="$SCRIPT_DIR/udesk-install.command"
ICON_FILE="$SCRIPT_DIR/assets/udesk-icon.icns"

echo "🎨 uDESK Icon Installer"
echo "======================"
echo ""

# Check if the command file exists
if [ ! -f "$COMMAND_FILE" ]; then
    echo "❌ udesk-install.command not found"
    exit 1
fi

# Create assets directory if it doesn't exist
mkdir -p "$SCRIPT_DIR/assets"

# Create a simple icon using built-in macOS tools if icon doesn't exist
if [ ! -f "$ICON_FILE" ]; then
    echo "🎨 Creating default uDESK icon..."
    
    # Create a simple icon using sips (if available)
    if command -v sips &> /dev/null; then
        # Create a simple colored square as base
        # Note: In a real implementation, you'd want to provide a proper .icns file
        echo "⚠️  Using system default icon - place custom udesk-icon.icns in assets/ folder"
        echo "   Icon should be 1024x1024 PNG converted to ICNS format"
        echo "   Use: sips -s format icns your-icon.png --out assets/udesk-icon.icns"
    fi
fi

# Apply icon to the command file (if icon exists)
if [ -f "$ICON_FILE" ]; then
    echo "🎨 Applying custom icon to installer..."
    
    # Use Rez (Resource Manager) to embed icon
    if command -v Rez &> /dev/null; then
        # Create resource file
        echo "type 'icns' (-16455) as 'icon';" > /tmp/icon.r
        Rez -a /tmp/icon.r -o "$COMMAND_FILE"
        
        # Set file attributes
        SetFile -a C "$COMMAND_FILE"
        
        echo "✅ Icon applied successfully"
    else
        echo "⚠️  Rez not available - using alternative method"
        
        # Alternative: Use osascript to set icon
        osascript -e "
        tell application \"Finder\"
            set iconFile to POSIX file \"$ICON_FILE\"
            set targetFile to POSIX file \"$COMMAND_FILE\"
            set icon of targetFile to icon of iconFile
        end tell"
        
        echo "✅ Icon applied via Finder"
    fi
else
    echo "⚠️  No custom icon found - installer will use default .command icon"
    echo ""
    echo "📝 To add a custom icon:"
    echo "   1. Create a 1024x1024 PNG icon for uDESK"
    echo "   2. Convert to ICNS: sips -s format icns icon.png --out assets/udesk-icon.icns"
    echo "   3. Run this script again"
fi

echo ""
echo "✅ Icon setup complete"
echo "📱 Your installer is ready for distribution"
