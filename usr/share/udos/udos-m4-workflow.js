#!/usr/bin/env node
/**
 * uDOS M4 Workflow Engine
 * AI-powered automation and workflow management system
 */

const fs = require('fs');
const path = require('path');
const { execSync, exec } = require('child_process');
const crypto = require('crypto');

class WorkflowEngine {
    constructor() {
        this.workflows = new Map();
        this.triggers = new Map();
        this.patterns = new Map();
        this.config = {
            workflowDir: '/etc/udos/workflows',
            dataDir: '/tmp/udos-m4-data',
            logFile: '/tmp/udos-m4.log'
        };
        
        this.initializeEngine();
        console.log('🤖 M4 Workflow Engine initialized');
    }

    /**
     * Initialize the workflow engine
     */
    initializeEngine() {
        // Create necessary directories
        this.ensureDirectories();
        
        // Load existing workflows
        this.loadWorkflows();
        
        // Initialize pattern recognition
        this.initializePatterns();
        
        // Setup event listeners
        this.setupTriggers();
    }

    /**
     * Ensure required directories exist
     */
    ensureDirectories() {
        const dirs = [this.config.workflowDir, this.config.dataDir];
        dirs.forEach(dir => {
            try {
                if (!fs.existsSync(dir)) {
                    fs.mkdirSync(dir, { recursive: true });
                }
            } catch (error) {
                console.warn(`⚠️  Could not create directory ${dir}:`, error.message);
            }
        });
    }

    /**
     * Load workflows from configuration
     */
    loadWorkflows() {
        try {
            if (fs.existsSync(this.config.workflowDir)) {
                const files = fs.readdirSync(this.config.workflowDir);
                files.filter(f => f.endsWith('.json')).forEach(file => {
                    try {
                        const workflowPath = path.join(this.config.workflowDir, file);
                        const workflow = JSON.parse(fs.readFileSync(workflowPath, 'utf8'));
                        this.workflows.set(workflow.id, workflow);
                        console.log(`📋 Loaded workflow: ${workflow.name}`);
                    } catch (error) {
                        console.error(`❌ Failed to load workflow ${file}:`, error.message);
                    }
                });
            }
        } catch (error) {
            console.warn('⚠️  Could not load workflows:', error.message);
        }
    }

    /**
     * Initialize AI pattern recognition
     */
    initializePatterns() {
        // Load user behavior patterns
        this.patterns.set('command_frequency', new Map());
        this.patterns.set('time_patterns', new Map());
        this.patterns.set('error_patterns', new Map());
        this.patterns.set('resource_usage', new Map());
        
        console.log('🧠 AI pattern recognition initialized');
    }

    /**
     * Setup automation triggers
     */
    setupTriggers() {
        // Time-based triggers
        this.triggers.set('schedule', new Map());
        
        // Event-based triggers
        this.triggers.set('command', new Map());
        this.triggers.set('system', new Map());
        this.triggers.set('file', new Map());
        
        console.log('⚡ Automation triggers configured');
    }

    /**
     * Create a new workflow
     */
    async createWorkflow(definition) {
        try {
            const workflow = {
                id: this.generateId(),
                name: definition.name || 'Unnamed Workflow',
                description: definition.description || '',
                triggers: definition.triggers || [],
                actions: definition.actions || [],
                conditions: definition.conditions || [],
                enabled: definition.enabled !== false,
                created: new Date().toISOString(),
                modified: new Date().toISOString(),
                executions: 0,
                lastRun: null
            };

            // Validate workflow
            this.validateWorkflow(workflow);

            // Save workflow
            await this.saveWorkflow(workflow);

            // Register triggers
            this.registerWorkflowTriggers(workflow);

            this.workflows.set(workflow.id, workflow);
            console.log(`✅ Created workflow: ${workflow.name} (${workflow.id})`);
            
            return workflow;
        } catch (error) {
            console.error('❌ Failed to create workflow:', error.message);
            throw error;
        }
    }

