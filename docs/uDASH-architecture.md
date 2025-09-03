# uDASH: Cross-Platform uDOS Interface

## Vision
Single interface that adapts to deployment context:
- **VM/Local**: Full desktop integration
- **macOS**: Native app via Electron/Tauri
- **Web**: Browser-based dashboard
- **Mobile**: Touch-optimized grid

## Architecture

### Core Components
1. **uDASH Engine** (Rust/WASM)
   - Grid layout system (16×16)
   - State management (uVAR/uDATA)
   - Template rendering (uTEMPLATE)

2. **Platform Adapters**
   - **Desktop**: Tauri native app
   - **Web**: WASM + Canvas/WebGL
   - **TinyCore**: Openbox + rofi integration

3. **Communication Layer**
   - **Local**: Direct filesystem access
   - **Remote**: REST API + WebSocket
   - **VM**: SSH tunnel + file sync

## Grid Discipline
```
┌─────────────────┐
│ 🟦🟦🟦🟦🟦🟦🟦🟦 │  16×16 grid
│ 🟦🟨🟨🟨🟨🟨🟨🟦 │  8-color palette
│ 🟦🟨📄📄📄📄🟨🟦 │  32px panels
│ 🟦🟨📄📊📊📄🟨🟦 │  64px tiles
│ 🟦🟨📄📊📊📄🟨🟦 │  Consistent spacing
│ 🟦🟨📄📄📄📄🟨🟦 │  Touch-friendly
│ 🟦🟨🟨🟨🟨🟨🟨🟦 │  Click-first UI
│ 🟦🟦🟦🟦🟦🟦🟦🟦 │
└─────────────────┘
```

## Deployment Modes

### Mode 1: TinyCore Desktop
- Openbox window manager
- tint2 panel + rofi grid
- Direct CLI integration

### Mode 2: macOS Native App
- Tauri-based native application
- SSH connection to uDOS VM
- File sync for offline work

### Mode 3: Web Dashboard
- Browser-based interface
- REST API backend
- WebSocket for real-time updates

## Implementation Plan
1. **Prototype**: Web-based grid in TypeScript
2. **Core**: Rust engine with WASM compilation
3. **Desktop**: Tauri wrapper for native apps
4. **Integration**: TinyCore Openbox themes

## Role-Based UI

Each uDOS role sees different interface elements:
- **Ghost**: Read-only dashboard
- **Tomb**: Basic editing tools
- **Imp**: Full desktop interface
- **Sorceror**: System management panels
- **Wizard**: Development environment (explicit mode)
