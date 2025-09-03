# uDESK Quick Style Reference

```
██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗
██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝
██║   ██║██║  ██║█████╗  ███████╗█████╔╝ 
██║   ██║██║  ██║██╔══╝  ╚════██║██╔# Wrong variable naming
local UserRole="tomb"              # Should be: user_role
readonly max-retries=3             # Should be: MAX_RETRIES╗ 
╚██████╔╝██████╔╝███████╗███████║██║  ██╗
 ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
```

*Universal Device Operating System - TinyCore Edition*

**Quick Reference**: Essential coding and formatting rules for uDESK v1.0.5
**Complete Guide**: See [STYLE-GUIDE.md](STYLE-GUIDE.md) for comprehensive specifications
**Version**: 1.0.5 | **Updated**: September 3, 2025 | **Status**: Clean Architecture

---

## 🚀 Essential Rules Summary

### 📝 **Code Formatting**
```bash
# Function names: lowercase with underscores
udos_init() {
    # Variables: lowercase with underscores
    local user_role="TOMB"
    # Constants: UPPERCASE with underscores
    readonly VERSION="1.0.5"
}

# File extensions: always lowercase
install-clean-udos.sh    config.env    readme.md
```

### 🔤 **Capitalization Standards**
```markdown
# System Components: Mixed case, descriptive
uDESK    uDOS     TinyCore    Universal Device Operating System

# Commands: Display in CAPS, accept lowercase input
UDOS HELP        → udos help
UDOS VAR SET     → udos var set  
UDOS ROLE DETECT → udos role detect
UVAR GET         → uvar get
UTPL LIST        → utpl list

# Variables: CAPS-DASH format for display, lowercase for files
{USER-NAME}      → stored as: ~/.udos/vars/user_name
{GRID-SIZE}      → stored as: ~/.udos/vars/grid_size
{SYSTEM-STATUS}  → stored as: ~/.udos/vars/system_status

# Roles: Title Case (8 Standard Hierarchy)
👻 GHOST → ⚰️ TOMB → 🤖 DRONE → � CRYPT → 😈 IMP → ⚔️ KNIGHT → 🧙‍♂️ SORCERER → 🧙‍♀️ WIZARD

# File types: lowercase extensions
.sh      .env      .md      .json     .tcz
```

### ⌨️ **Command Syntax**
```bash
# Primary commands (case-insensitive input)
udos help                    # System help
udos init                    # Initialize environment
udos var set KEY=VALUE       # Variable management
udos role detect             # Role detection
udos tpl create NAME         # Template creation

# Wrapper commands (backward compatibility)
uvar set TEST=hello          # Variable wrapper
udata list                   # Data wrapper  
utpl list                    # Template wrapper

# Display format (documentation/help)
UDOS HELP                    # Shows as caps in help
UDOS VAR SET KEY=VALUE       # Shows as caps in docs
UVAR GET KEY                 # Shows as caps in reference
```

### 🔧 **Variable Naming**
```bash
# Shell variables: lowercase with underscores
user_input=""
system_status="active"
udos_home="${HOME}/.udos"

# Environment variables: CAPS with underscores
UDOS_VERSION="1.0.5"
UDOS_HOME="${HOME}/.udos"
USER_ROLE="TOMB"

# Template variables: CAPS-DASH for display
{USER-NAME}      # Display format
{ROLE-SCORE}     # Display format
{INIT-DATE}      # Display format
```

### 🔤 **Text Formatting Standards**
```markdown
# Minimize quotes in documentation
❌ Press "Enter" to continue
✅ Press ENTER to continue

❌ Type "udos help" for assistance  
✅ Type UDOS HELP for assistance

❌ The "role" system has eight levels
✅ The ROLE system has eight levels

# Command references
❌ Run the command "udos init"
✅ Run UDOS INIT command
✅ Execute: udos init

# File and path references
✅ Edit ~/.profile file
✅ Check /usr/local/bin directory
✅ Template: readme.md

# UI elements and keys
✅ Click **Save** button
✅ Press CTRL+C to exit
✅ Select **Initialize** option
```

### 🌈 **TinyCore Terminal Colors**
```bash
# POSIX-compatible color variables
RED='\033[0;31m'       # Error messages
GREEN='\033[0;32m'     # Success messages  
BLUE='\033[0;34m'      # Information
YELLOW='\033[1;33m'    # Warnings
CYAN='\033[0;36m'      # Headers
NC='\033[0m'           # No Color

# Usage in scripts
log_error() { printf "${RED}❌ %s${NC}\n" "$1"; }
log_success() { printf "${GREEN}✅ %s${NC}\n" "$1"; }
log_info() { printf "${CYAN}ℹ️  %s${NC}\n" "$1"; }
```

### 📂 **Naming Conventions**
```bash
# Scripts: lowercase with hyphens
install-clean-udos.sh
quick-clean-setup.sh
udos-boot-art.sh

# Configuration files: lowercase with extensions
config.env
settings.json
template.md

# Documentation: UPPERCASE for main docs
README.md
STYLE-GUIDE.md  
INSTALL-COMMANDS.md

# Regular docs: lowercase with hyphens
quick-start.md
troubleshooting.md
user-guide.md

# TCZ packages: lowercase with version
udos-core.tcz
udos-vnc.tcz
udos-boot.tcz
```

---

## 🎨 Common Patterns

