# Node.js Integration for uDOS on TinyCore

## TinyCore Package Extensions for Node.js

### Available Node.js Extensions
TinyCore Linux supports Node.js through package extensions:

1. **nodejs.tcz** - Core Node.js runtime
2. **nodejs-dev.tcz** - Development tools and headers
3. **npm.tcz** - Node Package Manager
4. **yarn.tcz** - Alternative package manager

### Installation Methods

#### Manual Installation
```bash
# Download and install Node.js extension
tce-load -wi nodejs

# Verify installation
node --version
npm --version
```

#### Automated Installation Script
```bash
#!/bin/sh
# install-nodejs.sh - Add Node.js to TinyCore

echo "🔄 Installing Node.js for uDOS..."

# Check if already installed
if command -v node >/dev/null 2>&1; then
    echo "✅ Node.js already installed: $(node --version)"
    exit 0
fi

# Install Node.js extension
if command -v tce-load >/dev/null 2>&1; then
    echo "📦 Installing nodejs.tcz..."
    tce-load -wi nodejs
    
    # Verify installation
    if command -v node >/dev/null 2>&1; then
        echo "✅ Node.js installed successfully: $(node --version)"
        echo "✅ npm installed: $(npm --version)"
    else
        echo "❌ Node.js installation failed"
        exit 1
    fi
else
    echo "❌ TinyCore package manager not found"
    echo "💡 Run this script on TinyCore Linux system"
    exit 1
fi
```

## uDOS Ecosystem with Node.js

### Enhanced Architecture
With Node.js available, the ecosystem can provide:

1. **Rich Plugin System** - Full JavaScript/Node.js plugins
2. **Package Management** - npm-style plugin distribution
3. **Remote Registry** - Connect to online plugin repositories
4. **Advanced Features** - Real-time updates, complex workflows

### Integration Strategy

#### Phase 1: Detect Node.js Availability
```bash
# In udos script
check_nodejs() {
    if command -v node >/dev/null 2>&1; then
        NODE_AVAILABLE=true
        NODE_VERSION=$(node --version)
        echo "✅ Node.js available: $NODE_VERSION"
    else
        NODE_AVAILABLE=false
        echo "⚠️  Node.js not available - limited ecosystem features"
    fi
}
```

#### Phase 2: Fallback Architecture
- **With Node.js**: Full-featured ecosystem with JavaScript plugins
- **Without Node.js**: Basic shell-based plugin system

#### Phase 3: Auto-Installation
```bash
# Smart Node.js installation
install_nodejs_if_needed() {
    if [ "$NODE_AVAILABLE" = "false" ] && command -v tce-load >/dev/null 2>&1; then
        echo "🤔 Node.js required for ecosystem features"
        read -p "Install Node.js now? (y/N): " answer
        case $answer in
            [Yy]*)
                echo "📦 Installing Node.js..."
                tce-load -wi nodejs
                check_nodejs
                ;;
            *)
                echo "💡 Continuing with basic features"
                ;;
        esac
    fi
}
```

## Implementation Plan

### 1. Create Node.js Detection System
- Add Node.js availability check to udos init
- Provide installation prompts when needed
- Graceful fallback for non-Node.js environments

### 2. Dual-Mode Ecosystem
- **Enhanced Mode**: Full JavaScript plugins with Node.js
- **Basic Mode**: Shell-based plugins without Node.js

### 3. TinyCore Integration
- Add Node.js installation script to build system
- Include in TinyCore distribution options
- Document Node.js setup procedures

### 4. Plugin Compatibility
- Support both JavaScript and shell plugins
- Plugin manifest specifies runtime requirements
- Automatic runtime detection and selection

## Benefits

### For TinyCore Users
- Modern JavaScript ecosystem access
- Rich plugin development environment
- Industry-standard package management
- Real-time features and web integration

### For uDOS Ecosystem
- Expanded developer community
- Access to npm ecosystem
- Advanced plugin capabilities
- Future-proof architecture

## Next Steps

1. ✅ Create Node.js detection and installation scripts
2. ⏳ Modify ecosystem to support dual-mode operation
3. ⏳ Update plugin architecture for Node.js compatibility
4. ⏳ Add Node.js to TinyCore build process
5. ⏳ Document Node.js integration procedures

This approach ensures uDOS works both with and without Node.js, while providing enhanced capabilities when available.
