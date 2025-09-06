# uCODE User Manual
## uDESK v1.0.7.2 Command Language Reference

### Overview
uCODE is the integrated command language for uDESK. It provides a structured syntax for cross-platform system operations, development tasks, and unified build management.

### Command Contexts

#### **CLI Context (Terminal/uSCRIPT)**
Direct commands - case insensitive input, UPPERCASE output:
```
HELP                          ~ Show general help
BACKUP                        ~ Create backup
MEMORY SEARCH TERM            ~ Search for files
CONFIG SET THEME DARK         ~ Set theme to dark mode
```

#### **Documentation Context (Markdown/Shortcodes)**
Shortcodes with brackets for embedding in .md files:
```
[HELP]                        ~ System help shortcode
[MEMORY|SEARCH*term]          ~ Memory search with parameter
[CONFIG|SET*THEME*DARK]       ~ Configuration with multiple parameters
[BACKUP|CREATE*{PROJECT-NAME}] ~ Using variables in shortcodes
```

### Command Syntax Rules

**CLI Format (Terminal):**
```
COMMAND [OPTION] [PARAMETER]
```

**Shortcode Format (Documentation):**
```
[COMMAND|OPTION*PARAMETER]
```

**Components:**
- COMMAND : Primary operation (required) - UPPERCASE display
- OPTION : Command modifier (optional) - UPPERCASE display  
- PARAMETER : Command argument (optional) - varies by context

**Examples:**
```
# CLI Context
HELP                          ~ Show help
BACKUP FULL                   ~ Complete backup
BUILD USER                    ~ Build in user mode
EXT INSTALL NAME              ~ Install extension
MODE SET DEVELOPER            ~ Switch to developer mode

# Documentation Context  
[HELP]                        ~ Show help shortcode
[BACKUP|FULL]                 ~ Complete backup shortcode
[BUILD|USER]                  ~ Build user mode shortcode
[EXT|INSTALL*NAME]            ~ Install extension shortcode
[MODE|SET*DEVELOPER]          ~ Switch to developer mode shortcode
```

---

## Core Commands

### System Management
| CLI Command | Shortcode | Description | Platform Function |
|-------------|-----------|-------------|-------------------|
| BACKUP | [BACKUP] | Create system backup | Cross-platform backup system |
| BACKUP FULL | [BACKUP\|FULL] | Complete system backup | Includes all user data and configs |
| RESTORE | [RESTORE] | Restore from backup | Platform-aware restore |
| RESTORE SELECT PATH | [RESTORE\|SELECT*PATH] | Restore specific backup | Custom restore path |

### Build System
| CLI Command | Shortcode | Description | Function |
|-------------|-----------|-------------|----------|
| BUILD USER | [BUILD\|USER] | Build user mode | Essential features only |
| BUILD WIZARD-PLUS | [BUILD\|WIZARD-PLUS] | Build wizard+ mode | Advanced features |
| BUILD DEVELOPER | [BUILD\|DEVELOPER] | Build developer mode | Full development toolkit |
| BUILD ISO | [BUILD\|ISO] | Build bootable ISO | Bootable system image |

### Mode Management
| CLI Command | Shortcode | Description | Function |
|-------------|-----------|-------------|----------|
| MODE GET | [MODE\|GET] | Show current mode | Display active mode |
| MODE SET USER | [MODE\|SET*USER] | Switch to user mode | Basic functionality |
| MODE SET WIZARD-PLUS | [MODE\|SET*WIZARD-PLUS] | Switch to wizard+ mode | Advanced features |
| MODE SET DEVELOPER | [MODE\|SET*DEVELOPER] | Switch to developer mode | Full development access |

### System Control
| CLI Command | Shortcode | Description | Platform Function |
|-------------|-----------|-------------|-------------------|
| RESTART | [RESTART] | Restart system | Cross-platform restart |
| RESTART FORCE | [RESTART\|FORCE] | Force restart | Emergency restart |
| RESET | [RESET] | Reset to clean state | Remove user data, keep base |
| RESET COMPLETE | [RESET\|COMPLETE] | Full system reset | Factory reset equivalent |

