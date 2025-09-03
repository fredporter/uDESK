#!/usr/bin/env node
/**
 * uDOS M4 Natural Language Processing
 * Convert natural language queries to uDOS commands
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class NaturalLanguageProcessor {
    constructor() {
        this.config = {
            dataDir: '/tmp/udos-m4-data',
            patternsFile: '/tmp/udos-m4-nlp-patterns.json',
            confidence_threshold: 0.6
        };
        
        this.commandMappings = new Map();
        this.intentPatterns = new Map();
        this.entityExtractors = new Map();
        this.conversationContext = [];
        
        this.initializeNLP();
        console.log('🗣️  Natural Language Processor initialized');
    }

    /**
     * Initialize the NLP system
     */
    initializeNLP() {
        this.loadCommandMappings();
        this.loadIntentPatterns();
        this.setupEntityExtractors();
        this.loadConversationHistory();
    }

    /**
     * Load command mappings for natural language
     */
    loadCommandMappings() {
        const mappings = [
            // System commands
            { patterns: ['status', 'health', 'check system', 'system status'], command: 'udos info', category: 'system' },
            { patterns: ['test', 'check', 'verify', 'run test'], command: 'udos test', category: 'system' },
            { patterns: ['update', 'upgrade', 'get latest'], command: 'udos update', category: 'system' },
            { patterns: ['version', 'what version', 'current version'], command: 'udos version', category: 'system' },
            { patterns: ['help', 'how to', 'commands', 'what can you do'], command: 'udos help', category: 'help' },
            
            // Data commands
            { patterns: ['backup', 'backup data', 'save data', 'backup files'], command: 'udos data backup', category: 'data' },
            { patterns: ['list data', 'show data', 'data files', 'what data'], command: 'udos data list', category: 'data' },
            { patterns: ['backup and list', 'backup then list'], command: 'udos data backup && udos data list', category: 'data' },
            
            // Variable commands
            { patterns: ['set variable', 'create variable', 'store value'], command: 'udos var set', category: 'variables' },
            { patterns: ['get variable', 'show variable', 'variable value'], command: 'udos var get', category: 'variables' },
            { patterns: ['list variables', 'show variables', 'all variables'], command: 'udos var list', category: 'variables' },
            
            // Template commands
            { patterns: ['create template', 'new template', 'generate template'], command: 'udos tpl create', category: 'templates' },
            { patterns: ['list templates', 'show templates', 'available templates'], command: 'udos tpl list', category: 'templates' },
            
            // Role commands
            { patterns: ['detect role', 'what role', 'my role', 'user role'], command: 'udos role detect', category: 'role' },
            { patterns: ['role info', 'role details', 'show role'], command: 'udos role info', category: 'role' },
            
            // M3 Desktop commands
            { patterns: ['list windows', 'show windows', 'open windows'], command: 'udos m3 window list', category: 'm3' },
            { patterns: ['focus window', 'switch window', 'activate window'], command: 'udos m3 window focus', category: 'm3' },
            { patterns: ['move window', 'position window', 'window position'], command: 'udos m3 window move', category: 'm3' },
            { patterns: ['test m3', 'test desktop', 'm3 test'], command: 'udos m3 test', category: 'm3' },
            
            // M4 AI commands
            { patterns: ['ai suggestions', 'suggest', 'recommendations', 'what should i do'], command: 'udos m4 ai suggest', category: 'm4' },
            { patterns: ['ai learn', 'learn from', 'teach ai'], command: 'udos m4 ai learn', category: 'm4' },
            { patterns: ['predict commands', 'what next', 'next command'], command: 'udos m4 ai predict', category: 'm4' },
            { patterns: ['ai stats', 'ai statistics', 'pattern stats'], command: 'udos m4 ai stats', category: 'm4' },
            
            // M4 Workflow commands
            { patterns: ['list workflows', 'show workflows', 'automation workflows'], command: 'udos m4 workflow list', category: 'm4' },
            { patterns: ['create workflow', 'new workflow', 'automate'], command: 'udos m4 workflow create', category: 'm4' },
            { patterns: ['run workflow', 'execute workflow', 'start automation'], command: 'udos m4 workflow run', category: 'm4' },
            
            // M4 Template commands
            { patterns: ['list templates', 'available templates', 'template list'], command: 'udos m4 template list', category: 'm4' },
            { patterns: ['generate from template', 'use template', 'create from template'], command: 'udos m4 template generate', category: 'm4' },
            { patterns: ['suggest templates', 'template suggestions', 'recommended templates'], command: 'udos m4 template suggest', category: 'm4' },
            { patterns: ['learn template', 'create template from file'], command: 'udos m4 template learn', category: 'm4' },
            
            // Complex operations
            { patterns: ['full system check', 'complete check', 'comprehensive test'], command: 'udos test && udos info && udos data list', category: 'complex' },
            { patterns: ['backup and status', 'backup then status'], command: 'udos data backup && udos info', category: 'complex' },
            { patterns: ['setup workspace', 'prepare environment'], command: 'udos init && udos role detect && udos test', category: 'complex' },
        ];

        mappings.forEach(mapping => {
            mapping.patterns.forEach(pattern => {
                this.commandMappings.set(pattern.toLowerCase(), {
                    command: mapping.command,
                    category: mapping.category,
                    confidence: 1.0
                });
            });
        });

        console.log(`📚 Loaded ${mappings.length} command mapping groups`);
    }

    /**
     * Load intent recognition patterns
     */
    loadIntentPatterns() {
        const intents = [
            // Action intents
            { intent: 'action_backup', patterns: ['backup', 'save', 'archive', 'preserve'] },
            { intent: 'action_list', patterns: ['list', 'show', 'display', 'view', 'see'] },
            { intent: 'action_create', patterns: ['create', 'make', 'new', 'generate', 'build'] },
            { intent: 'action_test', patterns: ['test', 'check', 'verify', 'validate', 'examine'] },
            { intent: 'action_run', patterns: ['run', 'execute', 'start', 'launch', 'perform'] },
            { intent: 'action_get', patterns: ['get', 'fetch', 'retrieve', 'obtain', 'find'] },
            { intent: 'action_set', patterns: ['set', 'configure', 'define', 'establish', 'assign'] },
            { intent: 'action_update', patterns: ['update', 'upgrade', 'refresh', 'sync'] },
            
            // Object intents
            { intent: 'object_data', patterns: ['data', 'files', 'information', 'content'] },
            { intent: 'object_system', patterns: ['system', 'os', 'environment', 'platform'] },
            { intent: 'object_window', patterns: ['window', 'app', 'application', 'program'] },
            { intent: 'object_template', patterns: ['template', 'pattern', 'blueprint', 'scaffold'] },
            { intent: 'object_workflow', patterns: ['workflow', 'automation', 'process', 'procedure'] },
            { intent: 'object_variable', patterns: ['variable', 'var', 'setting', 'config', 'parameter'] },
            
            // Question intents
            { intent: 'question_what', patterns: ['what', 'which', 'what is', 'what are'] },
            { intent: 'question_how', patterns: ['how', 'how to', 'how do', 'how can'] },
            { intent: 'question_where', patterns: ['where', 'where is', 'where are'] },
            { intent: 'question_when', patterns: ['when', 'when is', 'when should'] },
            { intent: 'question_why', patterns: ['why', 'why is', 'why should'] },
            
            // Emotion/urgency intents
            { intent: 'urgency_high', patterns: ['urgent', 'quickly', 'asap', 'immediately', 'now'] },
            { intent: 'urgency_normal', patterns: ['please', 'can you', 'could you', 'would you'] },
            { intent: 'politeness', patterns: ['please', 'thank you', 'thanks', 'appreciate'] }
        ];

        intents.forEach(intent => {
            intent.patterns.forEach(pattern => {
                if (!this.intentPatterns.has(intent.intent)) {
                    this.intentPatterns.set(intent.intent, []);
                }
                this.intentPatterns.get(intent.intent).push(pattern.toLowerCase());
            });
        });

        console.log(`🎯 Loaded ${intents.length} intent pattern groups`);
    }

    /**
     * Setup entity extractors
     */
    setupEntityExtractors() {
        // Window names extractor
        this.entityExtractors.set('window_name', {
            patterns: [
                /(?:window|app|application)\s+(?:named|called)?\s*["']?([^"'\s]+)["']?/i,
                /focus\s+["']?([^"'\s]+)["']?/i,
                /switch\s+to\s+["']?([^"'\s]+)["']?/i
            ],
            extract: (text) => {
                for (const pattern of this.entityExtractors.get('window_name').patterns) {
                    const match = text.match(pattern);
                    if (match) return match[1];
                }
                return null;
            }
        });

        // Variable names and values extractor
        this.entityExtractors.set('variable', {
            patterns: [
                /(?:variable|var)\s+["']?([^"'\s=]+)["']?(?:\s*=\s*["']?([^"']+)["']?)?/i,
                /set\s+["']?([^"'\s=]+)["']?\s*=\s*["']?([^"']+)["']?/i,
                /["']?([^"'\s=]+)["']?\s*=\s*["']?([^"']+)["']?/i
            ],
            extract: (text) => {
                for (const pattern of this.entityExtractors.get('variable').patterns) {
                    const match = text.match(pattern);
                    if (match) {
                        return { name: match[1], value: match[2] || null };
                    }
                }
                return null;
            }
        });

        // File paths extractor
        this.entityExtractors.set('file_path', {
            patterns: [
                /(?:file|path|directory)\s+["']?([^\s"']+)["']?/i,
                /["']?([^\s"']*\/[^\s"']*)["']?/,
                /["']?([^\s"']*\.[a-zA-Z0-9]{1,4})["']?/
            ],
            extract: (text) => {
                for (const pattern of this.entityExtractors.get('file_path').patterns) {
                    const match = text.match(pattern);
                    if (match) return match[1];
                }
                return null;
            }
        });

        // Numbers extractor
        this.entityExtractors.set('number', {
            patterns: [
                /(\d+)/g
            ],
            extract: (text) => {
                const matches = text.match(/\d+/g);
                return matches ? matches.map(Number) : [];
            }
        });

        console.log(`🔍 Setup ${this.entityExtractors.size} entity extractors`);
    }

    /**
     * Load conversation history
     */
    loadConversationHistory() {
        try {
            const historyFile = path.join(this.config.dataDir, 'conversation-history.json');
            if (fs.existsSync(historyFile)) {
                this.conversationContext = JSON.parse(fs.readFileSync(historyFile, 'utf8'));
                // Keep only last 10 interactions
                this.conversationContext = this.conversationContext.slice(-10);
            }
        } catch (error) {
            console.warn('Could not load conversation history:', error.message);
        }
    }

    /**
     * Save conversation history
     */
    saveConversationHistory() {
        try {
            const historyFile = path.join(this.config.dataDir, 'conversation-history.json');
            fs.mkdirSync(path.dirname(historyFile), { recursive: true });
            fs.writeFileSync(historyFile, JSON.stringify(this.conversationContext, null, 2));
        } catch (error) {
            console.warn('Could not save conversation history:', error.message);
        }
    }

    /**
     * Process natural language query
     */
    processQuery(query) {
        const timestamp = new Date().toISOString();
        const normalizedQuery = this.normalizeQuery(query);
        
        console.log(`🗣️  Processing: "${query}"`);
        
        // Extract intents and entities
        const intents = this.extractIntents(normalizedQuery);
        const entities = this.extractEntities(normalizedQuery);
        
        // Find command matches
        const commandMatches = this.findCommandMatches(normalizedQuery);
        
        // Generate response
        const response = this.generateResponse(query, normalizedQuery, intents, entities, commandMatches);
        
        // Save to conversation context
        this.conversationContext.push({
            timestamp,
            query: query,
            normalized: normalizedQuery,
            intents,
            entities,
            commands: response.commands,
            executed: false
        });
        
        this.saveConversationHistory();
        
        return response;
    }

    /**
     * Normalize query text
     */
    normalizeQuery(query) {
        return query
            .toLowerCase()
            .replace(/[^\w\s]/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();
    }

    /**
     * Extract intents from query
     */
    extractIntents(query) {
        const foundIntents = [];
        
        for (const [intent, patterns] of this.intentPatterns.entries()) {
            for (const pattern of patterns) {
                if (query.includes(pattern)) {
                    foundIntents.push({
                        intent,
                        pattern,
                        confidence: this.calculateMatchConfidence(query, pattern)
                    });
                }
            }
        }
        
        // Sort by confidence
        return foundIntents
            .sort((a, b) => b.confidence - a.confidence)
            .slice(0, 5);
    }

    /**
     * Extract entities from query
     */
    extractEntities(query) {
        const entities = {};
        
        for (const [entityType, extractor] of this.entityExtractors.entries()) {
            const extracted = extractor.extract(query);
            if (extracted) {
                entities[entityType] = extracted;
            }
        }
        
        return entities;
    }

    /**
     * Find command matches
     */
    findCommandMatches(query) {
        const matches = [];
        
        // Exact pattern matches
        for (const [pattern, mapping] of this.commandMappings.entries()) {
            if (query.includes(pattern)) {
                matches.push({
                    pattern,
                    command: mapping.command,
                    category: mapping.category,
                    confidence: this.calculateMatchConfidence(query, pattern),
                    type: 'exact'
                });
            }
        }
        
        // Fuzzy matches (word overlap)
        for (const [pattern, mapping] of this.commandMappings.entries()) {
            const overlap = this.calculateWordOverlap(query, pattern);
            if (overlap > 0.4 && !matches.find(m => m.pattern === pattern)) {
                matches.push({
                    pattern,
                    command: mapping.command,
                    category: mapping.category,
                    confidence: overlap,
                    type: 'fuzzy'
                });
            }
        }
        
        // Sort by confidence
        return matches
            .sort((a, b) => b.confidence - a.confidence)
            .slice(0, 3);
    }

    /**
     * Generate response with commands
     */
    generateResponse(originalQuery, normalizedQuery, intents, entities, commandMatches) {
        const response = {
            understood: commandMatches.length > 0,
            confidence: commandMatches.length > 0 ? commandMatches[0].confidence : 0,
            commands: [],
            explanation: '',
            suggestions: []
        };

        if (commandMatches.length > 0) {
            const bestMatch = commandMatches[0];
            
            // Build command with entities
            let command = bestMatch.command;
            
            // Add entities to command
            if (entities.window_name && command.includes('window')) {
                command += ` "${entities.window_name}"`;
            }
            
            if (entities.variable && command.includes('var')) {
                if (entities.variable.value) {
                    command += ` "${entities.variable.name}=${entities.variable.value}"`;
                } else {
                    command += ` "${entities.variable.name}"`;
                }
            }
            
            if (entities.file_path && (command.includes('template') || command.includes('data'))) {
                command += ` "${entities.file_path}"`;
            }
            
            if (entities.number && entities.number.length >= 2 && command.includes('move')) {
                command += ` ${entities.number[0]} ${entities.number[1]}`;
            }
            
            response.commands.push({
                command,
                category: bestMatch.category,
                confidence: bestMatch.confidence,
                reasoning: `Matched pattern: "${bestMatch.pattern}" (${bestMatch.type})`
            });
            
            response.explanation = this.generateExplanation(originalQuery, bestMatch, entities);
            
            // Add alternative commands
            if (commandMatches.length > 1) {
                commandMatches.slice(1).forEach(match => {
                    response.suggestions.push({
                        command: match.command,
                        confidence: match.confidence,
                        reasoning: `Alternative: "${match.pattern}"`
                    });
                });
            }
        } else {
            response.explanation = "I couldn't understand that request. Here are some things you can try:";
            response.suggestions = this.generateHelpSuggestions(intents, entities);
        }

        return response;
    }

    /**
     * Generate explanation for the command
     */
    generateExplanation(query, match, entities) {
        let explanation = `I'll ${match.command.replace('udos ', '')}`;
        
        if (entities.window_name) {
            explanation += ` for window "${entities.window_name}"`;
        }
        
        if (entities.variable) {
            if (entities.variable.value) {
                explanation += ` and set ${entities.variable.name} to ${entities.variable.value}`;
            } else {
                explanation += ` for variable ${entities.variable.name}`;
            }
        }
        
        if (entities.file_path) {
            explanation += ` using file ${entities.file_path}`;
        }
        
        explanation += `.`;
        
        return explanation;
    }

    /**
     * Generate helpful suggestions
     */
    generateHelpSuggestions(intents, entities) {
        const suggestions = [];
        
        // Intent-based suggestions
        const hasActionIntent = intents.find(i => i.intent.startsWith('action_'));
        const hasObjectIntent = intents.find(i => i.intent.startsWith('object_'));
        
        if (hasActionIntent && hasObjectIntent) {
            const action = hasActionIntent.intent.replace('action_', '');
            const object = hasObjectIntent.intent.replace('object_', '');
            
            suggestions.push({
                command: `udos ${object} ${action}`,
                confidence: 0.7,
                reasoning: `Try: "${action}" action on "${object}"`
            });
        }
        
        // General suggestions
        suggestions.push(
            { command: 'udos help', confidence: 0.9, reasoning: 'Get list of all commands' },
            { command: 'udos m4 ai suggest', confidence: 0.8, reasoning: 'Get AI-powered suggestions' },
            { command: 'udos test', confidence: 0.7, reasoning: 'Test system functionality' }
        );
        
        return suggestions;
    }

    /**
     * Calculate match confidence
     */
    calculateMatchConfidence(query, pattern) {
        const queryWords = query.split(' ');
        const patternWords = pattern.split(' ');
        
        let matches = 0;
        patternWords.forEach(word => {
            if (queryWords.includes(word)) {
                matches++;
            }
        });
        
        return matches / patternWords.length;
    }

    /**
     * Calculate word overlap
     */
    calculateWordOverlap(text1, text2) {
        const words1 = new Set(text1.split(' '));
        const words2 = new Set(text2.split(' '));
        
        let overlap = 0;
        words1.forEach(word => {
            if (words2.has(word)) overlap++;
        });
        
        return overlap / Math.max(words1.size, words2.size);
    }

    /**
     * Execute commands with confirmation
     */
    async executeCommands(commands, options = {}) {
        const results = [];
        
        for (const cmd of commands) {
            try {
                console.log(`\n🚀 Executing: ${cmd.command}`);
                
                if (!options.autoConfirm) {
                    // In a real implementation, you might want user confirmation
                    console.log(`   Reason: ${cmd.reasoning}`);
                    console.log(`   Confidence: ${Math.round(cmd.confidence * 100)}%`);
                }
                
                const output = execSync(cmd.command, { 
                    encoding: 'utf8',
                    timeout: 30000
                });
                
                results.push({
                    command: cmd.command,
                    success: true,
                    output: output.trim()
                });
                
            } catch (error) {
                console.error(`❌ Command failed: ${error.message}`);
                results.push({
                    command: cmd.command,
                    success: false,
                    error: error.message
                });
            }
        }
        
        return results;
    }

    /**
     * Get conversation context
     */
    getConversationContext(limit = 5) {
        return this.conversationContext.slice(-limit);
    }

    /**
     * Clear conversation context
     */
    clearConversationContext() {
        this.conversationContext = [];
        this.saveConversationHistory();
    }
}

