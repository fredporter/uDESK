#!/bin/bash
# uDESK GitHub Wiki Migration Script

echo "🚀 Migrating uDESK documentation to GitHub Wiki format..."
echo ""

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -d "docs" ]; then
    echo "❌ Error: Please run this script from the uDESK root directory"
    exit 1
fi

# List of docs to migrate
declare -A docs=(
    ["docs/ARCHITECTURE.md"]="Architecture"
    ["docs/BUILD.md"]="Build-System"
    ["CONTRIBUTING.md"]="Contributing"
    ["docs/DISPLAY-SYSTEM.md"]="uDOS-Grid-System"
    ["docs/WIKI-SETUP.md"]="Wiki-Setup"
    ["dev/EXPRESS-DEV-TODOS.md"]="Development-Roadmap"
    ["QUICKSTART.md"]="Quick-Start"
    ["INSTALLERS.md"]="Installation-Guide"
)

echo "📋 Documentation files found for migration:"
for file in "${!docs[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file → ${docs[$file]}.md"
    else
        echo "  ⚠️  $file (not found, will create placeholder)"
    fi
done

echo ""
echo "📝 To complete the wiki setup:"
echo ""
echo "1️⃣ Enable Wiki in GitHub repository:"
echo "   → Go to: https://github.com/fredporter/uDESK/settings"
echo "   → Under 'Features', check ✅ Wikis"
echo "   → Save changes"
echo ""
echo "2️⃣ Clone the wiki repository:"
echo "   git clone https://github.com/fredporter/uDESK.wiki.git udesk-wiki"
echo ""
echo "3️⃣ Copy prepared wiki files:"
echo "   cd udesk-wiki"
echo "   cp ../uDESK/wiki-content/* ."
echo ""
echo "4️⃣ Push to wiki:"
echo "   git add ."
echo "   git commit -m 'Initial wiki setup with comprehensive documentation'"
echo "   git push"
echo ""
echo "🔗 Your wiki will be available at:"
echo "   https://github.com/fredporter/uDESK/wiki"
echo ""

# Create wiki-content directory
mkdir -p wiki-content

echo "📄 Generating wiki pages..."

# Create Home page
cat > wiki-content/Home.md << 'EOF'
# uDESK - Universal Desktop OS Wiki

Welcome to the uDESK documentation hub! This wiki provides comprehensive guides for users, developers, and contributors.

## 🚀 Quick Navigation

### **Get Started**
- [Quick Start Guide](Quick-Start) - Get running in 5 minutes
- [Installation Guide](Installation-Guide) - Platform-specific setup
- [Architecture Overview](Architecture) - System design concepts

### **User Interface**
- [PANEL System](PANEL-System) - Desktop interface guide
- [VSCode Integration](VSCode-Integration) - Development workflow
- [Workflow Management](Workflow-Management) - TODO and progress tracking

### **Development**
- [Development Setup](Development-Setup) - Contributor environment
- [Contributing Guide](Contributing) - How to help the project
- [Build System](Build-System) - Compilation process
- [API Reference](API-Reference) - Technical documentation

### **Advanced Topics**
- [uDOS Grid System](uDOS-Grid-System) - 16×16 pixel architecture
- [Core Scripts](Core-Scripts) - Shell script automation
- [Development Roadmap](Development-Roadmap) - Current progress and goals

## 🎯 Learning Paths

- **👋 New to uDESK**: [Quick Start](Quick-Start) → [Architecture](Architecture) → [PANEL System](PANEL-System)
- **💻 Developer**: [Development Setup](Development-Setup) → [Contributing](Contributing) → [Build System](Build-System)
- **🔧 Advanced**: [uDOS Grid System](uDOS-Grid-System) → [Core Scripts](Core-Scripts) → [API Reference](API-Reference)

## 🌟 Latest Features (v1.0.8)

