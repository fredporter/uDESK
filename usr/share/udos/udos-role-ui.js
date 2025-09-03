/**
 * uDOS Role-Based UI Adapter
 * Progressive interface disclosure based on 8-role hierarchy
 * M2 Interface Development - Role Adaptation
 */

class uDOSRoleUI {
    constructor(webBridge) {
        this.bridge = webBridge;
        this.currentRole = 'GHOST';
        this.roleLevel = 10;
        this.adaptedElements = new Set();
        this.roleStyles = new Map();
        this.init();
    }

    init() {
        console.log('🎭 Role-based UI initializing...');
        this.setupRoleStyles();
        this.setupEventListeners();
        this.bridge.on('roleChange', (data) => this.onRoleChange(data));
        this.bridge.on('stateChange', (state) => this.onStateChange(state));
    }

    setupRoleStyles() {
        // Define role-specific UI configurations
        this.roleConfigs = {
            'GHOST': {
                level: 10,
                color: '#9CA3AF',
                theme: 'minimal',
                allowedSections: ['overview', 'basic-status'],
                hiddenElements: ['.admin-panel', '.dev-tools', '.advanced-settings', '.security-tools', '.automation-panel'],
                maxGridSize: '4x4',
                features: ['readonly']
            },
            'TOMB': {
                level: 20,
                color: '#F59E0B',
                theme: 'standard',
                allowedSections: ['overview', 'basic-status', 'file-browser'],
                hiddenElements: ['.admin-panel', '.dev-tools', '.advanced-settings', '.security-tools'],
                maxGridSize: '8x8',
                features: ['readonly', 'basic-files']
            },
            'CRYPT': {
                level: 30,
                color: '#8B5CF6',
                theme: 'standard',
                allowedSections: ['overview', 'basic-status', 'file-browser', 'security-basic'],
                hiddenElements: ['.admin-panel', '.dev-tools', '.advanced-settings'],
                maxGridSize: '8x8',
                features: ['readonly', 'basic-files', 'basic-security']
            },
            'DRONE': {
                level: 40,
                color: '#3B82F6',
                theme: 'automation',
                allowedSections: ['overview', 'basic-status', 'file-browser', 'automation-basic'],
                hiddenElements: ['.admin-panel', '.dev-tools', '.advanced-settings'],
                maxGridSize: '12x12',
                features: ['readonly', 'basic-files', 'basic-automation']
            },
            'KNIGHT': {
                level: 50,
                color: '#06B6D4',
                theme: 'security',
                allowedSections: ['overview', 'status', 'file-browser', 'security', 'services'],
                hiddenElements: ['.admin-panel', '.dev-tools'],
                maxGridSize: '16x16',
                features: ['readonly', 'files', 'security', 'services']
            },
            'IMP': {
                level: 60,
                color: '#EF4444',
                theme: 'development',
                allowedSections: ['overview', 'status', 'file-browser', 'automation', 'development'],
                hiddenElements: ['.admin-panel'],
                maxGridSize: '16x16',
                features: ['readonly', 'files', 'automation', 'development']
            },
            'SORCERER': {
                level: 80,
                color: '#A855F7',
                theme: 'advanced',
                allowedSections: ['overview', 'status', 'file-browser', 'security', 'automation', 'development', 'advanced'],
                hiddenElements: [],
                maxGridSize: '32x32',
                features: ['readonly', 'files', 'security', 'automation', 'development', 'advanced']
            },
            'WIZARD': {
                level: 100,
                color: '#10B981',
                theme: 'complete',
                allowedSections: ['all'],
                hiddenElements: [],
                maxGridSize: '64x64',
                features: ['all']
            }
        };
    }

    setupEventListeners() {
        // Listen for role changes from the bridge
        this.bridge.on('roleChange', this.handleRoleChange.bind(this));
        
        // Initial adaptation
        const initialState = this.bridge.getSystemState();
        if (initialState.role) {
            this.adaptToRole(initialState.role, initialState.roleLevel);
        }
    }

