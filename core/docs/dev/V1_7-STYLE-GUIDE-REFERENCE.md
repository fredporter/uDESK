# uDESK v1.7 Style Guide

```
██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗
██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝
██║   ██║██║  ██║█████╗  ███████╗█████╔╝ 
██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ 
╚██████╔╝██████╔╝███████╗███████║██║  ██╗
 ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝

Universal Development Environment & System Kit v1.7.0
```

*TinyCore rebrand with Tauri wrapper • Cross-platform development environment*

**Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md) | **Extensions**: [EXTENSION-DEPENDENCY-TREE.md](EXTENSION-DEPENDENCY-TREE.md) | **Roadmap**: [ROADMAP.md](ROADMAP.md)

---

## 🎯 Core Principles & Terminology

### System Architecture (v1.7)
```
uDESK    = Universal Development Environment & System Kit
           (TinyCore rebrand + Tauri wrapper)

uDOS     = Universal Device Operating System
           (CLI/Terminal prompt mode and shell experience)

uCODE    = Universal Command Operations & Development Environment
           (Command syntax and language specification)

uSCRIPT  = Universal Scripting & Command Runtime Integration Platform
           (Engine that executes sets of uCODE commands)
```

### uCODE Language Standards
```ucode
[COMMAND|OPTION*PARAMETER]     ~ Universal shortcode syntax
{VARIABLE-NAME}                ~ Variables: CAPS-DASH-NUMBERS
<FUNCTION>                     ~ Functions: angle brackets
DEF {VAR} = {VALUE}           ~ Variable definitions
```

### 8-Role System (Inherited from uDOS)
```
👻 GHOST (10)    ⚰️ TOMB (20)     🔐 CRYPT (30)    🤖 DRONE (40)
⚔️ KNIGHT (50)   😈 IMP (60)      🧙‍♂️ SORCERER (80) 🧙‍♀️ WIZARD (100)
```

---

## 🎨 Visual Themes

### Theme System Architecture
```css
/* Theme switching support */
:root[data-theme="polaroid"] { /* uDOS default */ }
:root[data-theme="c64"] { /* Commodore 64 */ }
:root[data-theme="macintosh"] { /* Classic Mac */ }
:root[data-theme="mode7"] { /* BBC Mode 7 */ }
```

### Polaroid Theme (Default uDOS)
```css
:root[data-theme="polaroid"] {
    --polaroid-red: #FF1744;
    --polaroid-green: #00E676;
    --polaroid-yellow: #FFEB3B;
    --polaroid-blue: #2196F3;
    --polaroid-purple: #E91E63;
    --polaroid-cyan: #00E5FF;
    --polaroid-white: #FFFFFF;
    --polaroid-black: #000000;
}
```

### C64 Theme
```css
:root[data-theme="c64"] {
    --c64-blue: #6F6FDB;        /* Background */
    --c64-light-blue: #9F9FFF;  /* Text */
    --c64-white: #FFFFFF;
    --c64-cyan: #8CC8D8;
    --c64-green: #6DFC07;
    --c64-yellow: #DDDD6C;
}
```

### Macintosh Theme
```css
:root[data-theme="macintosh"] {
    --mac-white: #FFFFFF;
    --mac-light-gray: #CCCCCC;
    --mac-med-gray: #999999;
    --mac-dark-gray: #666666;
    --mac-black: #000000;
}
```

### Mode 7 Theme (BBC Micro)
```css
:root[data-theme="mode7"] {
    --mode7-black: #000000;
    --mode7-red: #FF0000;
    --mode7-green: #00FF00;
    --mode7-yellow: #FFFF00;
    --mode7-blue: #0000FF;
    --mode7-magenta: #FF00FF;
    --mode7-cyan: #00FFFF;
    --mode7-white: #FFFFFF;
}
```

---

## 📁 File Naming Standards

### TinyCore Extension Naming
```bash
# Core uDESK extensions
udesk-base.tcz           # Foundation framework
ucode-engine.tcz         # Command processor
udos-shell.tcz           # Enhanced terminal
uscript-runtime.tcz      # Script execution
udesk-themes.tcz         # Visual themes
udesk-fonts.tcz          # Retro font collection
```

### Project Files
```bash
# Tauri application structure
src-tauri/               # Rust backend
src/                     # Frontend (React/TypeScript)
extensions/              # Custom .tcz extension sources
container/               # Docker configuration
docs/v1.7/              # Version-specific documentation

# Documentation naming
ARCHITECTURE.md          # System architecture
EXTENSION-DEPENDENCY-TREE.md  # Extension mapping
ROADMAP.md              # Development roadmap
```

### uDOS Legacy Compatibility
```bash
# Maintain uDOS file naming for compatibility
uHEX-convention files   # Keep existing uTYPE-uHEXCODE format
Role-based files        # Maintain 8-role system files
Template structure      # Preserve uDOS template system
```

---

## 🚀 Development Standards

### Rust Code (Tauri Backend)
```rust
// Use consistent error handling
#[tauri::command]
pub async fn execute_ucode(command: String) -> Result<String, String> {
    match ucode_engine::parse(&command) {
        Ok(result) => Ok(result),
        Err(e) => Err(format!("uCODE error: {}", e)),
    }
}

// Follow Rust conventions
pub struct UCodeEngine {
    pub role_level: u8,
    pub theme: Theme,
}

// Use descriptive error types
#[derive(Debug)]
pub enum UCodeError {
    SyntaxError(String),
    PermissionDenied(u8),
    ExecutionFailed(String),
}
```

