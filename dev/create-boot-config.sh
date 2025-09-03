#!/bin/sh
# TinyCore Boot Configuration for uDOS
# Optimizes TinyCore boot parameters for uDOS usage

echo "TinyCore Boot Configuration for uDOS v1.0.5"
echo "============================================"
echo ""

# Boot parameter optimization
create_boot_config() {
    echo "Creating optimized boot configuration..."
    
    # Create boot configuration directory
    mkdir -p boot-config
    
    # Create grub.cfg optimized for uDOS
    cat > boot-config/grub.cfg << 'GRUB_EOF'
# TinyCore + uDOS Optimized Boot Configuration

menuentry "TinyCore + uDOS (Optimized)" {
    linux /boot/vmlinuz quiet 
          desktop=fluxbox 
          tce=sda1 
          opt=sda1 
          home=sda1 
          base 
          norestore 
          udos=auto
    initrd /boot/core.gz
}

menuentry "TinyCore + uDOS (Safe Mode)" {
    linux /boot/vmlinuz waitusb=5 
          desktop=fluxbox 
          tce=sda1 
          opt=sda1 
          home=sda1 
          base 
          norestore 
          udos=safe
    initrd /boot/core.gz
}

menuentry "TinyCore + uDOS (No Desktop)" {
    linux /boot/vmlinuz quiet 
          tce=sda1 
          opt=sda1 
          home=sda1 
          base 
          norestore 
          text 
          udos=cli
    initrd /boot/core.gz
}
GRUB_EOF
    
    echo "  ✓ grub.cfg created with uDOS optimization"
}

# Create filetool.lst for persistence
create_filetool_config() {
    echo "Creating filetool.lst configuration..."
    
    cat > boot-config/filetool.lst << 'FILETOOL_EOF'
# uDOS TinyCore Persistence Configuration
# Add these lines to /opt/.filetool.lst

# uDOS Configuration
etc/udos
opt/udos

# User Configuration
home/tc/.udos
home/tc/.profile
home/tc/.ashrc

# System Integration
opt/bootlocal.sh
opt/bootsync.sh

# VNC Configuration (if using VNC)
home/tc/.vnc
etc/X11

# Package Lists
etc/sysconfig/tcedir/onboot.lst
etc/sysconfig/tcedir/optional
FILETOOL_EOF
    
    echo "  ✓ filetool.lst configuration created"
}

# Create bootlocal.sh integration
create_bootlocal_integration() {
    echo "Creating bootlocal.sh integration..."
    
    cat > boot-config/bootlocal.sh << 'BOOTLOCAL_EOF'
#!/bin/sh
# /opt/bootlocal.sh - TinyCore boot customization with uDOS integration
# This file is executed during the boot process

# Enable networking
/usr/bin/dhcp.sh &

# uDOS Boot Integration
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh boot
fi

# Initialize uDOS environment
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh init
fi

# Auto-start VNC if configured
if [ "$UDOS_AUTO_VNC" = "yes" ] && [ -f /usr/local/bin/udos-vnc-start ]; then
    /usr/local/bin/udos-vnc-start &
fi

# Set uDOS role if not already set
if [ -z "$UDOS_ROLE" ] && [ -f /usr/local/bin/udos-detect-role ]; then
    export UDOS_ROLE=$(udos-detect-role)
fi

# Load additional uDOS services
if [ -f /usr/local/bin/udos ]; then
    udos boot-services >/dev/null 2>&1 || true
fi
BOOTLOCAL_EOF
    
    chmod +x boot-config/bootlocal.sh
    echo "  ✓ bootlocal.sh integration created"
}