### System Repair
| CLI Command | Shortcode | Description | Function |
|-------------|-----------|-------------|----------|
| REPAIR | [REPAIR] | Basic system repair | Auto-detect and fix common issues |
| REPAIR FILESYSTEM | [REPAIR\|FILESYSTEM] | Filesystem check | Platform-specific filesystem check |
| REPAIR EXT | [REPAIR\|EXT] | Rebuild extensions | Reinstall system extensions |
| REPAIR DEPENDENCIES | [REPAIR\|DEPENDENCIES] | Fix dependencies | Resolve dependency conflicts |

### Shell Commands  
| CLI Command | Shortcode | Description | Function |
|-------------|-----------|-------------|----------|
| EXIT | [EXIT] | Exit uDESK | Leave current session |
| QUIT | [QUIT] | Quit uDESK | Leave current session |
| CONFIG | [CONFIG] | Show configuration | Display current settings |
| ROLE | [ROLE] | Show role information | Display current role |
| THEME | [THEME] | Show theme settings | Display current theme |

### Undo/Redo System
| CLI Command | Shortcode | Description | Implementation |
|-------------|-----------|-------------|----------------|
| UNDO | [UNDO] | Undo last operation | Restore from automatic backup |
| UNDO STEPS N | [UNDO\|STEPS*N] | Undo N operations | Multi-step undo |
| REDO | [REDO] | Redo last undone | Apply from redo stack |
| REDO STEPS N | [REDO\|STEPS*N] | Redo N operations | Multi-step redo |

---

## Development Commands

### Desktop Application
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| APP START | [APP\|START] | Start desktop application |
| APP STOP | [APP\|STOP] | Stop desktop application |
| APP STATUS | [APP\|STATUS] | Check application status |
| APP REBUILD | [APP\|REBUILD] | Rebuild desktop application |

### Cross-Platform Development
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| STAGE DETECT | [STAGE\|DETECT] | Detect current platform |
| STAGE DEPS | [STAGE\|DEPS] | Install platform dependencies |
| STAGE TEST | [STAGE\|TEST] | Test cross-platform compatibility |

### Extension System
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| EXT LIST | [EXT\|LIST] | List available extensions |
| EXT INSTALL NAME | [EXT\|INSTALL*NAME] | Install extension |
| EXT REMOVE NAME | [EXT\|REMOVE*NAME] | Remove extension |
| EXT BUILD PATH | [EXT\|BUILD*PATH] | Build custom extension |
| EXT ENABLE NAME | [EXT\|ENABLE*NAME] | Enable extension |
| EXT DISABLE NAME | [EXT\|DISABLE*NAME] | Disable extension |

### Configuration Management
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| CONFIG GET KEY | [CONFIG\|GET*KEY] | Get configuration value |
| CONFIG SET KEY VALUE | [CONFIG\|SET*KEY*VALUE] | Set configuration value |
| CONFIG LIST | [CONFIG\|LIST] | List all configurations |
| CONFIG RESET | [CONFIG\|RESET] | Reset to default configuration |

### Theme Management
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| THEME LIST | [THEME\|LIST] | List available themes |
| THEME SET NAME | [THEME\|SET*NAME] | Switch to theme |
| THEME RESET | [THEME\|RESET] | Reset to default theme |
| THEME CREATE NAME | [THEME\|CREATE*NAME] | Create custom theme |

**Available Themes:**
- DEFAULT (clean modern)
- RETRO (vintage terminal)
- DARK (dark mode)
- LIGHT (light mode)

---

## Information Commands

### System Information
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| STATUS | [STATUS] | Overall system status |
| INFO | [INFO] | uDESK version and details |
| HARDWARE | [HARDWARE] | Hardware information |
| NETWORK | [NETWORK] | Network status |
| PLATFORM | [PLATFORM] | Platform information |
| DASHBOARD | [DASHBOARD] | System performance metrics |

### Help System
| CLI Command | Shortcode | Description |
|-------------|-----------|-------------|
| HELP | [HELP] | General help |
| HELP COMMAND NAME | [HELP\|COMMAND*NAME] | Help for specific command |
| MANUAL | [MANUAL] | Full manual (this document) |
| EXAMPLES | [EXAMPLES] | Command examples |
| REFERENCE | [REFERENCE] | Quick reference card |

---

## Character Usage Rules

