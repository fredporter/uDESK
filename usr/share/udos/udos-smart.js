#!/usr/bin/env node
/**
 * uDOS M4 AI Pattern Recognition System
 * Intelligent user behavior analysis and prediction
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

class AIPatternRecognition {
    constructor() {
        this.config = {
            dataDir: '/tmp/udos-m4-data',
            patternsFile: '/tmp/udos-m4-patterns.json',
            learningRate: 0.1,
            minPatternOccurrence: 3,
            maxPatternAge: 7 * 24 * 60 * 60 * 1000 // 7 days
        };
        
        this.patterns = {
            commands: new Map(),
            sequences: new Map(),
            timing: new Map(),
            contexts: new Map(),
            errors: new Map(),
            resources: new Map()
        };
        
        this.userProfile = {
            role: 'USER',
            experience: 'INTERMEDIATE',
            preferences: new Map(),
            workingHours: { start: 9, end: 17 },
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
        };
        
        this.initializeAI();
        console.log('🧠 AI Pattern Recognition System initialized');
    }

    /**
     * Initialize the AI system
     */
    initializeAI() {
        this.ensureDirectories();
        this.loadPatterns();
        this.loadUserProfile();
        this.startLearning();
    }

    /**
     * Ensure required directories exist
     */
    ensureDirectories() {
        try {
            if (!fs.existsSync(this.config.dataDir)) {
                fs.mkdirSync(this.config.dataDir, { recursive: true });
            }
        } catch (error) {
            console.warn(`⚠️  Could not create directory: ${error.message}`);
        }
    }

    /**
     * Load existing patterns from storage
     */
    loadPatterns() {
        try {
            if (fs.existsSync(this.config.patternsFile)) {
                const data = JSON.parse(fs.readFileSync(this.config.patternsFile, 'utf8'));
                
                // Convert arrays back to Maps
                Object.keys(data.patterns).forEach(key => {
                    this.patterns[key] = new Map(data.patterns[key]);
                });
                
                if (data.userProfile) {
                    this.userProfile = { ...this.userProfile, ...data.userProfile };
                    if (data.userProfile.preferences) {
                        this.userProfile.preferences = new Map(data.userProfile.preferences);
                    }
                }
                
                console.log('📚 Loaded existing patterns and user profile');
            }
        } catch (error) {
            console.warn('⚠️  Could not load patterns:', error.message);
        }
    }

    /**
     * Save patterns to storage
     */
    savePatterns() {
        try {
            const data = {
                timestamp: new Date().toISOString(),
                patterns: {},
                userProfile: {
                    ...this.userProfile,
                    preferences: Array.from(this.userProfile.preferences.entries())
                }
            };
            
            // Convert Maps to arrays for JSON serialization
            Object.keys(this.patterns).forEach(key => {
                data.patterns[key] = Array.from(this.patterns[key].entries());
            });
            
            fs.writeFileSync(this.config.patternsFile, JSON.stringify(data, null, 2));
        } catch (error) {
            console.warn('⚠️  Could not save patterns:', error.message);
        }
    }

    /**
     * Load user profile information
     */
    loadUserProfile() {
        try {
            // Try to detect user role from system
            const userInfo = this.detectUserRole();
            this.userProfile = { ...this.userProfile, ...userInfo };
            
            console.log(`👤 User profile: ${this.userProfile.role} (${this.userProfile.experience})`);
        } catch (error) {
            console.warn('⚠️  Could not load user profile:', error.message);
        }
    }

    /**
     * Detect user role and experience level
     */
    detectUserRole() {
        const profile = {};
        
        try {
            // Check if user has admin privileges
            const isAdmin = process.getuid && process.getuid() === 0;
            profile.role = isAdmin ? 'ADMIN' : 'USER';
            
            // Estimate experience based on command history
            const commandCount = this.patterns.commands.size;
            if (commandCount > 100) {
                profile.experience = 'EXPERT';
            } else if (commandCount > 30) {
                profile.experience = 'INTERMEDIATE';
            } else {
                profile.experience = 'BEGINNER';
            }
            
        } catch (error) {
            console.warn('Could not detect user role:', error.message);
        }
        
        return profile;
    }

    /**
     * Start continuous learning process
     */
    startLearning() {
        // Auto-save patterns every 5 minutes
        setInterval(() => {
            this.savePatterns();
        }, 5 * 60 * 1000);
        
        // Clean old patterns every hour
        setInterval(() => {
            this.cleanOldPatterns();
        }, 60 * 60 * 1000);
        
        console.log('🎓 Continuous learning started');
    }

    /**
     * Learn from a command execution
     */
    learnFromCommand(command, context = {}) {
        const timestamp = Date.now();
        const hour = new Date().getHours();
        
        // Command frequency patterns
        const commandKey = this.normalizeCommand(command);
        const commandData = this.patterns.commands.get(commandKey) || {
            count: 0,
            lastUsed: timestamp,
            avgExecutionTime: 0,
            successRate: 1.0,
            contexts: []
        };
        
        commandData.count++;
        commandData.lastUsed = timestamp;
        
        // Track context
        if (context.executionTime) {
            commandData.avgExecutionTime = (commandData.avgExecutionTime + context.executionTime) / 2;
        }
        
        if (context.success !== undefined) {
            commandData.successRate = (commandData.successRate + (context.success ? 1 : 0)) / 2;
        }
        
        if (context.workingDir) {
            commandData.contexts.push({
                dir: context.workingDir,
                timestamp: timestamp
            });
        }
        
        this.patterns.commands.set(commandKey, commandData);
        
        // Timing patterns
        const timingKey = `${hour}:${commandKey}`;
        const timingCount = this.patterns.timing.get(timingKey) || 0;
        this.patterns.timing.set(timingKey, timingCount + 1);
        
        // Context patterns
        if (context.workingDir) {
            const contextKey = `${context.workingDir}:${commandKey}`;
            const contextCount = this.patterns.contexts.get(contextKey) || 0;
            this.patterns.contexts.set(contextKey, contextCount + 1);
        }
        
        // Update user preferences
        this.updateUserPreferences(command, context);
        
        console.log(`🧠 Learned: ${commandKey} (count: ${commandData.count})`);
    }

    /**
     * Learn from command sequences
     */
    learnFromSequence(commands, context = {}) {
        if (commands.length < 2) return;
        
        for (let i = 0; i < commands.length - 1; i++) {
            const current = this.normalizeCommand(commands[i]);
            const next = this.normalizeCommand(commands[i + 1]);
            const sequenceKey = `${current} -> ${next}`;
            
            const sequenceData = this.patterns.sequences.get(sequenceKey) || {
                count: 0,
                probability: 0,
                avgDelay: 0,
                contexts: []
            };
            
            sequenceData.count++;
            sequenceData.probability = Math.min(sequenceData.count / 100, 1.0);
            
            if (context.delays && context.delays[i]) {
                sequenceData.avgDelay = (sequenceData.avgDelay + context.delays[i]) / 2;
            }
            
            this.patterns.sequences.set(sequenceKey, sequenceData);
        }
        
        console.log(`🔗 Learned sequence: ${commands.length} commands`);
    }

    /**
     * Learn from errors
     */
    learnFromError(command, error, context = {}) {
        const commandKey = this.normalizeCommand(command);
        const errorKey = `${commandKey}:${this.categorizeError(error)}`;
        
        const errorData = this.patterns.errors.get(errorKey) || {
            count: 0,
            lastOccurrence: Date.now(),
            category: this.categorizeError(error),
            solutions: []
        };
        
        errorData.count++;
        errorData.lastOccurrence = Date.now();
        
        // Learn potential solutions
        if (context.solution) {
            errorData.solutions.push({
                solution: context.solution,
                timestamp: Date.now(),
                effectiveness: 1.0
            });
        }
        
        this.patterns.errors.set(errorKey, errorData);
        
        console.log(`❌ Learned error: ${errorKey} (count: ${errorData.count})`);
    }

    /**
     * Learn from resource usage
     */
    learnFromResources(command, resources, context = {}) {
        const commandKey = this.normalizeCommand(command);
        const resourceKey = commandKey;
        
        const resourceData = this.patterns.resources.get(resourceKey) || {
            avgCpuUsage: 0,
            avgMemoryUsage: 0,
            avgDiskIO: 0,
            avgNetworkIO: 0,
            samples: 0
        };
        
        resourceData.samples++;
        
        if (resources.cpu) {
            resourceData.avgCpuUsage = (resourceData.avgCpuUsage + resources.cpu) / resourceData.samples;
        }
        
        if (resources.memory) {
            resourceData.avgMemoryUsage = (resourceData.avgMemoryUsage + resources.memory) / resourceData.samples;
        }
        
        if (resources.diskIO) {
            resourceData.avgDiskIO = (resourceData.avgDiskIO + resources.diskIO) / resourceData.samples;
        }
        
        if (resources.networkIO) {
            resourceData.avgNetworkIO = (resourceData.avgNetworkIO + resources.networkIO) / resourceData.samples;
        }
        
        this.patterns.resources.set(resourceKey, resourceData);
        
        console.log(`📊 Learned resources: ${resourceKey}`);
    }

    /**
     * Predict next command based on patterns
     */
    predictNextCommand(currentCommand, context = {}) {
        const predictions = [];
        const currentKey = this.normalizeCommand(currentCommand);
        
        // Find sequence patterns
        for (const [sequenceKey, data] of this.patterns.sequences.entries()) {
            if (sequenceKey.startsWith(currentKey + ' ->')) {
                const nextCommand = sequenceKey.split(' -> ')[1];
                predictions.push({
                    command: nextCommand,
                    probability: data.probability,
                    confidence: Math.min(data.count / 10, 1.0),
                    type: 'sequence'
                });
            }
        }
        
        // Find timing patterns
        const currentHour = new Date().getHours();
        for (const [timingKey, count] of this.patterns.timing.entries()) {
            const [hour, command] = timingKey.split(':');
            if (parseInt(hour) === currentHour && command !== currentKey) {
                const commandData = this.patterns.commands.get(command);
                if (commandData && count >= this.config.minPatternOccurrence) {
                    predictions.push({
                        command: command,
                        probability: count / 100,
                        confidence: Math.min(count / 20, 1.0),
                        type: 'timing'
                    });
                }
            }
        }
        
        // Find context patterns
        if (context.workingDir) {
            for (const [contextKey, count] of this.patterns.contexts.entries()) {
                if (contextKey.startsWith(context.workingDir + ':')) {
                    const command = contextKey.split(':')[1];
                    if (command !== currentKey && count >= this.config.minPatternOccurrence) {
                        predictions.push({
                            command: command,
                            probability: count / 50,
                            confidence: Math.min(count / 15, 1.0),
                            type: 'context'
                        });
                    }
                }
            }
        }
        
        // Sort by confidence and probability
        predictions.sort((a, b) => (b.confidence * b.probability) - (a.confidence * a.probability));
        
        return predictions.slice(0, 5); // Top 5 predictions
    }

    /**
     * Get intelligent suggestions based on current context
     */
    getIntelligentSuggestions(context = {}) {
        const suggestions = [];
        const currentTime = new Date();
        const hour = currentTime.getHours();
        
        // Time-based suggestions
        if (this.isWorkingHours(hour)) {
            suggestions.push(...this.getWorkTimeSuggestions(context));
        } else {
            suggestions.push(...this.getOffTimeSuggestions(context));
        }
        
        // User role-based suggestions
        suggestions.push(...this.getRoleBasedSuggestions(context));
        
        // Error prevention suggestions
        suggestions.push(...this.getErrorPreventionSuggestions(context));
        
        // Efficiency suggestions
        suggestions.push(...this.getEfficiencySuggestions(context));
        
        // Learning suggestions
        suggestions.push(...this.getLearningSuggestions(context));
        
        return this.rankSuggestions(suggestions);
    }

    /**
     * Get work time suggestions
     */
    getWorkTimeSuggestions(context) {
        const suggestions = [];
        const hour = new Date().getHours();
        
        if (hour >= 9 && hour <= 10) {
            suggestions.push({
                type: 'routine',
                priority: 'high',
                suggestion: 'Start your day with system health check',
                command: 'udos system status',
                reason: 'Morning routine pattern detected'
            });
        }
        
        if (hour >= 17 && hour <= 18) {
            suggestions.push({
                type: 'routine',
                priority: 'medium',
                suggestion: 'End-of-day backup and cleanup',
                command: 'udos data backup && udos system cleanup',
                reason: 'Evening routine pattern detected'
            });
        }
        
        return suggestions;
    }

    /**
     * Get off-time suggestions
     */
    getOffTimeSuggestions(context) {
        const suggestions = [];
        
        suggestions.push({
            type: 'maintenance',
            priority: 'low',
            suggestion: 'Perfect time for system maintenance',
            command: 'udos system maintenance',
            reason: 'Off-hours optimal for maintenance'
        });
        
        return suggestions;
    }

    /**
     * Get role-based suggestions
     */
    getRoleBasedSuggestions(context) {
        const suggestions = [];
        
        switch (this.userProfile.role) {
            case 'ADMIN':
                suggestions.push({
                    type: 'admin',
                    priority: 'high',
                    suggestion: 'Check system logs for anomalies',
                    command: 'udos logs analyze',
                    reason: 'Admin role detected'
                });
                break;
                
            case 'USER':
                suggestions.push({
                    type: 'user',
                    priority: 'medium',
                    suggestion: 'Organize your workspace',
                    command: 'udos files organize',
                    reason: 'User productivity optimization'
                });
                break;
        }
        
        return suggestions;
    }

    /**
     * Get error prevention suggestions
     */
    getErrorPreventionSuggestions(context) {
        const suggestions = [];
        
        // Find commands with high error rates
        for (const [errorKey, errorData] of this.patterns.errors.entries()) {
            if (errorData.count > 3) {
                const [command] = errorKey.split(':');
                suggestions.push({
                    type: 'error_prevention',
                    priority: 'high',
                    suggestion: `Be careful with "${command}" - high error rate detected`,
                    command: command,
                    reason: `Command has failed ${errorData.count} times`,
                    solutions: errorData.solutions
                });
            }
        }
        
        return suggestions;
    }

    /**
     * Get efficiency suggestions
     */
    getEfficiencySuggestions(context) {
        const suggestions = [];
        
        // Find frequently used command sequences for automation
        for (const [sequenceKey, data] of this.patterns.sequences.entries()) {
            if (data.count > 10 && data.probability > 0.8) {
                suggestions.push({
                    type: 'automation',
                    priority: 'medium',
                    suggestion: `Consider automating: ${sequenceKey}`,
                    command: `udos workflow create`,
                    reason: `Sequence used ${data.count} times with ${Math.round(data.probability * 100)}% probability`
                });
            }
        }
        
        return suggestions;
    }

    /**
     * Get learning suggestions
     */
    getLearningSuggestions(context) {
        const suggestions = [];
        
        if (this.userProfile.experience === 'BEGINNER') {
            suggestions.push({
                type: 'learning',
                priority: 'medium',
                suggestion: 'Try exploring uDOS help system',
                command: 'udos help',
                reason: 'Beginner experience level detected'
            });
        }
        
        return suggestions;
    }

    /**
     * Rank suggestions by relevance and priority
     */
    rankSuggestions(suggestions) {
        const priorityWeights = { high: 3, medium: 2, low: 1 };
        
        return suggestions
            .map(s => ({
                ...s,
                score: priorityWeights[s.priority] || 1
            }))
            .sort((a, b) => b.score - a.score)
            .slice(0, 10);
    }

    // Utility methods
    normalizeCommand(command) {
        if (!command || typeof command !== 'string') return 'unknown';
        
        // Remove parameters and normalize to base command
        return command
            .split(' ')[0]
            .toLowerCase()
            .replace(/[^a-z0-9-]/g, '');
    }

    categorizeError(error) {
        if (!error || typeof error !== 'string') return 'unknown';
        
        const errorStr = error.toLowerCase();
        
        if (errorStr.includes('permission')) return 'permission';
        if (errorStr.includes('not found')) return 'notfound';
        if (errorStr.includes('syntax')) return 'syntax';
        if (errorStr.includes('network')) return 'network';
        if (errorStr.includes('timeout')) return 'timeout';
        if (errorStr.includes('disk') || errorStr.includes('space')) return 'disk';
        if (errorStr.includes('memory')) return 'memory';
        
        return 'general';
    }

    updateUserPreferences(command, context) {
        const preferences = this.userProfile.preferences;
        
        // Track preferred working directories
        if (context.workingDir) {
            const dirKey = 'preferred_dirs';
            const dirs = preferences.get(dirKey) || new Map();
            dirs.set(context.workingDir, (dirs.get(context.workingDir) || 0) + 1);
            preferences.set(dirKey, dirs);
        }
        
        // Track preferred time patterns
        const hour = new Date().getHours();
        const timeKey = 'active_hours';
        const hours = preferences.get(timeKey) || new Map();
        hours.set(hour, (hours.get(hour) || 0) + 1);
        preferences.set(timeKey, hours);
    }

    isWorkingHours(hour) {
        return hour >= this.userProfile.workingHours.start && 
               hour <= this.userProfile.workingHours.end;
    }

    cleanOldPatterns() {
        const cutoff = Date.now() - this.config.maxPatternAge;
        let cleaned = 0;
        
        // Clean old timing patterns
        for (const [key, data] of this.patterns.commands.entries()) {
            if (data.lastUsed < cutoff) {
                this.patterns.commands.delete(key);
                cleaned++;
            }
        }
        
        if (cleaned > 0) {
            console.log(`🧹 Cleaned ${cleaned} old patterns`);
            this.savePatterns();
        }
    }

    // Public API methods
    getPatternStats() {
        return {
            commands: this.patterns.commands.size,
            sequences: this.patterns.sequences.size,
            timing: this.patterns.timing.size,
            contexts: this.patterns.contexts.size,
            errors: this.patterns.errors.size,
            resources: this.patterns.resources.size,
            userProfile: this.userProfile
        };
    }

    exportPatterns() {
        const data = {
            timestamp: new Date().toISOString(),
            patterns: {},
            userProfile: this.userProfile,
            stats: this.getPatternStats()
        };
        
        Object.keys(this.patterns).forEach(key => {
            data.patterns[key] = Array.from(this.patterns[key].entries());
        });
        
        return JSON.stringify(data, null, 2);
    }

    importPatterns(jsonData) {
        try {
            const data = JSON.parse(jsonData);
            
            Object.keys(data.patterns).forEach(key => {
                if (this.patterns[key]) {
                    this.patterns[key] = new Map(data.patterns[key]);
                }
            });
            
            if (data.userProfile) {
                this.userProfile = { ...this.userProfile, ...data.userProfile };
            }
            
            this.savePatterns();
            console.log('✅ Patterns imported successfully');
            
        } catch (error) {
            throw new Error(`Failed to import patterns: ${error.message}`);
        }
    }
}