// CLI Interface
if (require.main === module) {
    const nlp = new NaturalLanguageProcessor();
    const query = process.argv.slice(2).join(' ');

    if (!query) {
        console.log(`
🗣️  uDOS M4 Natural Language Processing

Usage:
  udos m4 nlp <natural language query>

Examples:
  udos m4 nlp "backup my data"
  udos m4 nlp "show system status"
  udos m4 nlp "list all windows"
  udos m4 nlp "create a new template"
  udos m4 nlp "set variable name to value"
  udos m4 nlp "what can you do?"

Supported Actions:
  • System operations (status, test, update)
  • Data management (backup, list)
  • Variable management (set, get, list)
  • Window management (list, focus, move)
  • Template operations (create, list, generate)
  • Workflow automation (create, run, list)
  • AI assistance (suggest, learn, predict)
        `);
        process.exit(0);
    }

    try {
        const response = nlp.processQuery(query);
        
        console.log(`\n🤖 Natural Language Processing Result:`);
        console.log(`───────────────────────────────────────`);
        
        if (response.understood) {
            console.log(`✅ Understood: ${response.explanation}`);
            console.log(`📊 Confidence: ${Math.round(response.confidence * 100)}%`);
            
            if (response.commands.length > 0) {
                console.log(`\n💻 Recommended Commands:`);
                response.commands.forEach((cmd, i) => {
                    console.log(`  ${i + 1}. ${cmd.command}`);
                    console.log(`     ${cmd.reasoning} (${Math.round(cmd.confidence * 100)}%)`);
                });
                
                // Ask if user wants to execute
                console.log(`\n🚀 To execute the top command, run:`);
                console.log(`     ${response.commands[0].command}`);
            }
            
            if (response.suggestions.length > 0) {
                console.log(`\n💡 Other Suggestions:`);
                response.suggestions.forEach((sug, i) => {
                    console.log(`  ${i + 1}. ${sug.command} (${Math.round(sug.confidence * 100)}%)`);
                });
            }
        } else {
            console.log(`❌ Could not understand: "${query}"`);
            console.log(`\n💡 Try these instead:`);
            response.suggestions.forEach((sug, i) => {
                console.log(`  ${i + 1}. ${sug.command}`);
                console.log(`     ${sug.reasoning}`);
            });
        }
        
    } catch (error) {
        console.error('❌ NLP Error:', error.message);
        process.exit(1);
    }
}

module.exports = NaturalLanguageProcessor;
