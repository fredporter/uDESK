# uDESK Development Scripts

This directory contains all development, build, and testing scripts for uDESK.

## Scripts Overview

### Core Development
- `build.sh` - Main build script for uDESK packages
- `test.sh` - Testing script for uDESK functionality
- `test-vm.sh` - VM-specific testing script

### Repository Management
- `cleanup-repo.sh` - Repository cleanup and organization
- `create-boot-config.sh` - Boot configuration creation
- `create-tcz-packages.sh` - TinyCore package creation
- `create-offline-distribution.sh` - Offline distribution builder

### Integration Testing
- `m2-integration/` - M2 milestone integration testing

## Usage

All scripts should be run from the uDESK root directory:

```bash
# Example: Run build script
cd /path/to/uDESK
./dev/build.sh

# Example: Run tests
./dev/test.sh

# Example: Clean repository
./dev/cleanup-repo.sh
```

## For End Users

If you're just installing or using uDESK, you only need:
- `install.sh` (in root directory) - Main installer
- Documentation in `/docs/` directory

These development scripts are for contributors and advanced users only.
