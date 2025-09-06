# Development Setup Guide

Complete guide for setting up a uDESK development environment and contributing to the project.

## 🛠️ Prerequisites

### Required Tools
- **Git**: Version control system
- **Node.js**: v18+ for Tauri application
- **Rust**: Latest stable for Tauri backend
- **VSCode**: Recommended editor with extensions
- **Platform tools**: Xcode (macOS), build-essential (Linux), MinGW (Windows)

### VSCode Extensions
Install these extensions for optimal development experience:
- **TODO Tree**: TODO comment management
- **Rust Analyzer**: Rust language support
- **Tauri**: Tauri development tools
- **GitLens**: Enhanced Git integration
- **Terminal**: Integrated terminal features

## 🚀 Environment Setup

### 1. Clone Repository
```bash
git clone https://github.com/fredporter/uDESK.git
cd uDESK
```

### 2. Install Dependencies
```bash
# Install Rust (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Install Node.js dependencies
cd app
npm install

# Install Tauri CLI
cargo install tauri-cli
```

### 3. Platform-Specific Setup

#### macOS Development
```bash
# Install Xcode command line tools
xcode-select --install

# Verify installation
clang --version
```

#### Linux Development
```bash
# Install build dependencies
sudo apt update
sudo apt install build-essential libwebkit2gtk-4.0-dev libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev

# Verify installation
gcc --version
```

#### Windows Development
```bash
# Install via WSL2 or use MinGW/MSYS2
# Follow Windows-specific guide in INSTALLERS.md
```

## 🏗️ Build System

### Development Builds
```bash
# User mode (most common)
./build.sh user

# Wizard role (with extension development)
./build.sh wizard  

# Development mode (core system access)
./build.sh dev

# TinyCore ISO generation
./build.sh iso
```

### Tauri Application
```bash
cd app

# Development mode with hot reload
npm run tauri:dev

# Production build
npm run tauri:build

# Check Tauri info
npm run tauri info
```

### Testing
```bash
# Test core uCODE system
echo "[INFO]" | ./build/user/udos

# Test workflow scripts
./core/todo-management.sh

# Test PANEL system
cd app && npm test
```

## 🎛️ Development Workflow

### 1. Core System Development
Located in `/core/` directory:
- **Shell scripts**: Workflow automation and system management
- **uCODE system**: Smart input parsing and command handling
- **Integration scripts**: VSCode and external tool connections

### 2. PANEL System Development  
Located in `/app/src/` directory:
- **React components**: Panel interfaces and UI elements
- **Services**: VSCode integration and workflow data processing
- **Tauri backend**: Rust-based desktop application framework

### 3. Documentation
Located in `/docs/` and wiki:
- **Architecture guides**: System design and concepts
- **API documentation**: Technical reference materials  
- **User guides**: Installation and usage instructions

## 🔧 Development Tools

### Core Scripts
```bash
# Workflow management
./core/todo-management.sh
./core/workflow-hierarchy.sh  
./core/progress-visualization.sh

# System utilities
./core/auto-assist.sh
./core/installation-lifespan.sh
./core/unified-workflow.sh
```

### Panel Development
```bash
# Component development
cd app/src/components/panels/

# Service development  
cd app/src/services/

# Tauri backend
cd app/tauri/src/
```

### Testing Commands
```bash
# Unit tests
npm test

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e

# Tauri tests
cargo test
```

## 🎯 Contribution Guidelines

### Code Standards
- **TypeScript**: Use strict typing throughout
- **React**: Functional components with hooks
- **Rust**: Follow Clippy recommendations
- **Shell**: POSIX-compliant scripts with error handling
- **Documentation**: Comprehensive inline comments

### Git Workflow
```bash
# Create feature branch
git checkout -b feature/new-panel-feature

# Make commits with descriptive messages
git commit -m "✨ Add real-time progress tracking to ProgressPanel"

# Push and create pull request
git push origin feature/new-panel-feature
```

### Testing Requirements
- **Unit tests** for all new functions
- **Integration tests** for panel interactions
- **Manual testing** with all build modes
- **Documentation updates** for new features

### Code Review Process
1. **Self-review**: Check your own code thoroughly
2. **Automated tests**: Ensure all tests pass
3. **Pull request**: Create with detailed description
4. **Peer review**: Address feedback constructively
5. **Merge**: Squash commits for clean history

## 📋 Development Checklist

### Before Starting
- [ ] Repository cloned and up to date
- [ ] Dependencies installed (Node.js, Rust, platform tools)
- [ ] VSCode configured with required extensions
- [ ] Build system verified with test commands

### During Development
- [ ] Feature branch created from latest main
- [ ] Code follows project standards and conventions
- [ ] Unit tests written for new functionality
- [ ] Integration tests verify panel interactions
- [ ] Documentation updated for new features

### Before Submitting
- [ ] All tests pass locally
- [ ] Code reviewed and optimized
- [ ] Commit messages are descriptive
- [ ] Pull request description is comprehensive
- [ ] Ready for peer review

## 🐛 Debugging

### Common Issues
- **Tauri build failures**: Check Rust installation and dependencies
- **VSCode integration errors**: Verify extension installation and configuration
- **Panel rendering issues**: Check React DevTools and console errors
- **Script execution failures**: Verify file permissions and PATH variables

### Debug Tools
```bash
# Tauri debug mode
npm run tauri:dev -- --debug

# React DevTools
# Install browser extension for component inspection

# Rust debugging
cargo run --bin tauri-app -- --debug

# Script debugging
bash -x ./core/script-name.sh
```

### Logging
- **Browser console**: Frontend debugging and React component state
- **Tauri logs**: Backend operations and system integration
- **Shell script logs**: Core system operations and automation
- **VSCode output**: Extension integration and command execution

[Continue to Contributing Guide →](Contributing) | [Back to Quick Start →](Quick-Start)
