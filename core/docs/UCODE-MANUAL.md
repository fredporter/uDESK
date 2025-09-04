# uCODE User Manual
## uDESK v1.0.7 Command Language Reference

### Overview
uCODE (Universal Command Operations & Development Environment) is the integrated command language for uDESK v1.0.7. It provides a structured syntax for cross-platform system operations, development tasks, and unified build management.

### Command Syntax
```
[COMMAND|OPTION*PARAMETER]
```

**Components:**
- `COMMAND`: Primary operation (required)
- `OPTION`: Command modifier (optional)
- `PARAMETER`: Command argument (optional)

**Examples:**
```
[HELP]                    # Show help
[STATUS]                  # System status
[BUILD|MODE*USER]        # Build in user mode
[EXT|INSTALL*NAME]       # Install extension
[MODE|SET*DEV]           # Switch to developer mode
```

---

## Core Commands (uDESK v1.0.7 Clean Architecture)

### System Management
| Command | Description | Platform Function |
|---------|-------------|-------------------|
| [BACKUP] | Create system backup | Cross-platform backup system |
| [BACKUP|FULL] | Complete system backup | Includes all user data and configs |
| [RESTORE] | Restore from backup | Platform-aware restore |
| [RESTORE|SELECT*PATH] | Restore specific backup | Custom restore path |

### Build System
| Command | Description | Function |
|---------|-------------|----------|
| [BUILD|USER] | Build user mode | Essential features only |
| [BUILD|WIZARD-PLUS] | Build wizard+ mode | Advanced features |
| [BUILD|DEV] | Build developer mode | Full development toolkit |
| [BUILD|ISO] | Build bootable ISO | Bootable system image |

### Mode Management
| Command | Description | Function |
|---------|-------------|----------|
| [MODE|GET] | Show current mode | Display active mode |
| [MODE|SET*USER] | Switch to user mode | Basic functionality |
| [MODE|SET*WIZARD-PLUS] | Switch to wizard+ mode | Advanced features |
| [MODE|SET*DEV] | Switch to developer mode | Full development access |

### System Control
| Command | Description | Platform Function |
|---------|-------------|-------------------|
| [RESTART] | Restart system | Cross-platform restart |
| [RESTART|FORCE] | Force restart | Emergency restart |
| [RESET] | Reset to clean state | Remove user data, keep base |
| [RESET|COMPLETE] | Full system reset | Factory reset equivalent |

### System Repair
| Command | Description | Function |
|---------|-------------|----------|
| [REPAIR] | Basic system repair | Auto-detect and fix common issues |
| [REPAIR|FILESYSTEM] | Filesystem check | Platform-specific filesystem check |
| [REPAIR|EXT] | Rebuild extensions | Reinstall system extensions |
| [REPAIR|DEPENDENCIES] | Fix dependencies | Resolve dependency conflicts |

### Undo/Redo System
| Command | Description | Implementation |
|---------|-------------|----------------|
| [UNDO] | Undo last operation | Restore from automatic backup |
| [UNDO|STEPS*N] | Undo N operations | Multi-step undo |
| [REDO] | Redo last undone | Apply from redo stack |
| [REDO|STEPS*N] | Redo N operations | Multi-step redo |

---

## Development Commands

### Desktop Application
| Command | Description |
|---------|-------------|
| [APP|START] | Start desktop application |
| [APP|STOP] | Stop desktop application |
| [APP|STATUS] | Check application status |
| [APP|REBUILD] | Rebuild desktop application |

### Cross-Platform Development
| Command | Description |
|---------|-------------|
| [STAGE|DETECT] | Detect current platform |
| [STAGE|DEPS] | Install platform dependencies |
| [STAGE|TEST] | Test cross-platform compatibility |

### Extension System
| Command | Description |
|---------|-------------|
| [EXT|LIST] | List available extensions |
| [EXT|INSTALL*NAME] | Install extension |
| [EXT|REMOVE*NAME] | Remove extension |
| [EXT|BUILD*PATH] | Build custom extension |
| [EXT|ENABLE*NAME] | Enable extension |
| [EXT|DISABLE*NAME] | Disable extension |

### Configuration Management
| Command | Description |
|---------|-------------|
| [CONF|GET*KEY] | Get configuration value |
| [CONF|SET*KEY*VALUE] | Set configuration value |
| [CONF|LIST] | List all configurations |
| [CONF|RESET] | Reset to default configuration |

