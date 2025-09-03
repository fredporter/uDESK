# uDOS Architecture: Cross-Platform Interface

## Overview
uDOS provides a unified interface that adapts to deployment context, maintaining consistent functionality across platforms while optimizing for each environment's capabilities.

## Core Architecture

### Clean Modular Design
```
uDOS System/
├── Core Command: /usr/local/bin/udos (unified interface)
├── Wrapper Scripts: uvar, udata, utpl
├── System Structure: /usr/local/share/udos/
├── Optional Data: /opt/udos/
└── Role System: 8-level progressive hierarchy
```

### Distribution Platforms
- **TinyCore VM**: Full CLI integration with desktop environment
- **macOS Native**: Tauri-based app with SSH connection
- **Web Dashboard**: Browser interface with REST API
- **Mobile Interface**: Touch-optimized grid layout

## Technical Components

### 1. Core System (M1 - Complete)
**Unified Command Interface**
- Single `udos` executable (460+ lines, POSIX-compatible)
- Wrapper scripts: `uvar`, `udata`, `utpl`
- TinyCore optimized (echo-based output, no printf dependencies)
- Clean modular architecture in `build/clean-udos/`

**Role Hierarchy System**
- 8-level progressive capability framework
- Authentic uDOS roles: GHOST → TOMB → DRONE → CRYPT → IMP → KNIGHT → SORCERER → WIZARD
- Automatic role detection with manual override
- Role-specific tool installation via TCZ packages

### 2. Interface Layer (M2 - In Development)
**uDASH Engine** (Rust/WASM)
- Grid layout system (16×16)
- State management (uVAR/uDATA integration)
- Template rendering (uTEMPLATE system)
- Cross-platform compilation target

**Platform Adapters**
- **Desktop**: Tauri native application
- **Web**: WASM + Canvas/WebGL rendering
- **TinyCore**: Openbox + rofi integration
- **Mobile**: Touch-optimized grid interface

### 3. Communication Layer
**Local Integration**
- Direct filesystem access for VM/local installations
- Real-time file monitoring and updates
- Native command execution and output capture

**Remote Access**
- REST API backend for web interface
- WebSocket connections for real-time updates  
- SSH tunnel integration for secure remote access
- File synchronization for offline capabilities

## Installation Methods

### Primary Installation
```bash
# Main installer (clean, unified approach)
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install.sh
chmod +x install.sh && ./install.sh

# One-line setup for fresh TinyCore VM
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/setup.sh  
chmod +x setup.sh && ./setup.sh
```

### Specialized Configurations
```bash
# UTM shared folder integration (macOS)
./utm.sh

# General VM environment setup
./vm.sh

# Boot integration with ASCII art
./udos-boot-art.sh setup
```

## Interface Design Philosophy

### Grid Discipline
```
┌─────────────────┐
│ 🟦🟦🟦🟦🟦🟦🟦🟦 │  16×16 grid system
│ 🟦🟨🟨🟨🟨🟨🟨🟦 │  8-color palette
│ 🟦🟨📄📄📄📄🟨🟦 │  32px panels  
│ 🟦🟨📄📊📊📄🟨🟦 │  64px tiles
│ 🟦🟨📄📊📊📄🟨🟦 │  Consistent spacing
│ 🟦🟨📄📄📄📄🟨🟦 │  Touch-friendly targets
│ 🟦🟨🟨🟨🟨🟨🟨🟦 │  Click-first UI design
│ 🟦🟦🟦🟦🟦🟦🟦🟦 │
└─────────────────┘
```

### Design Principles
- **Consistent Grid**: All interfaces use 16×16 grid system
- **Role-Based Views**: Interface adapts to user's role capabilities
- **Touch-First**: 64px minimum touch targets for mobile compatibility
- **Accessibility**: High contrast, keyboard navigation, screen reader support
- **Performance**: Efficient rendering, minimal resource usage

## Development Roadmap

### M1: Core Foundation (✅ Complete)
- ✅ Unified command interface (`udos` executable)
- ✅ Clean modular architecture  
- ✅ TinyCore compatibility (POSIX shell, echo-based)
- ✅ 8-role hierarchy system implementation
- ✅ Installation and setup scripts (`install.sh`, `setup.sh`)
- ✅ Development/production file separation

### M2: Interface Development (🚧 Next Phase)
1. **Prototype**: Web-based grid interface in TypeScript
2. **Core Engine**: Rust implementation with WASM compilation
3. **Desktop App**: Tauri wrapper for native applications
4. **TinyCore Integration**: Openbox themes and rofi integration
5. **Role-Based UI**: Interface adaptation per user role

### M3: Platform Integration (🔮 Future)
- Multi-platform native applications
- Advanced automation capabilities
- Enterprise deployment tools
- Community collaboration features

## Role-Based Interface Adaptation

### Interface Complexity by Role
- **GHOST** (👻): Read-only dashboard, basic file browser
- **TOMB** (⚱️): File management tools, archive operations
- **DRONE** (🤖): Basic automation panels, script execution
- **CRYPT** (💀): Security tools, encryption interface
- **IMP** (👹): Full scripting environment, network tools
- **KNIGHT** (⚔️): DevOps panels, service management
- **SORCERER** (🔮): AI/ML tools, advanced automation
- **WIZARD** (🧙): Complete system architecture interface

### Adaptive Features
- **Progressive Disclosure**: Advanced features hidden until role unlock
- **Contextual Help**: Role-specific documentation and tutorials
- **Capability Gates**: Interface elements require specific role permissions
- **Learning Paths**: Visual progress indicators toward next role

*Updated: 2025-09-03 - Clean architecture with simplified naming*
