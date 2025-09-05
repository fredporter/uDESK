# uDESK Architecture: Universal Development Environment & System Kit

## Overview
uDESK v1.0.7 provides TinyCore Linux integration for uDOS (Universal Device Operating System) with a clean, organized architecture featuring mode separation, cross-platform support, and modern Tauri application interface.

## Core Architecture

### Clean Build System Design
```
uDESK System/
├── Unified Build: build.sh (user/wizard/developer/iso modes)
├── Platform Launchers: uDESK-{platform}.sh (auto-dependency installation)
├── Modern Interface: Tauri application with uDOS branding
├── TinyCore Integration: 7 core uDOS system commands
└── Role System: 8-level progressive hierarchy (GHOST → WIZARD)
```

### Distribution Methods
- **Cross-Platform Builds**: Native macOS/Ubuntu/Windows support with zero dependencies
- **Tauri Application**: Modern web-based interface with React frontend
- **TinyCore Integration**: Native system commands and ISO generation
- **Mode Separation**: Clear User/Wizard+/Developer build distinction

## Technical Components

### 1. Build System (v1.0.7 - Complete)
**Unified Build Script**
- Single build.sh handling all modes (user/wizard/developer/iso)
- Fast GCC-only builds with 30-second setup time
- Cross-platform compatibility (macOS/Ubuntu/Windows)
- Zero external dependencies beyond GCC

**Mode Architecture**
- **User Mode**: Standard users, all roles (GHOST → WIZARD)
- **Wizard Mode**: WIZARD role with Dev Mode capabilities
- **Developer Mode**: Core system developers with full access
- **ISO Mode**: TinyCore ISO generation for specialized deployments

### 2. TinyCore Integration (v1.0.7 - Complete)
**Native System Commands**
- `BACKUP`: Create system backups using TinyCore filetool.sh
- `RESTORE`: Restore from backup archives
- `DESTROY`: Secure system cleanup
- `REBOOT`: Safe system restart
- `REPAIR`: File system repair with fsck
- `UNDO`: Reverse last operation
- `REDO`: Replay last successful operation

**Platform Launchers**
```
Platform Support/
├── uDESK-macOS.sh (auto-installs Xcode Command Line Tools)
├── uDESK-Ubuntu.sh (auto-installs build-essential)
└── uDESK-Windows.bat (MinGW/MSYS2 guidance)
```

### 3. Tauri Application Integration
**Modern Interface**
- React frontend with TypeScript
- Rust backend with container management
- uDOS blue diamond branding
- Cross-platform desktop application

## Installation Methods

### Primary Installation
```bash
# Platform-specific quickstart (recommended)
./uDESK-macOS.sh      # macOS with auto-dependency installation
./uDESK-Ubuntu.sh     # Ubuntu/Debian with build-essential
./uDESK-Windows.bat   # Windows with MinGW guidance

# Manual build and install
git clone https://github.com/fredporter/uDESK.git
cd uDESK
./build.sh user       # Build user mode
sudo ./installers/install.sh     # Install system-wide
```

### Development Setup
```bash
# Build specific modes
./build.sh user             # User mode build
./build.sh wizard           # Wizard mode build
./build.sh developer        # Developer mode build
./build.sh iso              # TinyCore ISO generation

# Tauri application development
cd app
npm install
npm run tauri dev           # Development interface
npm run tauri build         # Production build
```

## Command Interface Philosophy

### Clean and Efficient Design
```
uDESK Build System:

Build Commands:
├── ./build.sh user        - User mode build (all roles)
├── ./build.sh wizard      - Wizard mode build (WIZARD role + Dev Mode)
├── ./build.sh developer   - Developer mode build (core developers)
└── ./build.sh iso         - TinyCore ISO generation

Platform Launchers:
├── ./uDESK-macOS.sh      - macOS quickstart with Xcode tools
├── ./uDESK-Ubuntu.sh     - Ubuntu quickstart with build-essential
└── ./uDESK-Windows.bat   - Windows quickstart with MinGW guidance

Testing Commands:
├── echo "[INFO]" | ./build/user/udos       - Test user mode
├── echo "[INFO]" | ./build/wizard/udos     - Test wizard mode
└── echo "[INFO]" | ./build/developer/udos   - Test developer mode

uCODE System Commands (TinyCore Integration):
├── BACKUP   - Create system backups using filetool.sh
├── RESTORE  - Restore from backup archives
├── DESTROY  - Secure system cleanup
├── REBOOT   - Safe system restart
├── REPAIR   - File system repair with fsck
├── UNDO     - Reverse last operation
└── REDO     - Replay last successful operation
```

