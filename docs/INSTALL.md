# uDESK Installation Guide

> **uDESK v1.0.6** - A markdown-focused operating system based on TinyCore Linux

## Overview

uDESK is a minimalist operating system where **everything is markdown**. From system configuration to user documentation, markdown is the primary format for human-readable system management.

## System Requirements

### Minimum
- **RAM**: 512MB (1GB recommended)
- **Storage**: 1GB (for persistence)
- **CPU**: x86_64 compatible
- **Network**: Optional but recommended

### Recommended
- **RAM**: 2GB+ (for development work)
- **Storage**: 4GB+ (for development tools)
- **USB**: For portable deployment

## Installation Methods

### 1. USB Live System (Recommended)

Create a portable uDESK system that preserves your data:

```bash
# Download uDESK image
wget https://github.com/yourorg/uDESK/releases/latest/download/udesk-v1.0.6-standard.iso

# Write to USB (replace /dev/sdX with your USB device)
sudo dd if=udesk-v1.0.6-standard.iso of=/dev/sdX bs=4M status=progress

# Or use a GUI tool like Balena Etcher
```

### 2. Virtual Machine

Perfect for testing and development:

```bash
# Using QEMU
qemu-system-x86_64 -m 1024 -cdrom udesk-v1.0.6-standard.iso -boot d

# Using our helper script
./isos/run_qemu.sh --image out/udesk-v1.0.6-standard.iso
```

### 3. Hard Drive Installation

For permanent installation (advanced users):

```bash
# Boot from USB/CD first
# Then use TinyCore's built-in installer
tc-install.sh
```

## First Boot

### Boot Options

Add these to the kernel command line at boot:

- `udos.role=basic` - Minimal shell environment
- `udos.role=standard` - Full desktop (default)
- `udos.role=admin` - Development environment
- `udos.gui=off` - Boot to console only
- `udos.debug=on` - Enable debug output

### Initial Setup

1. **Select Role**: Choose your user role during first boot
2. **Network**: Configure networking (DHCP by default)
3. **Persistence**: Set up data persistence
4. **Markdown Tools**: Install micro and glow editors

### Default Credentials

- **User**: `tc` (TinyCore default)
- **Password**: None (passwordless login)
- **Sudo**: Varies by role

## Role-Based Setup

### Basic Role
```bash
# After boot, verify role
udos-info

# Start using markdown immediately
micro welcome.md
glow welcome.md
```

### Standard Role
```bash
# Start GUI desktop
startx

# Access full markdown workflow
micro mydocument.md
glow mydocument.md
```

### Admin Role
```bash
# Full development environment
udos-venv create myproject
source /opt/udos/venv/myproject/bin/activate
pip install markdown-extensions
```

## Persistence Setup

### Automatic Persistence
uDESK automatically persists:
- `/home/tc` - User files
- `/etc/udos` - System configuration
- `/opt/udos` - uDESK applications

### Manual Persistence
```bash
# Add custom paths to persistence
echo "/my/custom/path" >> /opt/.filetool.lst

# Backup current state
filetool.sh -b

# Restore on next boot (automatic)
```

## Network Configuration

### DHCP (Default)
Network is configured automatically via DHCP.

### Static IP
Edit the network configuration in markdown:

```bash
micro /etc/udos/network.md
```

Example network.md:
```markdown
# Network Configuration

## Interface: eth0
- **IP**: 192.168.1.100
- **Netmask**: 255.255.255.0
- **Gateway**: 192.168.1.1
- **DNS**: 8.8.8.8, 8.8.4.4

## WiFi: wlan0
- **SSID**: MyNetwork
- **Security**: WPA2
- **Password**: [stored separately]
```

## Markdown Development Environment

### Core Tools

All roles include these markdown essentials:

- **micro**: Lightweight, powerful editor
- **glow**: Beautiful terminal markdown viewer
- **pandoc**: Document conversion (Admin role)

### Workflow

```bash
# Create new document
micro project-plan.md

# View beautifully formatted
glow project-plan.md

# System documentation
udos-info > system-status.md
glow system-status.md
```

### Advanced Features (Admin Role)

```bash
# Convert markdown to other formats
pandoc README.md -o README.pdf

# Live preview server
glow -p 8080 documentation/

# Git integration for documentation
git init
git add *.md
git commit -m "Initial documentation"
```

## Troubleshooting

### Common Issues

**Problem**: Markdown tools not found
```bash
# Solution: Reinstall tools
/opt/udos/install-markdown-tools.sh
```

**Problem**: Persistence not working
```bash
# Solution: Check file tool list
cat /opt/.filetool.lst
filetool.sh -b
```

**Problem**: Wrong role active
```bash
# Solution: Change role and reboot
echo "standard" > /etc/udos/role
sudo reboot
```

### Debug Mode

Enable debug output:
```bash
# Add to kernel command line
udos.debug=on

# Or enable after boot
echo "debug" > /etc/udos/debug-mode
```

### Log Files

Check system logs:
```bash
# System messages
dmesg | tail

# uDESK specific logs
cat /var/log/udos.log

# Format as markdown for easy reading
echo "# System Log" > debug.md
dmesg | tail -50 >> debug.md
glow debug.md
```

## Recovery

### Reset to Defaults

```bash
# Remove persistence
rm /mnt/sda1/tce/mydata.tgz

# Or reset specific config
rm /etc/udos/role
echo "basic" > /etc/udos/role
```

### Safe Mode

Boot with minimal configuration:
```bash
# Kernel command line
udos.role=basic udos.gui=off udos.safe=on
```

## Updates

### System Updates
```bash
# Update TinyCore base (Admin role)
tce-update

# Update uDESK components
./packaging/build_udos_core.sh
./packaging/build_udos_roles.sh
```

### Markdown Tools Updates
```bash
# Update markdown tools
/opt/udos/install-markdown-tools.sh
```

## Support

### Documentation
All system documentation is in markdown format:
- `/etc/udos/*.md` - Configuration files
- `/opt/udos/docs/*.md` - User guides
- `/usr/local/share/doc/*.md` - Application docs

### Community
- GitHub Issues: Report bugs and feature requests
- Discussions: Share markdown workflows
- Wiki: Community documentation

### Self-Help
```bash
# System information
udos-info

# View all available markdown docs
find /etc /opt /usr -name "*.md" -type f | head -20

# Quick help
glow /opt/udos/docs/quick-help.md
```

---

*Everything in uDESK is designed around markdown. Even this installation guide lives as a markdown file that you can edit and improve!*
