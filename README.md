# uDESK - Universal Desktop OS

[![Version](https://img.shields.io/badge/version-1.0.7-blue.svg)](#current-status)
[![Status](https://img.shields.io/badge/status-Production%20Ready-green.svg)](#quick-start)
[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)](#package-status)

uDESK provides TinyCore Linux integration for **uDOS (Universal Device Operating System)**, featuring a modern Tauri application, lightweight development environment, and role-based system architecture.

## 🚀 **Quick Start** (Choose Your Platform)

### **macOS** 🍎
Double-click `Launch-uDESK-macOS.command` or run:
```bash
./Launch-uDESK-macOS.command
```

### **Ubuntu/Debian** 🐧  
```bash
./uDESK-Ubuntu.sh
```

### **Windows** 🪟
Double-click `uDESK-Windows.bat` or run:
```cmd
uDESK-Windows.bat
```

> 💡 **All launchers now include:**
> - Interactive startup menu with 6 options
> - Modern Tauri GUI with automated setup
> - Terminal interface for power users
> - Built-in dependency installation
> - Documentation and help system

## 🎯 **New Architecture**

### **Three Clear Modes:**
- **👤 User Mode**: Standard users (all roles: GHOST → WIZARD)
- **🧙‍♀️ Wizard Role**: Highest user role with extension development  
- **�️ Dev Mode**: Special development capabilities from ~/uDESK/dev/### **Mode Commands:**
```bash
./installers/build.sh user    # User Mode build
./installers/build.sh wizard  # Wizard Role build  
./installers/build.sh dev     # Legacy dev mode build
./installers/build.sh iso     # TinyCore ISO generation
```

### **Wizard Role Features:**
- **Extension Development**: Always available in `~/uDESK/uMEMORY/sandbox/`
- **[DEV-MODE]**: Core system development in `~/uDESK/dev/` (restricted)
- **Unified Interface**: Single wizard with role-based capabilities

---

## ✨ Integration Features

🎯 **Hybrid Distribution**: GitHub, TCZ package, and offline installation methods  
⚡ **Boot Integration**: ASCII art branding and automatic environment setup  
� **Role Hierarchy**: M1 CLI foundation + M2 8-role system (GHOST to WIZARD)  
🖥️ **VNC Desktop**: Full desktop environment with copy-paste functionality  
🚀 **Complete Automation**: Hands-off installation and configuration  
� **TinyCore Native**: Leverages TCZ packages and boot automation  

## 🚀 Quick Start

### Automatic Platform Setup (Recommended)
```bash
# macOS (with Xcode tools auto-install)
./Launch-uDOS-macOS.command

# Ubuntu/Debian (with build-essential auto-install)  
./Launch-uDOS-Ubuntu.sh

# Windows (with MinGW/MSYS2 guidance)
./Launch-uDOS-Windows.bat
```

### Manual Build & Install
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Build for your mode
./build.sh user          # Most users
./build.sh wizard        # WIZARD role with extension development
./build.sh developer     # Core development mode

# Install system-wide
sudo ./installers/install.sh
```

### Modern Tauri App (Optional)
```bash
# Development interface
cd app
npm install
npm run tauri dev

# Production build
npm run tauri build
```

### Verification
```bash
# Test installation
echo "[INFO]" | ./build/user/udos     # Test uCODE system
udos help                             # Show all commands (if installed)
```

## 🏗️ Project Structure

```
uDESK/
├── app/          # Modern Tauri application
│   ├── src/                # React frontend
│   ├── tauri/              # Rust backend
│   └── package.json        # Node.js dependencies
├── core/                   # Core uDESK system
│   ├── docs/               # Documentation
│   └── tc/                 # TinyCore integration
├── build/                  # Build outputs
│   ├── user/               # User mode binaries
│   ├── wizard/              # Wizard role binaries
│   └── clean-udos/         # Clean uDOS system
├── build.sh                # Unified build system
├── install.sh              # System installer
├── Launch-uDOS-macOS.command    # macOS launcher
├── Launch-uDOS-Ubuntu.sh        # Ubuntu launcher  
└── Launch-uDOS-Windows.bat      # Windows launcher
```

## 🌟 Key Features

### ⚡ **Lightning Fast Setup**
- **Zero Dependencies**: Only requires GCC (auto-installed)
- **30-Second Build**: From download to running executable
- **Cross-Platform**: macOS, Ubuntu, Windows support
- **No Complex Toolchains**: Eliminated npm/Rust complexity

### 🏗️ **Clean Architecture**
- **Role Separation**: User/Wizard/Developer builds
- **Tauri Integration**: Modern web-based interface option
- **TinyCore Native**: 7 core uDOS system commands
- **Role-Based Access**: GHOST to WIZARD hierarchy

### 🔧 **uCODE Command System**
Built-in commands for system management:
```bash
BACKUP    - Create system backups using TinyCore filetool
RESTORE   - Restore from backup archives  
DESTROY   - Secure system cleanup
REBOOT    - Safe system restart
REPAIR    - File system repair with fsck
UNDO      - Reverse last operation
REDO      - Replay last successful operation
```

## 🎯 **Mode Overview**

### **👤 User Mode** (Default)
- Standard uDOS functionality
- All user roles (GHOST → WIZARD) 
- Lightweight, fast execution
- Production-ready

### **🧙‍♀️ Wizard Role** (Highest User Role)
- WIZARD role with extension development capabilities
- Advanced system features
- Enhanced command set
- For power users

### **� Developer Mode** (Advanced)
- Core system development
- Full debugging capabilities  
- Development tools included
- For contributors

## 🚀 **Deployment Options**

### **Native Build** (Recommended)
- Single executable
- No external dependencies
- Cross-platform compatible
- Fast execution

### **Tauri App** (Modern UI)
- Web-based interface
- Modern React frontend
- Container management
- Rich visualizations

### **TinyCore Integration**
- ISO generation support
- TCZ package creation
- Boot integration
- Native TinyCore commands## 🖥️ Desktop Environment

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
## ⚙️ **Configuration & Environment**

### **Environment Variables**
```bash
# System Configuration
export UDOS_ROLE="GHOST"        # Default role (GHOST to WIZARD)
export UDOS_MODE="USER"         # Mode (USER/WIZARD/DEVELOPER)

# Development Environment  
export UDESK_VERSION="1.0.7"    # Version tracking
export UDESK_BUILD_MODE="user"  # Build mode selection
```

### **Command Examples**
```bash
# Check system status
echo "[INFO] System check" | ./build/user/udos

# Role detection and upgrade
echo "[ROLE] check" | ./build/user/udos

# Help and information
echo "[HELP]" | ./build/user/udos
```

## 📚 **Documentation**

### **User Documentation**
- **[Quick Start Guide](core/docs/QUICKSTART.md)** - Complete installation and setup (30 seconds)
- **[uCODE Command Manual](core/docs/UCODE-MANUAL.md)** - Complete command language reference
- **[Tauri App Guide](app/README.md)** - Modern desktop interface

### **Developer Documentation**
- **[Architecture Guide](core/docs/ARCHITECTURE.md)** - v1.0.7 clean system architecture
- **[Build System](core/docs/BUILD.md)** - Unified build system documentation
- **[Contributing Guide](core/docs/CONTRIBUTING.md)** - Development guidelines and workflows
- **[Style Guide](core/docs/STYLE-GUIDE.md)** - Code and documentation standards
- **[v1.0.7 Roadmap](core/docs/V1_0_7-ROADMAP.md)** - Development roadmap and feature timeline
- **[Development Archive](core/docs/dev/)** - Historical development documentation

## 🔧 **Development & Building**

### **Development Setup**
```bash
# Clone and build
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Quick development build
./build.sh developer

# Tauri development
cd app && npm run tauri dev
```

### **Testing & Validation**
```bash
# Test builds
echo "[INFO]" | ./build/user/udos
echo "[INFO]" | ./build/wizard-plus/udos  
echo "[INFO]" | ./build/developer/udos

# Validate installation
sudo ./installers/install.sh --test
```

## 🐛 **Troubleshooting**

### **Common Issues**
- **Missing GCC**: Platform launchers auto-install build tools
- **Permission Denied**: Use `chmod +x` on script files
- **Build Failures**: Ensure clean directory with `make clean`

### **Getting Help**
```bash
# Built-in help
echo "[HELP]" | ./build/user/udos

# Version information  
echo "[INFO]" | ./build/user/udos

# System diagnostics
./build.sh developer --verbose
```

---

**uDESK v1.0.7.2** | Universal Desktop OS  
*Production Ready* | *Cross-Platform* | *Zero Dependencies*