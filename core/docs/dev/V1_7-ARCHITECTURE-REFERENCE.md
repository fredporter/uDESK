# uDESK v1.7 Architecture

## Overview
uDESK v1.7 represents a fundamental architectural shift to a **TinyCore rebrand** approach with modern Tauri wrapper technology. This design maintains the lightweight, modular philosophy while adding contemporary development tools and user experience.

## Core Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Tauri Native App                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Boot Sequence │  │  Theme Engine   │  │ Container    │ │
│  │   & UI          │  │  (4 Retro       │  │ Management   │ │
│  │                 │  │   Themes)       │  │              │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Docker Container                            │
│  ┌─────────────────────────────────────────────────────────┤
│  │                TinyCore Linux Base                      │
│  │  ┌───────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  │   Official    │  │    Custom    │  │   Bridge     │ │
│  │  │   TinyCore    │  │    uDESK     │  │   API        │ │
│  │  │   Extensions  │  │   Extensions │  │   Layer      │ │
│  │  └───────────────┘  └──────────────┘  └──────────────┘ │
│  └─────────────────────────────────────────────────────────┤
│                        uDOS Shell                           │
│         (Enhanced Terminal with uCODE Support)             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Host File System                        │
│              (Workspace mounted into container)            │
└─────────────────────────────────────────────────────────────┘
```

## Component Definitions

### uDESK (Universal Development Environment & System Kit)
- **Role**: TinyCore Linux rebrand with development focus
- **Components**: Complete system including Tauri wrapper + TinyCore base
- **Target**: Cross-platform development environment

### uDOS (Universal Device Operating System)
- **Role**: CLI/Terminal prompt mode and shell experience
- **Components**: Enhanced bash shell with custom prompt, themes, role system
- **Features**: 8-role hierarchy, theme switching, enhanced commands

### uCODE (Universal Command Operations & Development Environment)
- **Role**: Command syntax and language specification
- **Syntax**: `[COMMAND|OPTION*PARAMETER]` format
- **Variables**: `{VARIABLE-NAME}` format with CAPS-DASH-NUMBERS
- **Functions**: `<FUNCTION>` format with angle brackets

### uSCRIPT (Universal Scripting & Command Runtime Integration Platform)
- **Role**: Engine that executes sets of uCODE commands
- **Capabilities**: Script execution, template processing, automation
- **Integration**: Works with uDOS shell and external tools

## Technology Stack

### Frontend Layer (Tauri)
- **Runtime**: Rust backend + Web frontend
- **UI Framework**: React/TypeScript
- **Capabilities**: Native OS integration, file system access
- **Themes**: Polaroid, C64, Macintosh, BBC Mode 7

### Container Layer (Docker)
- **Base**: TinyCore Linux minimal distribution
- **Extensions**: Official .tcz + custom uDESK .tcz packages
- **Networking**: Bridged container networking
- **Storage**: Workspace volume mounts

### Extension System
- **Official**: Leverage TinyCore's proven .tcz extension system
- **Custom**: Build uDESK-specific extensions following TinyCore standards
- **Distribution**: Package manager for extension installation

## Data Flow

### Boot Sequence
1. **Tauri App Start**: Native app launches with retro boot animation
2. **Container Init**: Docker container starts with TinyCore base
3. **Extension Loading**: Load official + custom extensions in dependency order
4. **uDOS Shell**: Enhanced terminal becomes available
5. **Ready State**: User can interact via uCODE commands

### Development Workflow
1. **File Editing**: Edit files in host IDE (VSCode, etc.)
2. **Live Sync**: Changes appear instantly in container workspace
3. **uCODE Execution**: Run commands through uDOS shell
4. **uSCRIPT Automation**: Execute multi-command workflows
5. **Result Display**: Output shown in themed terminal

### Deployment Options
- **Containerized**: Development mode with live file sync
- **ISO Generation**: Create bootable uDESK ISOs with selected extensions
- **Portable**: Self-contained environment for any platform

## Extension Architecture

### Official TinyCore Extensions
```bash
# Core system (Level 1-5)
bash.tcz, ncurses.tcz, readline.tcz    # Shell foundation
gcc.tcz, python3.9.tcz, nodejs.tcz    # Development tools
Xorg-7.7.tcz, flwm.tcz, aterm.tcz     # GUI components
openssh.tcz, curl.tcz, wget.tcz       # Network tools
```

### Custom uDESK Extensions
```bash
# Foundation (Level 6)
udesk-base.tcz         # Core uDESK framework
ucode-engine.tcz       # Command syntax processor
udos-shell.tcz         # Enhanced terminal experience

# Enhancement (Level 7-8)
udesk-fonts.tcz        # Retro font collection
udesk-themes.tcz       # Theme system (Polaroid, C64, Mac, Mode7)
uscript-runtime.tcz    # Script execution engine
uknowledge-base.tcz    # AI knowledge system
unetwork-tools.tcz     # Network utilities

# Integration (Level 9)
udesk-bridge.tcz       # Tauri communication layer
udesk-api.tcz          # REST API for container interaction
```

## Role-Based Access System

### 8-Role Hierarchy (from uDOS)
```
👻 GHOST (10)     - Observer mode, read-only access
⚰️ TOMB (20)      - Basic file operations
🔐 CRYPT (30)     - Secure operations, encryption
🤖 DRONE (40)     - Automated task execution
⚔️ KNIGHT (50)    - System administration
😈 IMP (60)       - Advanced scripting and automation
🧙‍♂️ SORCERER (80) - System modification capabilities
🧙‍♀️ WIZARD (100)  - Full system access and control
```

### Role Integration
- **uDOS Shell**: Displays role-appropriate prompt
- **uCODE Engine**: Validates command permissions by role
- **uSCRIPT Runtime**: Restricts script capabilities by role
- **File System**: Enforces role-based file access

## Theme System

### Visual Themes
1. **Polaroid** (Default uDOS)
   - High contrast colors
   - Modern terminal aesthetics
   - Professional development focus

2. **C64** (Commodore 64)
   - Authentic blue background
   - PETSCII character set
   - Nostalgic computing experience

3. **Macintosh** (Classic Mac)
   - Grayscale bitmap patterns
   - Chicago/Geneva fonts
   - Retro desktop metaphors

4. **Mode 7** (BBC Micro)
   - Teletext graphics support
   - Double-height text modes
   - Educational computing heritage

## Security Model

### Container Isolation
- **Process Isolation**: All uDOS commands run in container
- **File System**: Controlled access to host filesystem
- **Network**: Optional network isolation modes
- **Resources**: Memory and CPU limits configurable

### Permission System
- **Role-Based**: 8-tier permission system
- **Command Validation**: uCODE engine enforces role limits
- **File Access**: Workspace permissions controlled by role
- **System Operations**: Administrative tasks require appropriate role

## Performance Characteristics

### Resource Usage
- **Base Memory**: ~64MB for TinyCore + uDOS
- **Extension Overhead**: ~2-10MB per extension
- **Container Startup**: <5 seconds cold start
- **File Operations**: Native speed with volume mounts

### Scalability
- **Extensions**: Modular loading based on user needs
- **Themes**: Minimal memory impact for theme switching
- **Workspace**: Handles projects of any size via host filesystem
- **Multi-Instance**: Support multiple uDESK environments

This architecture provides a modern development environment with retro aesthetics, maintaining the simplicity and speed of TinyCore while adding contemporary developer experience through Tauri integration.