- **🎛️ Complete PANEL System**: Widget→PANEL transformation with uDOS grid alignment
- **💻 VSCode Integration**: Live TODO Tree sync, terminal commands, workflow execution
- **📊 Real Workflow Data**: Live parsing of workflow files with hierarchy visualization
- **⚡ Live Updates**: Real-time progress tracking with Goal→Mission→Milestone→TODO structure

## 🤝 Community

- **GitHub Issues**: Bug reports and feature requests
- **Discussions**: Community questions and ideas
- **Wiki Contributions**: Help improve documentation
- **Code Contributions**: See [Contributing Guide](Contributing)

---
*Wiki maintained by the uDESK team | Last updated: September 2025*
EOF

# Create PANEL System guide
cat > wiki-content/PANEL-System.md << 'EOF'
# PANEL System Guide

The uDESK PANEL system provides the main desktop interface through four integrated panels aligned to the **uDOS Grid System** (16×16 pixel uCELL architecture).

## 🎛️ Four Core Panels

### 📝 TodoPanel
**Live TODO Management with VSCode Integration**

Features:
- **Real-time TODO parsing** from workflow files
- **Progress tracking** with visual completion status
- **VSCode synchronization** with TODO Tree extension
- **Action buttons** for starting/completing TODOs
- **Workflow file editing** directly from panel

Use Cases:
- Track development progress
- Sync with VSCode TODO Tree
- Manage milestone assignments
- Edit workflow files on-the-fly

### 📊 ProgressPanel
**Workflow Hierarchy Visualization**

Features:
- **Goal→Mission→Milestone→TODO** hierarchy display
- **Expandable milestones** with progress bars
- **Real-time statistics** and completion tracking
- **Script integration** for hierarchy management
- **Interactive navigation** through workflow structure

Use Cases:
- Visualize project progress
- Navigate complex workflows
- Track milestone completion
- Execute hierarchy scripts

### ⚙️ WorkflowPanel
**VSCode Command Center & Script Execution**

Features:
- **VSCode commands**: Terminal launching, file operations, TODO Tree refresh
- **Script execution**: Direct execution of core workflow scripts
- **Custom commands**: Advanced workflow automation input
- **Action categories**: Organized command groups (Workflow, VSCode, Progress, System)

Use Cases:
- Launch VSCode terminals in workspace context
- Execute workflow automation scripts
- Refresh TODO Tree and file operations
- Custom workflow command execution

### 🖥️ SystemPanel
**Development Environment Integration**

Features:
- **Development integration**: VSCode workspace management
- **System monitoring**: Resource usage and environment status
- **Script access**: Quick execution of system health scripts
- **Terminal integration**: Launch terminals in development context

Use Cases:
- Monitor development environment
- Quick system health checks
- Launch development terminals
- Access system scripts

## 🔗 VSCode Integration Features

### Core Integrations
- **🔄 TODO Tree Sync**: Automatic refresh of VSCode TODO Tree extension
- **📂 File Operations**: Open workflow files directly in VSCode editor  
- **💻 Terminal Integration**: Launch terminals in uDESK workspace context
- **📋 Command Execution**: Run workflow scripts through VSCode interface
- **⚡ Task Management**: Create and execute VSCode tasks from panels

### Workflow Data Processing
- **📊 Live Parsing**: Real-time parsing of workflow files and hierarchy
- **📈 Progress Tracking**: Automatic progress calculation and milestone completion
- **🏆 Milestone Management**: Hierarchical organization with expandable views
- **🔧 Script Integration**: Direct execution of uDESK core workflow scripts

## 🎯 Usage Patterns

### Daily Development Workflow
1. **Check TodoPanel** for current tasks
2. **Review ProgressPanel** for milestone status
3. **Use WorkflowPanel** to execute scripts and VSCode commands
4. **Monitor SystemPanel** for environment health

### Project Management
1. **Navigate hierarchy** in ProgressPanel
2. **Track completion rates** across milestones
3. **Execute workflow scripts** for automation
4. **Sync with VSCode** for development tasks

### System Integration
1. **Launch VSCode terminals** from panels
2. **Refresh TODO Tree** after workflow changes
3. **Execute health checks** via SystemPanel
4. **Monitor resource usage** during development

