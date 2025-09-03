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
