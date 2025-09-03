#!/usr/bin/env node
// uDOS Ecosystem Manager - Package management and plugin system
const fs = require('fs');
const path = require('path');
const os = require('os');
const https = require('https');

const UDOS_HOME = process.env.UDOS_HOME || path.join(os.homedir(), '.udos');
const UDOS_ROOT = process.env.UDOS_ROOT || '/usr/local/udos';
const ECOSYSTEM_DIR = path.join(UDOS_ROOT, 'usr/share/udos/ecosystem');
const PLUGINS_DIR = path.join(UDOS_ROOT, 'usr/share/udos/plugins');
const CONFIG_DIR = path.join(UDOS_ROOT, 'etc/udos');

// Ensure required directories exist
const requiredDirs = [
    ECOSYSTEM_DIR,
    PLUGINS_DIR,
    path.join(PLUGINS_DIR, 'core'),
    path.join(PLUGINS_DIR, 'community'),
    path.join(PLUGINS_DIR, 'local'),
    CONFIG_DIR,
    path.join(CONFIG_DIR, 'security'),
    path.join(UDOS_HOME, 'ecosystem'),
    path.join(UDOS_HOME, 'ecosystem/cache'),
    path.join(UDOS_HOME, 'ecosystem/installed')
];

function initDirectories() {
    requiredDirs.forEach(dir => {
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
    });
}

// Plugin registry management
const registry = {
    localFile: path.join(UDOS_HOME, 'ecosystem/registry.json'),
    
    load() {
        try {
            if (fs.existsSync(this.localFile)) {
                return JSON.parse(fs.readFileSync(this.localFile, 'utf8'));
            }
        } catch (e) {
            console.log('⚠️  Warning: Could not load registry');
        }
        return { plugins: {}, updated: new Date().toISOString() };
    },
    
    save(data) {
        try {
            data.updated = new Date().toISOString();
            fs.writeFileSync(this.localFile, JSON.stringify(data, null, 2));
            return true;
        } catch (e) {
            console.log('❌ Error saving registry:', e.message);
            return false;
        }
    },
    
    add(plugin) {
        const data = this.load();
        data.plugins[plugin.id] = {
            ...plugin,
            installed: new Date().toISOString()
        };
        return this.save(data);
    },
    
    remove(pluginId) {
        const data = this.load();
        delete data.plugins[pluginId];
        return this.save(data);
    },
    
    get(pluginId) {
        const data = this.load();
        return data.plugins[pluginId] || null;
    },
    
    list() {
        const data = this.load();
        return Object.values(data.plugins);
    }
};

