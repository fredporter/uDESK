# uDESK v1.0.7.2 Getting Started

> Complete installation and development quick start guide

## 🚀 Quick Start (30 seconds)

### Option 1: Desktop Application (Recommended)
```bash
# Download and run installer
curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install.command
chmod +x udesk-install.command
./udesk-install.command         # macOS

curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install-linux.sh  
chmod +x udesk-install-linux.sh
./udesk-install-linux.sh        # Linux

curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install-windows.bat
# Run udesk-install-windows.bat  # Windows

# Build your preferred mode
./build.sh user                 # Essential features
./build.sh wizard               # Advanced features  
./build.sh developer            # Full development toolkit
```

### Option 2: Direct Build
```bash
# Clone and build
git clone <repo-url> uDESK
cd uDESK
./build.sh user && ./udos
```

---

## 📋 System Requirements

### Minimum Requirements
- **OS**: macOS 10.15+, Ubuntu 18.04+, Windows 10+
- **RAM**: 2GB (4GB recommended)
- **Storage**: 1GB free space
- **CPU**: x86_64 compatible
- **Dependencies**: Auto-installed by platform installers

### Development Requirements
- **RAM**: 4GB+ (for full development mode)
- **Storage**: 4GB+ (for development tools and extensions)
- **Network**: For downloading dependencies and extensions

---

## 🛠️ Installation Methods

### Method 1: Platform Installers (Recommended)

Each platform has an optimized installer that handles dependencies automatically:

#### macOS Installation
```bash
# Download uDESK installer
curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install.command
chmod +x udesk-install.command

# Run installer (handles dependencies automatically)
./udesk-install.command

# Dependencies auto-installed:
# - Xcode Command Line Tools
# - GCC compiler
# - Git (if not present)
```

#### Ubuntu/Debian Installation
```bash
# Download uDESK installer
curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install-linux.sh
chmod +x udesk-install-linux.sh

# Run installer (handles dependencies automatically)
./udesk-install-linux.sh

# Dependencies auto-installed:
# - build-essential package
# - Git
# - Basic development tools
```

#### Windows Installation
```bash
# Download uDESK installer
curl -O https://github.com/fredporter/uDESK/raw/main/udesk-install-windows.bat

# Run installer (provides guided setup)
# Double-click udesk-install-windows.bat

# Provides guidance for:
# - MinGW-w64 or MSYS2 installation
# - Git for Windows
# - Basic build environment
```

### Method 2: Manual Build

For advanced users who prefer manual control:

```bash
# Prerequisites (install manually)
# macOS: xcode-select --install
# Ubuntu: sudo apt install build-essential git
# Windows: Install MinGW-w64 or MSYS2

# Clone and build
git clone <repo-url> uDESK
cd uDESK
./build.sh developer
```

### Method 3: ISO Mode (Bootable System)

Create a bootable uDESK system:

```bash
# Build bootable ISO
./build.sh iso

# Results in bootable system image
# Can be written to USB or used in VMs
```

---

## 🎯 Build Modes

uDESK v1.0.7.2 uses a mode-based architecture for different use cases:

### User Mode
```bash
./build.sh user
```
- **Target**: General users and basic productivity
- **Features**: Essential commands, basic extensions
- **Size**: Minimal footprint
- **Use Case**: Daily computing, document management

### Wizard Mode  
```bash
./build.sh wizard
```
- **Target**: Power users and advanced workflows
- **Features**: Advanced commands, Dev Mode capabilities
- **Size**: Medium footprint
- **Use Case**: System administration, extension development

### Developer Mode
```bash
./build.sh developer
```
- **Target**: Software developers and system builders
- **Features**: Full development toolkit, all commands
- **Size**: Full footprint
- **Use Case**: Software development, system modification

### ISO Mode
```bash
./build.sh iso
```
- **Target**: Bootable system deployment
- **Features**: Self-contained bootable system
- **Size**: Complete system image
- **Use Case**: Deployment, testing, distribution

---

## 🖥️ First Boot & Setup

### Desktop Application First Run

After installing via platform installers:

1. **Mode Selection**: Choose your preferred mode (user/wizard/developer)
2. **Extension Setup**: Install recommended extensions
3. **Configuration**: Basic system configuration
4. **Ready**: Start using uDESK

### Command Line First Run

```bash
# Check system status
./udos status

# Get system information  
./udos info

# View available commands
./udos help

# Check current mode
./udos mode
```

### Configuration

Configuration is handled through the mode system:

```bash
# View current configuration
./udos config list

# Set configuration values
./udos config set theme dark
./udos config set mode developer

# Get configuration help
./udos config help
```

---

## 🔧 Development Quick Start

### Setting Up Development Environment

Perfect for rapid development and testing:

```bash
# Clone repository
git clone <repo-url> uDESK
cd uDESK

# Use platform installer for dependencies
./udesk-install.command         # macOS
./udesk-install-linux.sh        # Linux  
./udesk-install-windows.bat     # Windows

# Build for development
./build.sh developer

# Start desktop application (if desired)
cd app
npm run tauri dev
```

### Development Workflow

```bash
# Daily development cycle
# 1. Edit core system
nano uCORE/commands/my-command

# 2. Build and test
./build.sh developer
./udos test

# 3. Test desktop integration
cd app
npm run tauri dev

# 4. Build release when ready
./build.sh developer
```

### Extension Development

```bash
# Create new extension
./udos extension create "My Extension"

# Edit extension
nano extensions/user/my-extension/main.sh

# Test extension
./udos extension run my-extension test

# Install extension system-wide
./udos extension install my-extension
```

---

## 🎨 Customization

### Theme Configuration

```bash
# List available themes
./udos theme list

# Set theme
./udos theme set dark
./udos theme set light
./udos theme set retro

# Create custom theme
./udos theme create my-theme
```

### Extension Management

```bash
# Browse available extensions
./udos extension list --available

# Install extensions
./udos extension install "System Monitor"
./udos extension install "File Manager"

# Manage extensions
./udos extension enable system-monitor
./udos extension disable file-manager
./udos extension remove old-extension
```

### Mode Switching

```bash
# Check current mode
./udos mode

# Switch modes (requires rebuild)
./udos mode set wizard
./build.sh wizard

# Temporary mode override
./udos --mode developer status
```

---

## 🐛 Troubleshooting

### Common Issues

**Build fails with dependency errors**
```bash
# Solution: Use platform installer first
./udesk-install.command         # macOS
./udesk-install-linux.sh        # Linux
./udesk-install-windows.bat     # Windows

# Or manually install dependencies
# macOS: xcode-select --install
# Ubuntu: sudo apt install build-essential
# Windows: Install MinGW-w64
```

**Command not found**
```bash
# Solution: Check current mode
./udos mode

# Switch to appropriate mode
./build.sh developer

# Verify installation
./udos info
```

**Desktop app won't start**
```bash
# Solution: Install Node.js dependencies
cd app
npm install

# Build and run
npm run tauri dev
```

**Permission errors**
```bash
# Solution: Make scripts executable
chmod +x build.sh udesk-install*.{command,sh,bat}

# Check installer permissions
ls -la udesk-install*
```

### Debug Mode

```bash
# Enable debug output
export UDOS_DEBUG=1
./build.sh developer

# Check build logs
cat build/build.log

# Verify system state
./udos debug --system
```

### Getting Help

```bash
# Built-in help
./udos help
./udos help build
./udos help extension

# System information
./udos info
./udos status

# Version information
./udos version
```

---

## 📚 Next Steps

### For General Users
1. **Learn uCODE**: Read [USER-CODE-MANUAL.md](USER-CODE-MANUAL.md)
2. **Install Extensions**: Browse and install useful extensions
3. **Customize**: Set up themes and preferences
4. **Explore**: Try different modes to find your preference

### For Developers
1. **Read Architecture**: Review [ARCHITECTURE.md](ARCHITECTURE.md)
2. **Development Guidelines**: See [CONTRIBUTING.md](CONTRIBUTING.md)
3. **Build System**: Understand [BUILD.md](BUILD.md)
4. **Style Guide**: Follow [STYLE-GUIDE.md](STYLE-GUIDE.md)

### For Advanced Users
1. **Extension Development**: Create custom extensions
2. **System Modification**: Customize core system behavior
3. **Desktop Integration**: Enhance the Tauri application
4. **Cross-Platform Testing**: Validate across all platforms

---

## 🎉 Welcome to uDESK v1.0.7.2!

You now have a modern, cross-platform development environment with:
- ✅ **30-second setup** via platform installers
- ✅ **Mode-based architecture** for different use cases
- ✅ **Extension system** for customization
- ✅ **Cross-platform compatibility** (macOS/Ubuntu/Windows)
- ✅ **Desktop application** with native integration
- ✅ **Clean architecture** optimized for performance

Start building amazing things! 🚀
