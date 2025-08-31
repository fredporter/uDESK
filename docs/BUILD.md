# uDESK Build Guide

> How to build uDESK from source with your markdown-focused customizations

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourorg/uDESK
cd uDESK

# Build everything (requires TinyCore ISO in project root)
./build.sh

# Test in QEMU
./isos/run_qemu.sh --image out/udesk-v1.0.6-standard.iso
```

## Prerequisites

### System Requirements

**Host OS**: Linux (Ubuntu/Debian/Arch/etc.)  
**RAM**: 4GB minimum, 8GB recommended  
**Storage**: 10GB free space  
**Network**: For downloading dependencies

### Required Packages

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y \
    squashfs-tools \
    genisoimage \
    qemu-system-x86 \
    curl \
    git \
    build-essential
```

#### Arch Linux
```bash
sudo pacman -S \
    squashfs-tools \
    cdrtools \
    qemu \
    curl \
    git \
    base-devel
```

### TinyCore Base

```bash
# Download to project root
cd uDESK
wget http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso
```

## Build System

### Full Build
```bash
./build.sh --clean
```

### Component Builds
```bash
./build.sh --core-only     # Core package only
./build.sh --roles-only    # Role packages only
./build.sh --image-only    # ISO/IMG only
```

### Role-Specific Images
```bash
./build.sh --role basic    # Minimal system
./build.sh --role admin    # Development system
```

## Customization

### Adding Tools
```bash
# Add to role packages
mkdir -p src/udos-role-admin/usr/local/bin
echo '#!/bin/bash' > src/udos-role-admin/usr/local/bin/my-tool
chmod +x src/udos-role-admin/usr/local/bin/my-tool
```

### Markdown Templates
```bash
# Add system templates
mkdir -p src/udos-core/opt/udos/templates
cat > src/udos-core/opt/udos/templates/project.md << 'EOF'
# Project: {{NAME}}

## Overview
{{DESCRIPTION}}

## Status
- [ ] Planning
- [ ] Development  
- [ ] Testing
- [ ] Complete
EOF
```

## Testing

### QEMU Testing
```bash
# Test different roles
./isos/run_qemu.sh --image out/udesk-v1.0.6-basic.iso
./isos/run_qemu.sh --image out/udesk-v1.0.6-admin.iso --memory 2048
```

### Package Testing
```bash
# Extract and examine packages
unsquashfs -l build/udos-core.tcz
unsquashfs build/udos-role-admin.tcz
ls -la squashfs-root/
```

## Troubleshooting

### Missing Tools
```bash
# Check prerequisites
./build.sh --help

# Install missing packages
sudo apt install squashfs-tools genisoimage
```

### Build Failures
```bash
# Debug mode
export UDOS_DEBUG=1
./build.sh 2>&1 | tee build.log

# Check logs
glow build.log
```

### Permission Issues
```bash
# Fix script permissions
chmod +x packaging/*.sh isos/*.sh build.sh
```

---

*Building uDESK is simple, transparent, and fully documented in markdown - just like the system itself.*