## 🏗️ Technical Architecture

### uDOS Grid Alignment
- All panels align to **16×16 pixel uCELL** architecture
- **Consistent spacing** and **proportional scaling**
- **Grid-based positioning** for optimal layout
- **Responsive design** adapting to screen sizes

### Data Flow
```
Workflow Files → workflowDataService → Panel Components → VSCode Integration
     ↓                    ↓                    ↓                ↓
Core Scripts → Live Parsing → Real-time UI → Command Execution
```

### Service Integration
- **workflowDataService**: Parses workflow files and builds hierarchy
- **vscodeIntegrationService**: Handles VSCode commands and task management
- **uDeskDataService**: Manages panel data and state
- **udosGridSystem**: Provides layout and positioning services

[Continue to VSCode Integration →](VSCode-Integration) | [Learn about uDOS Grid System →](uDOS-Grid-System)
EOF

# Create VSCode Integration guide
cat > wiki-content/VSCode-Integration.md << 'EOF'
# VSCode Integration Guide

uDESK provides comprehensive VSCode integration through the **vscodeIntegrationService** and **PANEL system**, enabling seamless development workflow management.

## 🔗 Core Integration Features

### TODO Tree Synchronization
- **Automatic refresh** of VSCode TODO Tree extension
- **Real-time updates** when workflow files change
- **Bidirectional sync** between uDESK panels and VSCode
- **Custom TODO patterns** recognition and parsing

### Terminal Integration
- **Launch terminals** in uDESK workspace context
- **Preserve environment** variables and working directory
- **Multiple terminal** management from panels
- **Command execution** with output capture

### File Operations
- **Open workflow files** directly in VSCode editor
- **Navigate to specific** lines and TODO items
- **Bulk file operations** through panel interfaces
- **Real-time file watching** for automatic updates

### Task Management
- **Create VSCode tasks** from panel actions
- **Execute predefined** workflow tasks
- **Monitor task execution** status and output
- **Custom task** creation and management

## 🎛️ Panel-Specific Integrations

### TodoPanel VSCode Features
```typescript
// Real-time TODO Tree sync
await vscodeIntegrationService.refreshTodoTree();

// Open workflow file at specific TODO
await vscodeIntegrationService.openFile(filePath, lineNumber);

// Execute TODO-related tasks
await vscodeIntegrationService.executeTask('complete-todo', todoId);
```

### WorkflowPanel Command Center
```typescript
// Launch development terminal
await vscodeIntegrationService.createTerminal('uDESK-Dev', workspacePath);

// Execute workflow scripts
await vscodeIntegrationService.executeCommand('bash', [scriptPath, ...args]);

// Custom command execution
await vscodeIntegrationService.runCustomCommand(userInput);
```

### ProgressPanel Script Integration
```typescript
// Execute hierarchy management scripts
await vscodeIntegrationService.executeScript('workflow-hierarchy.sh');

// Update progress tracking
await vscodeIntegrationService.updateProgress(milestoneId, progress);
```

### SystemPanel Development Tools
```typescript
// Launch VSCode in workspace
await vscodeIntegrationService.launchVSCode(workspacePath);

// System health checks
await vscodeIntegrationService.executeHealthCheck();
```

## 🛠️ Service Architecture

### vscodeIntegrationService.ts
Core service providing VSCode integration capabilities:

```typescript
interface VSCodeIntegrationService {
  // Command execution
  executeCommand(command: string, args: string[]): Promise<CommandResult>;
  executeScript(scriptPath: string): Promise<ScriptResult>;
  runCustomCommand(input: string): Promise<CommandResult>;
  
  // Terminal management
  createTerminal(name: string, cwd: string): Promise<Terminal>;
  sendToTerminal(terminalId: string, command: string): Promise<void>;
  
  // File operations
  openFile(filePath: string, line?: number): Promise<void>;
  openWorkspace(workspacePath: string): Promise<void>;
  
  // TODO Tree integration
  refreshTodoTree(): Promise<void>;
  syncTodoTree(): Promise<TodoTreeItem[]>;
  
  // Task management
  executeTask(taskName: string, args?: any): Promise<TaskResult>;
  createTask(taskDefinition: TaskDefinition): Promise<Task>;
}
```

