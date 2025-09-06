# uDESK File Organization Guidelines
## Unified Development Environment Structure

### 🎯 Core Principle
All development files, testing scripts, logs, and temporary files should be organized within the uMEMORY structure following Linux-style dotted directory conventions.

## 📁 Directory Structure

### Root Level (uDESK/)
**ONLY** production-ready files and directories:
```
uDESK/
├── app/                    # Tauri application
├── assets/                 # Production assets
├── build/                  # Build configuration
├── core/                   # Core workflow scripts
├── dev/                    # Development utilities (permanent)
├── docs/                   # Documentation
├── installers/             # Installation scripts
├── scripts/                # Production scripts
├── src/                    # Source code
├── system/                 # System files
├── uMEMORY/               # Memory/data organization
├── README.md              # Project documentation
├── LICENSE                # License file
├── build.sh               # Production build script
├── install.sh             # Main installer
└── uDESK.code-workspace   # VSCode workspace
```

### uMEMORY Organization
```
uMEMORY/
├── .local/                # Local system files (Linux convention)
│   ├── backups/           # Backup files
│   ├── logs/              # Log files
│   └── state/             # System state
├── sandbox/               # Development sandbox
│   ├── scripts/           # Development/utility scripts
│   ├── testing/           # Test scripts and data
│   ├── workflows/         # Workflow development
│   └── builds/            # Development builds
├── config/                # Configuration files
├── projects/              # Project-specific data
└── templates/             # Template files
```

## 🚀 Workflow Rules

### ✅ DO
- **Development Scripts** → `uMEMORY/sandbox/scripts/`
- **Test Files** → `uMEMORY/sandbox/testing/`
- **Logs/Errors** → `uMEMORY/.local/logs/`
- **Backups** → `uMEMORY/.local/backups/`
- **Development Builds** → `uMEMORY/sandbox/builds/`
- **Workflow Development** → `uMEMORY/sandbox/workflows/`
- **Installer Scripts** → `installers/`

### ❌ DON'T
- **Never** put test scripts in root
- **Never** put temporary files in root
- **Never** put development scripts in root
- **Never** put logs/backups in root
- **Never** put one-off scripts in root

### 🔧 Migration Commands
When files are misplaced, use these commands:

```bash
# Move test scripts
mv test-*.sh uMEMORY/sandbox/testing/

# Move development scripts
mv *-dev.sh launch-*.sh add-*.sh uMEMORY/sandbox/scripts/

# Move installer scripts
mv *-install*.sh *-install*.bat installers/

# Move logs
mv *.log error.log uMEMORY/.local/logs/

# Move backups
mv *.bak *.backup uMEMORY/.local/backups/

# Move development workflows
mv workflow-*.sh uMEMORY/sandbox/workflows/
```

## 🎯 Integration with Unified Workflow

### Auto-Organization Script
Create `uMEMORY/.scripts/organize-files.sh`:

```bash
#!/bin/bash
# Auto-organize misplaced files

cd "$(dirname "$0")/../.."

# Test scripts
find . -maxdepth 1 -name "test-*.sh" -exec mv {} uMEMORY/.testing/ \;

# Development scripts
find . -maxdepth 1 -name "*-dev.sh" -exec mv {} uMEMORY/.scripts/ \;
find . -maxdepth 1 -name "launch-*.sh" -exec mv {} uMEMORY/.scripts/ \;
find . -maxdepth 1 -name "add-*.sh" -exec mv {} uMEMORY/.scripts/ \;

# Installer scripts (if not in installers/)
find . -maxdepth 1 -name "*install*.sh" -not -name "install.sh" -exec mv {} installers/ \;
find . -maxdepth 1 -name "*install*.bat" -exec mv {} installers/ \;

# Logs
find . -maxdepth 1 -name "*.log" -exec mv {} uMEMORY/.local/logs/ \;

# Backups
find . -maxdepth 1 -name "*.bak" -exec mv {} uMEMORY/.local/backups/ \;
find . -maxdepth 1 -name "*.backup" -exec mv {} uMEMORY/.local/backups/ \;

echo "✅ File organization complete!"
```

### Workflow Integration Commands

Add to `core/unified-workflow.sh`:

```bash
"organize"|"clean")
    echo "🧹 Organizing misplaced files..."
    "${uMEMORY}/.scripts/organize-files.sh"
    ;;
"check-structure")
    echo "📁 Checking file organization..."
    "${uMEMORY}/.scripts/check-structure.sh"
    ;;
```

## 🎯 VSCode Integration

### File Watcher Settings
Add to `.vscode/settings.json`:

```json
{
  "files.watcherExclude": {
    "**/uMEMORY/.local/**": true,
    "**/uMEMORY/.dev/builds/**": true
  },
  "search.exclude": {
    "**/uMEMORY/.local/logs/**": true,
    "**/uMEMORY/.local/backups/**": true
  }
}
```

### File Templates
Create proper file creation templates that automatically place files in correct locations based on their purpose.

## 🚀 Benefits

1. **Clean Root Directory**: Only production-ready files visible
2. **Organized Development**: All dev files in logical locations
3. **Easy Maintenance**: Clear structure for cleanup and organization
4. **Scalable**: Structure grows with project complexity
5. **Professional**: Follows Linux/Unix conventions
6. **IDE Friendly**: Proper exclusions for better performance

---

*This file should be updated whenever the organization structure changes*
*Location: `uMEMORY/.dev/WORKFLOW-FILE-ORGANIZATION.md`*
