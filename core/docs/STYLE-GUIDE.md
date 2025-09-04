# uDESK v1.0.7 Style Guide

## uDESK Capitalization Standards

### System Components
```
uDOS     uDESK    uCORE    uMEMORY   uNETWORK
uSCRIPT  uKNOWLEDGE       # Core system modules

# Legacy components (deprecated in v1.0.7)
# uGRID    uMAP     uDATA   uCELL     uTILE
# uHEX     uWORK    uBRIEF  uDEV      uREPORT  uTASK
```

### System Architecture (v1.0.7)
```
Build Modes:     user, wizard-plus, developer, iso
Platforms:       macOS, Ubuntu, Windows
Desktop App:     Tauri-based cross-platform application
Extensions:      Mode-aware extension system
```

### ⌨️ **Command Syntax (uCODE v1.0.7)**
```ucode
# uCODE shortcode default
[HELP]                    ~ System help
[MEMORY|SEARCH*term]      ~ Memory operations
[GRID|INIT*80/30]        ~ Grid initialization
[TEMPLATE|PROCESS*file.md]   ~ Template processing

# Full command mode (uSCRIPT functions)
[HELP]
[MEMORY|SEARCH*term]
[GRID|INIT*80/30]
[TEMPLATE|PROCESS*file.md]

# v1.0.7 Examples:
[BUILD|USER]                   ~ Build user mode
[MODE|SET*DEV]                 ~ Switch to developer mode
[EXT|INSTALL*NAME]             ~ Install extension
[CONF|GET*KEY]                 ~ Get configuration value
```

### 🔧 **Variable Naming**
```bash
# Shell variables: CAPS-DASH-NUMBERS
USER-INPUT=""
SYSTEM-STATUS="active"
GRID-WIDTH=80
BUILD-MODE="developer"
PLATFORM-TYPE="macOS"

# Template variables: CAPS-DASH-NUMBERS
{USER-NAME}
{GRID-SIZE}
{SYSTEM-STATUS}
{BUILD-MODE}
{PLATFORM-TYPE}
```

### Commands: CAPS-DASH-NUMBERS (v1.0.7)
```
# Core Commands
HELP     STATUS   INFO     BUILD    MODE
EXT      CONF     THEME    BACKUP   RESTORE
REPAIR   STAGE    APP      

# System Control  
RESTART  RESET    UNDO     REDO

# Development
DEV      TEST     DEBUG    DEPLOY
```

### Roles: Correct 8-Tier Hierarchy (v1.0.7)
```
👻 GHOST     ⚰️ TOMB      🤖 DRONE     🔐 CRYPT   
😈 IMP       ⚔️ KNIGHT    🔮 SORCERER  🧙‍♂️ WIZARD
```

### 🔤 **uDESK Syntax Characters (v1.0.7)**
```ucode
# Variable references: Single curly brackets
{VARIABLE}
{USER-NAME}
{GRID-SIZE}
{BUILD-MODE}
{PLATFORM-TYPE}

# Commands: Square brackets
[COMMAND]
[HELP]
[MEMORY|SEARCH*term]
[BUILD|USER]
[MODE|SET*DEV]
[EXT|INSTALL*NAME]

# Functions: Angle brackets
<FUNCTION>
<INIT>
<PROCESS>
<BUILD>
<DEPLOY>

~ Operators:
|  ~ Pipe for command actions
*  ~ Asterisk for parameters
/  ~ Slash for multiple parameters

~ Comments: Both # and ~ are REM in uCODE
# This is a full line comment
[HELP]                    ~ End-of-line comment
~ uCODE avoids these characters: '"`&%$

# Character Usage in Regular Text:
~ Avoid uCODE special characters in regular operations: []{}<>~/\|
~ Example: "Press [Enter]" could confuse with system shortcode
~ Preferred: "Press ENTER to continue" (all caps, no brackets)
~ uCODE avoids these characters altogether: '"`&%$
~ Minimize quotes: "Press ENTER" → Press ENTER
```

### 🌈 **Terminal Color Palettes (8 Available)**
```css
/* Polaroid Colors (System Default) - High-contrast photo-inspired */
--red:     #FF1744    /* tput 196 - Bold Red */
--green:   #00E676    /* tput 46  - Bright Green */
--yellow:  #FFEB3B    /* tput 226 - Yellow Burst */
--blue:    #2196F3    /* tput 21  - Deep Blue */
--purple:  #E91E63    /* tput 201 - Magenta Pink */
--cyan:    #00E5FF    /* tput 51  - Cyan Flash */
--white:   #FFFFFF    /* tput 15  - Pure White */
--black:   #000000    /* tput 16  - Pure Black */
```

### Examples (v1.0.7)
```bash
# ✅ Correct uDESK v1.0.7 formatting
Usage: udesk [COMMAND] [OPTIONS]   # Commands in caps
Help:  udesk HELP [COMMAND]        # Commands in caps
  BUILD        Build system - user, wizard-plus, developer, iso modes
  MODE         Mode management - get current mode, switch modes
  EXT          Extension system - install, remove, list extensions
  CONF         Configuration - get, set, list, reset configurations

