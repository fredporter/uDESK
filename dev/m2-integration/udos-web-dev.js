/**
 * uDOS M2 Integration Layer
 * Complete integration of web UI + command bridge + role adaptation
 * Ready for TinyCore VM testing
 */

class uDOSM2Integration {
    constructor() {
        this.bridge = null;
        this.roleUI = null;
        this.dashboard = null;
        this.initialized = false;
        this.config = {
            updateInterval: 5000,
            enableRealTime: true,
            debugMode: false
        };
    }

    async init() {
        console.log('🚀 uDOS M2 Integration starting...');
        
        try {
            // Initialize Web Bridge
            this.bridge = new uDOSWebBridge();
            await this.bridge.init();
            
            // Initialize Role UI
            this.roleUI = new uDOSRoleUI(this.bridge);
            
            // Connect to existing dashboard if present
            this.connectExistingDashboard();
            
            // Setup integrated event handlers
            this.setupEventHandlers();
            
            // Mark as initialized
            this.initialized = true;
            
            console.log('✅ M2 Integration complete!');
            this.showInitializationSuccess();
            
        } catch (error) {
            console.error('❌ M2 Integration failed:', error);
            this.showInitializationError(error);
        }
    }

    connectExistingDashboard() {
        // Connect to existing uDOS dashboard if present
        if (window.dashboard && typeof window.dashboard === 'object') {
            this.dashboard = window.dashboard;
            console.log('🔗 Connected to existing dashboard');
            this.enhanceDashboard();
        } else {
            console.log('📊 No existing dashboard found, creating enhanced interface');
            this.createEnhancedDashboard();
        }
    }

    enhanceDashboard() {
        // Enhance existing dashboard with M2 capabilities
        if (this.dashboard && this.dashboard.refreshDashboard) {
            const originalRefresh = this.dashboard.refreshDashboard.bind(this.dashboard);
            
            this.dashboard.refreshDashboard = async () => {
                // Call original refresh
                await originalRefresh();
                
                // Add M2 enhancements
                await this.updateWithLiveData();
            };
        }

        // Add role-based data attributes to existing elements
        this.addRoleAttributes();
    }

    addRoleAttributes() {
        // Add data attributes to existing dashboard elements for role-based hiding
        const mappings = [
            { selector: '.admin-panel, .system-admin', attr: 'data-min-level', value: '80' },
            { selector: '.dev-tools, .development', attr: 'data-min-level', value: '60' },
            { selector: '.security-tools', attr: 'data-min-level', value: '50' },
            { selector: '.automation-panel', attr: 'data-min-level', value: '40' },
            { selector: '.advanced-settings', attr: 'data-min-level', value: '30' },
            { selector: '.module-grid', attr: 'data-section', value: 'overview' },
            { selector: '.system-overview', attr: 'data-section', value: 'basic-status' },
            { selector: '.nav-item', attr: 'data-nav-section', value: 'overview' }
        ];

        mappings.forEach(mapping => {
            const elements = document.querySelectorAll(mapping.selector);
            elements.forEach(el => {
                if (!el.getAttribute(mapping.attr)) {
                    el.setAttribute(mapping.attr, mapping.value);
                }
            });
        });
    }

    createEnhancedDashboard() {
        // Create a new M2-enhanced dashboard
        const dashboardContainer = document.querySelector('.dashboard-grid, .main-content');
        if (!dashboardContainer) return;

        // Add M2 enhancements to container
        dashboardContainer.setAttribute('data-m2-enhanced', 'true');
        
        // Insert role indicator
        this.insertRoleIndicator();
        
        // Add command interface
        this.addCommandInterface();
        
        // Add real-time status
        this.addRealTimeStatus();
    }

    insertRoleIndicator() {
        const header = document.querySelector('.dashboard-header, .header, .top-nav');
        if (header && !document.querySelector('.role-indicator')) {
            const roleIndicator = document.createElement('div');
            roleIndicator.className = 'role-indicator';
            roleIndicator.innerHTML = `
                <div class="role-display">
                    <span class="role-icon">👻</span>
                    <span class="role-text">GHOST (10)</span>
                    <span class="role-status">●</span>
                </div>
            `;
            
            // Add to header
            header.appendChild(roleIndicator);
            
            // Style the indicator
            this.addRoleIndicatorStyles();
        }
    }