### Theme Management
| Command | Description |
|---------|-------------|
| [THEME|LIST] | List available themes |
| [THEME|SET*NAME] | Switch to theme |
| [THEME|RESET] | Reset to default theme |
| [THEME|CREATE*NAME] | Create custom theme |

**Available Themes:**
- `DEFAULT` (clean modern)
- `RETRO` (vintage terminal)
- `DARK` (dark mode)
- `LIGHT` (light mode)

---

## Information Commands

### System Information
| Command | Description |
|---------|-------------|
| [STATUS] | Overall system status |
| [INFO] | uDESK version and details |
| [HARD] | Hardware information |
| [NET] | Network status |
| [STAGE] | Platform information |
| [DASH] | System performance metrics |

### Help System
| Command | Description |
|---------|-------------|
| [HELP] | General help |
| [HELP|COMMAND*NAME] | Help for specific command |
| [MX] | Full manual (this document) |
| [EX] | Command examples |
| [RX] | Quick reference card |

---

## Role-Based Access

uCODE commands respect the 8-tier role hierarchy:

| Role | Level | Symbol | Access |
|------|-------|--------|--------|
| GHOST | 10 | 👻 | Read-only system info |
| TOMB | 20 | ⚰️ | Basic data access |
| DRONE | 30 | 🤖 | Standard operations |
| CRYPT | 40 | � | Security operations |
| IMP | 50 | � | System manipulation |
| KNIGHT | 60 | ⚔️ | Network operations |
| SORCERER | 70 | � | Advanced scripting |
| WIZARD | 100 | 🧙‍♂️ | All operations |

---

---

## Cross-Platform Integration Notes

### Platform Detection
uDESK v1.0.7 automatically detects and adapts to:
- **macOS**: Native integration with Homebrew and Xcode tools
- **Ubuntu/Debian**: APT package management integration
- **Windows**: MinGW-w64 and MSYS2 support

### File Locations
- **Extensions**: `extensions/user/` and `extensions/core/`
- **Backups**: `build/backups/`
- **User Data**: `usr/data/`
- **System Config**: `core/config/`
- **Desktop App**: `app/udesk-app/`

### Backup Strategy
1. **Automatic**: Before destructive operations
2. **Manual**: [BACKUP] command
3. **Incremental**: Only changed files
4. **Cross-Platform**: Works on all supported platforms

### Extension Compatibility
uDESK v1.0.7 supports:
- Native shell-based extensions
- Cross-platform executable extensions
- Desktop application plugins (via Tauri)
- Mode-specific feature sets

---

## Quick Reference

### Most Common Commands
```bash
[HELP]                   # Get help
[STATUS]                 # Check system
[INFO]                   # System information
[MODE|GET]               # Check current mode
[BUILD|USER]             # Build user mode
[EXT|LIST]               # See extensions
[BACKUP]                 # Save current state
[CONF|GET*KEY]           # Get configuration
```

### Mode-Specific Commands
```bash
# User Mode
[BUILD|USER]             # Build for basic use
[EXT|LIST]               # View user extensions

# Wizard+ Mode  
[BUILD|WIZARD-PLUS]      # Build advanced features
[CONF|SET*KEY*VALUE]     # Advanced configuration

# Developer Mode
[BUILD|DEV]              # Build development toolkit
[APP|START]              # Launch desktop app
[STAGE|TEST]             # Test cross-platform
```

### Emergency Commands
```bash
[REPAIR]                 # Auto-fix problems
[REPAIR|FILESYSTEM]      # Fix file system
[RESTORE]                # Restore from backup
[RESET]                  # Reset to clean state
[RESTART|FORCE]          # Force restart
```

---

## Version History

**v1.0.7 (Current)**
- Cross-platform command integration (macOS/Ubuntu/Windows)
- Mode-based system architecture (user/wizard-plus/developer/iso)
- Unified build system with single build.sh script
- Desktop application integration via Tauri
- Correct 8-tier role hierarchy (GHOST→TOMB→DRONE→CRYPT→IMP→KNIGHT→SORCERER→WIZARD)
- Enhanced extension system with mode awareness
- Platform-specific dependency management

**v1.0.6**
- Foundation for cross-platform support
- Initial clean architecture implementation
- Basic mode separation

**Based on uDOS v1.0.4**
- Core command syntax established
- Initial role hierarchy concepts
- Extension system framework

---

*For technical details and development documentation, see the uDESK Developer Guide.*
