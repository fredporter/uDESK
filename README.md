# uDESK - ## ✨ Integration Features

🎯 **Hybrid Distribution**: GitHub, TCZ package, and offline installation methods  
⚡ **Boot Integration**: ASCII art branding and automatic environment setup  
🔐 **Role Hierarchy**: M1 CLI foundation + M2 8-role system (GHOST to WIZARD)  
🖥️ **VNC Desktop**: Full desktop environment with copy-paste functionality  
🚀 **Complete Automation**: Hands-off installation and configuration  
📦 **TinyCore Native**: Leverages TCZ packages and boot automation  

## 🌐 Ecosystem Platform

🔌 **Plugin System**: Install, manage, and run plugins with simple commands  
🔄 **Dual-Mode Operation**: Shell-based plugins (universal) + Node.js plugins (enhanced)  
🎯 **Auto-Detection**: Seamlessly uses Node.js when available, graceful fallback  
📦 **TinyCore Integration**: Native Node.js installation via TCZ packages  
🛠️ **Developer Tools**: Plugin templates, installation scripts, comprehensive docs  
🔒 **Security Framework**: Permission system and trusted plugin sources  l Device Operating System for TinyCore

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](#current-status)
[![Status](https://img.shields.io/badge/status-Production%20Ready-green.svg)](#quick-start)
[![Build](https://img.shields.io/badge/build-passgit clone https://github.com/fredporter/uDESK.git
cd uDESK/vm/current
./install.sh-brightgreen.svg)](#package-status)

uDESK provides TinyCore Linux integration for **uDOS (Universal Device Operating System)**, enabling the complete uDOS CLI suite, role hierarchy system, and desktop environment in TinyCore's minimal Linux environment.

## ✨ Integration Features

🎯 **Hybrid Distribution**: GitHub, TCZ package, and offline installation methods  
⚡ **Boot Integration**: ASCII art branding and automatic environment setup  
� **Role Hierarchy**: M1 CLI foundation + M2 8-role system (GHOST to WIZARD)  
🖥️ **VNC Desktop**: Full desktop environment with copy-paste functionality  
🚀 **Complete Automation**: Hands-off installation and configuration  
� **TinyCore Native**: Leverages TCZ packages and boot automation  

## 🚀 Quick Start

### Automatic Installation (Recommended)
```bash
# Download and run installer
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install.sh
chmod +x install.sh
./install.sh
```

### One-Line Setup
```bash
# Complete setup for fresh TinyCore VM
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/setup.sh
chmod +x setup.sh && ./setup.sh
```

### Manual Setup
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK/vm/current/

# Run installer
./install.sh

# Setup boot integration
./udos-boot-art.sh setup
```
### Verification
```bash
# Test installation
udos help                 # Show all commands
udos info                 # System information  
udos version              # Version information
udos auto                 # Start full environment

# Test role system
udos-detect-role          # Show current role
udos role status          # Role hierarchy status
```

## 📦 Distribution Methods

### 🌐 GitHub Installation (Recommended)
- **Source**: Raw GitHub files
- **Requirements**: Network connectivity
- **Speed**: Fast, always latest version
- **Use case**: Standard installations

### 📦 TCZ Package Installation  
- **Source**: TinyCore extension packages
- **Requirements**: TinyCore Linux
- **Speed**: Very fast, optimized
- **Use case**: TinyCore native deployments

### 💾 Offline Installation
- **Source**: Local installation bundle
- **Requirements**: No network needed
- **Speed**: Fast, self-contained
- **Use case**: Air-gapped environments

## 🎯 uDOS Role Hierarchy

The complete 8-role system from uDOS is available in TinyCore:

### Core Roles
- **👻 GHOST (10)** - Minimal observer access
- **⚰️ TOMB (20)** - Read-only system access  
- **🔐 CRYPT (30)** - Basic encrypted operations
- **🤖 DRONE (40)** - Automated task execution

### Advanced Roles  
- **⚔️ KNIGHT (50)** - Standard user privileges
- **😈 IMP (60)** - Enhanced user operations
- **🧙‍♂️ SORCERER (80)** - Advanced system control
- **🧙‍♀️ WIZARD (100)** - Full administrative access

## 🖥️ Desktop Environment

### VNC Integration
```bash
# Start VNC desktop
udos-vnc start

# Configure VNC settings
udos-vnc config

# Check VNC status
udos-vnc status
```

**Features**:
- Full desktop environment in TinyCore
- Copy-paste functionality between host/VM
- Remote access capabilities
- Secure password protection

## 🏗️ Project Structure

```
uDESK/
├── README.md                    # Project overview
├── vm/                          # TinyCore integration
│   ├── current/                # Production files
│   │   ├── install.sh         # Main installer
│   │   ├── udos-boot-art.sh   # Boot integration
│   │   └── README.md          # Installation guide
│   └── archive/               # Development history
│       ├── legacy/            # Superseded scripts  
│       └── troubleshooting/   # Diagnostic tools
├── build/                      # Built uDOS packages
├── docs/                       # Documentation
├── packaging/                  # Build scripts
└── src/                       # Source code
```

## � Advanced Configuration

### Environment Variables
```bash
# VNC Configuration
export UDOS_VNC_PASSWORD="your-secure-password"
export UDOS_AUTO_VNC="yes"
export UDOS_DESKTOP="yes"

# Role Configuration  
export UDOS_DEFAULT_ROLE="knight"
export UDOS_AUTO_DETECT="yes"

# Boot Configuration
export UDOS_BOOT_ART="yes"
export UDOS_AUTO_START="yes"
```

### Boot Integration
```bash
# Setup automatic boot integration
./udos-boot-art.sh setup

# Test ASCII art displays
./udos-boot-art.sh test

# Remove boot integration
./udos-boot-art.sh remove
```

## 🚀 Development Features

### Command Suite
The complete uDOS CLI is available:
- `udos` - Main command router
- `uvar` - Variable management
- `udata` - Data operations  
- `utpl` - Template processing
- `udos-detect-role` - Role detection
- `udos-vnc` - VNC management
- `udos-boot-config` - Boot configuration

### TinyCore Integration
- **Native TCZ packages** for optimal performance
- **Boot automation** via bootlocal.sh integration
- **Persistent configuration** through filetool.lst
- **Desktop environment** with VNC support
- **Package management** integration

*Generated: 2025-01-15 10:30:45*
```

## 🔧 Development & Building

### Quick Build Commands
```bash
# Build everything
./build.sh --clean

# Build specific components  
./build.sh --core-only        # Just core package
./build.sh --roles-only       # Just role packages
./build.sh --role admin       # Specific role + dependencies

# Test built packages
./test-m1.sh                  # Integration tests
```

### Package Inspection
```bash
# View package contents
tar -tzf build/udos-core.tcz
## 🐛 Troubleshooting

### Installation Issues
```bash
# Network connectivity problems
./install.sh                   # Standard installation

# Permission issues  
sudo ./install.sh              # Run with admin privileges

# Installation verification
./install.sh --verify          # Install with verification
```

### TinyCore Specific
```bash
# Packages don't persist
sudo filetool.sh -b            # Backup configuration
tce-load -i package.tcz        # Reload packages

# VNC not starting
udos-vnc config                # Reconfigure VNC
udos-vnc start                 # Manual start

# Role detection issues
udos-detect-role --reset       # Reset role detection
```

## 🎯 Current Status

✅ **M1 Complete**: Modular command interface with external modules  
✅ **M2 Complete**: Ecosystem platform with plugin management  
✅ **TinyCore Integration**: Native boot and desktop support  
✅ **Node.js Integration**: Enhanced features with automatic installation  
✅ **Universal Compatibility**: Works with or without dependencies  
✅ **Production Ready**: Fast, modular, and well-documented  

### Ready for Use!
- **Installation**: One-command installer with ecosystem platform
- **Plugin System**: Comprehensive plugin management commands  
- **Modular Design**: Fast core with external modules
- **Universal Compatibility**: POSIX shell with optional Node.js enhancement

## 📚 Documentation

- **[Installation Guide](docs/INSTALL.md)** - Complete setup instructions
- **[Architecture](docs/ARCHITECTURE.md)** - System architecture and design
- **[Ecosystem Guide](docs/ECOSYSTEM.md)** - Plugin platform documentation
- **[Development](dev/README.md)** - Development scripts and tools

### Development Documentation
- **[M1 Foundation Complete](docs/dev/M1-FOUNDATION-COMPLETE.md)** - Core architecture completion
- **[M2 Ecosystem Complete](docs/dev/M2-ECOSYSTEM-COMPLETE.md)** - Plugin platform completion
- **[Future Roadmap](docs/roadmaps/ROADMAP.md)** - Next phase development plans

## 📁 Repository Structure

```
uDESK/
├── install.sh           # Main installer (user-facing)
├── README.md             # Project overview and quick start
├── docs/                 # Complete documentation
│   ├── ARCHITECTURE.md   # System architecture
│   ├── ECOSYSTEM.md      # Plugin platform guide
│   ├── INSTALL.md        # Installation instructions
│   └── roadmaps/         # Development roadmaps
├── dev/                  # Development scripts (contributors)
│   ├── build.sh          # Build script
│   ├── test.sh           # Testing script
│   ├── cleanup-repo.sh   # Repository maintenance
│   └── README.md         # Development guide
├── usr/                  # uDOS system files
│   ├── bin/udos          # Main uDOS command
│   └── share/udos/       # External modules and ecosystem
└── etc/                  # Configuration files
```

### For Users
- **Quick Start**: `./install.sh` (main installer)
- **Documentation**: `/docs/` directory
- **System Files**: `/usr/` directory (installed automatically)

### For Developers  
- **Development Scripts**: `/dev/` directory
- **Build Tools**: `./dev/build.sh`
- **Testing**: `./dev/test.sh`

## 🤝 Contributing

uDESK provides TinyCore integration for the Universal Device Operating System:

```markdown
# Development Focus
1. **TinyCore Compatibility**: POSIX shell compliance
2. **Boot Integration**: Seamless startup automation
3. **Package Management**: TCZ and hybrid distribution
4. **Desktop Environment**: VNC and accessibility
5. **Documentation**: Comprehensive user guides
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🎉 Ready to Deploy Universal Device Operating System!

```bash
# Quick installation
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install.sh | bash

# Or manual setup
git clone https://github.com/fredporter/uDESK.git
cd uDESK/vm/current/
./install.sh
```

### The Achievement
- **Complete Ecosystem Platform**: Full plugin management system
- **Modular Architecture**: 75% script size reduction with enhanced features
- **Universal Compatibility**: Works on any POSIX system
- **Node.js Integration**: Enhanced features with automatic TinyCore installation
- **Production Ready**: Comprehensive testing and documentation

### Next Steps
1. Run the installer: `./install.sh`
2. Explore ecosystem: `udos ecosystem list`
3. Install plugins: `udos ecosystem install <plugin>`
4. Start using the modular uDOS system!

*Welcome to uDESK - Modular uDOS with ecosystem platform! 🚀*

---

> **uDESK v1.1.0** - Modular Universal Device Operating System with comprehensive ecosystem platform and plugin management.