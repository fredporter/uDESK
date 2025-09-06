import React, { useState, useEffect } from 'react';
import WorkflowDataService, { type WorkflowTodo } from '../../services/workflowDataService';
import VSCodeIntegrationService from '../../services/vscodeIntegrationService';

interface TodoPanelProps {
  className?: string;
}

export const TodoPanel: React.FC<TodoPanelProps> = ({ className = '' }) => {
  const [todos, setTodos] = useState<WorkflowTodo[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<'all' | 'active' | 'completed'>('all');

  const workflowService = WorkflowDataService.getInstance();
  const vscodeService = VSCodeIntegrationService.getInstance();

  useEffect(() => {
    loadTodos();
  }, []);

  const loadTodos = async () => {
    try {
      setLoading(true);
      setError(null);
      const activeTodos = await workflowService.getActiveTodos();
      const allTodosHierarchy = await workflowService.getWorkflowHierarchy();
      const allTodos = allTodosHierarchy.mission.milestones.flatMap(m => m.todos);
      
      // Show active todos first, then completed ones
      const sortedTodos = [
        ...activeTodos,
        ...allTodos.filter(t => t.status === 'completed').slice(-3) // Show last 3 completed
      ];
      
      setTodos(sortedTodos);
    } catch (err) {
      setError('Failed to load workflow data');
      console.error('Error loading todos:', err);
    } finally {
      setLoading(false);
    }
  };

  const markTodoComplete = async (id: string) => {
    try {
      await workflowService.updateTodoStatus(id, 'completed');
      await loadTodos(); // Refresh data
      
      // Notify VSCode
      await vscodeService.syncWithTodoTree();
    } catch (err) {
      console.error('Failed to mark todo complete:', err);
    }
  };

  const markTodoInProgress = async (id: string) => {
    try {
      await workflowService.updateTodoStatus(id, 'in-progress');
      await loadTodos(); // Refresh data
      
      // Notify VSCode
      await vscodeService.syncWithTodoTree();
    } catch (err) {
      console.error('Failed to mark todo in progress:', err);
    }
  };

  const openTodoInVSCode = async (todo: WorkflowTodo) => {
    try {
      await vscodeService.openWorkflowFile('EXPRESS-DEV-TODOS.md');
    } catch (err) {
      console.error('Failed to open TODO file in VSCode:', err);
    }
  };

  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return todo.status !== 'completed';
    if (filter === 'completed') return todo.status === 'completed';
    return true;
  });

  const completedCount = todos.filter(todo => todo.status === 'completed').length;
  const totalCount = todos.length;
  const progressPercentage = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return '#ff4444';
      case 'medium': return '#ffaa00';
      case 'low': return '#44aa44';
      default: return '#888888';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed': return '✅';
      case 'in-progress': return '🚀';
      case 'not-started': return '📋';
      default: return '❓';
    }
  };

  return (
    <div className={`todo-panel ${className}`}>
      <div className="panel-header">
        <h3 className="panel-title">
          📝 TODO Manager
        </h3>
        <div className="panel-progress">
          <span className="progress-text">{completedCount}/{totalCount}</span>
          <div className="progress-bar-mini">
            <div 
              className="progress-fill-mini" 
              style={{ width: `${progressPercentage}%` }}
            />
          </div>
        </div>
      </div>

      {loading && (
        <div className="panel-loading">
          <span>🔄 Loading workflow data...</span>
        </div>
      )}

      {error && (
        <div className="panel-error">
          <span>⚠️ {error}</span>
          <button onClick={loadTodos} className="retry-btn">🔄 Retry</button>
        </div>
      )}

      {!loading && !error && (
        <>
          <div className="panel-filters">
            <button 
              className={`filter-btn ${filter === 'all' ? 'active' : ''}`}
              onClick={() => setFilter('all')}
            >
              All ({totalCount})
            </button>
            <button 
              className={`filter-btn ${filter === 'active' ? 'active' : ''}`}
              onClick={() => setFilter('active')}
            >
              Active ({totalCount - completedCount})
            </button>
            <button 
              className={`filter-btn ${filter === 'completed' ? 'active' : ''}`}
              onClick={() => setFilter('completed')}
            >
              Done ({completedCount})
            </button>
          </div>

          <div className="todo-list">
            {filteredTodos.map((todo) => (
              <div key={todo.id} className={`todo-item ${todo.status}`}>
                <div className="todo-header">
                  <span className="todo-status">{getStatusIcon(todo.status)}</span>
                  <span 
                    className="todo-priority" 
                    style={{ color: getPriorityColor(todo.priority) }}
                  >
                    ●
                  </span>
                  <span className="todo-number">{todo.number}</span>
                  <span className="todo-title">{todo.title}</span>
                </div>
                <div className="todo-description">{todo.description}</div>
                {todo.milestone && (
                  <div className="todo-milestone">
                    🎯 {todo.milestone}
                  </div>
                )}
                <div className="todo-actions">
                  {todo.status === 'not-started' && (
                    <button 
                      className="action-btn start-btn"
                      onClick={() => markTodoInProgress(todo.id)}
                    >
                      🚀 Start
                    </button>
                  )}
                  {todo.status === 'in-progress' && (
                    <button 
                      className="action-btn complete-btn"
                      onClick={() => markTodoComplete(todo.id)}
                    >
                      ✅ Complete
                    </button>
                  )}
                  {todo.status === 'completed' && (
                    <span className="completion-badge">Completed ✓</span>
                  )}
                  <button 
                    className="action-btn view-btn"
                    onClick={() => openTodoInVSCode(todo)}
                    title="Open in VSCode"
                  >
                    📝 View
                  </button>
                </div>
              </div>
            ))}
          </div>

          <div className="panel-footer">
            <button 
              className="panel-action-btn"
              onClick={() => vscodeService.openWorkflowFile('EXPRESS-DEV-TODOS.md')}
            >
              ➕ Edit TODOs
            </button>
            <button 
              className="panel-action-btn"
              onClick={() => vscodeService.syncWithTodoTree()}
            >
              � Sync VSCode
            </button>
          </div>
        </>
      )}
    </div>
  );
};
