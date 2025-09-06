import React, { useState, useEffect } from 'react';
import VSCodeIntegrationService from '../../services/vscodeIntegrationService';
import WorkflowDataService from '../../services/workflowDataService';

interface WorkflowAction {
  id: string;
  title: string;
  description: string;
  icon: string;
  command: string;
  script?: string;
  category: 'workflow' | 'legacy' | 'progress' | 'system' | 'vscode';
}

interface WorkflowPanelProps {
  className?: string;
  onActionExecute?: (command: string) => void;
}

export const WorkflowPanel: React.FC<WorkflowPanelProps> = ({ 
  className = '', 
  onActionExecute 
}) => {
  const [activeCategory, setActiveCategory] = useState<string>('workflow');
  const [lastExecuted, setLastExecuted] = useState<string>('');
  const [executing, setExecuting] = useState<string | null>(null);

  const vscodeService = VSCodeIntegrationService.getInstance();
  const workflowService = WorkflowDataService.getInstance();

  const actions: WorkflowAction[] = [
    {
      id: 'create-todo',
      title: 'Create TODO',
      description: 'Add new TODO item to workflow',
      icon: '📝',
      command: 'workflow create-todo',
      script: 'todo-management.sh',
      category: 'workflow'
    },
    {
      id: 'run-workflow',
      title: 'Run Workflow',
      description: 'Execute unified workflow engine',
      icon: '🚀',
      command: 'workflow run',
      script: 'unified-workflow.sh',
      category: 'workflow'
    },
    {
      id: 'show-status',
      title: 'Workflow Status',
      description: 'Display current workflow status',
      icon: '📋',
      command: 'workflow status',
      script: 'todo-management.sh',
      category: 'workflow'
    },
    {
      id: 'open-todos',
      title: 'Open TODOs',
      description: 'Open EXPRESS-DEV-TODOS.md in VSCode',
      icon: '📂',
      command: 'vscode open-todos',
      category: 'vscode'
    },
    {
      id: 'sync-todo-tree',
      title: 'Sync TODO Tree',
      description: 'Refresh VSCode TODO Tree extension',
      icon: '�',
      command: 'vscode sync-todos',
      category: 'vscode'
    },
    {
      id: 'open-terminal',
      title: 'Open Terminal',
      description: 'Open VSCode terminal in workspace',
      icon: '�',
      command: 'vscode terminal',
      category: 'vscode'
    },
    {
      id: 'show-progress',
      title: 'Progress Dashboard',
      description: 'Display visual progress overview',
      icon: '📊',
      command: 'progress',
      script: 'progress-visualization.sh',
      category: 'progress'
    },
    {
      id: 'milestone-status',
      title: 'Milestone Status',
      description: 'Check milestone completion',
      icon: '🎯',
      command: 'progress milestone',
      script: 'milestone-checkpoints.sh',
      category: 'progress'
    },
    {
      id: 'system-health',
      title: 'System Health',
      description: 'Check system health status',
      icon: '⚡',
      command: 'system health',
      category: 'system'
    },
    {
      id: 'backup-system',
      title: 'Backup System',
      description: 'Create system backup',
      icon: '💾',
      command: 'system backup',
      category: 'system'
    }
  ];

  const categories = [
    { id: 'workflow', name: 'Workflow', icon: '⚙️' },
    { id: 'vscode', name: 'VSCode', icon: '💻' },
    { id: 'progress', name: 'Progress', icon: '📊' },
    { id: 'system', name: 'System', icon: '⚡' }
  ];

  const filteredActions = actions.filter(action => action.category === activeCategory);

  const executeAction = async (action: WorkflowAction) => {
    try {
      setExecuting(action.id);
      setLastExecuted(action.title);
      
      // Execute based on category
      if (action.category === 'vscode') {
        await executeVSCodeAction(action);
      } else if (action.script) {
        await vscodeService.executeWorkflowScript(action.script);
      } else if (onActionExecute) {
        onActionExecute(action.command);
      }
      
      console.log(`Executed: ${action.title}`);
    } catch (error) {
      console.error(`Failed to execute ${action.title}:`, error);
    } finally {
      setExecuting(null);
      // Clear the "last executed" indicator after 3 seconds
      setTimeout(() => setLastExecuted(''), 3000);
    }
  };

  const executeVSCodeAction = async (action: WorkflowAction) => {
    switch (action.id) {
      case 'open-todos':
        await vscodeService.openWorkflowFile('EXPRESS-DEV-TODOS.md');
        break;
      case 'sync-todo-tree':
        await vscodeService.syncWithTodoTree();
        break;
      case 'open-terminal':
        await vscodeService.openTerminal('uDESK Workflow');
        break;
      default:
        console.log(`VSCode action: ${action.command}`);
    }
  };

  return (
    <div className={`workflow-panel ${className}`}>
      <div className="panel-header">
        <h3 className="panel-title">
          ⚙️ Workflow Actions
        </h3>
        {lastExecuted && (
          <div className="last-executed">
            Executed: {lastExecuted} ✓
          </div>
        )}
      </div>

      {/* Category Tabs */}
      <div className="category-tabs">
        {categories.map((category) => (
          <button
            key={category.id}
            className={`category-tab ${activeCategory === category.id ? 'active' : ''}`}
            onClick={() => setActiveCategory(category.id)}
          >
            <span className="tab-icon">{category.icon}</span>
            <span className="tab-name">{category.name}</span>
          </button>
        ))}
      </div>

      {/* Action Buttons */}
      <div className="action-grid">
        {filteredActions.map((action) => (
          <button
            key={action.id}
            className={`action-button ${executing === action.id ? 'executing' : ''}`}
            onClick={() => executeAction(action)}
            disabled={executing === action.id}
            title={action.description}
          >
            <div className="action-icon">
              {executing === action.id ? '⏳' : action.icon}
            </div>
            <div className="action-title">{action.title}</div>
            <div className="action-description">
              {executing === action.id ? 'Executing...' : action.description}
            </div>
          </button>
        ))}
      </div>

      {/* Quick Command Input */}
      <div className="panel-footer">
        <div className="quick-command">
          <input
            type="text"
            placeholder="Type command..."
            className="command-input"
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                const input = e.target as HTMLInputElement;
                if (input.value.trim()) {
                  const command = input.value.trim();
                  if (onActionExecute) {
                    onActionExecute(command);
                  }
                  setLastExecuted(`Custom: ${command}`);
                  input.value = '';
                  setTimeout(() => setLastExecuted(''), 3000);
                }
              }
            }}
          />
          <button className="execute-btn">⚡</button>
        </div>
      </div>

      <div className="panel-footer">
        <button 
          className="panel-action-btn"
          onClick={() => vscodeService.openWorkflowFile('EXPRESS-DEV-TODOS.md')}
        >
          📝 TODOs
        </button>
        <button 
          className="panel-action-btn"
          onClick={() => vscodeService.syncWithTodoTree()}
        >
          🔄 Sync
        </button>
      </div>
    </div>
  );
};