    /**
     * Execute a workflow
     */
    async executeWorkflow(workflowId, context = {}) {
        try {
            const workflow = this.workflows.get(workflowId);
            if (!workflow) {
                throw new Error(`Workflow ${workflowId} not found`);
            }

            if (!workflow.enabled) {
                console.log(`⏸️  Workflow ${workflow.name} is disabled`);
                return { status: 'disabled' };
            }

            console.log(`🚀 Executing workflow: ${workflow.name}`);
            
            // Check conditions
            const conditionsMet = await this.checkConditions(workflow.conditions, context);
            if (!conditionsMet) {
                console.log(`⏭️  Workflow conditions not met: ${workflow.name}`);
                return { status: 'conditions_not_met' };
            }

            // Execute actions
            const results = [];
            for (const action of workflow.actions) {
                try {
                    const result = await this.executeAction(action, context);
                    results.push({ action: action.type, result, success: true });
                    
                    // Add delay if specified
                    if (action.delay) {
                        await this.sleep(action.delay);
                    }
                } catch (error) {
                    console.error(`❌ Action failed: ${action.type}`, error.message);
                    results.push({ action: action.type, error: error.message, success: false });
                    
                    // Stop on error if specified
                    if (action.stopOnError !== false) {
                        break;
                    }
                }
            }

            // Update workflow statistics
            workflow.executions++;
            workflow.lastRun = new Date().toISOString();
            await this.saveWorkflow(workflow);

            // Log execution
            this.logExecution(workflow, results, context);

            console.log(`✅ Workflow completed: ${workflow.name}`);
            return { status: 'completed', results };

        } catch (error) {
            console.error('❌ Workflow execution failed:', error.message);
            return { status: 'error', error: error.message };
        }
    }

    /**
     * Execute a single action
     */
    async executeAction(action, context) {
        switch (action.type) {
            case 'command':
                return this.executeCommand(action, context);
            case 'file':
                return this.executeFileAction(action, context);
            case 'notification':
                return this.sendNotification(action, context);
            case 'variable':
                return this.setVariable(action, context);
            case 'http':
                return this.makeHttpRequest(action, context);
            case 'ai_suggest':
                return this.generateAISuggestion(action, context);
            default:
                throw new Error(`Unknown action type: ${action.type}`);
        }
    }

    /**
     * Execute command action
     */
    async executeCommand(action, context) {
        const command = this.interpolateString(action.command, context);
        console.log(`💻 Executing command: ${command}`);
        
        return new Promise((resolve, reject) => {
            exec(command, { timeout: action.timeout || 30000 }, (error, stdout, stderr) => {
                if (error) {
                    reject(new Error(`Command failed: ${error.message}`));
                } else {
                    resolve({ stdout: stdout.trim(), stderr: stderr.trim() });
                }
            });
        });
    }

    /**
     * Execute file action
     */
    async executeFileAction(action, context) {
        const filePath = this.interpolateString(action.path, context);
        
        switch (action.operation) {
            case 'create':
                const content = this.interpolateString(action.content || '', context);
                fs.writeFileSync(filePath, content);
                return { operation: 'create', path: filePath };
                
            case 'read':
                const data = fs.readFileSync(filePath, 'utf8');
                return { operation: 'read', path: filePath, content: data };
                
            case 'delete':
                fs.unlinkSync(filePath);
                return { operation: 'delete', path: filePath };
                
            case 'exists':
                const exists = fs.existsSync(filePath);
                return { operation: 'exists', path: filePath, exists };
                
            default:
                throw new Error(`Unknown file operation: ${action.operation}`);
        }
    }

    /**
     * Send notification
     */
    async sendNotification(action, context) {
        const message = this.interpolateString(action.message, context);
        const title = this.interpolateString(action.title || 'uDOS Automation', context);
        
        console.log(`🔔 ${title}: ${message}`);
        
        // Try to use system notifications if available
        try {
            if (process.platform === 'darwin') {
                execSync(`osascript -e 'display notification "${message}" with title "${title}"'`);
            } else if (process.platform === 'linux') {
                execSync(`notify-send "${title}" "${message}"`);
            }
        } catch (error) {
            // Fallback to console output
            console.log(`📢 Notification: ${title} - ${message}`);
        }
        
        return { title, message };
    }

    /**
     * Set variable action
     */
    async setVariable(action, context) {
        const key = this.interpolateString(action.key, context);
        const value = this.interpolateString(action.value, context);
        
        // Use udos variable system
        try {
            execSync(`udos var set "${key}=${value}"`);
            return { key, value };
        } catch (error) {
            throw new Error(`Failed to set variable: ${error.message}`);
        }
    }

    /**
     * Generate AI suggestion
     */
    async generateAISuggestion(action, context) {
        const prompt = this.interpolateString(action.prompt, context);
        
        // Simple pattern-based suggestions (placeholder for real AI)
        const suggestions = this.generateSimpleAISuggestion(prompt, context);
        
        console.log(`🤖 AI Suggestion: ${suggestions.join(', ')}`);
        return { prompt, suggestions };
    }

