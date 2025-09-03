#!/usr/bin/env node
// uDOS Smart Module - Clean AI/ML functionality
const fs = require('fs');
const path = require('path');
const os = require('os');

const UDOS_HOME = process.env.UDOS_HOME || path.join(os.homedir(), '.udos');
const SMART_DIR = path.join(UDOS_HOME, 'smart');

// Ensure smart directory exists
if (!fs.existsSync(SMART_DIR)) {
    fs.mkdirSync(SMART_DIR, { recursive: true });
}

const smart = {
    status() {
        console.log('🧠 uDOS Smart System Status:');
        console.log('');
        
        // Check various smart features
        const features = {
            'Text Analysis': this.checkTextAnalysis(),
            'Pattern Recognition': this.checkPatterns(),
            'Smart Suggestions': this.checkSuggestions(),
            'Context Learning': this.checkContext()
        };
        
        Object.entries(features).forEach(([name, status]) => {
            const icon = status ? '✅' : '❌';
            console.log(`  ${icon} ${name}: ${status ? 'Available' : 'Not Available'}`);
        });
        
        console.log('');
        console.log('💡 Use: udos smart help for available commands');
    },
    
    checkTextAnalysis() {
        // Simple check for text analysis capabilities
        return true; // Basic JS text processing always available
    },
    
    checkPatterns() {
        // Check if pattern recognition data exists
        return fs.existsSync(path.join(SMART_DIR, 'patterns.json'));
    },
    
    checkSuggestions() {
        // Check if suggestions system is initialized
        return fs.existsSync(path.join(SMART_DIR, 'suggestions.json'));
    },
    
    checkContext() {
        // Check if context learning is enabled
        return fs.existsSync(path.join(SMART_DIR, 'context.json'));
    },
    
    analyze(text) {
        if (!text) {
            console.log('❌ Text required for analysis');
            console.log('Usage: udos smart analyze "your text here"');
            return;
        }
        
        console.log('🔍 Analyzing text...');
        console.log('');
        
        // Basic text analysis
        const words = text.split(/\s+/).filter(w => w.length > 0);
        const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
        const chars = text.length;
        
        console.log('📊 Basic Statistics:');
        console.log(`  Characters: ${chars}`);
        console.log(`  Words: ${words.length}`);
        console.log(`  Sentences: ${sentences.length}`);
        console.log(`  Avg word length: ${words.length > 0 ? (words.join('').length / words.length).toFixed(1) : 0}`);
        
        // Word frequency
        const wordFreq = {};
        words.forEach(word => {
            const clean = word.toLowerCase().replace(/[^\w]/g, '');
            if (clean.length > 2) {
                wordFreq[clean] = (wordFreq[clean] || 0) + 1;
            }
        });
        
        const topWords = Object.entries(wordFreq)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 5);
        
        if (topWords.length > 0) {
            console.log('');
            console.log('🔝 Top Words:');
            topWords.forEach(([word, count]) => {
                console.log(`  ${word}: ${count}`);
            });
        }
        
        // Simple sentiment
        const positive = ['good', 'great', 'excellent', 'amazing', 'wonderful', 'fantastic'];
        const negative = ['bad', 'terrible', 'awful', 'horrible', 'worst', 'hate'];
        
        const positiveCount = words.filter(w => positive.includes(w.toLowerCase())).length;
        const negativeCount = words.filter(w => negative.includes(w.toLowerCase())).length;
        
        console.log('');
        console.log('😊 Sentiment Analysis:');
        if (positiveCount > negativeCount) {
            console.log('  Overall: Positive ✨');
        } else if (negativeCount > positiveCount) {
            console.log('  Overall: Negative 😔');
        } else {
            console.log('  Overall: Neutral 😐');
        }
    },
    
    suggest(context) {
        console.log('💡 Smart Suggestions:');
        
        if (!context) {
            console.log('');
            console.log('📝 General Suggestions:');
            console.log('  • Use "udos help" to explore available commands');
            console.log('  • Try "udos data" for data management tools');
            console.log('  • Use "udos workflow" for process automation');
            console.log('  • Check "udos status" for system information');
            return;
        }
        
        console.log('');
        console.log(`📋 Context: ${context}`);
        
        // Context-based suggestions
        const contextSuggestions = {
            'file': ['udos data list', 'udos data backup', 'udos file organize'],
            'workflow': ['udos workflow create', 'udos workflow list', 'udos workflow run'],
            'data': ['udos data backup', 'udos data export', 'udos data clean'],
            'help': ['udos help', 'udos manual', 'udos examples'],
            'system': ['udos status', 'udos update', 'udos configure']
        };
        
        const suggestions = contextSuggestions[context.toLowerCase()] || 
                          ['udos help', 'udos status', 'udos workflow list'];
        
        console.log('🎯 Suggested Commands:');
        suggestions.forEach(cmd => {
            console.log(`  • ${cmd}`);
        });
        
        // Save suggestion interaction for learning
        this.saveSuggestionInteraction(context, suggestions);
    },
    
    saveSuggestionInteraction(context, suggestions) {
        try {
            const file = path.join(SMART_DIR, 'suggestions.json');
            let data = {};
            
            if (fs.existsSync(file)) {
                data = JSON.parse(fs.readFileSync(file));
            }
            
            if (!data.interactions) data.interactions = [];
            
            data.interactions.push({
                context,
                suggestions,
                timestamp: new Date().toISOString()
            });
            
            // Keep only last 100 interactions
            data.interactions = data.interactions.slice(-100);
            
            fs.writeFileSync(file, JSON.stringify(data, null, 2));
        } catch (e) {
            // Silently fail for suggestion logging
        }
    },
    
    learn(command, context = '') {
        console.log('📚 Learning from command usage...');
        
        try {
            const file = path.join(SMART_DIR, 'context.json');
            let data = {};
            
            if (fs.existsSync(file)) {
                data = JSON.parse(fs.readFileSync(file));
            }
            
            if (!data.usage) data.usage = {};
            if (!data.patterns) data.patterns = {};
            
            // Track command usage
            data.usage[command] = (data.usage[command] || 0) + 1;
            
            // Track context patterns
            if (context) {
                const key = `${context}:${command}`;
                data.patterns[key] = (data.patterns[key] || 0) + 1;
            }
            
            data.lastUpdate = new Date().toISOString();
            
            fs.writeFileSync(file, JSON.stringify(data, null, 2));
            console.log(`✅ Learned: ${command}${context ? ` in context: ${context}` : ''}`);
        } catch (e) {
            console.log('⚠️  Learning disabled:', e.message);
        }
    },
    
    insights() {
        console.log('📈 Smart Insights:');
        
        try {
            const file = path.join(SMART_DIR, 'context.json');
            if (!fs.existsSync(file)) {
                console.log('');
                console.log('📝 No usage data available yet');
                console.log('💡 Use commands to build usage patterns');
                return;
            }
            
            const data = JSON.parse(fs.readFileSync(file));
            
            if (data.usage) {
                console.log('');
                console.log('🔝 Most Used Commands:');
                const topCommands = Object.entries(data.usage)
                    .sort((a, b) => b[1] - a[1])
                    .slice(0, 5);
                
                topCommands.forEach(([cmd, count]) => {
                    console.log(`  ${cmd}: ${count} times`);
                });
            }
            
            if (data.patterns) {
                console.log('');
                console.log('🔗 Context Patterns:');
                const topPatterns = Object.entries(data.patterns)
                    .sort((a, b) => b[1] - a[1])
                    .slice(0, 3);
                
                topPatterns.forEach(([pattern, count]) => {
                    console.log(`  ${pattern}: ${count} times`);
                });
            }
            
            console.log('');
            console.log(`📅 Last Update: ${data.lastUpdate || 'Unknown'}`);
        } catch (e) {
            console.log('❌ Error reading insights:', e.message);
        }
    },
    
    reset() {
        console.log('🗑  Resetting smart system...');
        
        try {
            const files = ['suggestions.json', 'context.json', 'patterns.json'];
            let removed = 0;
            
            files.forEach(file => {
                const fullPath = path.join(SMART_DIR, file);
                if (fs.existsSync(fullPath)) {
                    fs.unlinkSync(fullPath);
                    removed++;
                }
            });
            
            console.log(`✅ Reset complete - removed ${removed} files`);
            console.log('💡 Smart system will start learning from scratch');
        } catch (e) {
            console.log('❌ Error resetting:', e.message);
        }
    }
};

// Command line interface
const [,, command, ...args] = process.argv;

if (command === '--help' || command === 'help') {
    console.log('🧠 uDOS Smart System');
    console.log('');
    console.log('Commands:');
    console.log('  status                   Show smart system status');
    console.log('  analyze <text>          Analyze text content');
    console.log('  suggest [context]       Get smart suggestions');
    console.log('  learn <command> [ctx]   Learn from command usage');
    console.log('  insights                Show usage insights');
    console.log('  reset                   Reset learning data');
    console.log('');
    console.log('Examples:');
    console.log('  udos smart status');
    console.log('  udos smart analyze "This is sample text"');
    console.log('  udos smart suggest workflow');
    console.log('  udos smart insights');
} else if (smart[command]) {
    smart[command](...args);
} else {
    console.log('❌ Unknown command:', command);
    console.log('💡 Use: udos smart help');
}