### ✅ **Correct Examples**
```bash
# Function definition
udos_var() {
    local key="$1"
    local value="$2"
    echo "Setting ${key} = ${value}"
}

# Variable assignment  
readonly UDOS_SYSTEM="/usr/local/share/udos"
local user_role="TOMB"

# Command documentation
UDOS VAR SET KEY=VALUE       # Display format
udos var set test=hello      # Actual command
```

### ❌ **Incorrect Examples**
```bash
# Wrong function naming
function UdosVar() {           # Should be: udos_var
function udos-var() {          # Should be: udos_var

# Wrong variable naming
local UserRole="apprentice"    # Should be: user_role
readonly max-retries=3         # Should be: MAX_RETRIES

# Wrong documentation format
"udos help"                    # Should be: UDOS HELP
'Press enter'                  # Should be: Press ENTER
Run "the command"              # Should be: Run COMMAND
```

---

## 📋 Quick Reference Tables

### **uDESK Commands**
| Display Format | Actual Command | Description |
|----------------|----------------|-------------|
| `UDOS HELP` | `udos help` | Show all commands |
| `UDOS INIT` | `udos init` | Initialize environment |
| `UDOS VAR SET KEY=VALUE` | `udos var set key=value` | Set variable |
| `UDOS ROLE DETECT` | `udos role detect` | Detect capabilities |
| `UVAR GET KEY` | `uvar get key` | Get variable (wrapper) |
| `UTPL LIST` | `utpl list` | List templates |

### **File Extensions**
| Type | Extension | Example |
|------|-----------|---------|
| Shell Scripts | `.sh` | `install-clean-udos.sh` |
| Configuration | `.env` | `config.env` |
| Documentation | `.md` | `README.md` |
| TCZ Packages | `.tcz` | `udos-core.tcz` |

### **Directory Structure**
| Path | Purpose | Example Files |
|------|---------|---------------|
| `/usr/local/bin/` | Main executables | `udos`, `uvar`, `udata`, `utpl` |
| `/usr/local/share/udos/` | System files | `templates/`, `lib/` |
| `/opt/udos/` | Optional data | `config/`, `logs/` |
| `~/.udos/` | User data | `vars/`, `data/`, `templates/` |

---

## 🔗 TinyCore Integration

### **TCZ Package Standards**
```bash
# Package naming: component-purpose.tcz
udos-core.tcz        # Main system
udos-vnc.tcz         # VNC integration
udos-boot.tcz        # Boot integration

# File structure within TCZ
usr/local/bin/udos             # Main executable
usr/local/share/udos/          # System files
usr/local/tce.installed/       # Post-install hooks
```

### **Persistence Configuration**
```bash
# Add to /opt/.filetool.lst
usr/local/bin/udos
usr/local/share/udos
opt/udos
home/tc/.udos

# Backup inclusion
~/.udos/vars
~/.udos/data  
~/.udos/templates
```

### **POSIX Compatibility**
```bash
# Use POSIX shell features only
[ condition ] instead of [[ condition ]]
printf instead of echo -e
command -v instead of which
$(command) instead of `command`

# Avoid bash-specific features
No arrays: array=(a b c)
No ${var,,} lowercase conversion
No ${var^} uppercase conversion
Use tr/sed for string manipulation
```

---

## 🚀 Getting Started Checklist

### **For Developers**
- [ ] Use `lowercase_with_underscores` for function names
- [ ] Use `CAPS_WITH_UNDERSCORES` for constants and environment variables
- [ ] Display commands in CAPS in documentation: UDOS HELP
- [ ] Accept lowercase input in actual commands: udos help
- [ ] Minimize quotes in text: Press ENTER not Press "Enter"
- [ ] Use POSIX shell compatibility for TinyCore
- [ ] Follow TCZ package naming conventions
- [ ] Include persistence configuration for TinyCore

### **For Documentation**
- [ ] Use **Bold** for UI elements, `code` for commands
- [ ] Show commands in CAPS: UDOS VAR SET
- [ ] Minimize quotation marks in instructions
- [ ] Use emoji prefixes for headers (🚀 📚 ⚙️)
- [ ] Reference actual file paths: ~/.udos/vars
- [ ] Include TinyCore-specific instructions
- [ ] Provide both display and actual command formats

### **For System Integration**
- [ ] Maintain clean `/usr/local/bin` structure
- [ ] Use `/usr/local/share/udos` for system files
- [ ] Configure TinyCore persistence properly
- [ ] Follow uDESK component naming
- [ ] Implement role-based access (8-level hierarchy)
- [ ] Use POSIX-compatible color codes
- [ ] Support wrapper commands for compatibility

---

## 📋 Role Hierarchy Reference

```
Level 1: 👻 GHOST      → No access, observer mode
Level 2: ⚰️ TOMB       → Basic file access, read-only mode
Level 3: 🤖 DRONE      → Basic commands, automated tasks
Level 4: � CRYPT      → Data encryption, secure storage
Level 5: 😈 IMP        → Script execution, mischievous automation
Level 6: ⚔️ KNIGHT     → System protection, security administration
Level 7: 🧙‍♂️ SORCERER  → Advanced scripting, system manipulation
Level 8: 🧙‍♀️ WIZARD    → Full system access, administrative control
```

**Role Detection**: Based on system capabilities and installed tools
**Role Advancement**: Automatic detection via UDOS ROLE DETECT command
**Role Storage**: ~/.udos/vars/role file

---

*uDESK Style Reference v1.0.5 - TinyCore Linux Edition*
*Clean Architecture | For complete specifications: [STYLE-GUIDE.md](STYLE-GUIDE.md)*