    /**
     * Generate simple AI suggestions based on patterns
     */
    generateSimpleAISuggestion(prompt, context) {
        const suggestions = [];
        
        // Command frequency suggestions
        const commands = this.patterns.get('command_frequency');
        if (commands && commands.size > 0) {
            const topCommands = Array.from(commands.entries())
                .sort((a, b) => b[1] - a[1])
                .slice(0, 3)
                .map(([cmd]) => cmd);
            suggestions.push(`Frequently used: ${topCommands.join(', ')}`);
        }
        
        // Time-based suggestions
        const hour = new Date().getHours();
        if (hour < 12) {
            suggestions.push('Morning routine: Check system status, update packages');
        } else if (hour < 17) {
            suggestions.push('Afternoon tasks: Process data, run backups');
        } else {
            suggestions.push('Evening cleanup: Clear temp files, system maintenance');
        }
        
        // Context-based suggestions
        if (context.user_role) {
            switch (context.user_role) {
                case 'ADMIN':
                    suggestions.push('Admin tasks: Monitor logs, check security');
                    break;
                case 'USER':
                    suggestions.push('User tasks: Organize files, update documents');
                    break;
                default:
                    suggestions.push('General tasks: System health check');
            }
        }
        
        return suggestions.length > 0 ? suggestions : ['No specific suggestions available'];
    }

    /**
     * Learn from command execution
     */
    learnFromCommand(command, success, context = {}) {
        // Track command frequency
        const commands = this.patterns.get('command_frequency');
        commands.set(command, (commands.get(command) || 0) + 1);
        
        // Track time patterns
        const timePatterns = this.patterns.get('time_patterns');
        const hour = new Date().getHours();
        const timeKey = `${hour}:${command}`;
        timePatterns.set(timeKey, (timePatterns.get(timeKey) || 0) + 1);
        
        // Track success/error patterns
        if (!success) {
            const errorPatterns = this.patterns.get('error_patterns');
            errorPatterns.set(command, (errorPatterns.get(command) || 0) + 1);
        }
        
        console.log(`🧠 Learning: ${command} (success: ${success})`);
    }

    /**
     * Get intelligent suggestions
     */
    getIntelligentSuggestions(context = {}) {
        const suggestions = [];
        
        // Analyze patterns and generate suggestions
        const commands = this.patterns.get('command_frequency');
        const errorPatterns = this.patterns.get('error_patterns');
        
        // Suggest automation for frequently used commands
        if (commands.size > 0) {
            const frequent = Array.from(commands.entries())
                .filter(([cmd, count]) => count > 5)
                .map(([cmd]) => cmd);
            
            frequent.forEach(cmd => {
                suggestions.push({
                    type: 'automation',
                    command: cmd,
                    suggestion: `Consider automating "${cmd}" - used ${commands.get(cmd)} times`
                });
            });
        }
        
        // Suggest error handling for problematic commands
        if (errorPatterns.size > 0) {
            Array.from(errorPatterns.entries()).forEach(([cmd, errorCount]) => {
                if (errorCount > 2) {
                    suggestions.push({
                        type: 'error_handling',
                        command: cmd,
                        suggestion: `Add error handling for "${cmd}" - failed ${errorCount} times`
                    });
                }
            });
        }
        
        return suggestions;
    }

    // Utility methods
    generateId() {
        return crypto.randomBytes(16).toString('hex');
    }

