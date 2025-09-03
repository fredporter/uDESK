#!/bin/sh
# uDOS Offline Distribution Creator
# Creates offline installation bundles for air-gapped environments

set -e

VERSION="1.0.5"
BUNDLE_DIR="/tmp/udos-offline-bundle"
DIST_DIR="./offline-distribution"

echo "uDOS Offline Distribution Creator v$VERSION"
echo "==========================================="
echo ""

# Clean and create directories
rm -rf "$BUNDLE_DIR" "$DIST_DIR"
mkdir -p "$BUNDLE_DIR" "$DIST_DIR"

# Create comprehensive offline bundle
create_offline_bundle() {
    echo "Creating comprehensive offline bundle..."
    
    OFFLINE_DIR="$BUNDLE_DIR/udos-offline"
    mkdir -p "$OFFLINE_DIR/packages"
    mkdir -p "$OFFLINE_DIR/scripts"
    mkdir -p "$OFFLINE_DIR/config"
    mkdir -p "$OFFLINE_DIR/docs"
    
    # Copy core installation files
    if [ -d "vm/current" ]; then
        echo "  Copying installation scripts..."
        cp vm/current/install-udos.sh "$OFFLINE_DIR/scripts/"
        cp vm/current/udos-boot-art.sh "$OFFLINE_DIR/scripts/"
        
        # Create offline version of installer
        cat > "$OFFLINE_DIR/udos-offline-install.sh" << 'OFFLINE_INSTALLER_EOF'
#!/bin/sh
# uDOS Offline Installation Script
# Installs uDOS from local bundle without network connectivity

set -e

BUNDLE_DIR="$(dirname "$0")"
VERSION="1.0.5"

# ASCII Art Banner
show_banner() {
    cat << 'BANNER_EOF'

    ██╗   ██╗██████╗  ██████╗ ███████╗
    ██║   ██║██╔══██╗██╔═══██╗██╔════╝
    ██║   ██║██║  ██║██║   ██║███████╗
    ██║   ██║██║  ██║██║   ██║╚════██║
    ╚██████╔╝██████╔╝╚██████╔╝███████║
     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝

    Universal Device Operating System
    Offline Installation v1.0.5

BANNER_EOF
}

# Install from TCZ packages
install_from_tcz() {
    echo "Installing uDOS from offline TCZ packages..."
    
    if [ -f "$BUNDLE_DIR/packages/udos-core.tcz" ]; then
        echo "  Loading udos-core.tcz..."
        if command -v tce-load >/dev/null 2>&1; then
            tce-load -i "$BUNDLE_DIR/packages/udos-core.tcz"
        else
            echo "  Warning: tce-load not found, extracting manually..."
            cd /
            unsquashfs -f "$BUNDLE_DIR/packages/udos-core.tcz"
        fi
    fi
    
    if [ -f "$BUNDLE_DIR/packages/udos-vnc.tcz" ]; then
        echo "  Loading udos-vnc.tcz..."
        tce-load -i "$BUNDLE_DIR/packages/udos-vnc.tcz" 2>/dev/null || true
    fi
    
    if [ -f "$BUNDLE_DIR/packages/udos-boot.tcz" ]; then
        echo "  Loading udos-boot.tcz..."
        tce-load -i "$BUNDLE_DIR/packages/udos-boot.tcz" 2>/dev/null || true
    fi
}

# Install from extracted files
install_from_files() {
    echo "Installing uDOS from extracted files..."
    
    if [ -d "$BUNDLE_DIR/extracted" ]; then
        echo "  Copying files to system..."
        cp -r "$BUNDLE_DIR/extracted/"* /
        
        # Set permissions
        find /usr/local/bin -name "*udos*" -exec chmod +x {} \;
    fi
}

# Setup configuration
setup_configuration() {
    echo "Setting up configuration..."
    
    # Copy configuration files
    if [ -d "$BUNDLE_DIR/config" ]; then
        mkdir -p /etc/udos
        cp "$BUNDLE_DIR/config/"* /etc/udos/ 2>/dev/null || true
    fi
    
    # Setup boot integration
    if [ -f "$BUNDLE_DIR/scripts/udos-boot-art.sh" ]; then
        cp "$BUNDLE_DIR/scripts/udos-boot-art.sh" /usr/local/bin/
        chmod +x /usr/local/bin/udos-boot-art.sh
        
        # Setup boot integration if requested
        if [ "$UDOS_SETUP_BOOT" = "yes" ]; then
            /usr/local/bin/udos-boot-art.sh setup
        fi
    fi
}

# Verify installation
verify_installation() {
    echo "Verifying offline installation..."
    
    if [ -f /usr/local/bin/udos ]; then
        echo "  ✓ uDOS core installed"
        udos version || echo "  Warning: udos version check failed"
    else
        echo "  ✗ uDOS core installation failed"
        return 1
    fi
    
    if [ -f /usr/local/bin/udos-detect-role ]; then
        echo "  ✓ Role detection available"
    fi
    
    if [ -f /usr/local/bin/udos-boot-art.sh ]; then
        echo "  ✓ Boot integration available"
    fi
    
    echo ""
    echo "Offline installation completed successfully!"
    echo ""
    echo "Quick start:"
    echo "  udos help"
    echo "  udos info"
    echo "  udos-detect-role"
}

# Main installation process
main() {
    show_banner
    
    echo "Starting offline installation..."
    echo "Bundle directory: $BUNDLE_DIR"
    echo ""
    
    # Try TCZ packages first
    if [ -f "$BUNDLE_DIR/packages/udos-core.tcz" ]; then
        install_from_tcz
    elif [ -d "$BUNDLE_DIR/extracted" ]; then
        install_from_files
    else
        echo "Error: No installation packages found in bundle"
        exit 1
    fi
    
    setup_configuration
    verify_installation
}

main "$@"
OFFLINE_INSTALLER_EOF
        
        chmod +x "$OFFLINE_DIR/udos-offline-install.sh"
    fi
    
    # Copy TCZ packages if available
    if [ -d "tcz-packages" ]; then
        echo "  Copying TCZ packages..."
        cp tcz-packages/*.tcz* "$OFFLINE_DIR/packages/"
    fi
    
    # Copy boot configuration
    if [ -d "boot-config" ]; then
        echo "  Copying boot configuration..."
        cp -r boot-config/* "$OFFLINE_DIR/config/"
    fi
    
    # Copy documentation
    echo "  Copying documentation..."
    cp README.md "$OFFLINE_DIR/docs/" 2>/dev/null || true
    cp vm/current/README.md "$OFFLINE_DIR/docs/installation.md" 2>/dev/null || true
    
    # Create bundle documentation
    cat > "$OFFLINE_DIR/README.md" << 'BUNDLE_README_EOF'
# uDOS Offline Installation Bundle

This bundle contains everything needed to install uDOS in air-gapped environments.

## Contents

- `udos-offline-install.sh` - Main offline installer
- `packages/` - TCZ packages for TinyCore
- `scripts/` - Installation and boot scripts
- `config/` - Boot and system configuration
- `docs/` - Documentation and guides

## Installation

### Quick Installation
```bash
./udos-offline-install.sh
```

### Manual Installation
```bash
# Install packages
tce-load -i packages/udos-core.tcz
tce-load -i packages/udos-vnc.tcz
tce-load -i packages/udos-boot.tcz

# Setup boot integration
scripts/udos-boot-art.sh setup

# Verify installation
udos version
```

### Environment Variables
```bash
export UDOS_SETUP_BOOT=yes        # Auto-setup boot integration
export UDOS_VNC_PASSWORD=secure   # Set VNC password
export UDOS_AUTO_VNC=yes          # Auto-start VNC
```

## Air-Gapped Deployment

This bundle is designed for environments without internet connectivity:

1. **Download** on internet-connected machine
2. **Transfer** via USB, CD, or secure file transfer
3. **Install** on target air-gapped system
4. **Configure** according to security requirements

## Bundle Components

### Core System
- uDOS CLI suite (udos, uvar, udata, utpl)
- Role detection and hierarchy system
- POSIX shell compatibility

### Desktop Environment
- VNC server integration
- Lightweight desktop (fluxbox)
- Copy-paste functionality

### Boot Integration
- ASCII art branding
- Automatic startup configuration
- TinyCore bootlocal.sh integration

## Security Considerations

- No external network connections required
- All dependencies included in bundle
- Minimal attack surface
- Role-based access control
- Audit trail capabilities

## Support

For air-gapped environments, this bundle includes:
- Complete documentation
- Troubleshooting guides
- Configuration examples
- Self-contained installation

Version: 1.0.5
Date: $(date '+%Y-%m-%d')
BUNDLE_README_EOF
    
    echo "  ✓ Offline bundle created"
}

# Create extracted file version
create_extracted_bundle() {
    echo "Creating extracted file bundle..."
    
    EXTRACTED_DIR="$BUNDLE_DIR/udos-extracted"
    mkdir -p "$EXTRACTED_DIR/extracted"
    
    # Extract TCZ packages if available
    if [ -d "tcz-packages" ] && command -v unsquashfs >/dev/null 2>&1; then
        echo "  Extracting TCZ packages..."
        cd "$EXTRACTED_DIR"
        
        for tcz in ../../tcz-packages/*.tcz; do
            if [ -f "$tcz" ]; then
                echo "    Extracting $(basename "$tcz")..."
                unsquashfs -f -d extracted "$tcz" 2>/dev/null || true
            fi
        done
        
        cd - >/dev/null
    fi
    
    # Copy installation script
    cp "$BUNDLE_DIR/udos-offline/udos-offline-install.sh" "$EXTRACTED_DIR/"
    
    # Copy documentation
    mkdir -p "$EXTRACTED_DIR/docs"
    cp "$BUNDLE_DIR/udos-offline/README.md" "$EXTRACTED_DIR/docs/"
    
    echo "  ✓ Extracted bundle created"
}

# Create distribution archives
create_distribution_archives() {
    echo "Creating distribution archives..."
    
    # Ensure distribution directory exists with absolute path
    ABSOLUTE_DIST_DIR="$(pwd)/offline-distribution"
    mkdir -p "$ABSOLUTE_DIST_DIR"
    
    cd "$BUNDLE_DIR"
    
    # Create compressed archives
    if command -v tar >/dev/null 2>&1; then
        echo "  Creating tar.gz archives..."
        tar czf "$ABSOLUTE_DIST_DIR/udos-offline-bundle.tar.gz" udos-offline/
        tar czf "$ABSOLUTE_DIST_DIR/udos-extracted-bundle.tar.gz" udos-extracted/
    fi
    
    if command -v zip >/dev/null 2>&1; then
        echo "  Creating zip archives..."
        zip -r "$ABSOLUTE_DIST_DIR/udos-offline-bundle.zip" udos-offline/ >/dev/null
        zip -r "$ABSOLUTE_DIST_DIR/udos-extracted-bundle.zip" udos-extracted/ >/dev/null
    fi
    
    cd - >/dev/null
    
    echo "  ✓ Distribution archives created"
}

# Create deployment documentation
create_deployment_docs() {
    echo "Creating deployment documentation..."
    
    cat > "$DIST_DIR/DEPLOYMENT-GUIDE.md" << 'DEPLOYMENT_EOF'
# uDOS Offline Deployment Guide

This guide covers deploying uDOS in air-gapped and restricted environments.

## Bundle Options

### udos-offline-bundle (Recommended)
- **Format**: TCZ packages + installer
- **Size**: ~25KB compressed
- **Requirements**: TinyCore Linux with tce-load
- **Installation**: Single command execution

### udos-extracted-bundle (Fallback)
- **Format**: Extracted files + installer
- **Size**: ~50KB compressed  
- **Requirements**: Any POSIX shell environment
- **Installation**: File copying and permissions

## Deployment Scenarios

### Scenario 1: TinyCore VM Environment
```bash
# Transfer bundle to VM
scp udos-offline-bundle.tar.gz user@target:/tmp/

# Extract and install
cd /tmp && tar xzf udos-offline-bundle.tar.gz
cd udos-offline && ./udos-offline-install.sh
```

### Scenario 2: USB Transfer
```bash
# Prepare USB
mount /dev/sdb1 /mnt/usb
cp udos-offline-bundle.tar.gz /mnt/usb/

# On target system
mount /dev/sdb1 /mnt/usb
cp /mnt/usb/udos-offline-bundle.tar.gz /tmp/
cd /tmp && tar xzf udos-offline-bundle.tar.gz
cd udos-offline && ./udos-offline-install.sh
```

### Scenario 3: CD/DVD Distribution
```bash
# Create ISO with bundle
mkisofs -o udos-offline.iso udos-offline/

# On target system
mount /dev/cdrom /mnt/cdrom
cp -r /mnt/cdrom /tmp/udos-offline
cd /tmp/udos-offline && ./udos-offline-install.sh
```

## Security Hardening

### Pre-Deployment Verification
```bash
# Verify archive integrity
sha256sum udos-offline-bundle.tar.gz

# Scan for security issues
find udos-offline/ -type f -exec file {} \;

# Check permissions
find udos-offline/ -type f -perm +111
```

### Post-Installation Security
```bash
# Verify installation
udos version
udos-detect-role

# Check file permissions
find /usr/local/bin -name "*udos*" -ls

# Review configuration
cat /etc/udos/config
```

## Troubleshooting

### Installation Issues
```bash
# Check bundle integrity
tar tzf udos-offline-bundle.tar.gz | head

# Verify TCZ packages
unsquashfs -l packages/udos-core.tcz

# Manual extraction
cd / && unsquashfs -f packages/udos-core.tcz
```

### Runtime Issues
```bash
# Check environment
echo $PATH | grep local/bin

# Test commands
which udos
udos help

# Check role detection
udos-detect-role --debug
```

## Network Isolation Verification

Ensure complete air-gap compliance:

```bash
# Verify no network dependencies
ldd /usr/local/bin/udos

# Check for external connections
netstat -an | grep ESTABLISHED

# Verify offline operation
udos info  # Should work without network
```

## Documentation Access

In air-gapped environments:
- All documentation included in bundle
- No external links or dependencies
- Self-contained help system
- Offline troubleshooting guides

## Compliance and Auditing

### Installation Audit
- Bundle checksums and signatures
- File modification tracking
- Permission verification
- Configuration validation

### Runtime Audit
- Command execution logging
- Role-based access tracking
- Configuration change monitoring
- Security event recording

## Support Matrix

| Environment | Bundle Type | Installation | Support Level |
|-------------|-------------|--------------|---------------|
| TinyCore Linux | TCZ Bundle | Automatic | Full |
| Generic Linux | Extracted | Manual | Core |
| Restricted Shell | Extracted | Custom | Limited |
| Air-Gapped VM | Either | Offline | Full |

## Version Compatibility

- uDOS Core: v1.0.5+
- TinyCore: 13.x, 14.x
- Shell: POSIX compliant
- Architecture: x86_64

## Next Steps

1. Choose appropriate bundle type
2. Transfer to target environment
3. Verify integrity and permissions
4. Execute installation
5. Validate functionality
6. Configure security settings
7. Document deployment
DEPLOYMENT_EOF
    
    # Create quick reference card
    cat > "$DIST_DIR/QUICK-REFERENCE.md" << 'QUICK_REF_EOF'
# uDOS Offline Installation - Quick Reference

## One-Command Installation
```bash
tar xzf udos-offline-bundle.tar.gz && cd udos-offline && ./udos-offline-install.sh
```

## Bundle Contents
- `udos-offline-install.sh` - Main installer
- `packages/` - TCZ packages
- `scripts/` - Helper scripts
- `config/` - Configuration files
- `docs/` - Documentation

## Environment Variables
```bash
export UDOS_SETUP_BOOT=yes        # Auto-setup boot
export UDOS_VNC_PASSWORD=secure   # VNC password
export UDOS_AUTO_VNC=yes          # Auto-start VNC
```

## Verification Commands
```bash
udos version                       # Check installation
udos info                         # System information
udos-detect-role                  # Role detection
udos help                         # Command reference
```

## Troubleshooting
```bash
# Manual package installation
tce-load -i packages/udos-core.tcz

# Check installation
which udos && echo "Installed" || echo "Failed"

# Re-run installer
./udos-offline-install.sh

# Boot integration
scripts/udos-boot-art.sh setup
```

## File Locations
- Binaries: `/usr/local/bin/udos*`
- Config: `/etc/udos/`
- Boot: `/opt/bootlocal.sh`
- Docs: `docs/`

## Support
- All documentation included offline
- No network connectivity required
- Self-contained troubleshooting
- Air-gap compliant deployment
QUICK_REF_EOF
    
    echo "  ✓ Deployment documentation created"
}

# Create checksums and verification
create_verification() {
    echo "Creating verification files..."
    
    cd "$DIST_DIR"
    
    # Create checksums
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum *.tar.gz *.zip > checksums.sha256 2>/dev/null || true
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 *.tar.gz *.zip > checksums.sha256 2>/dev/null || true
    fi
    
    # Create file listing
    find . -type f -exec ls -la {} \; > file-manifest.txt
    
    cd - >/dev/null
    
    echo "  ✓ Verification files created"
}

# Main execution
main() {
    create_offline_bundle
    create_extracted_bundle
    create_distribution_archives
    create_deployment_docs
    create_verification
    
    echo ""
    echo "Offline Distribution Creation Complete!"
    echo "======================================"
    echo ""
    echo "Distribution files created in: $DIST_DIR"
    echo ""
    ls -la "$DIST_DIR"
    echo ""
    echo "Deployment options:"
    echo "1. udos-offline-bundle.tar.gz - TCZ packages (recommended)"
    echo "2. udos-extracted-bundle.tar.gz - Extracted files (fallback)"
    echo "3. .zip versions for Windows environments"
    echo ""
    echo "Documentation:"
    echo "- DEPLOYMENT-GUIDE.md - Complete deployment guide"
    echo "- QUICK-REFERENCE.md - Quick installation reference"
    echo "- checksums.sha256 - File integrity verification"
    echo ""
    echo "Ready for air-gapped deployment!"
}

main "$@"