### uCODE Special Characters
```
~ Operators:
|  ~ Pipe for command actions
*  ~ Asterisk for parameters
/  ~ Slash for multiple parameters

~ Comments: Both # and ~ are REM in uCODE
# This is a full line comment
HELP                          ~ End-of-line comment

~ Variable and Function Syntax:
{VARIABLE}                    ~ System variables
<FUNCTION>                    ~ Function calls
```

### Character Avoidance Rules
```
~ uCODE avoids these characters: '"`&%$

# Character usage in regular text:
~ Avoid uCODE special characters in regular operations: []{}<>~/\|
~ Example: "Press [Enter]" could confuse with system shortcode
~ Preferred: "Press ENTER to continue" (all caps, no brackets)
~ Minimize quotes: "Press ENTER" → Press ENTER
```

### Formatting Rules
```
# Commands, options, variables, functions: ALL CAPS
HELP BACKUP                   ~ Commands in UPPERCASE
CONFIG SET {THEME-NAME} DARK  ~ Variables and options in CAPS
RUN <BACKUP-SCRIPT|FULL>      ~ Functions in CAPS with parameters
EXIT CONFIG ROLE THEME        ~ Shell commands also in CAPS for consistency

# Regular text: Sentence case
To create a backup, use the BACKUP command.
Press ENTER to continue with the operation.
Your current role is {ROLE} in the system.
Type EXIT to quit the application.
```

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
uDESK automatically detects and adapts to:
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
uDESK supports:
- Native shell-based extensions
- Cross-platform executable extensions
- Desktop application plugins (via Tauri)
- Mode-specific feature sets

---

## Quick Reference

### Most Common Commands
```bash
# CLI Context (Terminal)
HELP                         ~ Get help
STATUS                       ~ Check system
INFO                         ~ System information
ROLE                         ~ Check current role
BUILD USER                   ~ Build user mode
EXT LIST                     ~ See extensions
BACKUP                       ~ Save current state
CONFIG GET KEY               ~ Get configuration

# Documentation Context (Shortcodes)
[HELP]                       ~ Get help shortcode
[STATUS]                     ~ Check system shortcode
[INFO]                       ~ System information shortcode
[ROLE]                       ~ Check current role shortcode
[BUILD|USER]                 ~ Build user mode shortcode
[EXT|LIST]                   ~ See extensions shortcode
[BACKUP]                     ~ Save current state shortcode
[CONFIG|GET*KEY]             ~ Get configuration shortcode
```

### Mode-Specific Commands
```bash
# User Mode - CLI
BUILD USER                   ~ Build for basic use
EXT LIST                     ~ View user extensions

# User Mode - Shortcodes
[BUILD|USER]                 ~ Build for basic use shortcode
[EXT|LIST]                   ~ View user extensions shortcode

# Wizard+ Mode - CLI
BUILD WIZARD-PLUS            ~ Build advanced features
CONFIG SET KEY VALUE         ~ Advanced configuration

# Wizard+ Mode - Shortcodes
[BUILD|WIZARD-PLUS]          ~ Build advanced features shortcode
[CONFIG|SET*KEY*VALUE]       ~ Advanced configuration shortcode

# Developer Mode - CLI
BUILD DEVELOPER              ~ Build development toolkit
APP START                    ~ Launch desktop app
STAGE TEST                   ~ Test cross-platform

# Developer Mode - Shortcodes
[BUILD|DEVELOPER]            ~ Build development toolkit shortcode
[APP|START]                  ~ Launch desktop app shortcode
[STAGE|TEST]                 ~ Test cross-platform shortcode
```

### Emergency Commands
```bash
# CLI Context
REPAIR                       ~ Auto-fix problems
REPAIR FILESYSTEM           ~ Fix file system
RESTORE                      ~ Restore from backup
RESET                        ~ Reset to clean state
RESTART FORCE                ~ Force restart

# Shortcode Context
[REPAIR]                     ~ Auto-fix problems shortcode
[REPAIR|FILESYSTEM]          ~ Fix file system shortcode
[RESTORE]                    ~ Restore from backup shortcode
[RESET]                      ~ Reset to clean state shortcode
[RESTART|FORCE]              ~ Force restart shortcode
```

---

## Version History

**v1.0.7.2 (Current)**
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
