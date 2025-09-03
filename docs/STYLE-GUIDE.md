# uDESK Style Guide

## uDOS Capitalization Standards

### System Components
```
uDOS    uCORE    uGRID    uMAP    uDATA
uCELL   uTILE    uHEX     uWORK   uBRIEF
uDEV    uREPORT  uTASK    uMEMORY uKNOWLEDGE
```

### Command Syntax
```ucode
[COMMAND|OPTION*PARAMETER]     ~ Universal shortcode syntax
{VARIABLE-NAME}                ~ Variables: CAPS-DASH-NUMBERS
<FUNCTION>                     ~ Functions: angle brackets
```

### Variable Naming
```bash
# Shell/Template variables: CAPS-DASH-NUMBERS
USER-INPUT=""
SYSTEM-STATUS="active"
GRID-WIDTH=80

# Template variables: CAPS-DASH-NUMBERS
{USER-NAME}
{GRID-SIZE}
{SYSTEM-STATUS}
```

### Commands: CAPS-DASH-NUMBERS
```
HELP     STATUS   GRID    TEMPLATE
MEMORY   SEARCH   INIT    PROCESS
```

### Roles: Title Case (8 Standard Roles)
```
👻 Ghost   ⚰️ Tomb   🔐 Crypt   🤖 Drone   
⚔️ Knight   😈 Imp   🧙‍♂️ Sorcerer   🧙‍♀️ Wizard
```

### uCODE Syntax Characters
```ucode
# Variable references: Single curly brackets
{VARIABLE}
{USER-NAME}
{GRID-SIZE}

# Commands: Square brackets
[COMMAND]
[HELP]
[MEMORY|SEARCH*term]

# Functions: Angle brackets
<FUNCTION>
<INIT>
<PROCESS>

~ Operators:
|  ~ Pipe for command actions
*  ~ Asterisk for parameters
/  ~ Slash for multiple parameters

~ Comments: Both # and ~ are REM in uCODE
# This is a full line comment
[HELP]                    ~ End-of-line comment
~ uCODE avoids these characters: '"`&%$
```

### Examples
```bash
# ✅ Correct uDOS formatting
Usage: udos [COMMAND] [OPTIONS]   # Commands in caps
Help:  udos HELP [COMMAND]        # Commands in caps
  VAR          Variable system - set, get, list, delete variables    # Command caps, description sentence case
  DATA         Data management, backup and restore                   # Command caps, description sentence case

Examples:
  uvar SET name=value             # Command caps, examples lowercase
  uvar GET name                   # Command caps, examples lowercase
  uvar LIST                       # Command caps

# ❌ Incorrect formatting  
Usage: udos [command] [options]   # Should be: udos [COMMAND] [OPTIONS]
  var          VARIABLE SYSTEM    # Should be: VAR with sentence case description
udos var set USER-NAME=VALUE      # Should be: lowercase examples
```

## Code Style Guidelines

### Shell Scripts
- Use `#!/bin/sh` for maximum portability
- Prefer POSIX-compliant shell features
- Use `#!/usr/bin/env bash` only when bash-specific features are required
- Variables in UPPER_CASE for environment variables
- Variables in lower_case for local variables
- Use descriptive function names with underscores: `init_system()`

### File Naming Conventions
- Shell scripts: lowercase with hyphens (`install-system.sh`)
- Documentation: uppercase with hyphens (`README.md`, `INSTALL.md`)
- JavaScript modules: lowercase with hyphens (`udos-workflow.js`)
- Configuration files: lowercase (`config.json`, `.gitignore`)

### Documentation Style
- Use clear, concise headers
- Include examples for all commands
- Maintain consistent emoji usage:
  - ✅ Success/completed
  - ❌ Error/failed
  - 🌟 Main features
  - 📖 Documentation
  - 🔧 Configuration
  - 🧪 Testing
  - 📊 Data/statistics
  - 🚀 Launch/execute

### Code Organization
- Keep functions under 50 lines when possible
- Use meaningful variable names
- Comment complex logic
- Group related functions together
- Separate concerns into modules

### Error Handling
- Always check command exit codes
- Provide helpful error messages
- Use consistent error formatting
- Log errors appropriately

### JavaScript Style
- Use semicolons consistently
- Prefer `const` and `let` over `var`
- Use descriptive function names
- Handle errors gracefully
- Use modern ES6+ features when available

### Directory Structure
```
/docs           - User documentation
/docs/dev       - Developer documentation
/docs/roadmaps  - Future development plans
/usr/bin        - Executable scripts
/usr/share      - Shared modules and data
/dev            - Development tools and tests
/build          - Build artifacts
```

### Version Control
- Use meaningful commit messages
- Keep commits atomic and focused
- Tag releases with semantic versioning
- Maintain clean git history

### Testing
- Test all shell scripts on multiple platforms
- Validate JSON configuration files
- Test error conditions
- Document test procedures

## Command Line Interface Standards

### Help Messages
- Always provide `--help` option
- Include usage examples
- Show available subcommands
- Use consistent formatting

### Exit Codes
- 0: Success
- 1: General error
- 2: Misuse of command
- 126: Command not executable
- 127: Command not found

### Output Format
- Use consistent icons and formatting
- Provide progress indicators for long operations
- Use colors appropriately (with fallbacks)
- Keep output concise but informative
