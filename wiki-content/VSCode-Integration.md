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
