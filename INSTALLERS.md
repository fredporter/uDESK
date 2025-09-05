# uDESK v1.0.7.2 Installers

Cross-platform installers for uDESK with repository management and self-healing capabilities.

## Quick Install

Choose your platform and download the appropriate installer:

### 🍎 **macOS**
```bash
# Download and run
curl -L https://github.com/fredporter/uDESK/raw/main/udesk-install.command -o ~/Desktop/udesk-install.command
chmod +x ~/Desktop/udesk-install.command
# Double-click from Desktop to install
```

### 🐧 **Ubuntu/Linux**
```bash
# Download and run
curl -L https://github.com/fredporter/uDESK/raw/main/udesk-install-ubuntu.sh -o ~/Desktop/udesk-install.sh
chmod +x ~/Desktop/udesk-install.sh
./udesk-install.sh
```

### 🪟 **Windows**
```powershell
# Download and run (in PowerShell/CMD)
curl -L https://github.com/fredporter/uDESK/raw/main/udesk-install-windows.bat -o %USERPROFILE%\Desktop\udesk-install.bat
# Double-click from Desktop to install
```

## What These Installers Do

All installers follow the same bootstrap pattern:

1. **Check Prerequisites** - Install git, curl, build tools
2. **Create Directory Structure**:
   ```
   ~/uDESK/
   ├── repo/           # Git-managed core system
   ├── iso/current/    # TinyCore ISO downloads
   └── iso/archive/    # Previous ISO versions
   
   ~/uMEMORY/
   ├── repo/           # Templates repository
   ├── .local/logs/    # Application logs (XDG)
   ├── .local/backups/ # User backups (XDG)
   ├── .local/state/   # Session data (XDG)
   └── sandbox/        # User workspace
   ```
3. **Download Core System** - Clone from GitHub
4. **Download TinyCore ISO** - With mirror fallback
5. **Run Health Check** - Self-healing system validation
6. **Install Legacy Components** - Backward compatibility

## Platform-Specific Features

### macOS (`udesk-install.command`)
- ✅ Double-click installation from Finder
- ✅ Xcode Command Line Tools auto-install
- ✅ Homebrew integration for dependencies

### Ubuntu/Linux (`udesk-install-ubuntu.sh`)
- ✅ Multi-distro package manager support (apt, yum, pacman, dnf)
- ✅ Build tools installation
- ✅ XDG Base Directory compliance

### Windows (`udesk-install-windows.bat`)
- ✅ Windows 10+ compatibility
- ✅ WSL integration for full functionality
- ✅ Windows-native fallback mode

## Advanced Features

### Self-Healing System
All installers include comprehensive health checks that:
- Validate directory structure
- Check for missing essential files
- Auto-repair via git operations
- Download missing resources
- Fix file permissions

### Repository Management
- Separates core system (`~/uDESK/repo/`) from user data (`~/uMEMORY/`)
- Supports updates via `git pull`
- Maintains user customizations
- Archives old versions

### TinyCore Integration
- Downloads latest TinyCore Linux ISO
- Multiple mirror fallback system
- Checksum verification
- Archive management

## Customization

### Distribution
These installers are designed for easy distribution:
- Single-file download and execute
- No pre-installation required
- Auto-configuring for each platform
- User-friendly error messages

## Troubleshooting

### Common Issues
1. **Git not found** - Installers will auto-install on most platforms
2. **Permission denied** - Run `chmod +x` on downloaded scripts
3. **Network issues** - TinyCore downloader has multiple mirrors
4. **Build failures** - Health check system will attempt repairs

### Manual Installation
If automatic installation fails:
```bash
git clone https://github.com/fredporter/uDESK.git ~/uDESK/repo
cd ~/uDESK/repo
bash install.sh
```

## Support

- 📚 [Full Documentation](README.md)
- 🐛 [Report Issues](https://github.com/fredporter/uDESK/issues)
- 💬 [Discussions](https://github.com/fredporter/uDESK/discussions)
