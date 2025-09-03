# uDESK TinyCore VM - Current Files

Production-ready files for uDOS TinyCore Linux integration.

## Primary Installation

### install-udos.sh
**Hybrid Distribution Manager** - Automatically detects and uses the best installation method:

```sh
# Auto-detect best method
./install-udos.sh

# Force specific method
./install-udos.sh github    # GitHub installation
./install-udos.sh tcz       # TinyCore extension package
./install-udos.sh offline   # Local bundle installation
./install-udos.sh update    # Update existing installation
```

**Features**:
- Auto-detection of network connectivity
- Fallback installation methods
- ASCII art boot integration
- Environment variable configuration
- Installation verification

## Boot Integration

### udos-boot-art.sh
**ASCII Art and Boot Integration** - Provides visual branding and system integration:

```sh
# Setup boot integration
./udos-boot-art.sh setup

# Test displays
./udos-boot-art.sh test

# Remove integration
./udos-boot-art.sh remove
```

**Features**:
- Boot sequence ASCII art
- Login prompt branding
- Terminal prompt integration
- Environment initialization
- TinyCore bootlocal.sh integration

## Quick Start

1. **Download uDESK**:
   ```sh
   wget https://github.com/fredporter/uDESK/archive/main.zip
   unzip main.zip
   cd uDESK-main/vm/current/
   ```

2. **Install uDOS**:
   ```sh
   chmod +x install-udos.sh
   ./install-udos.sh
   ```

3. **Setup Boot Integration**:
   ```sh
   chmod +x udos-boot-art.sh
   ./udos-boot-art.sh setup
   ```

4. **Verify Installation**:
   ```sh
   udos help
   udos info
   ```

## Environment Variables

Configure installation behavior:
- `UDOS_VNC_PASSWORD` - Set VNC password (default: udos2024)
- `UDOS_AUTO_VNC` - Auto-start VNC (default: yes)
- `UDOS_DESKTOP` - Install desktop environment (default: yes)

## Documentation

- Installation instructions: `INSTALL-INSTRUCTIONS.txt`
- Development history: `../archive/README.md`
- Main project: `../../README.md`
