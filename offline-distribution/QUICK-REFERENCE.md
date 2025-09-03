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
