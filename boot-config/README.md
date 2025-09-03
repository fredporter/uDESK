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
