# Quick Start Guide

Get uDESK running in 5 minutes! Choose your platform and follow the installation steps.

## 🚀 Platform Installation

### macOS 🍎
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Run macOS installer
./udesk-install.command
```

### Linux 🐧
```bash
# Clone repository  
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Run Linux installer
./udesk-install-linux.sh
```

### Windows 🪟
```bash
# Clone repository
git clone https://github.com/fredporter/uDESK.git
cd uDESK

# Run Windows installer
./udesk-install-windows.bat
```

## 🎯 First Steps

### 1. Launch the CHEST Desktop
After installation, launch the Tauri application:

```bash
cd app
npm install
npm run tauri:dev
```

### 2. Explore the PANEL System
The uDESK interface consists of four main panels:

- **📝 TodoPanel**: View and manage workflow TODOs
- **📊 ProgressPanel**: Track milestone and goal progress  
- **⚙️ WorkflowPanel**: Execute scripts and VSCode commands
- **🖥️ SystemPanel**: Monitor system and development environment

### 3. Try VSCode Integration
1. **Launch VSCode terminal** from WorkflowPanel
2. **Sync TODO Tree** from TodoPanel
3. **Execute workflow scripts** from any panel
4. **Monitor progress** in ProgressPanel

### 4. Basic Commands
Test the core system with these commands:

```bash
# Test uCODE input system
echo "[INFO]" | ./build/user/udos

# Check system status (if installed)
udos help

# Run development mode
./build.sh dev
```

## 🎛️ Interface Overview

### PANEL Layout
```
┌─────────────┬─────────────┐
│ TodoPanel   │ ProgressPanel│
│ 📝 Tasks    │ 📊 Progress │
├─────────────┼─────────────┤
│WorkflowPanel│ SystemPanel │
│ ⚙️ Scripts  │ 🖥️ System   │
└─────────────┴─────────────┘
```

### Key Features
- **Real-time updates** from workflow files
- **VSCode integration** with TODO Tree sync
- **Script execution** through panel interfaces
- **Progress tracking** with visual indicators
- **System monitoring** and health checks

## 🚀 Next Steps

### For Users
1. [Learn the PANEL System](PANEL-System) - Understand the interface
2. [Explore VSCode Integration](VSCode-Integration) - Development workflow
3. [Read Architecture Guide](Architecture) - System concepts

### For Developers  
1. [Development Setup](Development-Setup) - Contributor environment
2. [Contributing Guide](Contributing) - How to help the project
3. [Build System](Build-System) - Compilation process

### For Advanced Users
1. [uDOS Grid System](uDOS-Grid-System) - 16×16 pixel architecture
2. [Core Scripts](Core-Scripts) - Shell script automation
3. [API Reference](API-Reference) - Technical documentation

## 🆘 Getting Help

### Common Issues
- **Build failures**: Check build dependencies for your platform
- **Tauri errors**: Ensure Rust and Node.js are properly installed
- **VSCode integration**: Verify TODO Tree extension is installed
- **Script execution**: Check file permissions and PATH variables

### Support Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Community questions and ideas
- **Wiki**: Comprehensive documentation and guides
- **Code Examples**: See repository for working implementations

### Verification Commands
```bash
# Test installation
./build.sh user && echo "[TEST]" | ./build/user/udos

# Check Tauri setup
cd app && npm run tauri info

# Verify VSCode integration
code --version && echo "VSCode integration ready"
```

[Continue to Architecture Overview →](Architecture) | [Back to Home →](Home)
