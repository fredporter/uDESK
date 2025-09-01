#!/bin/bash
# Install Claude Code in TinyCore Linux
# This script downloads and sets up Claude Code CLI for TinyCore

set -e

echo "🤖 Installing Claude Code for TinyCore..."
echo "========================================"

# Check for internet connection
if ! ping -c 1 google.com >/dev/null 2>&1; then
    echo "❌ No internet connection. Please enable networking:"
    echo "   sudo dhcp.sh"
    exit 1
fi

echo "✅ Internet connection verified"

# Create installation directory
INSTALL_DIR="/opt/claude-code"
BIN_DIR="/usr/local/bin"

sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$BIN_DIR"

# Download Claude Code (using generic Linux x64 build)
echo "📥 Downloading Claude Code..."
cd /tmp

# Try different download methods
DOWNLOAD_URL="https://github.com/anthropics/claude-code/releases/latest/download/claude-code-linux-x64.tar.gz"

if command -v wget >/dev/null 2>&1; then
    wget -O claude-code.tar.gz "$DOWNLOAD_URL" || {
        echo "⚠ wget failed, trying curl..."
        curl -L -o claude-code.tar.gz "$DOWNLOAD_URL"
    }
elif command -v curl >/dev/null 2>&1; then
    curl -L -o claude-code.tar.gz "$DOWNLOAD_URL"
else
    echo "❌ No download tool available. Installing curl..."
    tce-load -wi curl.tcz
    curl -L -o claude-code.tar.gz "$DOWNLOAD_URL"
fi

echo "📦 Extracting Claude Code..."
tar -xzf claude-code.tar.gz

# Install Claude Code
echo "🔧 Installing Claude Code..."
sudo mv claude-code "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/claude-code"

# Create symlink in PATH
sudo ln -sf "$INSTALL_DIR/claude-code" "$BIN_DIR/claude-code"
sudo ln -sf "$INSTALL_DIR/claude-code" "$BIN_DIR/claude"

# Verify installation
echo "🧪 Testing installation..."
if command -v claude-code >/dev/null 2>&1; then
    echo "✅ Claude Code installed successfully!"
    echo ""
    echo "Version info:"
    claude-code --version || echo "Claude Code is ready to use"
    echo ""
else
    echo "❌ Installation failed"
    exit 1
fi

# Make persistent for TinyCore
echo "💾 Making Claude Code persistent..."
echo "usr/local/bin/claude-code" >> /opt/.filetool.lst 2>/dev/null || true
echo "opt/claude-code" >> /opt/.filetool.lst 2>/dev/null || true

# Create desktop shortcut if X is running
if [ -n "$DISPLAY" ] && [ -d "/home/tc/Desktop" ]; then
    echo "🖥️ Creating desktop shortcut..."
    cat > /home/tc/Desktop/claude-code.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Claude Code
Comment=Claude Code CLI
Exec=aterm -e claude-code
Icon=terminal
Terminal=false
Categories=Development;TextEditor;
EOF
    chmod +x /home/tc/Desktop/claude-code.desktop
fi

# Create quick start guide
cat > /home/tc/claude-code-quickstart.md << 'EOF'
# Claude Code Quick Start

## Getting Started
```bash
# Start Claude Code
claude-code

# Or use the short alias
claude
```

## Common Commands
```bash
# Get help
claude-code --help

# Check version
claude-code --version

# Start in a specific directory
cd /path/to/project
claude-code
```

## Tips for TinyCore
- Claude Code works best with internet connection
- Use `sudo dhcp.sh` to enable networking
- Files are saved to your home directory by default
- Consider making your project directory persistent

## Authentication
On first run, Claude Code will guide you through authentication.
Have your Anthropic API credentials ready.

## Integration with uDESK
Claude Code works perfectly with uDESK's markdown-everything philosophy:
- Edit .md configuration files
- Create documentation
- Generate scripts and automation
- Develop and debug system components

Enjoy coding with Claude! 🤖✨
EOF

echo ""
echo "🎉 Claude Code installation complete!"
echo ""
echo "Quick start:"
echo "  claude-code              # Start Claude Code"
echo "  claude                   # Short alias"
echo "  cat ~/claude-code-quickstart.md  # Read the guide"
echo ""
echo "For uDESK development:"
echo "  cd /mnt/sdb1             # Go to shared folder"
echo "  claude-code              # Start coding with Claude"
echo ""
echo "Your AI coding assistant is ready! 🤖"

# Clean up
rm -f /tmp/claude-code.tar.gz