# Create onboot.lst for automatic package loading
create_onboot_config() {
    echo "Creating onboot.lst configuration..."
    
    cat > boot-config/onboot.lst << 'ONBOOT_EOF'
# TinyCore onboot.lst - Packages to load automatically
# Place in /mnt/sda1/tce/onboot.lst

# Core TinyCore packages
nano.tcz
bash.tcz

# uDOS Core (required)
udos-core.tcz

# uDOS VNC Support (optional)
Xvesa.tcz
fluxbox.tcz
x11vnc.tcz
udos-vnc.tcz

# uDOS Boot Integration (optional)
udos-boot.tcz

# Network tools
curl.tcz
wget.tcz

# Development tools (if admin role)
git.tcz
python3.6.tcz
ONBOOT_EOF
    
    echo "  ✓ onboot.lst configuration created"
}

# Create boot optimization script
create_boot_optimizer() {
    echo "Creating boot optimization script..."
    
    cat > boot-config/optimize-boot.sh << 'OPTIMIZER_EOF'
#!/bin/sh
# TinyCore Boot Optimization for uDOS

set -e

echo "Optimizing TinyCore boot for uDOS..."

# Backup existing configurations
backup_configs() {
    if [ -f /opt/bootlocal.sh ]; then
        cp /opt/bootlocal.sh /opt/bootlocal.sh.backup.$(date +%Y%m%d)
    fi
    
    if [ -f /opt/.filetool.lst ]; then
        cp /opt/.filetool.lst /opt/.filetool.lst.backup.$(date +%Y%m%d)
    fi
}

# Apply boot optimization
apply_optimization() {
    echo "Applying boot configuration..."
    
    # Copy bootlocal.sh
    if [ -f bootlocal.sh ]; then
        sudo cp bootlocal.sh /opt/bootlocal.sh
        sudo chmod +x /opt/bootlocal.sh
        echo "  ✓ bootlocal.sh updated"
    fi
    
    # Update filetool.lst
    if [ -f filetool.lst ]; then
        if [ -f /opt/.filetool.lst ]; then
            # Append to existing file
            cat filetool.lst | while read line; do
                if ! grep -q "$line" /opt/.filetool.lst 2>/dev/null; then
                    echo "$line" | sudo tee -a /opt/.filetool.lst >/dev/null
                fi
            done
        else
            # Create new file
            sudo cp filetool.lst /opt/.filetool.lst
        fi
        echo "  ✓ filetool.lst updated"
    fi
    
    # Copy onboot.lst if TinyCore directory exists
    if [ -d /mnt/sda1/tce ] && [ -f onboot.lst ]; then
        sudo cp onboot.lst /mnt/sda1/tce/onboot.lst
        echo "  ✓ onboot.lst updated"
    fi
}

# Set kernel parameters
optimize_kernel_params() {
    echo "Setting kernel optimization parameters..."
    
    # Create kernel parameter file
    cat > /tmp/kernel-params << 'PARAMS_EOF'
# Optimized kernel parameters for uDOS
quiet
desktop=fluxbox
tce=sda1
opt=sda1
home=sda1
base
norestore
PARAMS_EOF
    
    echo "  ✓ Kernel parameters configured"
    echo "    Add these to your boot loader configuration"
}

# Main optimization routine
main() {
    backup_configs
    apply_optimization
    optimize_kernel_params
    
    echo ""
    echo "Boot optimization complete!"
    echo ""
    echo "Next steps:"
    echo "1. Reboot to apply changes"
    echo "2. Test uDOS functionality: udos info"
    echo "3. Test VNC (if enabled): udos-vnc-start"
    echo ""
    echo "Boot sequence will now include:"
    echo "- uDOS ASCII art branding"
    echo "- Automatic environment setup"
    echo "- Role detection and configuration"
    echo "- Optional VNC desktop startup"
}

main "$@"
OPTIMIZER_EOF
    
    chmod +x boot-config/optimize-boot.sh
    echo "  ✓ Boot optimization script created"
}

