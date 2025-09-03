#!/bin/sh
# uDESK Repository Cleanup Script
# Organizes and removes obsolete files for clean distribution

set -e

echo "uDESK Repository Cleanup v1.0.5"
echo "==============================="
echo ""

# Create organization structure
echo "Creating organized directory structure..."

# Create archive directory for obsolete files
mkdir -p vm/archive/troubleshooting
mkdir -p vm/archive/legacy
mkdir -p vm/current

# Files to keep in current (active/production)
CURRENT_FILES="
install-udos.sh
udos-boot-art.sh
INSTALL-INSTRUCTIONS.txt
"

# Files to archive as troubleshooting tools
TROUBLESHOOTING_FILES="
github-diagnostic.sh
test-bash.sh
test-basic.sh
m2-update.sh
"

# Files to archive as legacy/superseded
LEGACY_FILES="
auto-install.sh
bootstrap-install.sh
github-install-minimal.sh
github-install.sh
manual-install.sh
simple-install.sh
setup-gemini.sh
"

# Move troubleshooting files
echo "Archiving troubleshooting tools..."
for file in $TROUBLESHOOTING_FILES; do
    if [ -f "vm/$file" ]; then
        echo "  Moving $file to archive/troubleshooting/"
        mv "vm/$file" "vm/archive/troubleshooting/"
    fi
done

# Move legacy files
echo "Archiving legacy installation scripts..."
for file in $LEGACY_FILES; do
    if [ -f "vm/$file" ]; then
        echo "  Moving $file to archive/legacy/"
        mv "vm/$file" "vm/archive/legacy/"
    fi
done

# Move current files to organized location
echo "Organizing current files..."
for file in $CURRENT_FILES; do
    if [ -f "vm/$file" ] && [ ! -f "vm/current/$file" ]; then
        echo "  Organizing $file in current/"
        cp "vm/$file" "vm/current/"
    fi
done

# Create README files for organization
echo "Creating documentation for archived files..."

cat > vm/archive/README.md << 'ARCHIVE_EOF'
# uDESK VM Archive

This directory contains archived files from the uDESK TinyCore VM development process.

## Directory Structure

### troubleshooting/
Development and diagnostic tools used during TinyCore compatibility testing:
- `github-diagnostic.sh` - Network connectivity and GitHub access testing
- `test-bash.sh` - Shell compatibility testing
- `test-basic.sh` - Basic functionality testing  
- `m2-update.sh` - M2 role hierarchy update script

### legacy/
Superseded installation scripts from development iterations:
- `auto-install.sh` - Early automation attempt
- `bootstrap-install.sh` - Initial bootstrap installer
- `github-install-minimal.sh` - Minimal GitHub installer
- `github-install.sh` - Original GitHub installer
- `manual-install.sh` - Manual installation script
- `simple-install.sh` - Simplified installer
- `setup-gemini.sh` - Development testing script

## Current Active Files

The production-ready files are maintained in `/vm/current/`:
- `install-udos.sh` - Hybrid distribution manager (primary installer)
- `udos-boot-art.sh` - ASCII art and boot integration
- `INSTALL-INSTRUCTIONS.txt` - Installation documentation

## Usage

These archived files are preserved for:
1. **Reference** - Understanding development progression
2. **Debugging** - Troubleshooting specific TinyCore issues
3. **Recovery** - Fallback options if current system fails
4. **Learning** - Examples of different installation approaches

To use any archived script:
```sh
cd /path/to/uDESK/vm/archive/[category]
chmod +x [script-name].sh
./[script-name].sh
```

**Note**: Archived scripts may require modification for current uDOS v1.0.5 compatibility.
ARCHIVE_EOF

cat > vm/current/README.md << 'CURRENT_EOF'
# uDESK TinyCore VM - Current Files

Production-ready files for uDOS TinyCore Linux integration.

## Primary Installation

### install-udos.sh
**Hybrid Distribution Manager** - Automatically detects and uses the best installation method:

```sh
# Auto-detect best method
./install-udos.sh

# Force specific method
./install-udos.sh github    # GitHub installation
./install-udos.sh tcz       # TinyCore extension package
./install-udos.sh offline   # Local bundle installation
./install-udos.sh update    # Update existing installation
```

**Features**:
- Auto-detection of network connectivity
- Fallback installation methods
- ASCII art boot integration
- Environment variable configuration
- Installation verification

