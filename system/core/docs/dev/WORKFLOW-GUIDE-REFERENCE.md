# uDOS uDOS Workflow Workflow Workflow System - Complete User Guide

## Overview

uDOS uDOS Workflow represents the pinnacle of AI-assisted workflow, bringing intelligent workflow management, pattern recognition, smart templates, and natural language processing to the uDOS ecosystem.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Getting Started](#getting-started)
3. [Workflow Engine](#workflow-engine)
4. [Smart Pattern Recognition](#ai-pattern-recognition)
5. [Smart Templates](#smart-templates)
6. [Natural Language Processing](#natural-language-processing)
7. [Integration Guide](#integration-guide)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Advanced Features](#advanced-features)

## System Architecture

uDOS Workflow consists of four integrated AI-powered components:

```
┌─────────────────────────────────────────────────────────┐
│                    uDOS uDOS Workflow Smart System                   │
├─────────────────────────────────────────────────────────┤
│  🤖 Workflow Engine    │  🧠 Smart Recognition           │
│  • JSON Workflows      │  • Pattern Learning          │
│  • Workflow Tasks    │  • Command Prediction        │
│  • Triggers & Actions  │  • Context Awareness         │
├─────────────────────────────────────────────────────────┤
│  📄 Smart Templates    │  🗣️ Natural Language         │
│  • Code Generation     │  • Query Processing          │
│  • Config Creation     │  • Intent Recognition        │
│  • Learning Patterns   │  • Command Translation       │
└─────────────────────────────────────────────────────────┘
```

### Prerequisites

- **Node.js**: Required for all uDOS Workflow functionality
- **uDOS M1-M3**: Complete foundation systems
- **Linux environment**: For optimal workflow features

## Getting Started

### Installation Check

```bash
# Test uDOS Workflow system availability
udos workflow test

# Check individual components
udos workflow workflow
udos workflow ai
udos workflow template
udos workflow nlp "system status"
```

### Quick Start Workflow

1. **Create your first workflow**:
```bash
udos workflow workflow create '{
  "name": "Hello uDOS Workflow",
  "description": "First Smart workflow workflow",
  "actions": [
    {
      "type": "notification",
      "title": "uDOS Workflow Working",
      "message": "Your first Smart workflow is running!"
    },
    {
      "type": "command",
      "command": "udos info"
    }
  ]
}'
```

2. **Let Smart learn from your commands**:
```bash
udos workflow ai learn "udos data backup"
udos workflow ai learn "udos system status"
```

3. **Get Smart suggestions**:
```bash
udos workflow ai suggest
```

4. **Try natural language**:
```bash
udos workflow nlp "backup my data and show system status"
```

## Workflow Engine

### Workflow Structure

Every uDOS Workflow workflow follows this JSON structure:

```json
{
  "name": "Workflow Name",
  "description": "What this workflow does",
  "version": "1.0",
  "enabled": true,
  "triggers": [...],
  "conditions": [...], 
  "actions": [...],
  "variables": {...},
  "metadata": {...}
}
```

### Trigger Types

#### Time-Based Triggers
```json
{
  "type": "schedule",
  "cron": "0 2 * * *",
  "description": "Daily at 2 AM"
}
```

#### Command Triggers
```json
{
  "type": "command",
  "pattern": "backup",
  "description": "When user runs backup commands"
}
```

#### System Event Triggers
```json
{
  "type": "system",
  "event": "high_cpu_usage",
  "threshold": "80%"
}
```

#### File System Triggers
```json
{
  "type": "file",
  "path": "/important/directory",
  "event": "modified"
}
```

### Action Types

#### Command Execution
```json
{
  "type": "command",
  "command": "udos data backup",
  "timeout": 30000,
  "stopOnError": true
}
```

#### File Operations
```json
{
  "type": "file",
  "operation": "create",
  "path": "/tmp/report.txt",
  "content": "Report generated at ${TIMESTAMP}"
}
```

#### Notifications
```json
{
  "type": "notification",
  "title": "Task Complete",
  "message": "Backup finished successfully",
  "priority": "high"
}
```

#### Variable Management
```json
{
  "type": "variable",
  "key": "LAST_BACKUP",
  "value": "${TIMESTAMP}"
}
```

#### Smart Suggestions
```json
{
  "type": "ai_suggest",
  "prompt": "What should I do after backup?",
  "context": {
    "task": "post_backup",
    "time": "${HOUR}"
  }
}
```

#### HTTP Requests
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://api.example.com/webhook",
  "data": {"status": "${WORKFLOW_STATUS}"}
}
```

### Workflow Commands

```bash
# List all workflows
udos workflow workflow list

# Create workflow from file
udos workflow workflow create "$(cat workflow.json)"

# Execute specific workflow
udos workflow workflow run workflow-id

# Get workflow suggestions
udos workflow ai suggest
```

### Example: Daily Maintenance Workflow

```json
{
  "name": "Daily Maintenance",
  "triggers": [{"type": "schedule", "cron": "0 3 * * *"}],
  "actions": [
    {"type": "command", "command": "udos data backup"},
    {"type": "command", "command": "udos system cleanup"},
    {"type": "ai_suggest", "prompt": "Post-maintenance recommendations"},
    {"type": "notification", "message": "Maintenance complete: ${AI_SUGGESTIONS}"}
  ]
}
```

## Smart Pattern Recognition

### How Smart Learning Works

uDOS Workflow's Smart system continuously learns from:
- **Command frequency** and usage patterns
- **Time-based** behavior (when you work)
- **Context patterns** (which directories, what tasks)
- **Error patterns** and successful workflows
- **Resource usage** patterns

### Learning Commands

```bash
# Manual learning
udos workflow ai learn "udos data backup" '{"success": true, "executionTime": 5000}'

# Get predictions
udos workflow ai predict "udos data"

# View Smart statistics
udos workflow ai stats

# Get contextual suggestions
udos workflow ai suggest
```

### User Profile Detection

The Smart automatically detects:
- **User role**: ADMIN, USER, DEVELOPER
- **Experience level**: BEGINNER, INTERMEDIATE, EXPERT
- **Working patterns**: Peak hours, common directories
- **Preferred tools**: Most used commands

### Intelligent Suggestions

Based on patterns, uDOS Workflow provides:

#### **Time-Based Suggestions**
- Morning: "Start with system health check"
- Evening: "Time for backup and cleanup"
- Off-hours: "Perfect for system maintenance"

#### **Role-Based Suggestions**
- **Admin**: "Check security logs and system performance"
- **Developer**: "Run code analysis and tests"
- **User**: "Organize files and update documents"

#### **Error Prevention**
- "Command X has high failure rate - use error handling"
- "Consider workflow for frequently failing tasks"

#### **Workflow Opportunities**
- "You run these 3 commands together often - create workflow?"
- "Daily pattern detected - schedule workflow?"

### Learning Integration

```bash
# Every command can teach the Smart
udos data backup && udos workflow ai learn "udos data backup" '{"success": true}'

# Smart learns from workflow executions automatically
udos workflow workflow run my-workflow  # Learning happens automatically
```

## Smart Templates

### Built-in Templates

uDOS Workflow includes professional templates for:

#### **Script Templates**
- `bash-script`: Complete bash script with error handling
- `python-script`: Python script with argparse and best practices
- `udos-extension`: Full uDOS extension template

#### **Configuration Templates**
- `config-file`: YAML configuration with sections
- `workflow-definition`: Complete workflow JSON structure

#### **Development Templates**
- `git-hooks`: Git workflow scripts
- `ci-pipeline`: Continuous integration workflows

### Template Commands

```bash
# List available templates
udos workflow template list

# List by category
udos workflow template list script

# Generate from template
udos workflow template generate bash-script '{"NAME":"backup","AUTHOR":"John"}'

# Get contextual suggestions
udos workflow template suggest

# Create custom template
udos workflow template create '{"name":"My Template","template":"content"}'

# Learn from existing file
udos workflow template learn /path/to/script.sh

# View usage statistics
udos workflow template stats
```

### Template Variables

Templates use `{{VARIABLE}}` syntax:

```bash
#!/bin/bash
# {{DESCRIPTION}}
# Created: {{DATE}}
# Author: {{AUTHOR}}

{{MAIN_CONTENT}}
```

### Auto-Completion

uDOS Workflow intelligently suggests variable values:

```json
{
  "NAME": "MyProject",           // From filename
  "AUTHOR": "john",              // From $USER
  "VERSION": "1.0.0",            // Default versioning
  "CLASS_NAME": "MyClass",       // CamelCase from filename
  "DESCRIPTION": "Generated content"  // Context-based
}
```

### Template Learning

uDOS Workflow can learn from your existing code:

```bash
# Learn patterns from existing script
udos workflow template learn my-script.py

# Smart will suggest template based on patterns found
udos workflow template suggest '{"fileName":"new-script.py"}'
```

### Smart Suggestions

Templates are suggested based on:
- **File extension**: `.py` → Python templates
- **Directory name**: `scripts/` → Script templates  
- **Project context**: Git repo → Development templates
- **Usage history**: Frequently used templates first

## Natural Language Processing

### Supported Query Types

#### **System Operations**
```bash
udos workflow nlp "check system status"
udos workflow nlp "run system test"
udos workflow nlp "update the system"
```

#### **Data Management**
```bash
udos workflow nlp "backup my data"
udos workflow nlp "list all data files"
udos workflow nlp "backup and then list data"
```

#### **Variable Operations**
```bash
udos workflow nlp "set variable name to value"
udos workflow nlp "get variable status"
udos workflow nlp "show all variables"
```

#### **Window Management**
```bash
udos workflow nlp "list open windows"
udos workflow nlp "focus window Terminal"
udos workflow nlp "move window to position 100 200"
```

#### **Smart and Workflow**
```bash
udos workflow nlp "give me suggestions"
udos workflow nlp "create a backup workflow"
udos workflow nlp "learn from this command"
```

#### **Complex Operations**
```bash
udos workflow nlp "backup data and show system status"
udos workflow nlp "run full system check and notify me"
udos workflow nlp "setup my workspace environment"
```

### NLP Features

#### **Intent Recognition**
- Identifies what you want to do (backup, list, create, etc.)
- Understands objects (data, windows, variables, etc.)
- Recognizes urgency and politeness

#### **Entity Extraction**
- **File paths**: Automatically finds file references
- **Window names**: Extracts window identifiers
- **Variable assignments**: Parses key=value pairs
- **Numbers**: Identifies coordinates, counts, sizes

#### **Context Awareness**
- Remembers recent conversation
- Uses current working directory
- Adapts to user role and experience
- Learns from successful interactions

#### **Confidence Scoring**
Each suggestion includes confidence percentage:
- **90%+**: Direct command match
- **70-90%**: Strong pattern match
- **50-70%**: Fuzzy match with alternatives
- **<50%**: Suggestions for clarification

### NLP Workflow

1. **Query Processing**: Parse natural language
2. **Intent Recognition**: Understand what you want
3. **Entity Extraction**: Find parameters and objects
4. **Command Mapping**: Convert to uDOS commands
5. **Confidence Scoring**: Rate suggestion quality
6. **Response Generation**: Provide explanation and alternatives

### Example NLP Sessions

#### **Basic Query**
```bash
$ udos workflow nlp "backup my data"
🤖 Natural Language Processing Result:
─────────────────────────────────────
✅ Understood: I'll backup your data.
📊 Confidence: 95%

💻 Recommended Commands:
  1. udos data backup
     Matched pattern: "backup data" (exact)

🚀 To execute the top command, run:
     udos data backup
```

#### **Complex Query**
```bash
$ udos workflow nlp "check system status and then backup important files"
🤖 Natural Language Processing Result:
─────────────────────────────────────
✅ Understood: I'll check system status and backup files.
📊 Confidence: 87%

💻 Recommended Commands:
  1. udos info && udos data backup
     Matched pattern: "system status" + "backup" (sequence)

💡 Other Suggestions:
  1. udos test system (85%)
  2. udos workflow workflow create (70%)
```

#### **Ambiguous Query**
```bash
$ udos workflow nlp "help me organize things"
❌ Could not understand: "help me organize things"

💡 Try these instead:
  1. udos help
     Get list of all commands
  2. udos workflow ai suggest
     Get AI-powered suggestions
  3. udos test
     Test system functionality
```

## Integration Guide

### uDOS Workflow with M1-M3 Systems

uDOS Workflow seamlessly integrates with existing milestones:

#### **M1 Foundation Integration**
```json
{
  "type": "command",
  "command": "udos init && udos role detect",
  "description": "Initialize system with role detection"
}
```

#### **M2 Interface Integration**
```json
{
  "type": "command", 
  "command": "udos test m2",
  "description": "Test web interface functionality"
}
```

#### **M3 Desktop Integration**
```json
{
  "type": "command",
  "command": "udos m3 window list",
  "description": "Manage desktop windows"
}
```

### Cross-Component Workflows

```json
{
  "name": "Complete System Check",
  "actions": [
    {"type": "command", "command": "udos info"},
    {"type": "command", "command": "udos test m2"},
    {"type": "command", "command": "udos m3 test"},
    {"type": "ai_suggest", "prompt": "System analysis complete, next steps?"}
  ]
}
```

### External Tool Integration

#### **Git Integration**
```json
{
  "type": "command",
  "command": "git status --porcelain",
  "description": "Check git repository status"
}
```

#### **System Monitoring**
```json
{
  "type": "command",
  "command": "ps aux --sort=-%cpu | head -5",
  "description": "Monitor CPU usage"
}
```

#### **File Operations**
```json
{
  "type": "command",
  "command": "find /tmp -name '*.log' -mtime +7 -delete",
  "description": "Clean old log files"
}
```

## Troubleshooting

### Common Issues

#### **Node.js Not Found**
```
❌ Node.js: Missing
ℹ️  Install Node.js to enable uDOS Workflow Smart workflow
```

**Solution**: Install Node.js
```bash
# macOS with Homebrew
brew install node

# Ubuntu/Debian
sudo apt update && sudo apt install nodejs npm

# Verify installation
node --version
```

#### **uDOS Workflow Components Missing**
```
❌ Workflow engine: Missing
❌ Smart system: Missing
```

**Solution**: Check file permissions and locations
```bash
# Verify files exist
ls -la /usr/share/udos/udos-workflow-*.js

# Fix permissions if needed
chmod +x /usr/share/udos/udos-workflow-*.js
```

#### **Workflow Execution Fails**
```
❌ Workflow execution failed: Command not found
```

**Solutions**:
1. Check command syntax in workflow JSON
2. Verify all required commands are available
3. Test commands manually first
4. Check file permissions and paths

#### **Smart Learning Not Working**
```
⚠️  Could not save patterns: Permission denied
```

**Solution**: Ensure write permissions
```bash
# Create data directory with proper permissions
sudo mkdir -p /tmp/udos-workflow-data
sudo chown $USER:$USER /tmp/udos-workflow-data
```

#### **Template Generation Errors**
```
❌ Template content too large
```

**Solution**: Use smaller templates or increase limits
```javascript
// In udos-workflow-templates.js, modify:
maxTemplateSize: 2 * 1024 * 1024, // 2MB instead of 1MB
```

#### **NLP Understanding Issues**
```
❌ Could not understand: "complex query"
```

**Solutions**:
1. Use simpler, more direct language
2. Break complex requests into parts
3. Use supported command patterns
4. Check the NLP example patterns

### Debug Mode

Enable verbose debugging:
```bash
# Set debug environment
export UDOS_uDOS Workflow_DEBUG=true

# Run with detailed output
udos workflow workflow run workflow-id
```

### Performance Issues

#### **Slow Smart Responses**
- Reduce pattern complexity
- Clear old learning data
- Limit concurrent workflows

#### **High Memory Usage**
- Restart Smart components periodically
- Reduce workflow frequency
- Clean temporary files

```bash
# Clean uDOS Workflow temporary data
rm -rf /tmp/udos-workflow-data/*
udos workflow ai stats  # Reinitialize
```

## Best Practices

### Workflow Design

#### **Start Simple**
```json
{
  "name": "Simple Backup",
  "actions": [
    {"type": "command", "command": "udos data backup"},
    {"type": "notification", "message": "Backup complete"}
  ]
}
```

#### **Add Complexity Gradually**
```json
{
  "name": "Advanced Backup",
  "conditions": [
    {"type": "disk_space", "minimum": "1GB"}
  ],
  "actions": [
    {"type": "command", "command": "udos data backup"},
    {"type": "ai_suggest", "prompt": "Post-backup recommendations"},
    {"type": "notification", "message": "Backup complete: ${AI_SUGGESTIONS}"}
  ],
  "error_handling": {
    "on_failure": [
      {"type": "notification", "message": "Backup failed: ${ERROR}"}
    ]
  }
}
```

#### **Use Error Handling**
```json
{
  "actions": [
    {
      "type": "command",
      "command": "risky-command",
      "stopOnError": false,
      "timeout": 30000
    }
  ],
  "error_handling": {
    "retry_count": 3,
    "retry_delay": 5000,
    "on_failure": [
      {"type": "notification", "message": "Operation failed after retries"}
    ]
  }
}
```

### Smart Training

#### **Feed Quality Data**
```bash
# Good: Specific context
udos workflow ai learn "udos data backup" '{"success": true, "executionTime": 5000, "workingDir": "/home/user"}'

# Avoid: Minimal context
udos workflow ai learn "command"
```

#### **Regular Learning**
```bash
# Set up learning workflow
{
  "name": "Daily Learning",
  "triggers": [{"type": "schedule", "cron": "0 0 * * *"}],
  "actions": [
    {"type": "command", "command": "udos workflow ai stats"},
    {"type": "ai_suggest", "prompt": "Daily learning summary"}
  ]
}
```

### Template Management

#### **Organize by Category**
```bash
udos workflow template create '{
  "name": "Company Script Template",
  "category": "company_scripts",
  "tags": ["internal", "workflow"]
}'
```

#### **Version Templates**
```bash
udos workflow template create '{
  "name": "Script Template v2",
  "version": "2.0",
  "description": "Enhanced with error handling"
}'
```

### Security Considerations

#### **Validate Inputs**
```json
{
  "conditions": [
    {"type": "command_whitelist", "allowed": ["udos", "git", "npm"]},
    {"type": "path_restriction", "allowed_paths": ["/home/user", "/tmp"]}
  ]
}
```

#### **Limit Permissions**
```json
{
  "actions": [
    {
      "type": "command",
      "command": "udos data backup",
      "user": "backup_user",
      "timeout": 60000
    }
  ]
}
```

#### **Audit Workflows**
```bash
# Regular security review
udos workflow workflow list | grep -E "(sudo|rm|chmod)"
```

## Advanced Features

### Multi-Phase Workflows

```json
{
  "workflow_phases": [
    {
      "name": "preparation",
      "actions": [
        {"type": "command", "command": "udos test quick"}
      ]
    },
    {
      "name": "execution", 
      "actions": [
        {"type": "command", "command": "udos data backup"}
      ]
    },
    {
      "name": "cleanup",
      "actions": [
        {"type": "command", "command": "udos system cleanup"}
      ]
    }
  ]
}
```

### Conditional Execution

```json
{
  "conditional_actions": [
    {
      "condition": "DISK_USAGE > 80",
      "actions": [
        {"type": "command", "command": "udos system cleanup"},
        {"type": "notification", "message": "Disk cleanup performed"}
      ]
    },
    {
      "condition": "BACKUP_AGE > 24_HOURS",
      "actions": [
        {"type": "command", "command": "udos data backup"}
      ]
    }
  ]
}
```

### AI-Driven Workflows

```json
{
  "name": "Adaptive Maintenance",
  "actions": [
    {
      "type": "ai_suggest",
      "prompt": "Based on system state, what maintenance is needed?",
      "context": {
        "system_load": "${CPU_USAGE}",
        "disk_usage": "${DISK_USAGE}",
        "last_maintenance": "${LAST_MAINT}"
      }
    },
    {
      "type": "command",
      "command": "${AI_SUGGESTED_COMMAND}",
      "description": "Execute AI-recommended maintenance"
    }
  ]
}
```

### Workflow Inheritance

```json
{
  "name": "Extended Backup",
  "extends": "daily-backup",
  "additional_actions": [
    {"type": "command", "command": "udos system status"},
    {"type": "ai_suggest", "prompt": "Post-backup analysis"}
  ],
  "override_variables": {
    "BACKUP_RETENTION": "60_days"
  }
}
```

### Real-time Adaptation

```json
{
  "adaptive_triggers": [
    {
      "condition": "CPU_USAGE > 90% for 5_minutes",
      "action": "pause_non_critical_workflows"
    },
    {
      "condition": "DISK_SPACE < 1GB",
      "action": "trigger_emergency_cleanup"
    }
  ]
}
```

## API Reference

### Workflow Engine API

```javascript
const WorkflowEngine = require('./udos-workflow-workflow.js');
const engine = new WorkflowEngine();

// Create workflow
const workflow = await engine.createWorkflow({
  name: 'API Workflow',
  actions: [...]
});

// Execute workflow
const result = await engine.executeWorkflow(workflow.id);

// List workflows
const workflows = engine.listWorkflows();
```

### Smart Pattern Recognition API

```javascript
const AIPatternRecognition = require('./udos-workflow-ai.js');
const ai = new AIPatternRecognition();

// Learn from command
ai.learnFromCommand('udos data backup', {
  success: true,
  executionTime: 5000,
  workingDir: '/home/user'
});

// Get predictions
const predictions = ai.predictNextCommand('udos data');

// Get suggestions
const suggestions = ai.getIntelligentSuggestions({
  workingDir: '/home/user',
  timeOfDay: 'morning'
});
```

### Template Generator API

```javascript
const SmartTemplateGenerator = require('./udos-workflow-templates.js');
const generator = new SmartTemplateGenerator();

// Generate from template
const result = generator.generateFromTemplate('bash-script', {
  NAME: 'backup-script',
  AUTHOR: 'John Doe'
});

// Get suggestions
const suggestions = generator.suggestTemplates({
  fileName: 'script.py',
  workingDir: '/home/user/projects'
});
```

### NLP API

```javascript
const NaturalLanguageProcessor = require('./udos-workflow-nlp.js');
const nlp = new NaturalLanguageProcessor();

// Process query
const response = nlp.processQuery('backup my data and show status');

// Execute suggestions
if (response.understood) {
  const results = await nlp.executeCommands(response.commands);
}
```

## Conclusion

uDOS uDOS Workflow represents a comprehensive Smart workflow platform that brings intelligence to every aspect of system management. From simple task workflow to complex adaptive workflows, uDOS Workflow provides the tools needed for efficient, intelligent computing.

### Key Benefits

- **Intelligent Workflow**: AI-powered workflows that learn and adapt
- **Natural Interaction**: Communicate with your system in plain English
- **Rapid Development**: Smart templates accelerate creation tasks
- **Predictive Assistance**: Smart suggests actions before you need them
- **Seamless Integration**: Works perfectly with existing uDOS systems

### Next Steps

1. **Start Simple**: Create basic workflows for daily tasks
2. **Let Smart Learn**: Use the system regularly to improve Smart suggestions
3. **Explore Templates**: Use smart templates for rapid development
4. **Try NLP**: Experiment with natural language commands
5. **Build Complex Workflows**: Combine features for advanced workflow

The future of computing is intelligent workflow, and with uDOS uDOS Workflow, that future is now.

---

*For more information, visit the [uDOS GitHub repository](https://github.com/fredporter/uDESK) or run `udos help` for interactive assistance.*