    onRoleChange(data) {
        console.log(`🔄 Adapting UI: ${data.oldRole} → ${data.newRole}`);
        this.adaptToRole(data.newRole, data.level);
        this.showRoleChangeNotification(data.oldRole, data.newRole);
    }

    onStateChange(state) {
        if (state.role !== this.currentRole) {
            this.adaptToRole(state.role, state.roleLevel);
        }
    }

    adaptToRole(role, level) {
        this.currentRole = role;
        this.roleLevel = level;
        
        const config = this.roleConfigs[role] || this.roleConfigs['GHOST'];
        
        console.log(`🎭 Adapting interface for role: ${role} (${level})`);
        
        // Apply visual theme
        this.applyRoleTheme(config);
        
        // Show/hide elements based on role
        this.applyElementVisibility(config);
        
        // Update grid constraints
        this.applyGridConstraints(config);
        
        // Update navigation
        this.updateNavigation(config);
        
        // Update dashboard widgets
        this.updateDashboardWidgets(config);
        
        // Emit adaptation complete event
        this.emitAdaptationComplete(role, config);
    }

    applyRoleTheme(config) {
        const root = document.documentElement;
        
        // Set role-specific CSS variables
        root.style.setProperty('--role-primary-color', config.color);
        root.style.setProperty('--role-theme', config.theme);
        
        // Update body class for theme-specific styling
        document.body.className = document.body.className
            .replace(/role-\w+/g, '')
            .replace(/theme-\w+/g, '') + ` role-${role.toLowerCase()} theme-${config.theme}`;
        
        // Update role indicator in header
        const roleIndicator = document.querySelector('.role-indicator');
        if (roleIndicator) {
            roleIndicator.textContent = `${role} (${this.roleLevel})`;
            roleIndicator.style.color = config.color;
        }
    }

