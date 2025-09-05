# uDESK Desktop Application

> Modern Tauri-based desktop interface for uDESK v1.0.7

## 🚀 Overview

The uDESK Desktop Application provides a modern, native desktop interface for the uDESK system using Tauri (Rust + React + TypeScript). It offers a user-friendly GUI alternative to the command-line interface while maintaining full access to uCODE commands and system features.

## 🏗️ Technology Stack

- **Frontend**: React 18 + TypeScript + Vite
- **Backend**: Rust (Tauri)
- **UI Framework**: Modern React components
- **Build System**: Tauri CLI with cross-platform support
- **Integration**: Native uDESK system commands via Tauri IPC

## ⚡ Quick Start

### Development Mode
```bash
# Navigate to app directory
cd app/udesk-app

# Install dependencies
npm install

# Start development server
npm run tauri dev
```

### Production Build
```bash
# Build for current platform
npm run tauri build

# Output locations:
# macOS: target/release/bundle/macos/
# Ubuntu: target/release/bundle/deb/
# Windows: target/release/bundle/msi/
```

## 🛠️ Development Setup

### Prerequisites
- **Node.js** 18+ and npm (auto-installed by platform launchers)
- **Rust** 1.70+ (auto-installed by Tauri)
- **Platform tools**:
  - macOS: Xcode Command Line Tools
  - Ubuntu: build-essential, webkit2gtk
  - Windows: MSVC Build Tools

