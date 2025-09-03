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