    interpolateString(str, context) {
        if (!str || typeof str !== 'string') return str;
        
        return str.replace(/\$\{([^}]+)\}/g, (match, key) => {
            return context[key] || match;
        });
    }

    validateWorkflow(workflow) {
        if (!workflow.name) throw new Error('Workflow name is required');
        if (!workflow.actions || workflow.actions.length === 0) {
            throw new Error('Workflow must have at least one action');
        }
    }

    async saveWorkflow(workflow) {
        const filePath = path.join(this.config.workflowDir, `${workflow.id}.json`);
        fs.writeFileSync(filePath, JSON.stringify(workflow, null, 2));
    }

    async checkConditions(conditions, context) {
        // Simplified condition checking
        return conditions.length === 0 || conditions.every(condition => {
            // Basic condition evaluation
            return true; // Placeholder
        });
    }

    registerWorkflowTriggers(workflow) {
        // Register triggers for workflow execution
        workflow.triggers.forEach(trigger => {
            console.log(`⚡ Registered trigger: ${trigger.type} for ${workflow.name}`);
        });
    }

    logExecution(workflow, results, context) {
        const logEntry = {
            timestamp: new Date().toISOString(),
            workflow: workflow.name,
            workflowId: workflow.id,
            results: results.length,
            success: results.every(r => r.success),
            context
        };
        
        try {
            const logLine = JSON.stringify(logEntry) + '\n';
            fs.appendFileSync(this.config.logFile, logLine);
        } catch (error) {
            console.warn('Could not write to log file:', error.message);
        }
    }

    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    // Public API methods
    listWorkflows() {
        return Array.from(this.workflows.values()).map(w => ({
            id: w.id,
            name: w.name,
            description: w.description,
            enabled: w.enabled,
            executions: w.executions,
            lastRun: w.lastRun
        }));
    }

    getWorkflow(id) {
        return this.workflows.get(id);
    }

    async deleteWorkflow(id) {
        const workflow = this.workflows.get(id);
        if (!workflow) throw new Error('Workflow not found');
        
        // Remove file
        const filePath = path.join(this.config.workflowDir, `${id}.json`);
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
        
        // Remove from memory
        this.workflows.delete(id);
        
        console.log(`🗑️  Deleted workflow: ${workflow.name}`);
    }

    async toggleWorkflow(id) {
        const workflow = this.workflows.get(id);
        if (!workflow) throw new Error('Workflow not found');
        
        workflow.enabled = !workflow.enabled;
        workflow.modified = new Date().toISOString();
        await this.saveWorkflow(workflow);
        
        console.log(`${workflow.enabled ? '✅' : '⏸️ '} ${workflow.enabled ? 'Enabled' : 'Disabled'} workflow: ${workflow.name}`);
        return workflow;
    }
}

// CLI Interface
if (require.main === module) {
    const engine = new WorkflowEngine();
    const command = process.argv[2];
    const args = process.argv.slice(3);

    switch (command) {
        case 'create':
            if (args[0]) {
                try {
                    const definition = JSON.parse(args[0]);
                    engine.createWorkflow(definition).then(workflow => {
                        console.log(`Created workflow: ${workflow.id}`);
                    });
                } catch (error) {
                    console.error('Invalid workflow definition:', error.message);
                }
            } else {
                console.log('Usage: udos-m4-workflow.js create \'{"name":"Test","actions":[]}\'');
            }
            break;

        case 'list':
            const workflows = engine.listWorkflows();
            console.log('\n🤖 Available Workflows:');
            workflows.forEach(w => {
                const status = w.enabled ? '✅' : '⏸️ ';
                console.log(`  ${status}${w.id}: ${w.name} (executions: ${w.executions})`);
            });
            break;

        case 'execute':
            if (args[0]) {
                engine.executeWorkflow(args[0]).then(result => {
                    console.log(`Execution result: ${result.status}`);
                });
            } else {
                console.log('Usage: udos-m4-workflow.js execute <workflow-id>');
            }
            break;

        case 'suggestions':
            const suggestions = engine.getIntelligentSuggestions();
            console.log('\n🤖 AI Suggestions:');
            suggestions.forEach(s => {
                console.log(`  ${s.type}: ${s.suggestion}`);
            });
            break;

        case 'learn':
            if (args.length >= 2) {
                const [command, success] = args;
                engine.learnFromCommand(command, success === 'true');
            } else {
                console.log('Usage: udos-m4-workflow.js learn <command> <true|false>');
            }
            break;

        default:
            console.log(`
🤖 uDOS M4 Workflow Engine

Usage:
  udos-m4-workflow.js create '<json>'  - Create new workflow
  udos-m4-workflow.js list             - List all workflows
  udos-m4-workflow.js execute <id>     - Execute workflow
  udos-m4-workflow.js suggestions      - Get AI suggestions
  udos-m4-workflow.js learn <cmd> <success>  - Learn from command

Example workflow:
{
  "name": "Daily Backup",
  "description": "Automated daily system backup",
  "triggers": [{"type": "schedule", "cron": "0 2 * * *"}],
  "actions": [
    {"type": "command", "command": "udos data backup"},
    {"type": "notification", "message": "Backup completed"}
  ]
}
            `);
    }
}

module.exports = WorkflowEngine;
