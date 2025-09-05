# Development Workflow Guide - uDESK v1.0.7
## Enhanced Command System & Cross-Platform Development

### Overview
This document outlines the development workflow for uDESK v1.0.7, incorporating the enhanced dual-context command system, UPPERCASE formatting standards, and cross-platform build processes.

---

## Command System Development Workflow

### 1. Command Format Standards

#### **CLI Context Commands**
- **Input**: Case-insensitive (`help`, `HELP`, `Help` all accepted)
- **Output**: Always UPPERCASE display (`HELP`, `BACKUP`, `CONFIG`)
- **Format**: Direct commands without brackets
- **Implementation**: Use `toupper()` for case conversion

```c
// Example implementation
#include <ctype.h>

char upper_cmd[256];
for (int i = 0; input[i]; i++) {
    upper_cmd[i] = toupper(input[i]);
}

if (strncmp(upper_cmd, "HELP", 4) == 0) {
    printf("  HELP     - This help\n");
}
```

#### **Documentation Context Commands** 
- **Format**: Shortcodes with brackets `[COMMAND|OPTION*PARAMETER]`
- **Display**: Always UPPERCASE in brackets
- **Usage**: Markdown documentation, embedded examples
- **Parsing**: Regex pattern matching for complex commands

```c
// Example shortcode parsing
if (strncmp(command, "[HELP]", 6) == 0) {
    printf("  [HELP]        - This help\n");
}
if (strncmp(command, "[CONFIG|SET*", 12) == 0) {
    // Parse KEY*VALUE parameters
}
```

### 2. Mode-Specific Development

#### **User Mode** (`./build.sh user`)
- **Target**: Standard users (all role levels)
- **Commands**: `BACKUP`, `RESTORE`, `INFO`, `HELP`, `CONFIG`, `EXIT`
- **Access**: User workspace only
- **Testing**: `echo "HELP" | ./build/user/udos`

#### **Wizard+ Mode** (`./build.sh wizard-plus`)
- **Target**: WIZARD role users
- **Commands**: `[PLUS-MODE]`, `[CREATE-EXT]`, `[BUILD-TCZ]`, `[HELP]`, `EXIT`
- **Access**: User space + extension development
- **Testing**: `UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus`

#### **Developer Mode** (`./build.sh developer`)
- **Target**: Core system developers
- **Commands**: `[BUILD-CORE]`, `[BUILD-ISO]`, `[SYSTEM-INFO]`, `[HELP]`, `EXIT`
- **Access**: Full system modification
- **Testing**: `./build/developer/udos-developer`

---

## Build System Workflow

### 1. Development Testing Cycle

```bash
# 1. Code changes in build.sh
vim build.sh

# 2. Test user mode (fastest build)
./build.sh user
echo -e "HELP\nINFO\nEXIT" | ./build/user/udos

# 3. Test case-insensitive input
echo -e "help\nHELP\nHelp\nbackup\nBACKUP\nEXIT" | ./build/user/udos

# 4. Test wizard+ mode (if WIZARD role changes)
UDESK_ROLE=WIZARD ./build.sh wizard-plus
echo -e "[HELP]\n[PLUS-STATUS]\nEXIT" | UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus

# 5. Test developer mode (if core system changes)
./build.sh developer
echo -e "[HELP]\n[SYSTEM-INFO]\nEXIT" | ./build/developer/udos-developer
```

### 2. Cross-Platform Testing

```bash
# Test platform launchers
./uDESK-macOS.sh         # Test macOS integration
./uDESK-Ubuntu.sh        # Test Ubuntu/Debian
# ./uDESK-Windows.bat    # Test Windows (if available)

# Validate dependencies
./installers/install.sh --test      # Test installation script
```

### 3. ISO Build Testing (Optional)

```bash
# Build TinyCore ISO
./build.sh iso

# Test ISO components
ls -la build/iso/
```

---

## Documentation Workflow

### 1. Command Documentation Updates

When adding new commands, update these files in order:

1. **Core Implementation** (`build.sh`)
   - Add command parsing logic
   - Add help text (UPPERCASE format)
   - Test with `echo "COMMAND" | ./build/mode/udos`

2. **Style Guide** (`core/docs/STYLE-GUIDE.md`)
   - Add command syntax rules
   - Update character usage guidelines
   - Add formatting examples

3. **User Manual** (`core/docs/UCODE-MANUAL.md`)
   - Add to appropriate command table
   - Include both CLI and Shortcode formats
   - Update Quick Reference section

### 2. Documentation Format Standards

#### **Command Tables Format**
```markdown
| CLI Command | Shortcode | Description | Function |
|-------------|-----------|-------------|----------|
| BACKUP | [BACKUP] | Create system backup | Cross-platform backup system |
| BACKUP FULL | [BACKUP\|FULL] | Complete system backup | Includes all user data and configs |
```

