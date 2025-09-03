#!/usr/bin/env node
/**
 * uDOS M4 Smart Template Generator
 * AI-powered template creation and management system
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

class SmartTemplateGenerator {
    constructor() {
        this.config = {
            templatesDir: '/etc/udos/templates',
            userTemplatesDir: '/tmp/udos-m4-templates',
            dataDir: '/tmp/udos-m4-data',
            maxTemplateSize: 1024 * 1024, // 1MB
            supportedFormats: ['bash', 'python', 'javascript', 'json', 'yaml', 'markdown', 'html', 'css']
        };
        
        this.templates = new Map();
        this.patterns = new Map();
        this.usage = new Map();
        
        this.initializeTemplates();
        console.log('📄 Smart Template Generator initialized');
    }

    /**
     * Initialize the template system
     */
    initializeTemplates() {
        this.ensureDirectories();
        this.loadBuiltinTemplates();
        this.loadUserTemplates();
        this.initializePatterns();
    }

    /**
     * Ensure required directories exist
     */
    ensureDirectories() {
        const dirs = [this.config.templatesDir, this.config.userTemplatesDir, this.config.dataDir];
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
     * Load built-in templates
     */
    loadBuiltinTemplates() {
        const builtinTemplates = [
            {
                id: 'bash-script',
                name: 'Bash Script',
                description: 'Basic bash script template',
                category: 'script',
                language: 'bash',
                template: `#!/bin/bash
# {{DESCRIPTION}}
# Created: {{DATE}}
# Author: {{AUTHOR}}

set -e  # Exit on error

# Configuration
{{#if CONFIG}}
{{CONFIG}}
{{/if}}

# Functions
{{#if FUNCTIONS}}
{{FUNCTIONS}}
{{else}}
function main() {
    echo "Starting {{NAME}}..."
    
    {{MAIN_CONTENT}}
    
    echo "{{NAME}} completed successfully!"
}
{{/if}}

# Main execution
{{#if CUSTOM_MAIN}}
{{CUSTOM_MAIN}}
{{else}}
main "$@"
{{/if}}`,
                variables: ['DESCRIPTION', 'AUTHOR', 'NAME', 'MAIN_CONTENT', 'CONFIG', 'FUNCTIONS', 'CUSTOM_MAIN'],
                tags: ['script', 'bash', 'automation']
            },
            {
                id: 'python-script',
                name: 'Python Script',
                description: 'Python script template with best practices',
                category: 'script',
                language: 'python',
                template: `#!/usr/bin/env python3
"""
{{DESCRIPTION}}
Created: {{DATE}}
Author: {{AUTHOR}}
"""

import sys
import argparse
{{#if IMPORTS}}
{{IMPORTS}}
{{/if}}

def main():
    """Main function."""
    parser = argparse.ArgumentParser(description='{{DESCRIPTION}}')
    {{#if ARGS}}
    {{ARGS}}
    {{else}}
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose output')
    {{/if}}
    
    args = parser.parse_args()
    
    try:
        {{MAIN_CONTENT}}
        print("✅ {{NAME}} completed successfully!")
        return 0
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        return 1

if __name__ == '__main__':
    sys.exit(main())`,
                variables: ['DESCRIPTION', 'AUTHOR', 'NAME', 'MAIN_CONTENT', 'IMPORTS', 'ARGS'],
                tags: ['script', 'python', 'automation']
            },
            {
                id: 'udos-extension',
                name: 'uDOS Extension',
                description: 'Template for creating uDOS extensions',
                category: 'udos',
                language: 'javascript',
                template: `#!/usr/bin/env node
/**
 * uDOS Extension: {{NAME}}
 * {{DESCRIPTION}}
 * Created: {{DATE}}
 * Author: {{AUTHOR}}
 */

class {{CLASS_NAME}} {
    constructor() {
        this.name = '{{NAME}}';
        this.version = '{{VERSION}}';
        this.description = '{{DESCRIPTION}}';
        this.commands = new Map();
        
        this.initialize();
    }

    initialize() {
        console.log(\`🔌 Loading extension: \${this.name} v\${this.version}\`);
        
        {{#if COMMANDS}}
        {{COMMANDS}}
        {{else}}
        // Register default command
        this.commands.set('{{DEFAULT_COMMAND}}', this.defaultCommand.bind(this));
        {{/if}}
    }

    defaultCommand(args = []) {
        console.log(\`🚀 Executing \${this.name}...\`);
        
        {{MAIN_CONTENT}}
        
        console.log(\`✅ \${this.name} completed!\`);
        return { success: true, message: 'Command executed successfully' };
    }

    {{#if CUSTOM_METHODS}}
    {{CUSTOM_METHODS}}
    {{/if}}

    // Extension API
    getCommands() {
        return Array.from(this.commands.keys());
    }

    executeCommand(command, args = []) {
        const handler = this.commands.get(command);
        if (!handler) {
            throw new Error(\`Unknown command: \${command}\`);
        }
        return handler(args);
    }

    getInfo() {
        return {
            name: this.name,
            version: this.version,
            description: this.description,
            commands: this.getCommands()
        };
    }
}

// CLI Interface
if (require.main === module) {
    const extension = new {{CLASS_NAME}}();
    const command = process.argv[2] || '{{DEFAULT_COMMAND}}';
    const args = process.argv.slice(3);

    try {
        const result = extension.executeCommand(command, args);
        if (result && result.message) {
            console.log(result.message);
        }
        process.exit(result && result.success ? 0 : 1);
    } catch (error) {
        console.error(\`❌ Error: \${error.message}\`);
        process.exit(1);
    }
}

module.exports = {{CLASS_NAME}};`,
                variables: ['NAME', 'CLASS_NAME', 'DESCRIPTION', 'AUTHOR', 'VERSION', 'MAIN_CONTENT', 'COMMANDS', 'DEFAULT_COMMAND', 'CUSTOM_METHODS'],
                tags: ['udos', 'extension', 'javascript']
            },
            {
                id: 'workflow-definition',
                name: 'Workflow Definition',
                description: 'JSON template for uDOS M4 workflows',
                category: 'workflow',
                language: 'json',
                template: `{
  "name": "{{NAME}}",
  "description": "{{DESCRIPTION}}",
  "version": "{{VERSION}}",
  "author": "{{AUTHOR}}",
  "created": "{{DATE}}",
  "enabled": true,
  "triggers": [
    {{#if TRIGGERS}}
    {{TRIGGERS}}
    {{else}}
    {
      "type": "{{TRIGGER_TYPE}}",
      "{{TRIGGER_KEY}}": "{{TRIGGER_VALUE}}"
    }
    {{/if}}
  ],
  "conditions": [
    {{#if CONDITIONS}}
    {{CONDITIONS}}
    {{/if}}
  ],
  "actions": [
    {{#if ACTIONS}}
    {{ACTIONS}}
    {{else}}
    {
      "type": "command",
      "command": "{{DEFAULT_COMMAND}}",
      "timeout": 30000,
      "stopOnError": true
    }
    {{/if}}
  ],
  "variables": {
    {{#if VARIABLES}}
    {{VARIABLES}}
    {{/if}}
  },
  "metadata": {
    "category": "{{CATEGORY}}",
    "tags": [{{#if TAGS}}"{{TAGS}}"{{else}}"automation"{{/if}}],
    "complexity": "{{COMPLEXITY}}"
  }
}`,
                variables: ['NAME', 'DESCRIPTION', 'VERSION', 'AUTHOR', 'TRIGGERS', 'CONDITIONS', 'ACTIONS', 'VARIABLES', 'CATEGORY', 'TAGS', 'COMPLEXITY', 'TRIGGER_TYPE', 'TRIGGER_KEY', 'TRIGGER_VALUE', 'DEFAULT_COMMAND'],
                tags: ['workflow', 'json', 'automation']
            },
            {
                id: 'config-file',
                name: 'Configuration File',
                description: 'YAML configuration template',
                category: 'config',
                language: 'yaml',
                template: `# {{NAME}} Configuration
# {{DESCRIPTION}}
# Created: {{DATE}}
# Author: {{AUTHOR}}

# Application settings
app:
  name: "{{APP_NAME}}"
  version: "{{VERSION}}"
  debug: {{DEBUG}}
  
# Server configuration
{{#if SERVER_CONFIG}}
server:
{{SERVER_CONFIG}}
{{else}}
server:
  host: "{{HOST}}"
  port: {{PORT}}
  timeout: {{TIMEOUT}}
{{/if}}

# Database settings
{{#if DATABASE_CONFIG}}
database:
{{DATABASE_CONFIG}}
{{else}}
database:
  type: "{{DB_TYPE}}"
  host: "{{DB_HOST}}"
  port: {{DB_PORT}}
  name: "{{DB_NAME}}"
{{/if}}

# Logging configuration
logging:
  level: "{{LOG_LEVEL}}"
  file: "{{LOG_FILE}}"
  format: "{{LOG_FORMAT}}"

# Custom settings
{{#if CUSTOM_CONFIG}}
{{CUSTOM_CONFIG}}
{{/if}}`,
                variables: ['NAME', 'DESCRIPTION', 'AUTHOR', 'APP_NAME', 'VERSION', 'DEBUG', 'HOST', 'PORT', 'TIMEOUT', 'DB_TYPE', 'DB_HOST', 'DB_PORT', 'DB_NAME', 'LOG_LEVEL', 'LOG_FILE', 'LOG_FORMAT', 'SERVER_CONFIG', 'DATABASE_CONFIG', 'CUSTOM_CONFIG'],
                tags: ['config', 'yaml', 'settings']
            }
        ];

        builtinTemplates.forEach(template => {
            template.builtin = true;
            template.created = new Date().toISOString();
            this.templates.set(template.id, template);
        });

        console.log(`📚 Loaded ${builtinTemplates.length} built-in templates`);
    }

    /**
     * Load user-created templates
     */
    loadUserTemplates() {
        try {
            if (fs.existsSync(this.config.userTemplatesDir)) {
                const files = fs.readdirSync(this.config.userTemplatesDir);
                files.filter(f => f.endsWith('.json')).forEach(file => {
                    try {
                        const templatePath = path.join(this.config.userTemplatesDir, file);
                        const template = JSON.parse(fs.readFileSync(templatePath, 'utf8'));
                        template.builtin = false;
                        this.templates.set(template.id, template);
                    } catch (error) {
                        console.error(`❌ Failed to load template ${file}:`, error.message);
                    }
                });
            }
        } catch (error) {
            console.warn('⚠️  Could not load user templates:', error.message);
        }
    }

    /**
     * Initialize pattern recognition for smart suggestions
     */
    initializePatterns() {
        this.patterns.set('file_extensions', new Map());
        this.patterns.set('directory_patterns', new Map());
        this.patterns.set('content_patterns', new Map());
        this.patterns.set('naming_patterns', new Map());
        
        console.log('🧠 Template patterns initialized');
    }

    /**
     * Generate content from template
     */
    generateFromTemplate(templateId, variables = {}, options = {}) {
        const template = this.templates.get(templateId);
        if (!template) {
            throw new Error(`Template not found: ${templateId}`);
        }

        // Add default variables
        const allVariables = {
            DATE: new Date().toISOString().split('T')[0],
            TIMESTAMP: new Date().toISOString(),
            AUTHOR: options.author || process.env.USER || 'Unknown',
            ...variables
        };

        // Process template
        let content = template.template;
        
        // Handle conditional blocks
        content = this.processConditionals(content, allVariables);
        
        // Replace variables
        content = this.replaceVariables(content, allVariables);
        
        // Track usage
        this.trackUsage(templateId, allVariables);
        
        console.log(`📄 Generated content from template: ${template.name}`);
        
        return {
            content,
            template: template,
            variables: allVariables,
            metadata: {
                generated: new Date().toISOString(),
                templateId: templateId,
                templateName: template.name
            }
        };
    }

    /**
     * Process conditional blocks in template
     */
    processConditionals(content, variables) {
        // Handle {{#if VARIABLE}} ... {{else}} ... {{/if}} blocks
        const ifRegex = /\{\{#if\s+(\w+)\}\}([\s\S]*?)(\{\{else\}\}([\s\S]*?))?\{\{\/if\}\}/g;
        
        return content.replace(ifRegex, (match, variable, ifBlock, elseBlock, elseContent) => {
            const value = variables[variable];
            if (value && value !== '' && value !== false) {
                return ifBlock.trim();
            } else if (elseContent) {
                return elseContent.trim();
            } else {
                return '';
            }
        });
    }

    /**
     * Replace variables in template
     */
    replaceVariables(content, variables) {
        // Replace {{VARIABLE}} patterns
        return content.replace(/\{\{(\w+)\}\}/g, (match, variable) => {
            return variables[variable] || match;
        });
    }

    /**
     * Suggest templates based on context
     */
    suggestTemplates(context = {}) {
        const suggestions = [];
        
        // File extension-based suggestions
        if (context.fileName) {
            const ext = path.extname(context.fileName).slice(1);
            for (const [id, template] of this.templates.entries()) {
                if (template.language === ext || template.tags.includes(ext)) {
                    suggestions.push({
                        templateId: id,
                        template: template,
                        reason: `File extension match: .${ext}`,
                        confidence: 0.8
                    });
                }
            }
        }

        // Directory-based suggestions
        if (context.workingDir) {
            const dirName = path.basename(context.workingDir);
            for (const [id, template] of this.templates.entries()) {
                if (template.tags.some(tag => dirName.includes(tag))) {
                    suggestions.push({
                        templateId: id,
                        template: template,
                        reason: `Directory pattern match: ${dirName}`,
                        confidence: 0.6
                    });
                }
            }
        }

        // Context-based suggestions
        if (context.intent) {
            for (const [id, template] of this.templates.entries()) {
                if (template.category === context.intent || 
                    template.tags.includes(context.intent) ||
                    template.description.toLowerCase().includes(context.intent.toLowerCase())) {
                    suggestions.push({
                        templateId: id,
                        template: template,
                        reason: `Intent match: ${context.intent}`,
                        confidence: 0.7
                    });
                }
            }
        }

        // Usage-based suggestions
        const popularTemplates = Array.from(this.usage.entries())
            .sort((a, b) => b[1].count - a[1].count)
            .slice(0, 3);
        
        popularTemplates.forEach(([id, usage]) => {
            if (!suggestions.find(s => s.templateId === id)) {
                const template = this.templates.get(id);
                if (template) {
                    suggestions.push({
                        templateId: id,
                        template: template,
                        reason: `Popular template (used ${usage.count} times)`,
                        confidence: 0.5
                    });
                }
            }
        });

        // Sort by confidence
        return suggestions
            .sort((a, b) => b.confidence - a.confidence)
            .slice(0, 10);
    }

    /**
     * Create a new template
     */
    createTemplate(definition) {
        const template = {
            id: definition.id || this.generateId(),
            name: definition.name || 'Unnamed Template',
            description: definition.description || '',
            category: definition.category || 'custom',
            language: definition.language || 'text',
            template: definition.template || '',
            variables: definition.variables || [],
            tags: definition.tags || [],
            builtin: false,
            created: new Date().toISOString(),
            author: definition.author || process.env.USER || 'Unknown'
        };

        // Validate template
        this.validateTemplate(template);

        // Save template
        this.saveTemplate(template);

        // Add to memory
        this.templates.set(template.id, template);

        console.log(`✅ Created template: ${template.name} (${template.id})`);
        return template;
    }

    /**
     * Learn from file content to create templates
     */
    learnFromContent(filePath, content, metadata = {}) {
        try {
            const ext = path.extname(filePath).slice(1);
            const fileName = path.basename(filePath);
            
            // Extract patterns
            const patterns = this.extractPatterns(content, ext);
            
            // Generate template suggestion
            const suggestion = this.generateTemplateFromPatterns(patterns, {
                fileName,
                extension: ext,
                ...metadata
            });
            
            console.log(`🧠 Learned patterns from: ${fileName}`);
            return suggestion;
            
        } catch (error) {
            console.error('❌ Failed to learn from content:', error.message);
            return null;
        }
    }

    /**
     * Extract patterns from content
     */
    extractPatterns(content, language) {
        const patterns = {
            variables: new Set(),
            functions: new Set(),
            imports: new Set(),
            structure: {},
            commonBlocks: []
        };

        switch (language) {
            case 'js':
            case 'javascript':
                this.extractJavaScriptPatterns(content, patterns);
                break;
            case 'py':
            case 'python':
                this.extractPythonPatterns(content, patterns);
                break;
            case 'sh':
            case 'bash':
                this.extractBashPatterns(content, patterns);
                break;
            default:
                this.extractGenericPatterns(content, patterns);
        }

        return patterns;
    }

    /**
     * Extract JavaScript patterns
     */
    extractJavaScriptPatterns(content, patterns) {
        // Extract functions
        const functionMatches = content.match(/function\s+(\w+)/g);
        if (functionMatches) {
            functionMatches.forEach(match => {
                patterns.functions.add(match.replace('function ', ''));
            });
        }

        // Extract variables
        const varMatches = content.match(/(const|let|var)\s+(\w+)/g);
        if (varMatches) {
            varMatches.forEach(match => {
                const varName = match.split(/\s+/)[1];
                patterns.variables.add(varName);
            });
        }

        // Extract imports
        const importMatches = content.match(/require\(['"]([^'"]+)['"]\)/g);
        if (importMatches) {
            importMatches.forEach(match => {
                patterns.imports.add(match);
            });
        }
    }

    /**
     * Extract Python patterns
     */
    extractPythonPatterns(content, patterns) {
        // Extract functions
        const functionMatches = content.match(/def\s+(\w+)/g);
        if (functionMatches) {
            functionMatches.forEach(match => {
                patterns.functions.add(match.replace('def ', ''));
            });
        }

        // Extract imports
        const importMatches = content.match(/import\s+\w+|from\s+\w+\s+import/g);
        if (importMatches) {
            importMatches.forEach(match => {
                patterns.imports.add(match);
            });
        }
    }

    /**
     * Extract Bash patterns
     */
    extractBashPatterns(content, patterns) {
        // Extract functions
        const functionMatches = content.match(/function\s+(\w+)|(\w+)\(\s*\)\s*{/g);
        if (functionMatches) {
            functionMatches.forEach(match => {
                const funcName = match.includes('function') ? 
                    match.replace('function ', '').trim() :
                    match.replace(/\(\s*\)\s*{/, '').trim();
                patterns.functions.add(funcName);
            });
        }

        // Extract variables
        const varMatches = content.match(/(\w+)=/g);
        if (varMatches) {
            varMatches.forEach(match => {
                patterns.variables.add(match.replace('=', ''));
            });
        }
    }

    /**
     * Extract generic patterns
     */
    extractGenericPatterns(content, patterns) {
        // Extract common variable-like patterns
        const varLikeMatches = content.match(/\b[A-Z_][A-Z0-9_]*\b/g);
        if (varLikeMatches) {
            varLikeMatches.forEach(match => {
                if (match.length > 2) {
                    patterns.variables.add(match);
                }
            });
        }
    }

    /**
     * Generate template from patterns
     */
    generateTemplateFromPatterns(patterns, metadata) {
        const templateId = `learned-${metadata.extension}-${this.generateId().slice(0, 8)}`;
        
        let template = `# Generated template for ${metadata.fileName}\n`;
        template += `# Auto-learned on ${new Date().toISOString()}\n\n`;
        
        // Add common variables as placeholders
        if (patterns.variables.size > 0) {
            template += '# Variables:\n';
            Array.from(patterns.variables).forEach(variable => {
                template += `{{${variable}}}\n`;
            });
            template += '\n';
        }
        
        // Add function patterns
        if (patterns.functions.size > 0) {
            template += '# Functions:\n';
            Array.from(patterns.functions).forEach(func => {
                template += `{{${func.toUpperCase()}_FUNCTION}}\n`;
            });
            template += '\n';
        }
        
        template += '{{MAIN_CONTENT}}\n';
        
        return {
            id: templateId,
            name: `Learned ${metadata.extension.toUpperCase()} Template`,
            description: `Auto-generated template from ${metadata.fileName}`,
            category: 'learned',
            language: metadata.extension,
            template: template,
            variables: Array.from(patterns.variables),
            tags: ['learned', metadata.extension],
            patterns: patterns
        };
    }

    /**
     * Auto-complete template variables
     */
    autoCompleteVariables(templateId, partialVariables = {}, context = {}) {
        const template = this.templates.get(templateId);
        if (!template) {
            throw new Error(`Template not found: ${templateId}`);
        }

        const suggestions = {};
        
        template.variables.forEach(variable => {
            if (!partialVariables[variable]) {
                const suggestion = this.suggestVariableValue(variable, context, template);
                if (suggestion) {
                    suggestions[variable] = suggestion;
                }
            }
        });

        return suggestions;
    }

    /**
     * Suggest variable value based on context
     */
    suggestVariableValue(variable, context, template) {
        const varLower = variable.toLowerCase();
        
        // Name-based suggestions
        if (varLower.includes('name')) {
            return context.fileName ? path.parse(context.fileName).name : 'MyProject';
        }
        
        if (varLower.includes('author')) {
            return process.env.USER || 'Unknown';
        }
        
        if (varLower.includes('version')) {
            return '1.0.0';
        }
        
        if (varLower.includes('description')) {
            return `${template.name} generated content`;
        }
        
        if (varLower.includes('class')) {
            const name = context.fileName ? path.parse(context.fileName).name : 'MyClass';
            return name.charAt(0).toUpperCase() + name.slice(1).replace(/[-_]/g, '');
        }
        
        if (varLower.includes('port')) {
            return '3000';
        }
        
        if (varLower.includes('host')) {
            return 'localhost';
        }
        
        if (varLower.includes('debug')) {
            return 'false';
        }
        
        // Default suggestions
        return '';
    }

    // Utility methods
    validateTemplate(template) {
        if (!template.id) throw new Error('Template ID is required');
        if (!template.name) throw new Error('Template name is required');
        if (!template.template) throw new Error('Template content is required');
        if (template.template.length > this.config.maxTemplateSize) {
            throw new Error('Template content too large');
        }
    }

    saveTemplate(template) {
        if (!template.builtin) {
            const filePath = path.join(this.config.userTemplatesDir, `${template.id}.json`);
            fs.writeFileSync(filePath, JSON.stringify(template, null, 2));
        }
    }

    trackUsage(templateId, variables) {
        const usage = this.usage.get(templateId) || {
            count: 0,
            lastUsed: null,
            commonVariables: new Map()
        };
        
        usage.count++;
        usage.lastUsed = new Date().toISOString();
        
        // Track common variable values
        Object.entries(variables).forEach(([key, value]) => {
            if (value && typeof value === 'string') {
                const varUsage = usage.commonVariables.get(key) || new Map();
                varUsage.set(value, (varUsage.get(value) || 0) + 1);
                usage.commonVariables.set(key, varUsage);
            }
        });
        
        this.usage.set(templateId, usage);
    }

    generateId() {
        return crypto.randomBytes(8).toString('hex');
    }

    // Public API methods
    listTemplates(category = null) {
        const templates = Array.from(this.templates.values());
        
        if (category) {
            return templates.filter(t => t.category === category);
        }
        
        return templates.map(t => ({
            id: t.id,
            name: t.name,
            description: t.description,
            category: t.category,
            language: t.language,
            builtin: t.builtin,
            tags: t.tags
        }));
    }

    getTemplate(id) {
        return this.templates.get(id);
    }

    deleteTemplate(id) {
        const template = this.templates.get(id);
        if (!template) throw new Error('Template not found');
        if (template.builtin) throw new Error('Cannot delete built-in template');
        
        // Remove file
        const filePath = path.join(this.config.userTemplatesDir, `${id}.json`);
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
        }
        
        // Remove from memory
        this.templates.delete(id);
        this.usage.delete(id);
        
        console.log(`🗑️  Deleted template: ${template.name}`);
    }

    getUsageStats() {
        return Array.from(this.usage.entries()).map(([id, usage]) => {
            const template = this.templates.get(id);
            return {
                templateId: id,
                templateName: template ? template.name : 'Unknown',
                count: usage.count,
                lastUsed: usage.lastUsed
            };
        }).sort((a, b) => b.count - a.count);
    }
}

// CLI Interface
if (require.main === module) {
    const generator = new SmartTemplateGenerator();
    const command = process.argv[2];
    const args = process.argv.slice(3);

    switch (command) {
        case 'list':
            const category = args[0];
            const templates = generator.listTemplates(category);
            console.log(`\n📄 Available Templates${category ? ` (${category})` : ''}:`);
            templates.forEach(t => {
                const builtin = t.builtin ? '🔒' : '👤';
                console.log(`  ${builtin} ${t.id}: ${t.name} (${t.language})`);
                console.log(`     ${t.description}`);
            });
            break;

        case 'generate':
            if (args.length >= 1) {
                const templateId = args[0];
                const variables = args[1] ? JSON.parse(args[1]) : {};
                const options = args[2] ? JSON.parse(args[2]) : {};
                
                try {
                    const result = generator.generateFromTemplate(templateId, variables, options);
                    console.log(result.content);
                } catch (error) {
                    console.error('❌ Generation failed:', error.message);
                }
            } else {
                console.log('Usage: udos-m4-templates.js generate <template-id> [variables-json] [options-json]');
            }
            break;

        case 'suggest':
            const context = args[0] ? JSON.parse(args[0]) : {};
            const suggestions = generator.suggestTemplates(context);
            console.log('\n💡 Template Suggestions:');
            suggestions.forEach((s, i) => {
                console.log(`  ${i + 1}. ${s.template.name} (${Math.round(s.confidence * 100)}%)`);
                console.log(`     ${s.reason}`);
                console.log(`     Usage: udos-m4-templates.js generate ${s.templateId}\n`);
            });
            break;

        case 'create':
            if (args[0]) {
                try {
                    const definition = JSON.parse(args[0]);
                    const template = generator.createTemplate(definition);
                    console.log(`✅ Created template: ${template.id}`);
                } catch (error) {
                    console.error('❌ Creation failed:', error.message);
                }
            } else {
                console.log('Usage: udos-m4-templates.js create \'{"name":"My Template","template":"content"}\'');
            }
            break;

        case 'learn':
            if (args.length >= 2) {
                const filePath = args[0];
                const content = fs.readFileSync(filePath, 'utf8');
                const metadata = args[1] ? JSON.parse(args[1]) : {};
                
                const suggestion = generator.learnFromContent(filePath, content, metadata);
                if (suggestion) {
                    console.log('🧠 Learned template suggestion:');
                    console.log(JSON.stringify(suggestion, null, 2));
                }
            } else {
                console.log('Usage: udos-m4-templates.js learn <file-path> [metadata-json]');
            }
            break;

        case 'stats':
            const stats = generator.getUsageStats();
            console.log('\n📊 Template Usage Statistics:');
            stats.forEach((s, i) => {
                console.log(`  ${i + 1}. ${s.templateName}: ${s.count} uses`);
                if (s.lastUsed) {
                    console.log(`     Last used: ${s.lastUsed}`);
                }
            });
            break;

        default:
            console.log(`
📄 uDOS M4 Smart Template Generator

Usage:
  udos-m4-templates.js list [category]        - List available templates
  udos-m4-templates.js generate <id> [vars]   - Generate from template
  udos-m4-templates.js suggest [context]      - Get template suggestions
  udos-m4-templates.js create <definition>    - Create new template
  udos-m4-templates.js learn <file> [meta]    - Learn from existing file
  udos-m4-templates.js stats                  - Show usage statistics

Examples:
  udos-m4-templates.js list script
  udos-m4-templates.js generate bash-script '{"NAME":"backup","AUTHOR":"John"}'
  udos-m4-templates.js suggest '{"fileName":"app.py","intent":"script"}'
            `);
    }
}

module.exports = SmartTemplateGenerator;
