#!/bin/sh
# uDOS TCZ Package Creator
# Creates native TinyCore extension packages for uDOS

set -e

VERSION="1.0.5"
BUILD_DIR="/tmp/udos-tcz-build"
PACKAGE_DIR="/tmp/udos-packages"

echo "uDOS TCZ Package Creator v$VERSION"
echo "================================="
echo ""

# Clean and create build directories
rm -rf "$BUILD_DIR" "$PACKAGE_DIR"
mkdir -p "$BUILD_DIR" "$PACKAGE_DIR"

# Create main uDOS package structure
create_udos_core_package() {
    echo "Creating udos-core.tcz package..."
    
    CORE_DIR="$BUILD_DIR/udos-core"
    mkdir -p "$CORE_DIR/usr/local/bin"
    mkdir -p "$CORE_DIR/usr/local/share/udos"
    mkdir -p "$CORE_DIR/etc/udos"
    
    # Copy uDOS core binaries from existing build directory
    if [ -d "build/udos-core" ]; then
        echo "  Copying uDOS core files from existing build..."
        # Copy entire structure from existing build
        cp -r build/udos-core/* "$CORE_DIR/"
        
        # Make all executables
        find "$CORE_DIR/usr/local/bin" -type f -exec chmod +x {} \;
    else
        echo "  Creating minimal uDOS core files..."
        # Create minimal versions if build directory doesn't exist
        cat > "$CORE_DIR/usr/local/bin/udos" << 'UDOS_EOF'
#!/bin/sh
# uDOS Core Command Router v1.0.5
echo "uDOS v1.0.5 - Universal Device Operating System"
echo "Available commands: help, info, version, status"
case "$1" in
    help) echo "uDOS Help System - Use 'udos info' for system information" ;;
    info) echo "uDOS System Information"; echo "Role: $(udos-detect-role)"; echo "Version: 1.0.5" ;;
    version) echo "uDOS v1.0.5" ;;
    status) echo "uDOS Status: Active" ;;
    *) echo "Usage: udos [help|info|version|status]" ;;
esac
UDOS_EOF
        
        cat > "$CORE_DIR/usr/local/bin/udos-detect-role" << 'ROLE_EOF'
#!/bin/sh
# uDOS Role Detection v1.0.5
if [ "$(id -u)" = "0" ]; then
    echo "wizard"
elif groups | grep -q sudo; then
    echo "sorcerer"
else
    echo "knight"
fi
ROLE_EOF
        
        chmod +x "$CORE_DIR/usr/local/bin/"*
    fi
    
    # Create configuration files
    cat > "$CORE_DIR/etc/udos/config" << 'CONFIG_EOF'
# uDOS Configuration
UDOS_VERSION=1.0.5
UDOS_HOME=/usr/local/share/udos
UDOS_CONFIG_DIR=/etc/udos
UDOS_AUTO_START=yes
CONFIG_EOF
    
    # Create package info
    cat > "$CORE_DIR/usr/local/share/udos/info" << 'INFO_EOF'
Title:          udos-core.tcz
Description:    Universal Device Operating System - Core Package
Version:        1.0.5
Author:         uDOS Project
Original-site:  https://github.com/fredporter/uDOS
Copying-policy: MIT
Size:           16KB
Extension_by:   uDOS Team
Tags:           CLI system universal
Comments:       Core uDOS command suite for TinyCore Linux
                Provides udos, uvar, udata, utpl, role detection
                Minimal dependencies, POSIX shell compatible
Change-log:     2024/09/03 v1.0.5 Initial TinyCore package
Current:        2024/09/03
INFO_EOF
    
    # Create dependencies file
    cat > "$CORE_DIR/usr/local/share/udos/depends" << 'DEPS_EOF'
# uDOS Core Dependencies (minimal)
# No external dependencies - pure POSIX shell
DEPS_EOF
    
    # Create the TCZ package
    echo "  Building udos-core.tcz..."
    cd "$BUILD_DIR"
    if command -v mksquashfs >/dev/null 2>&1; then
        mksquashfs udos-core "$PACKAGE_DIR/udos-core.tcz" -all-root -no-progress
    else
        echo "  Warning: mksquashfs not found, creating tar.gz instead"
        tar czf "$PACKAGE_DIR/udos-core.tcz" udos-core/
    fi
    
    # Create info files for TCZ system
    cp udos-core/usr/local/share/udos/info "$PACKAGE_DIR/udos-core.tcz.info"
    cp udos-core/usr/local/share/udos/depends "$PACKAGE_DIR/udos-core.tcz.dep"
    
    echo "  ✓ udos-core.tcz created"
}

# Create VNC support package
create_udos_vnc_package() {
    echo "Creating udos-vnc.tcz package..."
    
    VNC_DIR="$BUILD_DIR/udos-vnc"
    mkdir -p "$VNC_DIR/usr/local/bin"
    mkdir -p "$VNC_DIR/usr/local/share/udos-vnc"
    
    # Copy VNC integration scripts
    if [ -f "vm/current/udos-boot-art.sh" ]; then
        cp "vm/current/udos-boot-art.sh" "$VNC_DIR/usr/local/bin/"
        chmod +x "$VNC_DIR/usr/local/bin/udos-boot-art.sh"
    fi
    
    # Create VNC startup script
    cat > "$VNC_DIR/usr/local/bin/udos-vnc-start" << 'VNC_EOF'
#!/bin/sh
# uDOS VNC Startup Script
set -e

# Load required TCZ packages
tce-load -i Xvesa.tcz
tce-load -i fluxbox.tcz
tce-load -i x11vnc.tcz

# Start X server
Xvesa -screen 1024x768x24 -pixdepth 24 :1 &
sleep 2

# Set display
export DISPLAY=:1

# Start window manager
fluxbox &
sleep 1

# Start VNC server
x11vnc -display :1 -passwd ${UDOS_VNC_PASSWORD:-udos2024} -forever -shared &

echo "VNC server started on display :1"
echo "Password: ${UDOS_VNC_PASSWORD:-udos2024}"
echo "Connect to: $(hostname -I | awk '{print $1}'):5901"
VNC_EOF
    
    chmod +x "$VNC_DIR/usr/local/bin/udos-vnc-start"
    
    # Create package info
    cat > "$VNC_DIR/usr/local/share/udos-vnc/info" << 'VNC_INFO_EOF'
Title:          udos-vnc.tcz
Description:    Universal Device Operating System - VNC Desktop
Version:        1.0.5
Author:         uDOS Project
Original-site:  https://github.com/fredporter/uDOS
Copying-policy: MIT
Size:           8KB
Extension_by:   uDOS Team
Tags:           VNC desktop GUI
Comments:       VNC desktop environment for uDOS
                Provides graphical access and copy-paste functionality
                Requires Xvesa, fluxbox, x11vnc packages
Change-log:     2024/09/03 v1.0.5 Initial VNC package
Current:        2024/09/03
VNC_INFO_EOF
    
    # Create dependencies
    cat > "$VNC_DIR/usr/local/share/udos-vnc/depends" << 'VNC_DEPS_EOF'
Xvesa.tcz
fluxbox.tcz
x11vnc.tcz
udos-core.tcz
VNC_DEPS_EOF
    
    # Build package
    cd "$BUILD_DIR"
    if command -v mksquashfs >/dev/null 2>&1; then
        mksquashfs udos-vnc "$PACKAGE_DIR/udos-vnc.tcz" -all-root -no-progress
    else
        tar czf "$PACKAGE_DIR/udos-vnc.tcz" udos-vnc/
    fi
    
    cp udos-vnc/usr/local/share/udos-vnc/info "$PACKAGE_DIR/udos-vnc.tcz.info"
    cp udos-vnc/usr/local/share/udos-vnc/depends "$PACKAGE_DIR/udos-vnc.tcz.dep"
    
    echo "  ✓ udos-vnc.tcz created"
}

# Create boot integration package
create_udos_boot_package() {
    echo "Creating udos-boot.tcz package..."
    
    BOOT_DIR="$BUILD_DIR/udos-boot"
    mkdir -p "$BOOT_DIR/usr/local/bin"
    mkdir -p "$BOOT_DIR/usr/local/share/udos-boot"
    mkdir -p "$BOOT_DIR/opt"
    
    # Copy boot integration
    if [ -f "vm/current/udos-boot-art.sh" ]; then
        cp "vm/current/udos-boot-art.sh" "$BOOT_DIR/usr/local/bin/"
        chmod +x "$BOOT_DIR/usr/local/bin/udos-boot-art.sh"
    fi
    
    # Create bootlocal.sh integration
    cat > "$BOOT_DIR/opt/udos-bootlocal.sh" << 'BOOTLOCAL_EOF'
#!/bin/sh
# uDOS Boot Integration for TinyCore
# Add this to /opt/bootlocal.sh

# uDOS Boot Integration
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh boot
fi

# Initialize uDOS environment
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh init
fi
BOOTLOCAL_EOF
    
    chmod +x "$BOOT_DIR/opt/udos-bootlocal.sh"
    
    # Create filetool.lst entries
    cat > "$BOOT_DIR/usr/local/share/udos-boot/filetool.lst" << 'FILETOOL_EOF'
# uDOS Configuration Persistence
etc/udos
opt/udos-bootlocal.sh
home/tc/.udos
home/tc/.profile
FILETOOL_EOF
    
    # Create package info
    cat > "$BOOT_DIR/usr/local/share/udos-boot/info" << 'BOOT_INFO_EOF'
Title:          udos-boot.tcz
Description:    Universal Device Operating System - Boot Integration
Version:        1.0.5
Author:         uDOS Project
Original-site:  https://github.com/fredporter/uDOS
Copying-policy: MIT
Size:           4KB
Extension_by:   uDOS Team
Tags:           boot integration startup
Comments:       Boot integration and ASCII art for uDOS
                Provides automatic startup and branding
                Integrates with TinyCore boot system
Change-log:     2024/09/03 v1.0.5 Initial boot package
Current:        2024/09/03
BOOT_INFO_EOF
    
    # Create dependencies
    cat > "$BOOT_DIR/usr/local/share/udos-boot/depends" << 'BOOT_DEPS_EOF'
udos-core.tcz
BOOT_DEPS_EOF
    
    # Build package
    cd "$BUILD_DIR"
    if command -v mksquashfs >/dev/null 2>&1; then
        mksquashfs udos-boot "$PACKAGE_DIR/udos-boot.tcz" -all-root -no-progress
    else
        tar czf "$PACKAGE_DIR/udos-boot.tcz" udos-boot/
    fi
    
    cp udos-boot/usr/local/share/udos-boot/info "$PACKAGE_DIR/udos-boot.tcz.info"
    cp udos-boot/usr/local/share/udos-boot/depends "$PACKAGE_DIR/udos-boot.tcz.dep"
    
    echo "  ✓ udos-boot.tcz created"
}

# Create installation instructions
create_installation_docs() {
    echo "Creating installation documentation..."
    
    cat > "$PACKAGE_DIR/INSTALL.md" << 'INSTALL_EOF'
# uDOS TCZ Package Installation

## Quick Installation

```bash
# Install core package
tce-load -wi udos-core.tcz

# Install VNC support (optional)
tce-load -wi udos-vnc.tcz

# Install boot integration (optional)
tce-load -wi udos-boot.tcz
```

## Manual Installation

1. **Copy packages to TinyCore**:
   ```bash
   # Copy to tce directory
   sudo cp *.tcz /mnt/sda1/tce/optional/
   sudo cp *.tcz.* /mnt/sda1/tce/optional/
   ```

2. **Load packages**:
   ```bash
   tce-load -i udos-core.tcz
   tce-load -i udos-vnc.tcz
   tce-load -i udos-boot.tcz
   ```

3. **Make persistent**:
   ```bash
   # Add to onboot.lst for automatic loading
   echo udos-core.tcz >> /mnt/sda1/tce/onboot.lst
   echo udos-vnc.tcz >> /mnt/sda1/tce/onboot.lst
   echo udos-boot.tcz >> /mnt/sda1/tce/onboot.lst
   ```

## Verification

```bash
# Test uDOS installation
udos version
udos info
udos-detect-role

# Test VNC (if installed)
udos-vnc-start

# Test boot integration (if installed)
udos-boot-art.sh test
```

## Package Descriptions

- **udos-core.tcz**: Core uDOS command suite and role system
- **udos-vnc.tcz**: VNC desktop environment integration
- **udos-boot.tcz**: Boot sequence ASCII art and automation

## Dependencies

Each package declares its dependencies in `.tcz.dep` files:
- udos-core: No dependencies (pure POSIX shell)
- udos-vnc: Requires Xvesa, fluxbox, x11vnc
- udos-boot: Requires udos-core

## Configuration

uDOS configuration is stored in `/etc/udos/config` and persisted
via TinyCore's filetool.lst system.
INSTALL_EOF
    
    echo "  ✓ Installation documentation created"
}

# Main execution
main() {
    echo "Building uDOS TCZ packages..."
    echo ""
    
    create_udos_core_package
    create_udos_vnc_package  
    create_udos_boot_package
    create_installation_docs
    
    echo ""
    echo "TCZ Package Creation Complete!"
    echo "=============================="
    echo ""
    echo "Packages created in: $PACKAGE_DIR"
    echo ""
    ls -la "$PACKAGE_DIR"
    echo ""
    echo "Installation:"
    echo "1. Copy packages to TinyCore VM"
    echo "2. Run: tce-load -wi udos-core.tcz"
    echo "3. Run: udos version"
    echo ""
    echo "For full installation instructions:"
    echo "cat $PACKAGE_DIR/INSTALL.md"
}

# Run main function
main "$@"