Examples:
  udesk build user                 # Command caps, examples lowercase
  udesk mode set dev               # Command caps, examples lowercase
  udesk ext install monitor       # Command caps, examples lowercase
  udesk conf get build-mode       # Command caps, examples lowercase

# ❌ Incorrect formatting  
Usage: udesk [command] [options]   # Should be: udesk [COMMAND] [OPTIONS]
  build        BUILD SYSTEM       # Should be: BUILD with sentence case description
udesk BUILD USER                   # Should be: lowercase examples
```

## Code Style Guidelines (v1.0.7)

### Cross-Platform Shell Scripts
- Use `#!/bin/bash` for unified build system compatibility
- Support macOS, Ubuntu, and Windows (via MSYS2/MinGW)
- Use cross-platform commands when possible
- Test on all supported platforms
- Variables in UPPER_CASE for environment variables
- Variables in lower_case for local variables
- Use descriptive function names with underscores: `build_user_mode()`

### Platform Detection
```bash
# Platform detection pattern
case "$(uname)" in
    "Darwin") 
        # macOS-specific code
        ;;
    "Linux")
        # Ubuntu/Linux-specific code
        ;;
    "MINGW"*|"MSYS"*)
        # Windows-specific code
        ;;
esac
```

### File Naming Conventions (v1.0.7)
- Shell scripts: lowercase with hyphens (`build-system.sh`, platform launchers)
- Documentation: uppercase with hyphens (`README.md`, `BUILD.md`, `USER-CODE-MANUAL.md`)
- Rust/Tauri files: snake_case (`main.rs`, `tauri.conf.json`)
- JavaScript modules: lowercase with hyphens (`udesk-workflow.js`)
- Configuration files: lowercase (`config.json`, `.gitignore`)
- Platform launchers: descriptive with extensions (`.command`, `.sh`, `.bat`)

### Documentation Style (v1.0.7)
- Use clear, concise headers
- Include examples for all commands
- Document cross-platform differences
- **Depunctuation**: Remove unnecessary backticks around command syntax in tables for cleaner readability
- Maintain consistent emoji usage:
  - ✅ Success/completed
  - ❌ Error/failed
  - 🌟 Main features
  - 📖 Documentation
  - 🔧 Configuration
  - 🧪 Testing
  - 📊 Data/statistics
  - 🚀 Launch/execute
  - 🎯 Target/goal achieved
  - 🔄 Process/workflow

### Code Organization (v1.0.7)
- Keep functions under 50 lines when possible
- Use meaningful variable names
- Comment complex logic
- Group related functions together
- Separate concerns into modules
- Follow mode-based architecture (user/wizard-plus/developer)
- Implement cross-platform compatibility patterns

### Error Handling (v1.0.7)
- Always check command exit codes
- Provide helpful error messages with platform context
- Use consistent error formatting across platforms
- Log errors appropriately to build logs
- Handle platform-specific error conditions

### Rust/Tauri Style (v1.0.7)
- Follow standard Rust conventions (snake_case, etc.)
- Use `cargo fmt` for consistent formatting
- Handle errors with `Result<T, E>` types
- Use descriptive function and variable names
- Implement proper error propagation
- Follow Tauri security best practices

### JavaScript/TypeScript Style (Desktop App)
- Use semicolons consistently
- Prefer `const` and `let` over `var`
- Use descriptive function names
- Handle errors gracefully
- Use modern ES6+ features
- Follow Tauri frontend patterns

### Directory Structure (v1.0.7)
```
/core/docs          - Core documentation
/core/docs/dev      - Developer documentation  
/core/config        - System configuration
/uCORE              - Core runtime system
/uMEMORY            - Memory management
/uNETWORK           - Network operations
/uSCRIPT            - Script execution
/uKNOWLEDGE         - Knowledge management
/app/udesk-app      - Tauri desktop application
/app/udesk-app/tauri - Tauri backend (Rust)
/extensions         - Extension system
/build              - Build artifacts
/usr                - User data and configurations
```

### Version Control (v1.0.7)
- Use conventional commit messages
- Keep commits atomic and focused
- Tag releases with semantic versioning (v1.0.7+)
- Maintain clean git history
- Document cross-platform testing in commits
- Include platform-specific changes in commit messages

### Testing (v1.0.7)
- Test unified build system on all platforms
- Validate cross-platform compatibility
- Test desktop application builds
- Test extension system functionality
- Validate mode switching operations
- Document test procedures for each platform

## Command Line Interface Standards (v1.0.7)

### Help Messages
- Always provide `--help` option
- Include usage examples for each mode
- Show available subcommands and modes
- Use consistent formatting across platforms
- Document platform-specific differences

### Exit Codes (Cross-Platform)
- 0: Success
- 1: General error
- 2: Misuse of command
- 3: Platform compatibility error
- 126: Command not executable
- 127: Command not found

### Output Format (v1.0.7)
- Use consistent icons and formatting
- Provide progress indicators for build operations
- Use colors appropriately (with fallbacks for Windows)
- Keep output concise but informative
- Include platform detection information
- Show current mode in status outputs

### Mode-Specific Behaviors
- **User Mode**: Simple, essential commands only
- **Wizard+ Mode**: Advanced features with helpful warnings
- **Developer Mode**: Full command set with detailed output
- **ISO Mode**: Specialized bootable system creation
