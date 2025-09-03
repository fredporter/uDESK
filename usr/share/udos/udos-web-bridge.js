/**
 * uDOS Web-Command Bridge
 * Connects web interface to live udos command system
 * M2 Interface Development - Core Integration
 */

class uDOSWebBridge {
    constructor() {
        this.commandQueue = [];
        this.isProcessing = false;
        this.systemState = {
            role: 'GHOST',
            version: 'unknown',
            modules: {},
            lastUpdate: null
        };
        this.eventHandlers = new Map();
        this.init();
    }

    async init() {
        console.log('🚀 uDOS Web Bridge initializing...');
        await this.detectSystem();
        await this.loadInitialState();
        this.startPolling();
    }

    // System Detection
    async detectSystem() {
        try {
            // Try direct udos command first
            const result = await this.executeCommand('udos version');
            if (result.success) {
                this.systemState.available = true;
                console.log('✅ uDOS system detected');
                return;
            }
        } catch (e) {
            console.log('📡 uDOS not available locally, checking alternatives...');
        }

        // Check for TinyCore environment
        if (this.isTinyCore()) {
            this.systemState.environment = 'tinycore';
            console.log('🐧 TinyCore environment detected');
        }

        // Check for development environment
        if (this.isDevelopment()) {
            this.systemState.environment = 'development';
            this.systemState.mockMode = true;
            console.log('🔧 Development mode enabled');
        }
    }

    // Command Execution
    async executeCommand(command) {
        if (this.systemState.mockMode) {
            return this.mockCommand(command);
        }

        try {
            // For browser environment, need backend API
            if (typeof window !== 'undefined') {
                return await this.executeViaAPI(command);
            }

            // For Node.js/local environment
            const { exec } = require('child_process');
            return new Promise((resolve, reject) => {
                exec(command, { timeout: 10000 }, (error, stdout, stderr) => {
                    if (error) {
                        resolve({ success: false, error: error.message, stderr });
                    } else {
                        resolve({ success: true, stdout, stderr });
                    }
                });
            });
        } catch (error) {
            return { success: false, error: error.message };
        }
    }