### TypeScript Code (Frontend)
```typescript
// Use strict typing
interface UDOSConfig {
    theme: 'polaroid' | 'c64' | 'macintosh' | 'mode7';
    role: Role;
    extensions: string[];
}

// Follow naming conventions
export class UCodeEngine {
    private readonly roleLevel: number;
    
    public async executeCommand(command: string): Promise<string> {
        return await invoke('execute_ucode', { command });
    }
}

// Use consistent error handling
export const handleUCodeError = (error: unknown): string => {
    if (error instanceof Error) {
        return `uCODE Error: ${error.message}`;
    }
    return 'Unknown uCODE error occurred';
};
```

### Bash Scripts (Extensions)
```bash
#!/bin/bash
# Extension: udos-shell.tcz
# Description: Enhanced terminal for uDESK v1.7

set -e  # Exit on any error

# Use uDOS naming conventions
UDOS_VERSION="1.7.0"
UDOS_CONFIG_DIR="/usr/local/etc/udos"
UDOS_LIB_DIR="/usr/local/lib/udos"

# Function naming: snake_case
function setup_udos_environment() {
    local theme="${1:-polaroid}"
    log_info "Setting up uDOS environment with theme: $theme"
}

# Error handling
function log_error() {
    echo "ERROR: $*" >&2
}

function log_info() {
    echo "INFO: $*"
}
```

### CSS/SCSS Standards
```css
/* Use CSS custom properties for themes */
.udos-terminal {
    background: var(--theme-bg);
    color: var(--theme-text);
    font-family: var(--theme-font);
}

/* Follow BEM methodology for complex components */
.boot-sequence__stage {
    /* Boot sequence stage styling */
}

.boot-sequence__stage--loading {
    /* Loading state modifier */
}

/* Use consistent spacing units */
.ucell-grid {
    --ucell-size: 16px;
    --ucell-buffer: 2px;
    grid-template-columns: repeat(auto-fit, var(--ucell-size));
}
```

---

## 🔧 Extension Development

### Extension Structure Standard
```bash
extension-name.tcz/
├── DEBIAN/
│   ├── control          # Package metadata
│   └── postinst         # Post-installation script
├── usr/local/bin/       # Executables
├── usr/local/lib/       # Libraries and modules
├── usr/local/share/     # Data files and resources
├── etc/                 # Configuration files
└── opt/                 # Optional large components

# Required files for each extension
extension-name.tcz.dep   # Dependencies
extension-name.tcz.info  # Extension information
extension-name.tcz.list  # File list
```

### Extension Metadata
```bash
# Example: udos-shell.tcz.info
Title:          uDOS Shell
Description:    Enhanced terminal environment for uDESK v1.7
Version:        1.7.0
Author:         uDESK Project
Copying:        MIT License
Size:           2.1MB
Extension_by:   uDESK Team
Tags:           shell terminal uDOS uCODE
Comments:       Universal Device Operating System shell with uCODE support
                Provides enhanced prompt, role system, and theme support
Change-log:     2025/09/04: First release for uDESK v1.7
Current:        1.7.0
```

---

## 🎭 Theme Implementation

### Theme Component Structure
```typescript
// Theme interface
interface Theme {
    name: 'polaroid' | 'c64' | 'macintosh' | 'mode7';
    displayName: string;
    fontFamily: string;
    colorPalette: Record<string, string>;
    specialFeatures?: {
        teletext?: boolean;
        bitmapPatterns?: boolean;
        petscii?: boolean;
    };
}

// Theme registration
export const themes: Record<string, Theme> = {
    polaroid: {
        name: 'polaroid',
        displayName: 'Polaroid (uDOS Default)',
        fontFamily: "'Fixed', 'Terminus', monospace",
        colorPalette: {
            primary: '#00E5FF',
            background: '#000000',
            text: '#FFFFFF',
        },
    },
    // ... other themes
};
```

### Font Loading Strategy
```rust
// Font management in Tauri
#[tauri::command]
pub async fn load_theme_fonts(theme: String) -> Result<Vec<String>, String> {
    let font_map = HashMap::from([
        ("c64", vec!["c64.ttf", "petme64.ttf"]),
        ("macintosh", vec!["chicago.ttf", "geneva.ttf"]),
        ("mode7", vec!["mode7.ttf", "teletext.ttf"]),
        ("polaroid", vec!["fixed-13.ttf", "terminus.ttf"]),
    ]);
    
    let fonts = font_map.get(&theme.as_str())
        .ok_or("Unknown theme")?;
    
    install_fonts(fonts).await
}
```

---

## 📚 Documentation Standards

### README Structure
```markdown
# Extension Name

Brief description of the extension's purpose.

## Installation
[Installation instructions]

## Usage
[Usage examples with uCODE syntax]

## Configuration
[Configuration options]

## Dependencies
[List of required extensions]

## Compatibility
[uDESK version compatibility]
```

### Code Documentation
```rust
/// Executes a uCODE command within the specified role context
/// 
/// # Arguments
/// * `command` - uCODE formatted command string
/// * `role_level` - User's current role level (10-100)
/// 
/// # Returns
/// * `Ok(String)` - Command output
/// * `Err(String)` - Error message
/// 
/// # Examples
/// ```
/// let result = execute_ucode("[HELP|COMMANDS]", 50).await?;
/// ```
#[tauri::command]
pub async fn execute_ucode(command: String, role_level: u8) -> Result<String, String> {
    // Implementation
}
```

This style guide establishes the visual and development standards for uDESK v1.7, ensuring consistency across the TinyCore rebrand architecture while maintaining the distinctive uDOS character and extensibility.