### IDE Setup (Recommended)
- **VS Code** with extensions:
  - [Tauri](https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode)
  - [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)
  - [ES7+ React/Redux/React-Native snippets](https://marketplace.visualstudio.com/items?itemName=dsznajder.es7-react-js-snippets)

### Project Structure
```
app/udesk-app/
├── src/                    # React frontend
│   ├── components/         # React components
│   ├── pages/              # Page components
│   ├── hooks/              # Custom React hooks
│   ├── utils/              # Utility functions
│   ├── types/              # TypeScript type definitions
│   └── App.tsx             # Main React component
├── tauri/                  # Rust backend
│   ├── src/                # Rust source code
│   ├── icons/              # Application icons
│   ├── Cargo.toml          # Rust dependencies
│   └── tauri.conf.json     # Tauri configuration
├── public/                 # Static assets
├── package.json            # Node.js dependencies
└── vite.config.ts          # Vite configuration
```

## 🎯 Features

### Core Features
- **Native Desktop Experience**: Platform-native window management and UI
- **uCODE Integration**: Direct access to all uDESK commands
- **System Monitoring**: Real-time system status and performance
- **Extension Manager**: GUI for managing uDESK extensions
- **Theme Support**: Light/dark themes with system preference detection
- **Cross-Platform**: Native builds for macOS, Ubuntu, and Windows

### Advanced Features
- **Command Palette**: Quick access to uCODE commands via keyboard shortcuts
- **File System Browser**: Integrated file management with uDESK context
- **Terminal Integration**: Embedded terminal for direct command execution
- **Settings Management**: GUI for uDESK configuration and preferences
- **Update System**: Built-in update notifications and management

## 🔧 Development

### Available Scripts
```bash
# Development
npm run tauri dev           # Start dev server with hot reload
npm run dev                 # Start Vite dev server only

# Building
npm run tauri build         # Build production app for current platform
npm run build               # Build frontend only

# Testing
npm run test                # Run React tests
npm run tauri test          # Run Tauri integration tests

# Linting & Formatting
npm run lint                # Run ESLint
npm run format              # Run Prettier
```

### Configuration

#### Tauri Configuration (`tauri/tauri.conf.json`)
```json
{
  "build": {
    "beforeDevCommand": "npm run dev",
    "beforeBuildCommand": "npm run build",
    "devPath": "http://localhost:1420",
    "distDir": "../dist"
  },
  "package": {
    "productName": "uDESK",
    "version": "1.0.7"
  },
  "tauri": {
    "allowlist": {
      "all": false,
      "shell": {
        "all": false,
        "execute": true,
        "sidecar": true,
        "open": true
      },
      "dialog": {
        "all": false,
        "ask": true,
        "confirm": true,
        "message": true,
        "open": true,
        "save": true
      }
    }
  }
}
```

#### Vite Configuration (`vite.config.ts`)
```typescript
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig(async () => ({
  plugins: [react()],
  clearScreen: false,
  server: {
    port: 1420,
    strictPort: true,
  },
  envPrefix: ["VITE_", "TAURI_"],
  build: {
    target: process.env.TAURI_PLATFORM == "windows" ? "chrome105" : "safari13",
    minify: !process.env.TAURI_DEBUG ? "esbuild" : false,
    sourcemap: !!process.env.TAURI_DEBUG,
  },
}));
```

## 🔌 uDESK Integration

### Command Execution
```typescript
import { invoke } from "@tauri-apps/api/tauri";

// Execute uCODE command
const result = await invoke("execute_ucode", { 
  command: "[STATUS]" 
});

// Execute system command  
const output = await invoke("execute_shell", { 
  command: "./build.sh user" 
});
```

### System Events
```typescript
import { listen } from "@tauri-apps/api/event";

// Listen for system status updates
const unlisten = await listen("system-status", (event) => {
  console.log("System status:", event.payload);
});

// Listen for build events
const unlisten = await listen("build-progress", (event) => {
  console.log("Build progress:", event.payload);
});
```

### File System Access
```typescript
import { readTextFile, writeTextFile } from "@tauri-apps/api/fs";
import { open } from "@tauri-apps/api/dialog";

// Read configuration file
const config = await readTextFile("core/config/system.conf");

// Save user preferences
await writeTextFile("usr/config/preferences.json", JSON.stringify(prefs));

// Open file dialog
const selected = await open({
  directory: true,
  multiple: false,
  defaultPath: "usr/",
});
```

## 🎨 UI Components

### Core Components
- **CommandPalette**: Quick access to uCODE commands
- **SystemStatus**: Real-time system monitoring dashboard
- **ExtensionManager**: GUI for extension management
- **SettingsPanel**: Configuration and preferences interface
- **TerminalEmulator**: Integrated terminal for command execution
- **FileExplorer**: File system navigation and management

### Design System
- **Colors**: Follows uDESK theme system (light/dark/retro)
- **Typography**: Modern, readable font stack
- **Icons**: Tauri-compatible icon set with platform-specific variants
- **Layout**: Responsive design with sidebar navigation
- **Accessibility**: WCAG 2.1 AA compliance

## 🐛 Troubleshooting

### Common Issues

**Tauri dev server won't start**
```bash
# Solution: Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run tauri dev
```

**Rust compilation errors**
```bash
# Solution: Update Rust toolchain
rustup update
cargo clean
npm run tauri dev
```

**Missing platform dependencies**
```bash
# macOS: Install Xcode tools
xcode-select --install

# Ubuntu: Install webkit
sudo apt install webkit2gtk-4.0-dev

# Windows: Install MSVC Build Tools
# Download from Microsoft Visual Studio website
```

**Permission errors on build**
```bash
# Solution: Make scripts executable
chmod +x ../../build.sh
chmod +x ../../Launch-uDOS-*.{command,sh}
```

### Debug Mode
```bash
# Enable Tauri debug mode
export TAURI_DEBUG=1
npm run tauri dev

# View browser dev tools
# macOS: Cmd+Option+I
# Ubuntu/Windows: Ctrl+Shift+I
```

## 📚 Documentation Links

- **[Tauri Documentation](https://tauri.app/v1/guides/)** - Official Tauri guides
- **[React Documentation](https://react.dev/)** - React development guides  
- **[Vite Documentation](https://vitejs.dev/)** - Vite build tool docs
- **[uDESK Architecture](../../core/docs/ARCHITECTURE.md)** - System architecture
- **[uCODE Manual](../../core/docs/UCODE-MANUAL.md)** - Command reference

---

## 🎉 Next Steps

1. **Start Development**: `npm run tauri dev`
2. **Explore Components**: Check `src/components/` for UI elements
3. **Add Features**: Integrate with uDESK system commands
4. **Test Builds**: `npm run tauri build` for production
5. **Deploy**: Share built applications with users

*uDESK Desktop Application v1.0.7 - Modern UI for Universal Development Environment*
