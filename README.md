# uDESK - Universal Device Operating System for TinyCore

[![Version](https://img.shields.io/badge/version-1.0.5-blue.svg)](#current-status)
[![Status](https://img.shields.io/badge/status-Production%20Ready-green.svg)](#quick-start)
[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)](#package-status)

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
# Download and run hybrid installer
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install-udos.sh
chmod +x install-udos.sh
./install-udos.sh
```

### Manual Setup
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK/vm/current/

# Run installer
./install-udos.sh

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
│   │   ├── install-udos.sh    # Hybrid installer
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
./install-udos.sh offline      # Use offline installation

# Permission issues  
sudo ./install-udos.sh         # Run with admin privileges

# Package conflicts
./install-udos.sh github       # Force GitHub installation
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

✅ **M1 Complete**: Full CLI suite with role hierarchy  
✅ **M2 Complete**: 8-role system (GHOST to WIZARD)  
✅ **TinyCore Integration**: Native boot and desktop support  
✅ **VNC Desktop**: Copy-paste functionality working  
✅ **Hybrid Distribution**: GitHub/TCZ/offline installation  
✅ **Production Ready**: Comprehensive automation and documentation  

### Ready for Deployment!
- **Installation**: One-command hybrid installer
- **Integration**: Complete TinyCore boot automation
- **Documentation**: Comprehensive guides and troubleshooting
- **Compatibility**: Full POSIX shell compliance

## 📚 Documentation

- **[Installation Guide](vm/current/README.md)** - Complete setup instructions
- **[Boot Integration](vm/current/udos-boot-art.sh)** - ASCII art and branding
- **[Archive](vm/archive/README.md)** - Development history and tools
- **[uDOS Project](../uDOS/README.md)** - Main Universal Device Operating System

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
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install-udos.sh | bash

# Or manual setup
git clone https://github.com/fredporter/uDESK.git
cd uDESK/vm/current/
./install-udos.sh
```

### The Achievement
- **Complete uDOS Integration**: Full CLI suite in TinyCore
- **8-Role Hierarchy**: Progressive capability system
- **Hybrid Distribution**: Multiple installation methods
- **Boot Automation**: ASCII art branding and environment setup
- **Production Ready**: Comprehensive testing and documentation

### Next Steps
1. Run the hybrid installer
2. Configure role hierarchy
3. Setup desktop environment
4. Start using the Universal Device Operating System!

*Welcome to uDESK - TinyCore integration for Universal Device Operating System! 🚀*

---

> **uDESK v1.0.5** - Bringing the power of Universal Device Operating System to TinyCore Linux with complete automation, role hierarchy, and seamless integration.