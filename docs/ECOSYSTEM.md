# uDOS Ecosystem Documentation

## Overview
The uDOS Ecosystem provides a comprehensive plugin management system that transforms uDOS from a modular tool into an extensible platform. It supports both shell-based and Node.js-enhanced plugins, making it suitable for any environment.

## Architecture

### Dual-Mode Operation
- **Basic Mode**: Shell-based plugins, no external dependencies
- **Enhanced Mode**: JavaScript/Node.js plugins with full npm ecosystem access

### Directory Structure
```
usr/share/udos/
├── ecosystem/
│   ├── udos-ecosystem.sh     # Shell-based manager
│   ├── udos-ecosystem.js     # Node.js-enhanced manager
│   └── registry.js           # Plugin registry management
├── plugins/
│   ├── core/                 # System core plugins
│   ├── community/            # Community-contributed plugins
│   └── local/                # User-installed local plugins
```

### Configuration
```
etc/udos/
├── ecosystem.conf            # Main ecosystem configuration
├── plugins.conf              # Plugin-specific settings
└── security/
    ├── trusted-keys/         # Plugin signing keys
    └── permissions.json      # Plugin security permissions
```

## Plugin Management

### Installing Plugins
```bash
# Install a new plugin
udos ecosystem install "My Plugin"

# Install with description
udos ecosystem install "System Monitor" --description="CPU and memory monitoring"
```

### Managing Plugins
```bash
# List installed plugins
udos ecosystem list

# Get plugin information
udos ecosystem info plugin-id

# Run plugin commands
udos ecosystem run plugin-id help
udos ecosystem run plugin-id status

# Remove a plugin
udos ecosystem remove plugin-id
```

### System Maintenance
```bash
# Update ecosystem
udos ecosystem update

# Check Node.js availability
udos ecosystem install-nodejs  # TinyCore only
```

## Plugin Development

### Basic Shell Plugin Structure
```
plugin-name/
├── manifest.txt              # Plugin metadata
├── plugin.sh                 # Main plugin script
├── README.md                 # Documentation
└── config/                   # Configuration files
    └── defaults.conf
```

### Plugin Manifest Format
```
name=My Plugin
id=my-plugin
version=1.0.0
type=local
author=Plugin Developer
created=2025-09-04
description=Plugin description
main=plugin.sh
dependencies=
permissions=
```

### Basic Plugin Template
```bash
#!/bin/sh
# Plugin Template for uDOS

PLUGIN_NAME="My Plugin"
PLUGIN_VERSION="1.0.0"

show_help() {
    echo "📖 $PLUGIN_NAME Plugin Commands:"
    echo "  help     Show this help"
    echo "  status   Show plugin status"
    echo "  run      Execute main functionality"
}

main_function() {
    echo "🚀 $PLUGIN_NAME is executing..."
    # Plugin functionality here
}

# Command handling
case "${1:-help}" in
    help|--help|-h)
        show_help
        ;;
    status)
        echo "✅ $PLUGIN_NAME v$PLUGIN_VERSION is active"
        ;;
    run)
        main_function
        ;;
    *)
        echo "❌ Unknown command: $1"
        show_help
        exit 1
        ;;
esac
```

## Node.js Enhancement

### Installation on TinyCore
```bash
# Install Node.js on TinyCore Linux
./usr/bin/install-nodejs.sh install

# Check installation status
./usr/bin/install-nodejs.sh status
```

### Enhanced Features with Node.js
- Full JavaScript plugin development
- npm package integration
- Remote plugin repositories
- Real-time plugin updates
- Advanced plugin APIs

### JavaScript Plugin Template
```javascript
#!/usr/bin/env node
// JavaScript Plugin Template for uDOS

const plugin = {
    name: 'My Plugin',
    version: '1.0.0',
    
    init() {
        console.log('🔌 Plugin initialized');
    },
    
    execute(command, args) {
        switch (command) {
            case 'help':
                this.showHelp();
                break;
            case 'status':
                console.log('✅ Plugin is running');
                break;
            default:
                console.log(`❌ Unknown command: ${command}`);
                this.showHelp();
        }
    },
    
    showHelp() {
        console.log('📖 Plugin Commands:');
        console.log('  help     Show this help');
        console.log('  status   Show plugin status');
    }
};

// CLI interface
if (require.main === module) {
    const [,, command, ...args] = process.argv;
    plugin.execute(command || 'help', args);
}

module.exports = plugin;
```

## Security

### Plugin Permissions
Plugins run with limited permissions by default:
- File system access restricted to plugin directory
- Network access requires explicit permission
- System command execution requires approval

### Trusted Sources
- Core plugins: Pre-installed and verified
- Community plugins: Community-reviewed and rated
- Local plugins: User-created, full trust

## Examples

### System Monitoring Plugin
```bash
# Install system monitor
udos ecosystem install "System Monitor"

# Check system status
udos ecosystem run system-monitor status

# View system information
udos ecosystem run system-monitor info
```

### Data Backup Plugin
```bash
# Install backup plugin
udos ecosystem install "Data Backup"

# Create backup
udos ecosystem run data-backup create

# List backups
udos ecosystem run data-backup list
```

## Troubleshooting

### Common Issues

**Plugin not found**
```bash
# Check if plugin is installed
udos ecosystem list

# Reinstall if necessary
udos ecosystem remove plugin-id
udos ecosystem install "Plugin Name"
```

**Node.js features not available**
```bash
# Check Node.js status
./usr/bin/install-nodejs.sh status

# Install Node.js (TinyCore)
./usr/bin/install-nodejs.sh install
```

**Plugin execution errors**
```bash
# Check plugin information
udos ecosystem info plugin-id

# Verify plugin permissions
ls -la ~/.udos/ecosystem/installed/plugin-id/
```

## API Reference

### Command Line Interface
- `udos ecosystem help` - Show help
- `udos ecosystem install <name>` - Install plugin
- `udos ecosystem remove <id>` - Remove plugin
- `udos ecosystem list` - List plugins
- `udos ecosystem run <id> <command>` - Run plugin
- `udos ecosystem info <id>` - Plugin information
- `udos ecosystem update` - Update ecosystem

### Environment Variables
- `UDOS_HOME` - uDOS configuration directory
- `UDOS_ROOT` - uDOS installation root
- `NODE_AVAILABLE` - Node.js availability flag

## Future Enhancements

### Planned Features
- Remote plugin repositories
- Plugin dependency resolution
- Automated plugin updates
- Plugin marketplace integration
- Advanced security sandbox
- Plugin development SDK

### Community Contributions
The ecosystem is designed to support community-driven plugin development. Contributors can:
- Create and share plugins
- Submit to community repository
- Participate in plugin reviews
- Contribute to core ecosystem development

---

*uDOS Ecosystem Documentation v1.0.0 - Extensible plugin platform for TinyCore and beyond*