### Design Principles
- **Mode Separation**: Clear distinction between User/Wizard/Developer contexts
- **Zero Dependencies**: Only requires GCC (auto-installed by platform launchers)
- **Cross-Platform**: Native support for macOS/Ubuntu/Windows
- **Fast Setup**: 30-second build time from download to executable
- **Modern Interface**: Optional Tauri application for enhanced user experience

## Development Status & Roadmap

### ✅ MILESTONE 1: Clean Architecture (Complete - v1.0.7)
- ✅ Mode separation (User/Wizard/Developer)
- ✅ Cross-platform support (macOS/Ubuntu/Windows)
- ✅ Zero dependency builds (GCC-only)
- ✅ Platform launchers with auto-dependency installation
- ✅ 8-role hierarchy system (GHOST → WIZARD)

### ✅ MILESTONE 2: TinyCore Integration (Complete - v1.0.7) 
- ✅ 7 core uDOS system commands (BACKUP, RESTORE, etc.)
- ✅ Native TinyCore functions (filetool.sh, tce-load, fsck)
- ✅ ISO generation capabilities
- ✅ TCZ package creation
- ✅ Boot integration support

### ✅ MILESTONE 3: Modern Interface (Complete - v1.0.7)
- ✅ Tauri application with React frontend
- ✅ uDOS blue diamond branding
- ✅ Container management interface
- ✅ Cross-platform desktop application
- ✅ Rust backend with system integration

### 🔮 MILESTONE 4: Advanced Features (Future)
- Enhanced workflow automation
- Advanced system analysis tools
- Extended TinyCore integration
- Community extension system

## Role-Based System

### Progressive Capability Framework
- **GHOST** (👻): Basic system monitoring, read-only access
- **TOMB** (⚱️): File management, archive operations
- **DRONE** (🤖): Basic workflow automation, script execution
- **CRYPT** (💀): Security tools, encryption operations
- **IMP** (👹): Full scripting environment, network tools
- **KNIGHT** (⚔️): System administration, service management
- **SORCERER** (🔮): Advanced smart features, complex workflow
- **WIZARD** (🧙): Complete system access, advanced development

### Role-Based Features
- **Automatic Detection**: System determines role based on capabilities
- **Manual Override**: Users can specify role with environment variables
- **Progressive Unlock**: Features become available as role increases
- **Mode Access**: Higher roles can access Wizard+ and Developer modes

---

## Extension System

### Overview
The uDOS System provides a streamlined extension framework that integrates with uDESK's clean architecture. Built for simplicity and cross-platform compatibility, it supports mode-based functionality without external dependencies.

### Mode-Based Operation
- **User Mode**: Essential tools and basic extensions
- **Wizard Mode**: Advanced features and development tools  
- **Developer Mode**: Full extension development environment
- **ISO Mode**: Bootable system with selected extensions

### Extension Directory Structure
```
uDESK/
├── extensions/               # System extensions
│   ├── core/                 # Built-in extensions
│   ├── user/                 # User-installed extensions
│   └── dev/                  # Development extensions
└── core/config/              # Extension configuration
    ├── extensions.conf       # Extension configuration
    ├── modes.conf           # Mode-specific settings
    └── security/
        ├── permissions.json  # Extension permissions
        └── trusted.list      # Trusted extension sources
```

### Extension Management Commands
```bash
# Install extensions
udos extension install "System Monitor"
udos extension install "Dev Tools" --mode developer

# Manage extensions
udos extension list
udos extension enable monitor
udos extension disable monitor
udos extension remove old-extension

# Security and permissions
udos extension permissions system-monitor
udos extension check compatibility
```

### Extension Development
Extensions follow a simple structure with JSON manifests and shell scripts:

```bash
extension-name/
├── manifest.json             # Extension metadata
├── main.sh                   # Main extension script
├── README.md                 # Documentation
└── config/
    └── defaults.conf         # Configuration files
```

### Cross-Platform Integration
Extensions can integrate with the Tauri desktop application and detect platform-specific capabilities for optimal cross-platform functionality.

---

*Updated: 2025-09-04 - Clean architecture v1.0.7 with cross-platform support*