    applyElementVisibility(config) {
        // Hide elements not allowed for this role
        config.hiddenElements.forEach(selector => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => {
                el.style.display = 'none';
                el.setAttribute('data-role-hidden', 'true');
                this.adaptedElements.add(el);
            });
        });

        // Show elements that should be visible
        document.querySelectorAll('[data-role-hidden="true"]').forEach(el => {
            const shouldBeHidden = config.hiddenElements.some(selector => 
                el.matches(selector)
            );
            
            if (!shouldBeHidden) {
                el.style.display = '';
                el.removeAttribute('data-role-hidden');
                this.adaptedElements.delete(el);
            }
        });

        // Show/hide sections based on allowed sections
        if (config.allowedSections[0] !== 'all') {
            this.adaptSectionVisibility(config.allowedSections);
        }
    }

    adaptSectionVisibility(allowedSections) {
        const allSections = document.querySelectorAll('[data-section]');
        
        allSections.forEach(section => {
            const sectionName = section.getAttribute('data-section');
            const isAllowed = allowedSections.includes(sectionName);
            
            if (isAllowed) {
                section.style.display = '';
                section.removeAttribute('data-role-hidden');
            } else {
                section.style.display = 'none';
                section.setAttribute('data-role-hidden', 'true');
            }
        });
    }

    applyGridConstraints(config) {
        // Update maximum grid size based on role
        const gridContainers = document.querySelectorAll('.grid-container, .dashboard-grid');
        
        gridContainers.forEach(container => {
            container.setAttribute('data-max-grid', config.maxGridSize);
            
            // Adjust grid template based on max size
            const [maxCols, maxRows] = config.maxGridSize.split('x').map(n => parseInt(n));
            
            if (container.style.gridTemplateColumns) {
                const currentCols = container.style.gridTemplateColumns.split(' ').length;
                if (currentCols > maxCols) {
                    container.style.gridTemplateColumns = `repeat(${maxCols}, 1fr)`;
                }
            }
        });
    }

    updateNavigation(config) {
        const navItems = document.querySelectorAll('.nav-item, .sidebar-item');
        
        navItems.forEach(item => {
            const section = item.getAttribute('data-nav-section');
            if (section) {
                const isAllowed = config.allowedSections.includes(section) || 
                                config.allowedSections[0] === 'all';
                
                if (isAllowed) {
                    item.style.display = '';
                    item.removeAttribute('disabled');
                } else {
                    item.style.display = 'none';
                    item.setAttribute('disabled', 'true');
                }
            }
        });
    }

    updateDashboardWidgets(config) {
        const widgets = document.querySelectorAll('.dashboard-widget, .card');
        
        widgets.forEach(widget => {
            const requiredRole = widget.getAttribute('data-min-role');
            const requiredLevel = parseInt(widget.getAttribute('data-min-level') || '0');
            
            if (requiredRole && this.roleLevel < requiredLevel) {
                widget.style.display = 'none';
                widget.setAttribute('data-role-hidden', 'true');
            } else {
                widget.style.display = '';
                widget.removeAttribute('data-role-hidden');
            }
        });

        // Update widget content based on features
        this.updateWidgetContent(config.features);
    }

    updateWidgetContent(features) {
        // Show/hide buttons based on available features
        const actionButtons = document.querySelectorAll('[data-requires-feature]');
        
        actionButtons.forEach(button => {
            const requiredFeature = button.getAttribute('data-requires-feature');
            const hasFeature = features.includes(requiredFeature) || features.includes('all');
            
            if (hasFeature) {
                button.style.display = '';
                button.removeAttribute('disabled');
            } else {
                button.style.display = 'none';
                button.setAttribute('disabled', 'true');
            }
        });
    }

    showRoleChangeNotification(oldRole, newRole) {
        const notification = document.createElement('div');
        notification.className = 'role-change-notification';
        notification.innerHTML = `
            <div class="notification-content">
                <div class="notification-icon">🎭</div>
                <div class="notification-text">
                    <strong>Role Updated!</strong><br>
                    ${oldRole} → ${newRole}
                </div>
            </div>
        `;
        
        // Add notification styles if not present
        if (!document.querySelector('#role-notification-styles')) {
            const styles = document.createElement('style');
            styles.id = 'role-notification-styles';
            styles.textContent = `
                .role-change-notification {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: var(--role-primary-color, #3B82F6);
                    color: white;
                    padding: 16px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                    z-index: 10000;
                    animation: slideInRight 0.3s ease;
                }
                
                .notification-content {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                
                .notification-icon {
                    font-size: 24px;
                }
                
                @keyframes slideInRight {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
            `;
            document.head.appendChild(styles);
        }
        
        document.body.appendChild(notification);
        
        // Auto-remove after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideInRight 0.3s ease reverse';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    emitAdaptationComplete(role, config) {
        const event = new CustomEvent('udos-role-adapted', {
            detail: { role, config, level: this.roleLevel }
        });
        document.dispatchEvent(event);
    }

    // Public API
    getCurrentRole() {
        return {
            role: this.currentRole,
            level: this.roleLevel,
            config: this.roleConfigs[this.currentRole]
        };
    }

    canAccessFeature(feature) {
        const config = this.roleConfigs[this.currentRole];
        return config.features.includes(feature) || config.features.includes('all');
    }

    canAccessSection(section) {
        const config = this.roleConfigs[this.currentRole];
        return config.allowedSections.includes(section) || config.allowedSections[0] === 'all';
    }

    forceRoleUpdate(role) {
        if (this.roleConfigs[role]) {
            this.adaptToRole(role, this.roleConfigs[role].level);
        }
    }

    resetToDefault() {
        this.adaptToRole('GHOST', 10);
    }
}

// Export for both Node.js and browser
if (typeof module !== 'undefined' && module.exports) {
    module.exports = uDOSRoleUI;
} else if (typeof window !== 'undefined') {
    window.uDOSRoleUI = uDOSRoleUI;
}
