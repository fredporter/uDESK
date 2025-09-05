# uDESK Desktop App Guide

## 🎨 How to Open the Tauri Desktop App

After installing uDESK, you have several ways to access the modern desktop interface:

### 🚀 Quick Launch (Development Mode)
```bash
cd ~/uDESK
./launch-tauri.sh
```
- Opens immediately in development mode
- Perfect for daily use and testing
- No dock icon, but full functionality

### 🏗️ Production Build (With Dock Icon)
```bash
cd ~/uDESK
./launch-tauri.sh --build
```
- Creates a proper macOS .app bundle
- Adds icon to dock/Applications
- Takes a few minutes to build first time
- Production-ready with native performance

### ⚡ Quick Command
```bash
cd ~/uDESK
./udesk-app
```
- Simple launcher wrapper
- Same as `./launch-tauri.sh`

### 🔧 Manual Launch
```bash
cd ~/uDESK/app
npm run tauri:dev
```
- Direct npm command
- Useful for debugging

## 📱 What You Get

### Development Mode
- ✅ Full desktop interface
- ✅ React-based modern UI
- ✅ All uDOS functionality
- ❌ No dock icon
- ❌ Temporary window

### Production Build
- ✅ Full desktop interface  
- ✅ Native macOS .app bundle
- ✅ Dock icon and proper integration
- ✅ Persistent installation
- ✅ Can be added to Applications folder

## 🛠️ Troubleshooting

### "npm not found"
Install Node.js from: https://nodejs.org/

### "Tauri build failed"
1. Make sure Xcode Command Line Tools are installed:
   ```bash
   xcode-select --install
   ```
2. Install Rust if needed:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

### "App won't open"
Try development mode first:
```bash
cd ~/uDESK && ./launch-tauri.sh
```

## 🎯 Recommended Workflow

1. **First time**: Use `./launch-tauri.sh` to test quickly
2. **Daily use**: Build production app with `./launch-tauri.sh --build`
3. **Development**: Use manual npm commands for debugging

The production build creates a proper macOS application that integrates with your system like any other app!