// CLI Interface
if (require.main === module) {
    const ai = new AIPatternRecognition();
    const command = process.argv[2];
    const args = process.argv.slice(3);

    switch (command) {
        case 'learn':
            if (args.length >= 1) {
                const commandStr = args[0];
                const context = args[1] ? JSON.parse(args[1]) : {};
                ai.learnFromCommand(commandStr, context);
                console.log(`✅ Learned from command: ${commandStr}`);
            } else {
                console.log('Usage: udos-m4-ai.js learn <command> [context-json]');
            }
            break;

        case 'predict':
            if (args[0]) {
                const predictions = ai.predictNextCommand(args[0]);
                console.log('\n🔮 Predictions:');
                predictions.forEach((p, i) => {
                    console.log(`  ${i + 1}. ${p.command} (${Math.round(p.probability * 100)}% ${p.type})`);
                });
            } else {
                console.log('Usage: udos-m4-ai.js predict <current-command>');
            }
            break;

        case 'suggest':
            const context = args[0] ? JSON.parse(args[0]) : {};
            const suggestions = ai.getIntelligentSuggestions(context);
            console.log('\n💡 AI Suggestions:');
            suggestions.forEach((s, i) => {
                console.log(`  ${i + 1}. [${s.priority.toUpperCase()}] ${s.suggestion}`);
                console.log(`     Command: ${s.command}`);
                console.log(`     Reason: ${s.reason}\n`);
            });
            break;

        case 'stats':
            const stats = ai.getPatternStats();
            console.log('\n📊 Pattern Statistics:');
            console.log(`  Commands: ${stats.commands}`);
            console.log(`  Sequences: ${stats.sequences}`);
            console.log(`  Timing patterns: ${stats.timing}`);
            console.log(`  Context patterns: ${stats.contexts}`);
            console.log(`  Error patterns: ${stats.errors}`);
            console.log(`  Resource patterns: ${stats.resources}`);
            console.log(`  User role: ${stats.userProfile.role}`);
            console.log(`  Experience: ${stats.userProfile.experience}`);
            break;

        case 'export':
            const exported = ai.exportPatterns();
            console.log(exported);
            break;

        case 'import':
            if (args[0]) {
                try {
                    ai.importPatterns(args[0]);
                } catch (error) {
                    console.error('❌ Import failed:', error.message);
                }
            } else {
                console.log('Usage: udos-m4-ai.js import <json-data>');
            }
            break;

        default:
            console.log(`
🧠 uDOS M4 AI Pattern Recognition System

Usage:
  udos-m4-ai.js learn <command> [context]  - Learn from command execution
  udos-m4-ai.js predict <command>          - Predict next commands
  udos-m4-ai.js suggest [context]          - Get intelligent suggestions
  udos-m4-ai.js stats                      - Show pattern statistics
  udos-m4-ai.js export                     - Export patterns as JSON
  udos-m4-ai.js import <json>              - Import patterns from JSON

Examples:
  udos-m4-ai.js learn "udos system status"
  udos-m4-ai.js predict "udos data"
  udos-m4-ai.js suggest '{"workingDir":"/home/user"}'
            `);
    }
}

module.exports = AIPatternRecognition;