// Plugin management
const ecosystem = {
    install(pluginName, options = {}) {
        console.log(`🔄 Installing plugin: ${pluginName}`);
        
        // For now, create a simple plugin structure
        const pluginId = pluginName.toLowerCase().replace(/[^a-z0-9-]/g, '-');
        const pluginDir = path.join(PLUGINS_DIR, 'local', pluginId);
        
        if (fs.existsSync(pluginDir)) {
            console.log(`⚠️  Plugin '${pluginName}' already installed`);
            return false;
        }
        
        try {
            // Create plugin directory structure
            fs.mkdirSync(pluginDir, { recursive: true });
            
            // Create basic plugin manifest
            const manifest = {
                id: pluginId,
                name: pluginName,
                version: options.version || '1.0.0',
                description: options.description || `Local plugin: ${pluginName}`,
                type: 'local',
                author: options.author || 'Local User',
                created: new Date().toISOString(),
                dependencies: options.dependencies || [],
                permissions: options.permissions || [],
                main: 'index.js'
            };
            
            fs.writeFileSync(
                path.join(pluginDir, 'manifest.json'),
                JSON.stringify(manifest, null, 2)
            );
            
            // Create basic plugin entry point
            const pluginCode = `#!/usr/bin/env node
// ${pluginName} Plugin for uDOS
// Generated: ${new Date().toISOString()}

const plugin = {
    name: '${pluginName}',
    version: '${manifest.version}',
    
    init() {
        console.log('🔌 ${pluginName} plugin initialized');
    },
    
    execute(command, args) {
        switch (command) {
            case 'help':
                this.showHelp();
                break;
            case 'status':
                console.log('✅ ${pluginName} is running');
                break;
            default:
                console.log(\`❌ Unknown command: \${command}\`);
                this.showHelp();
        }
    },
    
    showHelp() {
        console.log('📖 ${pluginName} Plugin Commands:');
        console.log('  help     Show this help');
        console.log('  status   Show plugin status');
    }
};

// Command line interface
if (require.main === module) {
    const [,, command, ...args] = process.argv;
    plugin.execute(command || 'help', args);
}

module.exports = plugin;
`;
            
            fs.writeFileSync(path.join(pluginDir, 'index.js'), pluginCode);
            fs.chmodSync(path.join(pluginDir, 'index.js'), 0o755);
            
            // Register plugin
            registry.add(manifest);
            
            console.log(`✅ Plugin '${pluginName}' installed successfully`);
            console.log(`📁 Location: ${pluginDir}`);
            console.log(`🔧 Test with: udos ecosystem run ${pluginId} help`);
            
            return true;
        } catch (e) {
            console.log(`❌ Failed to install plugin '${pluginName}':`, e.message);
            return false;
        }
    },
    
    remove(pluginId) {
        console.log(`🗑  Removing plugin: ${pluginId}`);
        
        const plugin = registry.get(pluginId);
        if (!plugin) {
            console.log(`❌ Plugin '${pluginId}' not found`);
            return false;
        }
        
        const pluginDir = path.join(PLUGINS_DIR, plugin.type || 'local', pluginId);
        
        try {
            if (fs.existsSync(pluginDir)) {
                fs.rmSync(pluginDir, { recursive: true, force: true });
            }
            
            registry.remove(pluginId);
            
            console.log(`✅ Plugin '${pluginId}' removed successfully`);
            return true;
        } catch (e) {
            console.log(`❌ Failed to remove plugin '${pluginId}':`, e.message);
            return false;
        }
    },
    
    list() {
        const plugins = registry.list();
        
        if (plugins.length === 0) {
            console.log('📦 No plugins installed');
            console.log('💡 Install a plugin with: udos ecosystem install <name>');
            return;
        }
        
        console.log('📦 Installed Plugins:');
        console.log('');
        
        plugins.forEach(plugin => {
            const status = this.getPluginStatus(plugin.id);
            const statusIcon = status.working ? '✅' : '❌';
            
            console.log(`  ${statusIcon} ${plugin.name} (${plugin.id})`);
            console.log(`      Version: ${plugin.version}`);
            console.log(`      Type: ${plugin.type || 'unknown'}`);
            console.log(`      Description: ${plugin.description || 'No description'}`);
            if (plugin.dependencies && plugin.dependencies.length > 0) {
                console.log(`      Dependencies: ${plugin.dependencies.join(', ')}`);
            }
            console.log('');
        });
    },
    
    run(pluginId, command = 'help', args = []) {
        const plugin = registry.get(pluginId);
        if (!plugin) {
            console.log(`❌ Plugin '${pluginId}' not found`);
            console.log('💡 List plugins with: udos ecosystem list');
            return false;
        }
        
        const pluginDir = path.join(PLUGINS_DIR, plugin.type || 'local', pluginId);
        const pluginScript = path.join(pluginDir, plugin.main || 'index.js');
        
        if (!fs.existsSync(pluginScript)) {
            console.log(`❌ Plugin script not found: ${pluginScript}`);
            return false;
        }
        
        try {
            console.log(`🚀 Running plugin: ${plugin.name}`);
            require('child_process').execSync(
                `node "${pluginScript}" ${command} ${args.join(' ')}`,
                { stdio: 'inherit' }
            );
            return true;
        } catch (e) {
            console.log(`❌ Plugin execution failed:`, e.message);
            return false;
        }
    },
    
    info(pluginId) {
        const plugin = registry.get(pluginId);
        if (!plugin) {
            console.log(`❌ Plugin '${pluginId}' not found`);
            return false;
        }
        
        console.log(`📦 Plugin Information: ${plugin.name}`);
        console.log('');
        console.log(`ID: ${plugin.id}`);
        console.log(`Version: ${plugin.version}`);
        console.log(`Type: ${plugin.type || 'unknown'}`);
        console.log(`Author: ${plugin.author || 'Unknown'}`);
        console.log(`Description: ${plugin.description || 'No description'}`);
        console.log(`Installed: ${plugin.installed || 'Unknown'}`);
        
        if (plugin.dependencies && plugin.dependencies.length > 0) {
            console.log(`Dependencies: ${plugin.dependencies.join(', ')}`);
        }
        
        if (plugin.permissions && plugin.permissions.length > 0) {
            console.log(`Permissions: ${plugin.permissions.join(', ')}`);
        }
        
        const status = this.getPluginStatus(plugin.id);
        console.log(`Status: ${status.working ? '✅ Working' : '❌ Not working'}`);
        
        return true;
    },
    
    getPluginStatus(pluginId) {
        const plugin = registry.get(pluginId);
        if (!plugin) return { working: false, reason: 'Not found' };
        
        const pluginDir = path.join(PLUGINS_DIR, plugin.type || 'local', pluginId);
        const pluginScript = path.join(pluginDir, plugin.main || 'index.js');
        
        if (!fs.existsSync(pluginDir)) {
            return { working: false, reason: 'Directory missing' };
        }
        
        if (!fs.existsSync(pluginScript)) {
            return { working: false, reason: 'Script missing' };
        }
        
        return { working: true, reason: 'OK' };
    },
    
    update() {
        console.log('🔄 Updating ecosystem...');
        console.log('💡 Remote registry support coming soon');
        
        // For now, just validate local plugins
        const plugins = registry.list();
        let updated = 0;
        
        plugins.forEach(plugin => {
            const status = this.getPluginStatus(plugin.id);
            if (status.working) {
                updated++;
            } else {
                console.log(`⚠️  Plugin '${plugin.id}' has issues: ${status.reason}`);
            }
        });
        
        console.log(`✅ Ecosystem update complete - ${updated}/${plugins.length} plugins working`);
    }
};

// Command line interface
const [,, command, ...args] = process.argv;

// Initialize directories
initDirectories();

if (command === '--help' || command === 'help') {
    console.log('🌐 uDOS Ecosystem Manager');
    console.log('');
    console.log('Commands:');
    console.log('  install <name>          Install a plugin');
    console.log('  remove <id>             Remove a plugin');
    console.log('  list                    List installed plugins');
    console.log('  run <id> [command]      Run a plugin command');
    console.log('  info <id>               Show plugin information');
    console.log('  update                  Update ecosystem');
    console.log('');
    console.log('Examples:');
    console.log('  udos ecosystem install my-plugin');
    console.log('  udos ecosystem list');
    console.log('  udos ecosystem run my-plugin status');
    console.log('  udos ecosystem info my-plugin');
} else if (ecosystem[command]) {
    ecosystem[command](...args);
} else {
    console.log('❌ Unknown command:', command);
    console.log('💡 Use: udos ecosystem help');
}
