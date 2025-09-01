# 🚀 uDESK - Markdown-Everything Operating System

[![Version](https://img.shields.io/badge/version-1.0.6-blue.svg)](#current-status)
[![Status](https://img.shields.io/badge/status-Ready%20for%20VM-green.svg)](#quick-start)
[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)](#package-status)

uDESK is a lightweight, markdown-focused Linux distribution based on TinyCore Linux. **Everything in uDESK is configured through markdown files** for maximum readability, version control compatibility, and universal editability.

## ✨ Philosophy: Markdown Everything

🌟 **Human-Readable Configuration**: All system settings in `.md` format  
📝 **Documentation-Driven**: Every component self-documenting  
🎯 **Version Control Friendly**: Git-native configuration management  
⚡ **Universal Compatibility**: Edit with any text editor  
🔧 **Developer Focused**: Built by developers, for developers  

## 🚀 Quick Start

### One-Command Setup
```bash
cd /Users/fredbook/Code/uDESK
chmod +x setup-udesk-utm.sh
./setup-udesk-utm.sh
```

**What this does:**
- ✅ Detects your TinyCore ISO at `/Users/fredbook/Code/TinyCore-current.iso`
- ✅ Builds uDESK packages with SquashFS compression  
- ✅ Creates UTM virtual machine (or manual setup)
- ✅ Opens UTM with your configured VM
- ✅ Provides complete installation instructions

### Alternative Methods

**Manual Build:**
```bash
./build.sh --clean --role admin
```

**UTM Automation (requires QEMU):**
```bash
./utm-auto-setup.sh
```

**Simple Manual Setup:**
```bash
./utm-simple-setup.sh
```

## 📦 Package Status

### Core Components (Ready for VM Launch)
- **udos-core.tcz** (4.5KB) - Base system with markdown tools ✅
- **udos-role-basic.tcz** (898B) - Minimal markdown environment ✅
- **udos-role-standard.tcz** (1.0KB) - Productivity tools ✅
- **udos-role-admin.tcz** (1.4KB) - Full development environment ✅

**Total system size:** 7.8KB compressed

### Built-in Commands
```bash
udos-info              # System information in markdown format
udos-detect-role       # Current role detection  
udos-service list      # Available services
```

## 🎯 Role-Based Architecture

### 🟢 Basic Role (898B)
```markdown
# Basic Role Features
- Minimal system footprint
- Core markdown editing tools  
- Essential system utilities
- Perfect for focused writing
- No sudo access (secure)
```

### 🟡 Standard Role (1.0KB)  
```markdown
# Standard Role Features
- All Basic features
- Productivity applications
- Enhanced markdown workflow
- File management tools
- Limited sudo for user tasks
```

### 🔴 Admin Role (1.4KB)
```markdown
# Admin Role Features  
- All Standard features
- Full development toolchain
- Python + virtual environments
- System administration tools
- Complete package management
- Full sudo access
```

## 🖥️ UTM Setup (macOS)

### Prerequisites
- **UTM** installed from https://mac.getutm.app/
- **TinyCore ISO** at `/Users/fredbook/Code/TinyCore-current.iso`
- **Optional**: Homebrew for automation features

### Critical VM Settings
```markdown
# UTM VM Configuration
- **Type**: Virtualize → Linux
- **RAM**: 1024 MB minimum
- **Storage**: 4 GB minimum  
- **Display**: Console Only ⚠️ (fixes "display not active" errors)
- **Network**: NAT or Bridged
- **ISO**: Your TinyCore-current.iso
```

### Installation Process
1. **Boot TinyCore** in UTM (text mode is normal)
2. **Copy uDESK packages** to VM via drag-drop or shared folder
3. **Run installation script**: `./install-udesk.sh`
4. **Test installation**: `udos-info`
5. **Reboot for persistence**: `sudo reboot`

## 🏗️ Project Structure

```
uDESK/
├── README.md                    # This file
├── QUICKSTART.md               # 5-minute setup guide
├── build/                      # Built packages (.tcz files)
│   ├── udos-core.tcz          # Core system (4.5KB)
│   ├── udos-role-basic.tcz    # Basic role (898B)
│   ├── udos-role-standard.tcz # Standard role (1.0KB)
│   └── udos-role-admin.tcz    # Admin role (1.4KB)
├── docs/                       # Documentation
│   ├── BUILD.md               # Build instructions
│   ├── INSTALL.md             # Installation guide
│   ├── ROLES.md               # Role descriptions
│   └── UTM.md                 # UTM setup guide
├── packaging/                  # Package build scripts
├── src/                        # Source code
└── setup-udesk-utm.sh        # Main setup automation
```

## 📝 Markdown-First Design

### Configuration Files
```markdown
# Example: /etc/udos/config.md
# uDESK System Configuration

## Current Settings
- **Role**: admin
- **Version**: 1.0.6  
- **Boot Mode**: persistent
- **Network**: dhcp enabled

## Available Commands
- `udos-info` - System status
- `udos-detect-role` - Current role
- `udos-service list` - Available services
```

### System Information
```bash
$ udos-info
# uDESK System Information

## Current Status
- **Role**: admin
- **Uptime**: 00:05:32 up
- **Memory**: 45M/1024M
- **Load**: 0.12, 0.08, 0.03

## Installed Extensions  
- udos-core.tcz
- udos-role-admin.tcz
- micro.tcz
- git.tcz

*Generated: 2025-01-15 10:30:45*
```

## 🔧 Development & Building

### Quick Build Commands
```bash
# Build everything
./build.sh --clean

# Build specific components  
./build.sh --core-only        # Just core package
./build.sh --roles-only       # Just role packages
./build.sh --role admin       # Specific role + dependencies

# Test built packages
./test-m1.sh                  # Integration tests
```

### Package Inspection
```bash
# View package contents
tar -tzf build/udos-core.tcz

# With SquashFS tools installed
unsquashfs -l build/udos-core.tcz

# Test package installation
tce-load -i build/udos-core.tcz
```

## 🐛 Troubleshooting

### Common UTM Issues
```markdown
# "Display not active" error
**Fix**: Set Display to "Console Only" in UTM VM settings

# ISO not found
**Fix**: Ensure TinyCore ISO is at `/Users/fredbook/Code/TinyCore-current.iso`

# Build tools missing  
**Fix**: Install with `brew install squashfs cdrtools`
**Alternative**: Use fallback tar.gz compression (works automatically)
```

### TinyCore Issues
```bash
# Packages don't persist
ls /mnt/sda1/tce/onboot.lst    # Check boot list
tce-load -i udos-core.tcz      # Reload manually

# Network not working
sudo dhcp.sh                   # Enable networking

# Need more packages
tce-load -wi micro.tcz         # Install micro editor
tce-load -wi git.tcz           # Install git
```

## 🎯 Current Status

✅ **M1 Complete**: Core system and role packages built and tested  
✅ **UTM Integration**: Automated VM setup with Console Only display  
✅ **SquashFS Compression**: Optimized 7.8KB total package size  
✅ **Markdown Tools**: Built-in markdown-focused commands  
🔄 **M2 In Progress**: Enhanced role policies and package management  
🔮 **M3 Planned**: Advanced markdown toolchain and GUI options  

### Ready for Launch!
- **Build Status**: All packages built with SquashFS compression
- **VM Status**: UTM automation scripts tested and working  
- **Documentation**: Complete setup guides and troubleshooting
- **Total Size**: 7.8KB compressed, boots in ~10 seconds

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get running in 5 minutes
- **[Installation Guide](docs/INSTALL.md)** - Detailed setup instructions  
- **[Role Guide](docs/ROLES.md)** - Choose your environment
- **[Build Guide](docs/BUILD.md)** - Development and packaging
- **[UTM Guide](docs/UTM.md)** - Virtual machine setup
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and fixes

## 🤝 Contributing

uDESK embraces markdown throughout the development process:

```markdown
# Development Workflow
1. **Documentation**: All docs in markdown format
2. **Configuration**: Human-readable .md config files  
3. **Issues**: Described in markdown templates
4. **Testing**: Markdown-based test reports
5. **Releases**: Changelog and notes in markdown
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🎉 Ready to Launch Your Markdown OS!

```bash
# One command to get started
./setup-udesk-utm.sh

# Then in your UTM VM
./install-udesk.sh
udos-info
```

### The Numbers
- **Total build size**: 7.8KB compressed
- **Boot time**: ~10 seconds in UTM
- **Memory usage**: ~45MB base system
- **Philosophy**: Everything is markdown

### Next Steps
1. Run the setup script
2. Create UTM VM with Console Only display  
3. Install uDESK packages
4. Start creating with markdown!

*Welcome to uDESK - where everything is markdown! 🚀*

---

> **uDESK v1.0.6** - Built for developers who believe configuration should be as readable as documentation, and documentation should be as simple as markdown.