# uDESK Build Guide

> How to build uDESK v1.0.7.2 - Universal Desktop OS built on TinyCore Linux

## Quick Start

```bash
# Clone the repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Platform-specific quickstart (recommended)
./udesk-install.command       # macOS with auto-dependency installation
./udesk-install-linux.sh      # Ubuntu/Debian with build-essential
./udesk-install-windows.bat   # Windows with MinGW guidance

# Or build directly
./build.sh user       # User mode build (most users)
```

## Prerequisites

### System Requirements

**Host OS**: macOS, Ubuntu/Debian, or Windows  
**RAM**: 2GB minimum, 4GB recommended  
**Storage**: 1GB free space  
**Network**: For downloading dependencies (handled automatically)

### Required Tools (Auto-Installed)

#### macOS
```bash
# Xcode Command Line Tools (auto-installed by udesk-install.command)
# - GCC compiler
# - Git
# - Basic build tools
```

#### Ubuntu/Debian
```bash
# build-essential package (auto-installed by udesk-install-linux.sh)
sudo apt update
sudo apt install build-essential git
```

#### Windows
```bash
# MinGW-w64 or MSYS2 (guidance provided by udesk-install-windows.bat)
# - GCC compiler
# - Git for Windows
# - Basic build environment
```

### Zero Dependencies Philosophy
uDESK is built on TinyCore Linux and requires **only GCC** - everything else is handled automatically by platform installers.

## Build System

uDESK is built on TinyCore Linux and uses a **unified build system** with a single `build.sh` script that handles all compilation and deployment for cross-platform builds.

### Core Architecture

```
uDESK/
├── build.sh              # Unified build script
├── udesk-install.command      # macOS installer
├── udesk-install-linux.sh     # Linux installer  
├── udesk-install-windows.bat  # Windows installer
├── src/                       # Source code
├── uCORE/                     # Core runtime (TinyCore-based)
├── app/                       # Tauri desktop app
├── system/                    # TinyCore system components
└── build/                    # Build artifacts
```

### Build Modes

The unified build system supports three deployment modes:

```bash
# User Mode (default)
./build.sh user

# Wizard Role (extension development)
./build.sh wizard

# Developer Mode (full toolkit)
./build.sh developer

# ISO Mode (bootable system)
./build.sh iso
```

### Build Process

1. **Auto-detection**: Platform and architecture detection
2. **Dependencies**: Automatic tool installation via platform launchers  
3. **Compilation**: GCC-based compilation of core components
4. **Assembly**: Mode-specific feature bundling
5. **Deployment**: Cross-platform executable generation

## Customization

### Mode Configuration

Customize features for each deployment mode:

```bash
# User Mode - Basic features
core/user.conf
- Basic commands
- Essential tools
- Simplified interface

# Wizard Role - Extension development  
core/wizard.conf
- Developer tools
- Advanced scripting
- Extended command set

# Developer Mode - Full toolkit
core/developer.conf
- Complete development environment
- Debug tools
- Full API access
```

### Adding Components

```bash
# Add to uCORE runtime
mkdir -p uCORE/commands
echo '#!/bin/bash' > uCORE/commands/my-command
chmod +x uCORE/commands/my-command

# Add to Tauri app
cd app
# Modify tauri/tauri.conf.json for new features
```

### System Templates

```bash
# Add documentation templates
mkdir -p core/templates
cat > core/templates/project.md << 'EOF'
# Project: {{NAME}}

## Overview
{{DESCRIPTION}}

## Usage
{{USAGE}}
EOF
```

## Status
- [ ] Planning
- [ ] Development  
- [ ] Testing
- [ ] Complete
EOF
```

## Testing

### Local Testing

```bash
# Test each build mode
./build.sh user && ./udos
./build.sh wizard && ./udos
./build.sh developer && ./udos

# Test cross-platform
./udesk-install.command
./udesk-install-linux.sh
./udesk-install-windows.bat
```

### Tauri Desktop Testing

```bash
# Development mode
cd app
npm run tauri dev

# Production build testing
npm run tauri build
```

### Mode Validation

```bash
# Verify user mode features
./udos help | grep -E "(basic|user)"

# Verify wizard features  
./udos wizard --list-advanced