# Create documentation
create_boot_docs() {
    echo "Creating boot configuration documentation..."
    
    cat > boot-config/README.md << 'BOOT_README_EOF'
# TinyCore Boot Configuration for uDOS

This directory contains optimized boot configurations for running uDOS on TinyCore Linux.

## Files

### Core Configuration
- `bootlocal.sh` - Boot-time initialization script
- `filetool.lst` - Persistence configuration
- `onboot.lst` - Automatic package loading
- `grub.cfg` - Boot loader configuration

### Utilities
- `optimize-boot.sh` - Apply all optimizations automatically
- `README.md` - This documentation

## Installation

### Automatic (Recommended)
```bash
./optimize-boot.sh
```

### Manual Installation

1. **Boot Script Integration**:
   ```bash
   sudo cp bootlocal.sh /opt/bootlocal.sh
   sudo chmod +x /opt/bootlocal.sh
   ```

2. **Persistence Configuration**:
   ```bash
   sudo cp filetool.lst /opt/.filetool.lst
   ```

3. **Package Loading**:
   ```bash
   sudo cp onboot.lst /mnt/sda1/tce/onboot.lst
   ```

4. **Boot Loader** (if using GRUB):
   ```bash
   sudo cp grub.cfg /boot/grub/grub.cfg
   ```

## Boot Process

With these configurations, TinyCore will:

1. **Boot with uDOS branding** - ASCII art display
2. **Auto-load packages** - Core uDOS and optional components
3. **Initialize environment** - Set paths, roles, configuration
4. **Start services** - Network, VNC (if configured)
5. **Ready for use** - uDOS commands available immediately

## Kernel Parameters

Optimized boot parameters for uDOS:
```
quiet desktop=fluxbox tce=sda1 opt=sda1 home=sda1 base norestore
```

### Parameter Explanation
- `quiet` - Reduce boot messages
- `desktop=fluxbox` - Use lightweight window manager
- `tce=sda1` - Store extensions on first drive
- `opt=sda1` - Store optional files on first drive
- `home=sda1` - Store home directory on first drive
- `base` - Use base TinyCore (no desktop by default)
- `norestore` - Fresh start each boot (faster)

## Persistence

Files preserved across reboots:
- `/etc/udos/` - uDOS configuration
- `/home/tc/.udos/` - User uDOS settings
- `/home/tc/.profile` - User environment
- `/opt/bootlocal.sh` - Boot script
- Package lists and preferences

## Troubleshooting

### Boot Issues
```bash
# Check bootlocal.sh syntax
sh -n /opt/bootlocal.sh

# View boot log
dmesg | grep -i udos

# Test components individually
udos version
udos-detect-role
```

### Package Issues
```bash
# Check loaded packages
lsmod | grep udos

# Reload packages manually
tce-load -i udos-core.tcz

# Check package integrity
unsquashfs -l /mnt/sda1/tce/optional/udos-core.tcz
```

### VNC Issues
```bash
# Check VNC process
ps aux | grep vnc

# Test X server
DISPLAY=:1 xterm

# Check network
netstat -ln | grep 5901
```

## Performance

Optimizations included:
- **Fast boot** - Minimal package loading
- **Memory efficient** - Lightweight components
- **Network ready** - DHCP auto-configuration
- **Persistent settings** - Smart file preservation
- **Role-based loading** - Only load needed components

Total boot time: ~10-15 seconds on modern hardware
Memory usage: ~50-80MB for base uDOS system
BOOT_README_EOF
    
    echo "  ✓ Boot configuration documentation created"
}

# Main execution
main() {
    create_boot_config
    create_filetool_config
    create_bootlocal_integration
    create_onboot_config
    create_boot_optimizer
    create_boot_docs
    
    echo ""
    echo "TinyCore Boot Configuration Complete!"
    echo "====================================="
    echo ""
    echo "Files created in boot-config/:"
    ls -la boot-config/
    echo ""
    echo "To apply optimizations:"
    echo "  cd boot-config && ./optimize-boot.sh"
    echo ""
    echo "Manual installation:"
    echo "  See boot-config/README.md for details"
}

main "$@"
