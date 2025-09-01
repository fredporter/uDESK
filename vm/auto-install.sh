#!/bin/bash
# Auto-install uDOS-core on TinyCore VM boot

set -e

echo "🚀 uDOS Auto-Installation Starting..."

# Check if already installed
if command -v udos >/dev/null 2>&1; then
    echo "✅ uDOS already installed, skipping..."
    exit 0
fi

# Ensure we have internet connectivity
echo "🌐 Checking internet connectivity..."
if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "❌ No internet connection, cannot install uDOS"
    exit 1
fi

# Install dependencies first
echo "📦 Installing dependencies..."
tce-load -wi bash
tce-load -wi coreutils  
tce-load -wi util-linux
tce-load -wi git
tce-load -wi curl
tce-load -wi tmux
tce-load -wi htop
tce-load -wi python3

# Download and install Gemini CLI (free alternative to Claude)
echo "🤖 Installing Gemini CLI..."
if ! command -v gemini >/dev/null 2>&1; then
    # Install Node.js for Gemini CLI
    tce-load -wi nodejs
    
    # Install Gemini CLI globally
    npm install -g @google/generative-ai-cli || {
        echo "⚠️  Gemini CLI install failed, continuing without AI assistant"
    }
fi

# Create uDOS installation directory
mkdir -p /tmp/udos-install
cd /tmp/udos-install

# Download uDOS-core from local development (if available)
echo "📥 Installing uDOS-core..."

# Copy from mounted development folder (if available)
DEV_PATH="/mnt/hgfs/Code/uDESK"  # VMware shared folder
if [ -d "$DEV_PATH/build/uDOS-core" ]; then
    echo "🔧 Installing from development build..."
    cp -r "$DEV_PATH/build/uDOS-core/"* /
else
    # Fallback: create minimal installation
    echo "📦 Creating minimal uDOS installation..."
    
    # Create directory structure
    mkdir -p /usr/local/bin
    mkdir -p /usr/local/share/udos/templates
    mkdir -p /usr/local/tce.installed
    
    # Create basic udos command
    cat > /usr/local/bin/udos << 'EOF'
#!/bin/bash
# Minimal uDOS CLI for testing
echo "uDOS v1.0.0 (minimal install)"
case "$1" in
    init) 
        mkdir -p ~/.udos/{vars,data,templates,logs}
        echo "✅ uDOS initialized at ~/.udos"
        ;;
    info)
        echo "uDOS minimal installation"
        echo "User: $(whoami)"
        echo "Home: ~/.udos"
        ;;
    *)
        echo "Available commands: init, info"
        echo "Full installation pending..."
        ;;
esac
EOF
    
    chmod +x /usr/local/bin/udos
fi

# Make all scripts executable
chmod +x /usr/local/bin/udos* 2>/dev/null || true
chmod +x /usr/local/tce.installed/* 2>/dev/null || true

# Run post-install hooks
if [ -f /usr/local/tce.installed/uDOS-core ]; then
    /usr/local/tce.installed/uDOS-core
fi

# Initialize uDOS for tc user
echo "🔧 Initializing uDOS for user tc..."
su tc -c "udos init" || true

# Add to persistent storage
echo "💾 Adding to persistent storage..."
if [ -f /opt/.filetool.lst ]; then
    # Add if not already present
    grep -qxF 'usr/local/bin/udos' /opt/.filetool.lst || echo 'usr/local/bin/udos' >> /opt/.filetool.lst
    grep -qxF 'usr/local/share/udos' /opt/.filetool.lst || echo 'usr/local/share/udos' >> /opt/.filetool.lst
    grep -qxF 'home/tc/.udos' /opt/.filetool.lst || echo 'home/tc/.udos' >> /opt/.filetool.lst
fi

echo "✅ uDOS installation complete!"
echo "💡 Run 'udos info' to verify installation"

# Clean up
cd /
rm -rf /tmp/udos-install