## Boot Integration

### udos-boot-art.sh
**ASCII Art and Boot Integration** - Provides visual branding and system integration:

```sh
# Setup boot integration
./udos-boot-art.sh setup

# Test displays
./udos-boot-art.sh test

# Remove integration
./udos-boot-art.sh remove
```

**Features**:
- Boot sequence ASCII art
- Login prompt branding
- Terminal prompt integration
- Environment initialization
- TinyCore bootlocal.sh integration

## Quick Start

1. **Download uDESK**:
   ```sh
   wget https://github.com/fredporter/uDESK/archive/main.zip
   unzip main.zip
   cd uDESK-main/vm/current/
   ```

2. **Install uDOS**:
   ```sh
   chmod +x install-udos.sh
   ./install-udos.sh
   ```

3. **Setup Boot Integration**:
   ```sh
   chmod +x udos-boot-art.sh
   ./udos-boot-art.sh setup
   ```

4. **Verify Installation**:
   ```sh
   udos help
   udos info
   ```

## Environment Variables

Configure installation behavior:
- `UDOS_VNC_PASSWORD` - Set VNC password (default: udos2024)
- `UDOS_AUTO_VNC` - Auto-start VNC (default: yes)
- `UDOS_DESKTOP` - Install desktop environment (default: yes)

## Documentation

- Installation instructions: `INSTALL-INSTRUCTIONS.txt`
- Development history: `../archive/README.md`
- Main project: `../../README.md`
CURRENT_EOF

# Update main vm README if it exists
if [ -f vm/README.md ]; then
    cat > vm/README.md << 'VM_README_EOF'
# uDESK TinyCore VM Integration

This directory contains all files for uDOS integration with TinyCore Linux.

## Directory Structure

- `current/` - Production-ready installation and integration files
- `archive/` - Development history and troubleshooting tools
- `INSTALL-INSTRUCTIONS.txt` - Main installation documentation

## Quick Start

For immediate installation:
```sh
cd current/
./install-udos.sh
```

For development or troubleshooting:
```sh
cd archive/troubleshooting/
# Use appropriate diagnostic script
```

## Integration Features

- **Hybrid Distribution**: Supports GitHub, TCZ, and offline installation
- **Boot Integration**: ASCII art branding and environment setup
- **Role Hierarchy**: M1 CLI foundation + M2 role system
- **VNC Support**: Desktop environment with copy-paste functionality
- **Automation**: Complete hands-off installation and configuration

See `current/README.md` for detailed usage instructions.
VM_README_EOF
else
    cat > vm/README.md << 'VM_README_EOF'
# uDESK TinyCore VM Integration

This directory contains all files for uDOS integration with TinyCore Linux.

## Directory Structure

- `current/` - Production-ready installation and integration files
- `archive/` - Development history and troubleshooting tools

## Quick Start

For immediate installation:
```sh
cd current/
./install-udos.sh
```

For development or troubleshooting:
```sh
cd archive/troubleshooting/
# Use appropriate diagnostic script
```

## Integration Features

- **Hybrid Distribution**: Supports GitHub, TCZ, and offline installation
- **Boot Integration**: ASCII art branding and environment setup
- **Role Hierarchy**: M1 CLI foundation + M2 role system
- **VNC Support**: Desktop environment with copy-paste functionality
- **Automation**: Complete hands-off installation and configuration

See `current/README.md` for detailed usage instructions.
VM_README_EOF
fi

echo ""
echo "Repository cleanup completed!"
echo ""
echo "Structure:"
echo "  vm/current/           - Production files"
echo "  vm/archive/legacy/    - Superseded scripts"
echo "  vm/archive/troubleshooting/ - Diagnostic tools"
echo ""
echo "Next steps:"
echo "1. Review archived files in vm/archive/"
echo "2. Test installation with vm/current/install-udos.sh"
echo "3. Update main documentation"
echo ""

# Show summary
echo "File organization summary:"
echo "=========================="
echo "Current files: $(ls vm/current/ 2>/dev/null | wc -l)"
echo "Archived legacy: $(ls vm/archive/legacy/ 2>/dev/null | wc -l)"
echo "Archived troubleshooting: $(ls vm/archive/troubleshooting/ 2>/dev/null | wc -l)"
echo ""

echo "Cleanup script completed successfully!"