    async executeViaAPI(command) {
        try {
            const response = await fetch('/api/udos/execute', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ command })
            });
            return await response.json();
        } catch (error) {
            console.warn('API not available, using mock mode');
            this.systemState.mockMode = true;
            return this.mockCommand(command);
        }
    }

    // Mock Commands for Development
    mockCommand(command) {
        const responses = {
            'udos version': {
                success: true,
                stdout: 'uDOS v1.0.5 (M1 Complete)\nRole: GHOST (10)\nModules: 5 active\nTinyCore Ready'
            },
            'udos role': {
                success: true,
                stdout: 'Current Role: GHOST (10)\nCapabilities: Basic viewing, Read-only access\nNext Role: TOMB (20)'
            },
            'udos status': {
                success: true,
                stdout: 'System Status: Online\nUptime: 2h 34m\nMemory Usage: 45%\nStorage: 67%'
            },
            'udos modules': {
                success: true,
                stdout: 'uCORE: Active\nuMEMORY: Active\nuKNOWLEDGE: Active\nuNETWORK: Active\nuSCRIPT: Active'
            }
        };

        return responses[command] || {
            success: false,
            error: `Unknown command: ${command}`
        };
    }

    // State Management
    async loadInitialState() {
        console.log('📊 Loading initial system state...');
        
        try {
            // Get version and role
            const versionResult = await this.executeCommand('udos version');
            if (versionResult.success) {
                this.parseVersionInfo(versionResult.stdout);
            }

            // Get role information
            const roleResult = await this.executeCommand('udos role');
            if (roleResult.success) {
                this.parseRoleInfo(roleResult.stdout);
            }

            // Get module status
            const moduleResult = await this.executeCommand('udos modules');
            if (moduleResult.success) {
                this.parseModuleInfo(moduleResult.stdout);
            }

            this.systemState.lastUpdate = Date.now();
            this.notifyStateChange();

        } catch (error) {
            console.error('Failed to load initial state:', error);
        }
    }

    parseVersionInfo(output) {
        const lines = output.split('\n');
        lines.forEach(line => {
            if (line.includes('uDOS v')) {
                this.systemState.version = line.split(' ')[1];
            }
            if (line.includes('Role:')) {
                const match = line.match(/Role:\s*(\w+)\s*\((\d+)\)/);
                if (match) {
                    this.systemState.role = match[1];
                    this.systemState.roleLevel = parseInt(match[2]);
                }
            }
        });
    }

    parseRoleInfo(output) {
        const lines = output.split('\n');
        lines.forEach(line => {
            if (line.includes('Current Role:')) {
                const match = line.match(/Current Role:\s*(\w+)\s*\((\d+)\)/);
                if (match) {
                    this.systemState.role = match[1];
                    this.systemState.roleLevel = parseInt(match[2]);
                }
            }
            if (line.includes('Capabilities:')) {
                this.systemState.capabilities = line.replace('Capabilities:', '').trim();
            }
        });
    }

    parseModuleInfo(output) {
        const modules = {};
        output.split('\n').forEach(line => {
            if (line.includes(':')) {
                const [name, status] = line.split(':').map(s => s.trim());
                modules[name] = status;
            }
        });
        this.systemState.modules = modules;
    }

    // Real-time Updates
    startPolling() {
        // Poll every 5 seconds for state changes
        setInterval(() => {
            this.updateSystemState();
        }, 5000);
    }

    async updateSystemState() {
        if (this.isProcessing) return;
        
        try {
            this.isProcessing = true;
            const roleResult = await this.executeCommand('udos role');
            if (roleResult.success) {
                const oldRole = this.systemState.role;
                this.parseRoleInfo(roleResult.stdout);
                
                if (oldRole !== this.systemState.role) {
                    console.log(`🔄 Role changed: ${oldRole} → ${this.systemState.role}`);
                    this.notifyRoleChange(oldRole, this.systemState.role);
                }
            }
            
            this.systemState.lastUpdate = Date.now();
            this.notifyStateChange();
        } catch (error) {
            console.warn('State update failed:', error);
        } finally {
            this.isProcessing = false;
        }
    }

    // Event System
    on(event, handler) {
        if (!this.eventHandlers.has(event)) {
            this.eventHandlers.set(event, []);
        }
        this.eventHandlers.get(event).push(handler);
    }

    notifyStateChange() {
        this.emit('stateChange', this.systemState);
    }

    notifyRoleChange(oldRole, newRole) {
        this.emit('roleChange', { oldRole, newRole, level: this.systemState.roleLevel });
    }

    emit(event, data) {
        const handlers = this.eventHandlers.get(event) || [];
        handlers.forEach(handler => {
            try {
                handler(data);
            } catch (error) {
                console.error(`Event handler error for ${event}:`, error);
            }
        });
    }

    // Utility Methods
    isTinyCore() {
        return typeof window === 'undefined' && 
               process.platform === 'linux' && 
               process.env.HOME === '/home/tc';
    }

    isDevelopment() {
        return typeof window !== 'undefined' && 
               (window.location.hostname === 'localhost' || 
                window.location.hostname === '127.0.0.1');
    }

    // Public API
    getSystemState() {
        return { ...this.systemState };
    }

    async runCommand(command) {
        console.log(`🔧 Executing: ${command}`);
        const result = await this.executeCommand(command);
        console.log(`${result.success ? '✅' : '❌'} Result:`, result);
        return result;
    }

    getRoleCapabilities() {
        const roleMap = {
            'GHOST': { level: 10, color: '#9CA3AF', capabilities: ['view', 'basic'] },
            'TOMB': { level: 20, color: '#F59E0B', capabilities: ['view', 'basic', 'files'] },
            'CRYPT': { level: 30, color: '#8B5CF6', capabilities: ['view', 'basic', 'files', 'security'] },
            'DRONE': { level: 40, color: '#3B82F6', capabilities: ['view', 'basic', 'files', 'automation'] },
            'KNIGHT': { level: 50, color: '#06B6D4', capabilities: ['view', 'basic', 'files', 'security', 'services'] },
            'IMP': { level: 60, color: '#EF4444', capabilities: ['view', 'basic', 'files', 'automation', 'development'] },
            'SORCERER': { level: 80, color: '#A855F7', capabilities: ['view', 'basic', 'files', 'security', 'services', 'advanced'] },
            'WIZARD': { level: 100, color: '#10B981', capabilities: ['all'] }
        };
        return roleMap[this.systemState.role] || roleMap['GHOST'];
    }
}

// Export for both Node.js and browser
if (typeof module !== 'undefined' && module.exports) {
    module.exports = uDOSWebBridge;
} else if (typeof window !== 'undefined') {
    window.uDOSWebBridge = uDOSWebBridge;
}
