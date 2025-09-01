# uDOS User Roles → Linux Users Mapping

## Philosophy
Real Linux users with uDOS capabilities layered on top via groups and sudo rules, following the established 8-role hierarchy from uDOS architecture.

## Role Hierarchy (Level 10-100)

### GHOST (Level 10, UID 1000-1099)
- **Linux**: Basic user, no sudo
- **uDOS**: Demo installation, read-only access
- **Features**: `udos var get`, `udos data view`, basic help
- **Access**: CLI Terminal Mode only

### TOMB (Level 20, UID 1100-1199) 
- **Linux**: Basic user + `udos-tomb` group
- **uDOS**: Archive access, data archaeology
- **Features**: `udos var set`, `udos data save`, basic storage
- **Access**: CLI Terminal Mode only

### CRYPT (Level 30, UID 1200-1299)
- **Linux**: Basic user + `udos-crypt` group  
- **uDOS**: Encryption, security protocols, standard operations
- **Features**: `udos tpl create`, secure storage, desktop access
- **Access**: CLI + Desktop/Web Display

### DRONE (Level 40, UID 1300-1399)
- **Linux**: Basic user + `udos-drone` group
- **uDOS**: Automation, maintenance tasks
- **Features**: Session management, workflow automation, extension installation
- **Access**: CLI + Desktop/Web Display

### KNIGHT (Level 50, UID 1400-1499)
- **Linux**: Basic user + `udos-knight` group
- **uDOS**: Security functions, enhanced operations
- **Features**: Advanced templates, collaboration, security tools
- **Access**: CLI + Desktop/Web Display

### IMP (Level 60, UID 1500-1599)
- **Linux**: Limited sudo for development
- **uDOS**: Development tools, script automation
- **Features**: User script development, extension creation
- **Access**: CLI + Desktop/Web + Sandbox development

### SORCERER (Level 80, UID 1600-1699)
- **Linux**: Full sudo for system administration
- **uDOS**: Advanced administration, platform management
- **Features**: System config, user management, debugging
- **Access**: CLI + Desktop/Web + System administration

### WIZARD (Level 100, UID 1700-1799)
- **Linux**: Full sudo + `udos-wizard` group
- **uDOS**: Full system access + Core development (/dev)
- **Features**: `udos dev-mode`, uSCRIPT containers, core development
- **Access**: All modes + /dev folder + DEV mode activation

## Implementation

Each role maps to:
1. **Linux user** with specific UID range
2. **Group membership** for uDOS capabilities  
3. **Sudo rules** for system access
4. **uDOS permissions** via CLI tool restrictions

## Security Model

- **Principle of least privilege**: Each role has minimal required access
- **Progressive capabilities**: Higher roles inherit lower role abilities
- **Explicit dev mode**: Development tools only available when explicitly activated
- **Real Linux users**: No custom authentication, uses standard Linux security