    addCommandInterface() {
        const container = document.querySelector('.dashboard-grid, .main-content');
        if (container && !document.querySelector('.m2-command-interface')) {
            const commandInterface = document.createElement('div');
            commandInterface.className = 'm2-command-interface card';
            commandInterface.innerHTML = `
                <div class="card-header">
                    <h3>🔧 uDOS Command Interface</h3>
                    <button class="btn btn-sm" onclick="this.closest('.m2-command-interface').querySelector('.command-input').focus()">Focus</button>
                </div>
                <div class="card-content">
                    <div class="command-form">
                        <input type="text" class="command-input" placeholder="Enter udos command..." />
                        <button class="execute-btn">Execute</button>
                    </div>
                    <div class="command-output"></div>
                </div>
            `;
            
            container.appendChild(commandInterface);
            this.setupCommandInterface(commandInterface);
        }
    }

    setupCommandInterface(container) {
        const input = container.querySelector('.command-input');
        const executeBtn = container.querySelector('.execute-btn');
        const output = container.querySelector('.command-output');

        const executeCommand = async () => {
            const command = input.value.trim();
            if (!command) return;

            output.innerHTML = `<div class="executing">🔄 Executing: ${command}</div>`;
            
            try {
                const result = await this.bridge.runCommand(command);
                
                if (result.success) {
                    output.innerHTML = `
                        <div class="command-success">
                            <div class="command-line">$ ${command}</div>
                            <pre class="command-result">${result.stdout}</pre>
                        </div>
                    `;
                } else {
                    output.innerHTML = `
                        <div class="command-error">
                            <div class="command-line">$ ${command}</div>
                            <pre class="error-result">Error: ${result.error || result.stderr}</pre>
                        </div>
                    `;
                }
            } catch (error) {
                output.innerHTML = `
                    <div class="command-error">
                        <div class="command-line">$ ${command}</div>
                        <pre class="error-result">Exception: ${error.message}</pre>
                    </div>
                `;
            }
            
            input.value = '';
        };

        executeBtn.addEventListener('click', executeCommand);
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') executeCommand();
        });
    }

    addRealTimeStatus() {
        const container = document.querySelector('.dashboard-grid, .main-content');
        if (container && !document.querySelector('.m2-realtime-status')) {
            const statusPanel = document.createElement('div');
            statusPanel.className = 'm2-realtime-status card';
            statusPanel.innerHTML = `
                <div class="card-header">
                    <h3>📡 Live System Status</h3>
                    <span class="last-update">Updated: --</span>
                </div>
                <div class="card-content">
                    <div class="status-grid">
                        <div class="status-item">
                            <div class="status-label">Role</div>
                            <div class="status-value role-value">--</div>
                        </div>
                        <div class="status-item">
                            <div class="status-label">Version</div>
                            <div class="status-value version-value">--</div>
                        </div>
                        <div class="status-item">
                            <div class="status-label">Modules</div>
                            <div class="status-value modules-value">--</div>
                        </div>
                        <div class="status-item">
                            <div class="status-label">Update</div>
                            <div class="status-value update-value">--</div>
                        </div>
                    </div>
                </div>
            `;
            
            container.appendChild(statusPanel);
        }
    }

    setupEventHandlers() {
        // Listen for bridge state changes
        this.bridge.on('stateChange', (state) => {
            this.updateRealTimeStatus(state);
        });

        // Listen for role changes
        this.bridge.on('roleChange', (data) => {
            this.updateRoleIndicator(data.newRole, data.level);
        });

        // Listen for role UI adaptations
        document.addEventListener('udos-role-adapted', (event) => {
            console.log('🎭 UI adapted for role:', event.detail.role);
        });
    }

    updateRealTimeStatus(state) {
        const statusPanel = document.querySelector('.m2-realtime-status');
        if (!statusPanel) return;

        const updates = {
            '.role-value': `${state.role} (${state.roleLevel || 'N/A'})`,
            '.version-value': state.version || 'Unknown',
            '.modules-value': Object.keys(state.modules || {}).length.toString(),
            '.update-value': state.lastUpdate ? new Date(state.lastUpdate).toLocaleTimeString() : 'Never',
            '.last-update': `Updated: ${new Date().toLocaleTimeString()}`
        };

        Object.entries(updates).forEach(([selector, value]) => {
            const element = statusPanel.querySelector(selector);
            if (element) element.textContent = value;
        });
    }

    updateRoleIndicator(role, level) {
        const indicator = document.querySelector('.role-indicator');
        if (indicator) {
            const roleText = indicator.querySelector('.role-text');
            const roleIcon = indicator.querySelector('.role-icon');
            
            if (roleText) roleText.textContent = `${role} (${level})`;
            if (roleIcon) {
                const icons = {
                    'GHOST': '👻', 'TOMB': '⚱️', 'CRYPT': '💀', 'DRONE': '🤖',
                    'KNIGHT': '⚔️', 'IMP': '👹', 'SORCERER': '🔮', 'WIZARD': '🧙'
                };
                roleIcon.textContent = icons[role] || '👻';
            }
        }
    }

    async updateWithLiveData() {
        if (!this.initialized) return;
        
        try {
            // Get fresh system state
            await this.bridge.loadInitialState();
            
            // Force UI refresh based on current role
            const currentRole = this.roleUI.getCurrentRole();
            this.roleUI.forceRoleUpdate(currentRole.role);
            
        } catch (error) {
            console.warn('Live data update failed:', error);
        }
    }

    addRoleIndicatorStyles() {
        if (!document.querySelector('#m2-integration-styles')) {
            const styles = document.createElement('style');
            styles.id = 'm2-integration-styles';
            styles.textContent = `
                .role-indicator {
                    display: flex;
                    align-items: center;
                    margin-left: auto;
                }
                
                .role-display {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 6px 12px;
                    background: rgba(255,255,255,0.1);
                    border-radius: 16px;
                    font-size: 14px;
                    font-weight: 500;
                }
                
                .role-status {
                    color: #10B981;
                    animation: pulse 2s infinite;
                }
                
                .m2-command-interface .command-form {
                    display: flex;
                    gap: 8px;
                    margin-bottom: 16px;
                }
                
                .m2-command-interface .command-input {
                    flex: 1;
                    padding: 8px 12px;
                    border: 1px solid var(--border-color, #ccc);
                    border-radius: 4px;
                    font-family: monospace;
                    background: var(--bg-primary, #fff);
                    color: var(--text-primary, #000);
                }
                
                .m2-command-interface .command-output {
                    min-height: 100px;
                    max-height: 200px;
                    overflow-y: auto;
                    background: #1a1a1a;
                    color: #00ff00;
                    padding: 12px;
                    border-radius: 4px;
                    font-family: monospace;
                    font-size: 12px;
                }
                
                .command-success .command-result {
                    color: #00ff00;
                    margin: 0;
                    white-space: pre-wrap;
                }
                
                .command-error .error-result {
                    color: #ff4444;
                    margin: 0;
                    white-space: pre-wrap;
                }
                
                .command-line {
                    color: #888;
                    margin-bottom: 4px;
                }
                
                .executing {
                    color: #ffaa00;
                }
                
                .status-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
                    gap: 16px;
                }
                
                .status-item {
                    text-align: center;
                }
                
                .status-label {
                    font-size: 12px;
                    color: var(--text-secondary, #666);
                    margin-bottom: 4px;
                }
                
                .status-value {
                    font-weight: 600;
                    color: var(--text-primary, #000);
                }
            `;
            document.head.appendChild(styles);
        }
    }

    showInitializationSuccess() {
        const notification = document.createElement('div');
        notification.className = 'init-notification success';
        notification.innerHTML = `
            <div class="notification-content">
                <div class="notification-icon">🚀</div>
                <div class="notification-text">
                    <strong>M2 Integration Complete!</strong><br>
                    Web UI + Command Bridge + Role Adaptation
                </div>
            </div>
        `;
        
        this.showNotification(notification, '#10B981');
    }

    showInitializationError(error) {
        const notification = document.createElement('div');
        notification.className = 'init-notification error';
        notification.innerHTML = `
            <div class="notification-content">
                <div class="notification-icon">❌</div>
                <div class="notification-text">
                    <strong>M2 Integration Failed!</strong><br>
                    ${error.message}
                </div>
            </div>
        `;
        
        this.showNotification(notification, '#EF4444');
    }

    showNotification(notification, color) {
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${color};
            color: white;
            padding: 16px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 10000;
            animation: slideInRight 0.3s ease;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideInRight 0.3s ease reverse';
            setTimeout(() => notification.remove(), 300);
        }, 4000);
    }

    // Public API
    getStatus() {
        return {
            initialized: this.initialized,
            bridge: !!this.bridge,
            roleUI: !!this.roleUI,
            dashboard: !!this.dashboard,
            currentRole: this.roleUI?.getCurrentRole(),
            systemState: this.bridge?.getSystemState()
        };
    }

    async forceRefresh() {
        if (this.bridge) {
            await this.bridge.loadInitialState();
        }
        await this.updateWithLiveData();
    }

    destroy() {
        // Cleanup resources
        this.initialized = false;
        this.bridge = null;
        this.roleUI = null;
        this.dashboard = null;
    }
}

// Auto-initialize when page loads
document.addEventListener('DOMContentLoaded', () => {
    // Wait a moment for other scripts to load
    setTimeout(() => {
        window.uDOSM2 = new uDOSM2Integration();
        window.uDOSM2.init();
    }, 1000);
});

// Export for both Node.js and browser
if (typeof module !== 'undefined' && module.exports) {
    module.exports = uDOSM2Integration;
} else if (typeof window !== 'undefined') {
    window.uDOSM2Integration = uDOSM2Integration;
}
