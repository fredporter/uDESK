# 🚀 TinyCore VM ISO Update Guide - uDOS v1.0.5

## Current Status
✅ **Repository restructured**: Clean Linux-standard layout (85% reduction!)  
✅ **M1 + M2 Complete**: Full foundation with web interface integration  
✅ **Ready for M3**: Desktop integration development ready  
✅ **Clean installer**: Single `install.sh` with unified structure

---

## 🎯 Update Options for Your VM

### Option 1: Clean Structure Installation (Recommended)
**Install the new clean uDOS structure:**

```bash
# Boot your existing TinyCore VM
# Install the new clean uDOS directly:

curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh | bash

# Or manual method:
wget https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh
chmod +x install.sh
sudo ./install.sh

# Test the installation:
udos version
udos test
```

### Option 2: Fresh VM Creation (Clean Start)
**Create a new VM with latest clean uDOS structure:**

1. **Create new UTM VM** with TinyCore-current.iso
2. **Boot TinyCore** in text mode
3. **Enable networking**: `sudo dhcp.sh`
4. **Install clean uDOS**: `curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh | bash`
5. **Test installation**: `udos version && udos test`

### Option 3: Local Development Installation
**For development from the clean repository:**

```bash
# Clone the clean repository:
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Install locally:
sudo ./install.sh

# Test installation:
./test.sh
udos version
```

---

## 🎨 What You'll Get After Update

### Clean Directory Structure
```
/usr/local/
├── bin/
│   ├── udos          # Main uDOS command
│   ├── uvar          # Variable management
│   ├── udata         # Data management
│   └── utpl          # Template management
└── share/udos/       # M2 interface components
    ├── udos-web-bridge.js
    ├── udos-role-ui.js
    └── udos-m2-complete.js

/etc/udos/
└── config            # Configuration files
```

### New Features (v1.0.5)
- ✅ **Clean Structure**: Linux-standard directory layout
- ✅ **Unified Commands**: udos, uvar, udata, utpl
- ✅ **M2 Integration**: Complete web interface system
- ✅ **Role System**: 8-tier hierarchy (GHOST to WIZARD)
- ✅ **Built-in Testing**: `udos test` command
- ✅ **Simple Installation**: Single installer script

---

## 🛠 Recommended Update Path

### For Your Setup (Easiest)
1. **Boot your existing TinyCore VM**
2. **Enable networking** if not already: `sudo dhcp.sh`
3. **Run the clean installer**:
   ```bash
   curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh | bash
   ```
4. **Test the installation**:
   ```bash
   udos version    # Should show v1.0.5
   udos test       # Run built-in tests
   uvar --help     # Test utility commands
   ```

### Verification Commands
```bash
# Check installation
udos version
udos role

# Test M2 interface
udos test m2

# Check command availability
which udos uvar udata utpl

# View system information
udos info
```

---

## 🔧 Troubleshooting

### If Network Issues in VM
```bash
# Enable DHCP
sudo dhcp.sh

# Test connectivity
ping google.com

# Use offline method if network fails
# (Copy offline bundle via shared folder)
```

### If Installation Fails
```bash
# Try manual download
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/install-udos.sh

# Check permissions
chmod +x install-udos.sh

# Run with verbose output
./install-udos.sh github
```

### If Boot Integration Issues
```bash
# Manual setup
./udos-boot-art.sh setup

# Test components
./udos-boot-art.sh test

# Remove if needed
./udos-boot-art.sh remove
```

---

## 📋 Quick Command Reference

```bash
# Install clean uDOS v1.0.5
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/install.sh | bash

# Test installation
udos version && udos test

# Basic commands
udos info         # System information
uvar list         # Variable management
udata status      # Data management
utpl list         # Template management

# Role system
udos role         # Check current role
udos help         # Role-based help
```

---

## 🎉 After Update

Your TinyCore VM will have:
- **Clean Linux-standard structure** with proper file organization
- **Complete uDOS CLI suite** with unified command interface
- **M2 web interface integration** for advanced functionality
- **Role-based access system** (8 levels: GHOST → WIZARD)
- **Built-in testing system** with `udos test` command
- **Organized documentation** in `/usr/local/share/udos/docs/`

**Ready to update?** Just run the installation command in your VM! 🚀

---

## 🔄 For Developers

### Development Installation
```bash
# Clone and install for development
git clone https://github.com/fredporter/uDESK.git
cd uDESK
sudo ./install.sh

# Development testing
./test.sh
udos test system
udos test m2
```

### Clean Structure Benefits
- **85% fewer directories** (97 → 12)
- **Linux-standard layout** (usr/bin, etc/udos)
- **Unified commands** (udos, uvar, udata, utpl)
- **Organized documentation** (docs/ with roadmaps)
- **Ready for M3 development** (desktop integration)
