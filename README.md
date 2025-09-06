# uDESK - Universal Desktop OS

[![Status](https://img.shields.io/badge/status-Production%20Ready-green.svg)](#quick-start)
[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)](#package-status)

uDESK provides TinyCore Linux integration for **uDOS (Universal Device Operating System)**, featuring a modern Tauri application with **PANEL system**, **VSCode integration**, and **live workflow management**.

## 🚀 **Quick Start** (Choose Your Platform)

### **macOS** 🍎
```bash
./udesk-install.command
```

### **Linux** 🐧  
```bash
./udesk-install-linux.sh
```

### **Windows** 🪟
```bash
./udesk-install-windows.bat
```

> 💡 **Latest Features:**
> - **🎛️ PANEL System**: Complete widget→PANEL transformation with uDOS grid alignment
> - **💻 VSCode Integration**: Live TODO Tree sync, terminal commands, workflow script execution
> - **📊 Real Workflow Data**: Live parsing of workflow files and hierarchy visualization
> - **⚡ Live Updates**: Real-time progress tracking with Goal→Mission→Milestone→TODO structure
> - **🔧 Script Integration**: Direct execution of uDESK core scripts from CHEST Desktop panels

## 🏗️ **Installation Architecture**

### **Consolidated Design**
All platform installers are lightweight wrappers that call the core `install.sh`:

```
Platform Installers (Lightweight Wrappers)
├── udesk-install.command        # macOS: Xcode CLI tools check
├── udesk-install-linux.sh       # Linux: Build tools installation  
└── udesk-install-windows.bat    # Windows: WSL requirement check
            ↓
Core Installation Logic
└── install.sh                   # All installation logic with uCODE input parsing
```

### **uCODE Input System**
Smart case-insensitive partial matching for user inputs:
- **[YES|NO]**: Accepts "y", "yes", "n", "no", "Y", "YES", etc.
- **[UPDATE|DESTROY|CANCEL]**: Accepts "up", "dest", "can", "update", etc.
- **Error Handling**: Invalid inputs prompt retry with examples

### **Modern Installation Approach**
- **User-Local**: Installs to `~/.local/bin` (no sudo required)
- **Direct Downloads**: Bypasses failing mirror system with curl
- **Prerequisite Detection**: Automatic build tool installation per platform
- **Clean Structure**: Single source of truth with platform-specific setup

---

## 🎯 **Architecture Overview**

### **Three Clear Modes:**
- **👤 User Mode**: Standard users (all roles: GHOST → WIZARD)
- **🧙‍♀️ Wizard Role**: Highest user role with extension development  
- **🛠️ Dev Mode**: Special development capabilities from ~/uDESK/dev/

### **Mode Commands:**
```bash
./build.sh user    # User Mode build
./build.sh wizard  # Wizard Role build  
./build.sh dev     # Dev mode build
./build.sh iso     # TinyCore ISO generation
```

### **Wizard Role Features:**
- **Extension Development**: Always available in `~/uDESK/uMEMORY/sandbox/`
- **[DEV-MODE]**: Core system development in `~/uDESK/dev/` (restricted)
- **Unified Interface**: Single wizard with role-based capabilities

---

## ✨ Integration Features

🎯 **Hybrid Distribution**: GitHub, TCZ package, and offline installation methods  
⚡ **Boot Integration**: ASCII art branding and automatic environment setup  
🏛️ **Role Hierarchy**: M1 CLI foundation + M2 8-role system (GHOST to WIZARD)  
🖥️ **VNC Desktop**: Full desktop environment with copy-paste functionality  
🚀 **Complete Automation**: Hands-off installation and configuration  
🐧 **TinyCore Native**: Leverages TCZ packages and boot automation  

## 🎛️ PANEL System & VSCode Integration

### **CHEST Desktop Panels**
The uDESK Tauri application features a complete **PANEL system** aligned to the **uDOS Grid System** (16×16 pixel uCELL architecture):

#### **📝 TodoPanel**
- **Live TODO Parsing**: Real-time display of TODOs from workflow files
- **Progress Tracking**: Visual completion status with milestone assignments
- **VSCode Integration**: Direct file editing and TODO Tree synchronization
- **Action Buttons**: Start/Complete TODOs, sync with VSCode, edit workflow files

#### **📊 ProgressPanel** 
- **Workflow Hierarchy**: Goal→Mission→Milestone→TODO visualization
- **Expandable Milestones**: Click to view contained TODOs with progress bars
- **Real-Time Statistics**: Live progress calculation and completion tracking
- **Script Integration**: Execute workflow hierarchy scripts directly

#### **⚙️ WorkflowPanel**
- **VSCode Commands**: Terminal launching, file operations, TODO Tree refresh
- **Script Execution**: Direct execution of core workflow scripts
- **Custom Commands**: Advanced command input for workflow automation
- **Action Categories**: Workflow, VSCode, Progress, System command organization

#### **🖥️ SystemPanel**
- **Development Integration**: VSCode terminal launching and workspace management
- **System Monitoring**: Resource usage and development environment status
- **Script Access**: Quick execution of system health and workflow scripts

### **VSCode Integration Features**
- **🔄 TODO Tree Sync**: Automatic refresh of VSCode TODO Tree extension
- **📂 File Operations**: Open workflow files directly in VSCode editor
- **💻 Terminal Integration**: Launch terminals in uDESK workspace context
- **📋 Command Execution**: Run workflow scripts through VSCode interface
- **⚡ Task Management**: Create and execute VSCode tasks from panels

### **Real Workflow Data**
- **📊 Live Parsing**: Real-time parsing of workflow files
- **📈 Progress Tracking**: Automatic progress calculation and milestone completion
- **🏆 Milestone Management**: Hierarchical organization with expandable views
- **🔧 Script Integration**: Direct execution of uDESK core workflow scripts

## 🚀 Quick Start

### Automatic Platform Setup (Recommended)
```bash
# macOS (with Xcode tools auto-install)
./udesk-install.command

# Linux (with build-essential auto-install)  
./udesk-install-linux.sh

# Windows (with MinGW/MSYS2 guidance)
./udesk-install-windows.bat
```

### Manual Build & Install
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Build for your mode
./build.sh user          # Most users
./build.sh wizard        # WIZARD role with extension development
./build.sh dev           # Core development mode

# Install system-wide
sudo ./install.sh
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
├── app/                         # Modern Tauri application
│   ├── src/                    # React frontend
│   ├── tauri/                  # Rust backend
│   └── package.json            # Node.js dependencies
├── system/                      # System components
│   └── tinycore/               # TinyCore Linux integration files
│       ├── build-tcz.sh       # TCZ package build script
│       ├── udesk.desktop      # Desktop entry
│       └── udesk.tcz.*        # Package metadata
├── build/                       # Build outputs
│   ├── user/                   # User mode build
│   ├── wizard/                 # Wizard role build
│   ├── dev/                    # Development build
│   └── iso/                    # TinyCore ISO build
├── core/                        # Core workflow scripts
├── uMEMORY/                    # Persistent storage system
├── installers/                 # Platform-specific installers
├── docs/                       # Documentation
└── dev/                        # Development files and tests
```

## 📦 Package Status

| Component | Status | Description |
|-----------|--------|-------------|
| **Core uDOS** | ✅ Complete | CLI foundation with all 8 roles |
| **TinyCore Integration** | ✅ Complete | Boot integration and TCZ packaging |
| **VNC Desktop** | ✅ Complete | Full desktop environment |
| **Installation System** | ✅ Complete | Multi-platform automated install |
| **Tauri App** | ✅ Complete | PANEL system with VSCode integration |
| **Wizard Extensions** | ⚠️ Partial | Extension development framework |
| **Legacy Migration** | 🚧 In Progress | Legacy archive and treasure system |

## 🎯 Supported Platforms

- **macOS** (Intel/Apple Silicon): Full support with Xcode integration
- **Linux**: Native support with build-essential 
- **TinyCore Linux**: Primary target with TCZ packaging
- **Windows**: WSL2 support with MinGW/MSYS2 guidance
- **Other Linux**: Generic support via build scripts

## 📋 Current Status

uDESK is **production ready** for User Mode and Wizard Role deployment. The core system is stable with comprehensive installation automation. The modern Tauri application provides a complete PANEL-based interface with VSCode integration for development workflows.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and architecture documentation.

## 📜 License

[LICENSE](LICENSE) - Open source with attribution requirements.
