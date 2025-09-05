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
Build Modes:     user, wizard, developer, iso
Platforms:       macOS, Ubuntu, Windows
Desktop App:     Tauri-based cross-platform application
Extensions:      Mode-aware extension system
```

### ⌨️ **Command Syntax (uCODE v1.0.7)**

#### **CLI Context (Terminal/uSCRIPT)**
```ucode
# Direct commands - case insensitive input, UPPERCASE output
help                          ~ Show general help
HELP                          ~ System responds in UPPERCASE
backup create full            ~ Create full backup
MEMORY SEARCH term            ~ Search for files
CONFIG SET THEME DARK         ~ Set theme to dark mode
```

#### **Documentation Context (Markdown/Shortcodes)**
```ucode
# Shortcodes with brackets for embedding in .md files
[HELP]                        ~ System help shortcode
[MEMORY|SEARCH*term]          ~ Memory search with parameter
[CONFIG|SET*THEME*DARK]       ~ Configuration with multiple parameters
[BACKUP|CREATE*{PROJECT-NAME}] ~ Using variables in shortcodes

# v1.0.7 Examples:
[BUILD|USER]                  ~ Build user mode
[MODE|SET*DEVELOPER]          ~ Switch to developer mode  
[EXT|INSTALL*{EXTENSION-NAME}] ~ Install extension with variable
[CONFIG|GET*THEME]            ~ Get configuration value
```

#### **UPPERCASE Rules**
```ucode
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

### 🔧 **Variable Naming (v1.0.7)**
```bash
# Shell variables: CAPS-DASH-NUMBERS
USER-INPUT=""
SYSTEM-STATUS="active"
BUILD-MODE="developer"
PLATFORM-TYPE="macOS"

# Template variables: CAPS-DASH-NUMBERS
{USER-NAME}                   ~ Current system user
{BUILD-MODE}                  ~ Active build configuration  
{SYSTEM-STATUS}               ~ Current system state
{PROJECT-PATH}                ~ Current project directory
{BACKUP-COUNT}                ~ Number of available backups

# Function variables: CAPS-DASH-NUMBERS with pipe parameters
<BACKUP-SCRIPT|FULL>          ~ Execute full backup function
<DEPLOY-SITE|PRODUCTION>      ~ Deploy to production environment
<ANALYZE-LOGS|ERROR-LEVEL>    ~ Analyze logs at error level
```

### Commands: CAPS-DASH-NUMBERS (v1.0.7)
```
# Core Commands
HELP     STATUS   INFO     BUILD    MODE
EXT      CONFIG   THEME    BACKUP   RESTORE  
MEMORY   SEARCH   

# Shell Commands
EXIT     QUIT     ROLE     

# System Control  
RESTART  RESET    

# Development
DEBUG    DEPLOY   TEST
```

### Roles: Correct 8-Tier Hierarchy (v1.0.7)
```
👻 GHOST     ⚰️ TOMB      🤖 DRONE     🔐 CRYPT   
😈 IMP       ⚔️ KNIGHT    🔮 SORCERER  🧙‍♂️ WIZARD
```

### 🔤 **uDESK Syntax Characters (v1.0.7)**
```ucode
# Variable references: Single curly brackets  
{VARIABLE}                    ~ System variables
{USER-NAME}                   ~ Current user
{BUILD-MODE}                  ~ Build configuration
{PROJECT-PATH}                ~ Project directory

# Commands: Square brackets (shortcodes) or direct (CLI)
[COMMAND]                     ~ Shortcode format for documentation
COMMAND                       ~ Direct CLI format (case insensitive)
[HELP]                        ~ Help shortcode
HELP                          ~ Help command (input)
HELP                          ~ Help response (UPPERCASE output)

# Functions: Angle brackets with parameters
<FUNCTION>                    ~ Function reference
<BACKUP-SCRIPT>               ~ Simple function call
<DEPLOY-SITE|PRODUCTION>      ~ Function with single parameter
<BACKUP-PROJECT|{PROJECT-NAME}|INCREMENTAL> ~ Function with variables

~ Operators:
|  ~ Pipe for command actions
*  ~ Asterisk for parameters
/  ~ Slash for multiple parameters

~ Comments: Both # and ~ are REM in uCODE
# This is a full line comment
HELP                          ~ End-of-line comment
~ uCODE avoids these characters: '"`&%$

# Character usage in regular text:
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
Usage: udesk COMMAND OPTIONS                   ~ Commands in UPPERCASE
Help:  udesk HELP COMMAND                      ~ Commands in UPPERCASE

Commands:
  BUILD        Build system in specified mode
  MODE         Manage current operational mode  
  EXT          Extension system operations
  CONFIG       Configuration management

Variables:
  {USER-NAME}       Current system user
  {BUILD-MODE}      Active build configuration
  {PROJECT-PATH}    Current project directory

Examples:
  udesk build user                    ~ Build user mode
  udesk config set theme dark         ~ Set dark theme
  udesk ext install {EXTENSION-NAME}  ~ Install extension

# ❌ Incorrect formatting
Usage: udesk command options          ~ Should be: COMMAND OPTIONS
Help:  udesk help command            ~ Should be: HELP COMMAND
Variables: {user-name}               ~ Should be: {USER-NAME}

# Don't use quotes unnecessarily  
"Press ENTER to continue"            ~ Should be: Press ENTER to continue
Use "CONFIG SET" command             ~ Should be: Use CONFIG SET command
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
- Follow role-based architecture (user/wizard/developer)
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
- **Wizard Role**: Highest user role with extension development
- **Developer Mode**: Full command set with detailed output
- **ISO Mode**: Specialized bootable system creation
