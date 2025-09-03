#!/bin/sh
# TinyCore Bootstrap for uDOS Git Deployment
# Run this FIRST in a fresh TinyCore VM

echo "🔧 TinyCore Bootstrap for uDOS"
echo "=============================="

# Enable networking
echo "📡 Enabling networking..."
sudo dhcp.sh
if [ $? -eq 0 ]; then
    echo "✅ Network enabled"
else
    echo "❌ Network setup failed"
    exit 1
fi

# Test connectivity
echo "🌐 Testing connectivity..."
if ping -c 1 github.com >/dev/null 2>&1; then
    echo "✅ Internet connectivity confirmed"
else
    echo "❌ No internet connectivity"
    exit 1
fi

# Install essential tools
echo "📦 Installing essential tools..."

tools="curl bash git wget nano"
for tool in $tools; do
    echo "Installing $tool..."
    if tce-load -wi "$tool.tcz" 2>/dev/null; then
        echo "✅ $tool installed"
    else
        echo "⚠️  $tool failed (may not be available)"
    fi
done

# Verify critical tools
echo "🔍 Verifying installation..."
for tool in curl bash git; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool available"
    else
        echo "❌ $tool NOT available"
        echo "Please manually install: tce-load -wi $tool.tcz"
        exit 1
    fi
done

echo ""
echo "🎉 Bootstrap complete! Now run:"
echo ""
echo "curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/git-deploy.sh | bash"
echo ""