#### **Command Examples Format**
```markdown
# CLI Context (Terminal)
HELP                          ~ Get help
BACKUP                        ~ Create backup
CONFIG SET KEY VALUE          ~ Set configuration

# Documentation Context (Shortcodes)
[HELP]                        ~ Get help shortcode
[BACKUP]                      ~ Create backup shortcode
[CONFIG|SET*KEY*VALUE]        ~ Set configuration shortcode
```

---

## Testing Procedures

### 1. Command Testing Matrix

| Test Case | User Mode | Wizard+ Mode | Developer Mode |
|-----------|-----------|--------------|----------------|
| Lowercase input | `echo "help" \| ./build/user/udos` | `echo "exit" \| ./build/wizard-plus/udos-wizard-plus` | `echo "exit" \| ./build/developer/udos-developer` |
| UPPERCASE input | `echo "HELP" \| ./build/user/udos` | `echo "EXIT" \| ./build/wizard-plus/udos-wizard-plus` | `echo "EXIT" \| ./build/developer/udos-developer` |
| Mixed case input | `echo "Help" \| ./build/user/udos` | `echo "Exit" \| ./build/wizard-plus/udos-wizard-plus` | `echo "Exit" \| ./build/developer/udos-developer` |
| Shortcode format | N/A | `echo "[HELP]" \| ./build/wizard-plus/udos-wizard-plus` | `echo "[HELP]" \| ./build/developer/udos-developer` |

### 2. Regression Testing

```bash
# Quick regression test script
#!/bin/bash
set -e

echo "Testing User Mode..."
./build.sh user
echo -e "HELP\nINFO\nCONFIG\nEXIT" | ./build/user/udos

echo "Testing Wizard+ Mode..."
UDESK_ROLE=WIZARD ./build.sh wizard-plus
echo -e "[HELP]\n[PLUS-STATUS]\nEXIT" | UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus

echo "Testing Developer Mode..."
./build.sh developer
echo -e "[HELP]\n[SYSTEM-INFO]\nEXIT" | ./build/developer/udos-developer

echo "All tests passed!"
```

---

## Git Workflow

### 1. Branch Management

```bash
# Create feature branch
git checkout -b feature/command-system-v1.0.7

# Development commits
git add .
git commit -m "feat: implement UPPERCASE command display format"
git commit -m "fix: add case-insensitive input processing"
git commit -m "docs: update UCODE-MANUAL with dual-context examples"

# Merge to main
git checkout main
git merge feature/command-system-v1.0.7
```

### 2. Commit Message Standards

```bash
# Feature additions
git commit -m "feat: add new [COMMAND] with UPPERCASE display"

# Bug fixes
git commit -m "fix: correct exit command handling in wizard+ mode"

# Documentation updates
git commit -m "docs: update command tables with CLI/Shortcode format"

# Testing improvements
git commit -m "test: add case-insensitive input validation"

# Refactoring
git commit -m "refactor: consolidate command processing logic"
```

### 3. Release Preparation

```bash
# Validate all modes
./build.sh clean
./build.sh user && ./build.sh wizard-plus && ./build.sh developer

# Update version references
grep -r "v1.0.7" . --include="*.md" --include="*.sh" --include="*.c"

# Final testing
./core/docs/dev/regression-test.sh

# Tag release
git tag -a v1.0.7 -m "uDESK v1.0.7 - Enhanced command system with dual-context support"
git push origin v1.0.7
```

---

## AI Assistant Integration

### 1. Copilot Instructions

- Always use UPPERCASE for command display in code comments
- Implement case-insensitive input processing with `toupper()`
- Include both CLI and shortcode examples in documentation
- Test commands in all three modes (user/wizard+/developer)
- Update documentation files in correct order (implementation → style guide → manual)

### 2. Common Patterns

```c
// Command processing pattern
if (strncmp(upper_cmd, "HELP", 4) == 0) {
    printf("📖 uDESK v1.0.7 User Commands\n\n");
    printf("USER uCODE COMMANDS:\n");
    printf("  HELP     - This help\n");
    return 0;
}

// Exit handling pattern (all modes)
if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
    strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
    printf("👋 Goodbye! Thanks for using uDESK v1.0.7\n");
    break;
}
```

---

## Version Control

**Current Status**: uDESK v1.0.7
- ✅ Dual-context command system implemented
- ✅ UPPERCASE display format with case-insensitive input
- ✅ Three-mode build system (user/wizard+/developer)
- ✅ Cross-platform launcher integration
- ✅ Complete documentation coverage

**Next Phase**: Continue iterating on enhanced features and cross-platform optimizations.

---

*This workflow ensures consistent development practices for uDESK v1.0.7 with proper command formatting, comprehensive testing, and clear documentation standards.*