# Verify developer features
./udos dev --show-all-commands
```

## Troubleshooting

### Common Issues

**Build fails with GCC errors**
```bash
# Ensure GCC is installed
gcc --version

# Run platform installer first
./udesk-install.command       # macOS
./udesk-install-linux.sh      # Linux
./udesk-install-windows.bat   # Windows
```

**Missing dependencies**
```bash
# Platform launchers handle dependencies automatically
# If manual installation needed:

# macOS
xcode-select --install

# Ubuntu
sudo apt install build-essential

# Windows  
# Install MinGW-w64 or MSYS2
```

**Permission errors**
```bash
# Ensure build script is executable
chmod +x build.sh
chmod +x udesk-install*.{command,sh,bat}
```

### Debug Mode

```bash
# Enable detailed build output
export UDOS_DEBUG=1
./build.sh developer

# Check build logs
cat build/build.log
```

## Advanced Features

### Custom Builds

```bash
# Create custom mode configuration
cp core/user.conf core/custom.conf
# Edit custom.conf for specific needs
./build.sh custom
```

### Integration Testing

```bash
# Test with external systems
./build.sh developer
./udos test --integration

# Verify command routing
./udos test --command-router
```
unsquashfs build/udos-role-admin.tcz
ls -la squashfs-root/
```

## Troubleshooting

### Missing Tools
```bash
## Additional Resources

### Build Configuration

```bash
# Check build options
./build.sh --help

# View current configuration
./udos config --show
```

### Performance Optimization

```bash
# Parallel builds (if supported)
export MAKEFLAGS="-j$(nproc)"
./build.sh developer

# Minimal builds for testing
./build.sh user --minimal
```

### Documentation Integration

```bash
# Generate documentation
./udos doc --generate

# View in terminal
./udos doc --view BUILD.md
```

---

## Git Integration

uDESK includes **one-way git repository synchronization** for setup and installation only. This ensures users always have access to the latest system templates and core files during installation.

### How It Works

#### Installation Process
1. **Downloads latest uDESK** from GitHub during installation
2. **Copies bundled templates** to user workspace
3. **Creates user workspace** in `~/uMEMORY/`
4. **One-time setup** - no ongoing git synchronization

#### Key Principles
- **Setup Only**: Git used only during initial installation and manual updates
- **No Auto-Sync**: User environment never automatically updated  
- **Separate Development**: User work isolated from core system
- **User Control**: Updates only when user explicitly runs installer

### Directory Structure

```
~/uDESK/                    # Main home directory
├── repo/                   # Full git repository (during install)
├── docs/                   # Documentation (copied from repo)
├── README.md              # Project README (copied from repo)
├── LICENSE                # License file (copied from repo)
└── uMEMORY/              # Main workspace directory
    ├── projects/          # Active projects
    ├── sandbox/           # User workspace
    ├── config/            # User configuration
    └── .local/            # XDG-compliant user data
        ├── logs/          # System logs
        ├── backups/       # User backups
        └── state/         # Application state
```

### Repository Management

#### Automatic Features
- **Smart Detection**: Checks if repository exists during build
- **Offline Resilient**: Gracefully handles offline situations
- **Conflict Safe**: Uses safe git operations with error handling
- **Silent Operation**: Updates happen in background during builds

#### Manual Updates
```bash
# Update repository manually
cd ~/uDESK/repo && git pull

# Force fresh install
rm -rf ~/uDESK && ./udesk-install.command  # macOS
rm -rf ~/uDESK && ./udesk-install-linux.sh  # Linux
```

### Security Considerations

- Uses HTTPS for repository access (no credentials required)
- Only pulls from official repository (no arbitrary code execution)  
- Preserves user data in separate directories
- Handles network failures gracefully
- Does not modify user files outside uDESK directories

### Troubleshooting

#### Repository Issues
```bash
# Check repository status
ls ~/uDESK/repo/.git

# Verify git installation
git --version

# Test GitHub connectivity
ping github.com
```

#### Permission Issues
```bash
# Check directory ownership
ls -la ~/uDESK/

# Fix permissions if needed
chmod -R u+w ~/uDESK/
```

---

*Building uDESK is designed to be simple, fast, and fully cross-platform - completing setup in under 30 seconds on any supported system.*
