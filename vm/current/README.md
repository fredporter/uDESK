# uDESK TinyCore VM - Current Files

Production-ready files for uDOS TinyCore Linux integration.

## Primary Installation

### install.sh
**Main uDOS Installer** - Installs the modular uDOS system:

```sh
# Standard installation
./install.sh

# Installation with verification
./install.sh --verify
```

**Features**:
- Clean modular installation
- ASCII art boot integration
- Environment variable configuration
- Installation verification
- Persistence setup

## Quick Setup

### setup.sh
**Quick VM Setup** - One-command setup for fresh TinyCore VM:

```sh
# Complete VM setup
./setup.sh
```

**Features**:
- Essential tools installation
- Git repository setup
- Automatic uDOS installation
- Environment configuration

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

## UTM Integration

### utm.sh
**UTM Shared Folder Setup** - Configures Mac UTM shared folder integration:

```sh
# Setup UTM shared folders
./utm.sh
```

## VM Configuration

### vm.sh
**General VM Setup** - Configures VM environment:

```sh
# Setup VM environment
./vm.sh
```

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