### Command Simulation
For Tauri environment compatibility:

```typescript
// Simulated VSCode API calls
const simulateVSCodeCommand = async (command: string, args: any[]) => {
  // Translate VSCode commands to shell equivalents
  switch (command) {
    case 'vscode.open':
      return await invoke('open_file_in_editor', { path: args[0] });
    case 'workbench.action.terminal.new':
      return await invoke('create_terminal', { cwd: args[0] });
    // ... more command mappings
  }
};
```

## 📋 Available Commands

### Workflow Commands
- `workflow.start` - Start new workflow session
- `workflow.complete` - Complete current workflow
- `workflow.sync` - Sync workflow data
- `workflow.hierarchy` - Display hierarchy view

### TODO Commands
- `todo.create` - Create new TODO item
- `todo.complete` - Mark TODO as completed
- `todo.assign` - Assign TODO to milestone
- `todo.sync` - Sync with VSCode TODO Tree

### System Commands
- `system.health` - Run system health check
- `system.update` - Update system components
- `system.clean` - Clean temporary files
- `system.backup` - Backup workflow data

### Development Commands
- `dev.terminal` - Launch development terminal
- `dev.build` - Execute build commands
- `dev.test` - Run test suites
- `dev.deploy` - Deploy applications

## 🎯 Usage Examples

### Daily Development Workflow
1. **Launch uDESK PANEL system**
2. **Check TodoPanel** for pending tasks
3. **Use WorkflowPanel** to launch VSCode terminal
4. **Execute workflow scripts** through panels
5. **Sync TODO Tree** after making changes
6. **Monitor progress** in ProgressPanel

### Project Setup
```bash
# From WorkflowPanel command input
workflow.start new-feature-branch

# Execute through SystemPanel
dev.terminal --workspace=/path/to/project

# Sync through TodoPanel
todo.sync --refresh-vscode
```

### Automation Integration
```typescript
// Panel button actions automatically integrate with VSCode
const handleTodoComplete = async (todoId: string) => {
  await vscodeIntegrationService.executeTask('complete-todo', { todoId });
  await vscodeIntegrationService.refreshTodoTree();
  await updateProgressTracking(todoId);
};
```

## 🔧 Configuration

### VSCode Extensions
Required extensions for full integration:
- **TODO Tree** - TODO comment management
- **Terminal** - Integrated terminal support
- **Task Runner** - Custom task execution
- **File Watcher** - Real-time file monitoring

### Workspace Settings
```json
{
  "todoTree.regex.regex": "((//|#|<!--|;|/\\*|^|^\\s*(-|\\*|\\+)|^\\s*[0-9]+(.\\s|)\\*)\\s*($TAGS))",
  "todoTree.general.tags": ["TODO", "FIXME", "BUG", "HACK", "NOTE", "XXX"],
  "terminal.integrated.cwd": "${workspaceFolder}",
  "tasks.version": "2.0.0"
}
```

### uDESK Configuration
```typescript
// Panel configuration for VSCode integration
const panelConfig = {
  vscode: {
    enabled: true,
    autoSync: true,
    todoTreeRefresh: true,
    terminalIntegration: true
  },
  workflow: {
    scriptExecution: true,
    realTimeUpdates: true,
    hierarchySync: true
  }
};
```

[Continue to Core Scripts →](Core-Scripts) | [Back to PANEL System →](PANEL-System)
EOF

# Copy existing documentation files if they exist
for file in "${!docs[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "wiki-content/${docs[$file]}.md"
        echo "  📄 Copied: $file → wiki-content/${docs[$file]}.md"
    fi
done

echo ""
echo "✅ Wiki content prepared in wiki-content/ directory"
echo "🎯 Next: Enable wiki in GitHub settings and follow the steps above"
