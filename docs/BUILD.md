# uDESK Build Guide

> How to build uDESK v1.0.7 - Universal Development Environment & System Kit

## Quick Start

```bash
# Clone the repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Platform-specific quickstart (recommended)
./uDESK-macOS.sh      # macOS with auto-dependency installation
./uDESK-Ubuntu.sh     # Ubuntu/Debian with build-essential
./uDESK-Windows.bat   # Windows with MinGW guidance

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
# Xcode Command Line Tools (auto-installed by uDESK-macOS.sh)
# - GCC compiler
# - Git
# - Basic build tools
```

#### Ubuntu/Debian
```bash
# build-essential package (auto-installed by uDESK-Ubuntu.sh)
sudo apt update
sudo apt install build-essential git
```

#### Windows
```bash
# MinGW-w64 or MSYS2 (guidance provided by uDESK-Windows.bat)
# - GCC compiler
# - Git for Windows
# - Basic build environment
```

### Zero Dependencies Philosophy
uDESK v1.0.7 requires **only GCC** - everything else is handled automatically by platform launchers.

## Build System

uDESK v1.0.7 uses a **unified build system** with a single `build.sh` script that handles all compilation and deployment for cross-platform builds.

### Core Architecture

```
uDESK/
├── build.sh              # Unified build script
├── Launch-uDOS-macOS.command   # macOS launcher
├── Launch-uDOS-Ubuntu.sh       # Ubuntu launcher  
├── Launch-uDOS-Windows.bat     # Windows launcher
├── core/                       # uDOS system core
├── uCORE/                     # Core runtime
├── app/udesk-app/            # Tauri desktop app
└── build/                    # Build artifacts
```

### Build Modes

The unified build system supports three deployment modes:

```bash
# User Mode (default)
./build.sh user

# Wizard Role (extension development)
./build.sh wizard-plus

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
core/wizard-plus.conf
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
cd app/udesk-app
# Modify src-tauri/tauri.conf.json for new features
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
./build.sh wizard-plus && ./udos
./build.sh developer && ./udos

# Test cross-platform
./Launch-uDOS-macOS.command
./Launch-uDOS-Ubuntu.sh
./Launch-uDOS-Windows.bat
```

### Tauri Desktop Testing

```bash
# Development mode
cd app/udesk-app
npm run tauri dev

# Production build testing
npm run tauri build
```

### Mode Validation

```bash
# Verify user mode features
./udos help | grep -E "(basic|user)"

# Verify wizard+ features  
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

# Run platform launcher first
./Launch-uDOS-macOS.command  # or Ubuntu/Windows equivalent
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
chmod +x Launch-uDOS-*.{command,sh,bat}
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

*Building uDESK v1.0.7 is designed to be simple, fast, and fully cross-platform - completing setup in under 30 seconds on any supported system.*
