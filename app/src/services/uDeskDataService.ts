/**
 * uDESK Data Service
 * Provides interface between CHEST Desktop UI and uDESK core system
 * Integrates with TinyCore Linux workflow patterns
 */

export interface TodoItem {
  id: string;
  title: string;
  description: string;
  status: 'ACTIVE' | 'IN_PROGRESS' | 'COMPLETED' | 'ARCHIVED';
  priority: 'HIGH' | 'MEDIUM' | 'LOW';
  category: 'EXPRESS_DEV' | 'WORKFLOW' | 'CHEST' | 'INFRASTRUCTURE';
  timestamp: string;
  milestone?: string;
}

export interface ProgressData {
  overallProgress: number;
  completedTodos: number;
  totalTodos: number;
  activeTodos: number;
  inProgressTodos: number;
  currentMilestone: string;
  milestones: MilestoneData[];
  legacyStats: LegacyStats;
}

export interface MilestoneData {
  id: string;
  name: string;
  status: 'COMPLETED' | 'IN_PROGRESS' | 'PENDING';
  todos: string[];
  completionDate?: string;
  progress: number;
}

export interface LegacyStats {
  archives: number;
  treasures: number;
  stories: number;
  lastActivity: string;
}

export interface SystemStats {
  cpu: string;
  memory: string;
  storage: string;
  network: string;
  uptime: string;
  processes: number;
}

export interface WorkflowAction {
  id: string;
  name: string;
  category: 'workflow' | 'legacy' | 'progress' | 'system';
  command: string;
  description: string;
  icon: string;
}

class UDeskDataService {
  private baseUrl = 'http://localhost:3001/api'; // Future API endpoint
  private isApiMode = false; // Switch between API and mock mode

  constructor() {
    // For now, use mock data that reflects real uDESK structure
    this.isApiMode = false;
  }

  // TODO Management
  async getTodos(): Promise<TodoItem[]> {
    if (this.isApiMode) {
      // Future: Call actual uDESK core API
      const response = await fetch(`${this.baseUrl}/todos`);
      return response.json();
    }

    // Mock data based on actual uDESK TODO structure
    return [
      {
        id: 'TODO-011',
        title: 'TinyCore-inspired Tauri interface',
        description: 'Design CHEST desktop with TC aesthetic',
        status: 'COMPLETED',
        priority: 'HIGH',
        category: 'CHEST',
        timestamp: '2025-09-06T10:30:00Z',
        milestone: 'chest_desktop'
      },
      {
        id: 'TODO-012',
        title: 'Desktop workflow widgets',
        description: 'Create TODO widgets and progress bars for CHEST',
        status: 'IN_PROGRESS',
        priority: 'HIGH',
        category: 'CHEST',
        timestamp: '2025-09-06T14:15:00Z',
        milestone: 'chest_desktop'
      },
      {
        id: 'TODO-013',
        title: 'VSCode browser simulation integration',
        description: 'Implement shared UI development workflow',
        status: 'ACTIVE',
        priority: 'MEDIUM',
        category: 'WORKFLOW',
        timestamp: '2025-09-06T15:00:00Z',
        milestone: 'chest_desktop'
      },
      {
        id: 'TODO-014',
        title: 'Production app with dock integration',
        description: 'Build production Tauri app with platform features',
        status: 'ACTIVE',
        priority: 'HIGH',
        category: 'INFRASTRUCTURE',
        timestamp: '2025-09-06T16:00:00Z',
        milestone: 'chest_desktop'
      }
    ];
  }

  async updateTodoStatus(todoId: string, status: TodoItem['status']): Promise<boolean> {
    if (this.isApiMode) {
      const response = await fetch(`${this.baseUrl}/todos/${todoId}/status`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status })
      });
      return response.ok;
    }

    // Mock implementation
    console.log(`[uDESK] TODO ${todoId} status updated to ${status}`);
    return true;
  }

  // Progress Tracking
  async getProgressData(): Promise<ProgressData> {
    if (this.isApiMode) {
      const response = await fetch(`${this.baseUrl}/progress`);
      return response.json();
    }

    // Mock data reflecting actual uDESK milestones
    return {
      overallProgress: 61,
      completedTodos: 11,
      totalTodos: 18,
      activeTodos: 6,
      inProgressTodos: 1,
      currentMilestone: 'chest_desktop',
      milestones: [
        {
          id: 'express_dev_system',
          name: 'Express Dev System',
          status: 'COMPLETED',
          todos: ['TODO-001', 'TODO-002', 'TODO-003', 'TODO-004', 'TODO-005'],
          completionDate: '2025-09-05T18:30:00Z',
          progress: 100
        },
        {
          id: 'workflow_system',
          name: 'Workflow System',
          status: 'COMPLETED',
          todos: ['TODO-006', 'TODO-007', 'TODO-008', 'TODO-009', 'TODO-010'],
          completionDate: '2025-09-06T09:00:00Z',
          progress: 100
        },
        {
          id: 'chest_desktop',
          name: 'CHEST Desktop',
          status: 'IN_PROGRESS',
          todos: ['TODO-011', 'TODO-012', 'TODO-013', 'TODO-014'],
          progress: 50
        },
        {
          id: 'infrastructure',
          name: 'Infrastructure',
          status: 'PENDING',
          todos: ['TODO-015', 'TODO-016', 'TODO-017', 'TODO-018'],
          progress: 0
        }
      ],
      legacyStats: {
        archives: 3,
        treasures: 2,
        stories: 1,
        lastActivity: '2025-09-06T14:30:00Z'
      }
    };
  }

  // Workflow Actions
  async getWorkflowActions(): Promise<WorkflowAction[]> {
    return [
      // Workflow Category
      { id: 'create-todo', name: 'Create TODO', category: 'workflow', command: 'workflow todo create', description: 'Create new TODO item', icon: '📝' },
      { id: 'run-workflow', name: 'Run Workflow', category: 'workflow', command: 'workflow unified', description: 'Execute unified workflow', icon: '🏃' },
      { id: 'show-progress', name: 'Show Progress', category: 'workflow', command: 'workflow progress', description: 'Display progress overview', icon: '📊' },
      
      // Legacy Category
      { id: 'archive-mission', name: 'Archive Mission', category: 'legacy', command: 'workflow legacy archive', description: 'Archive completed mission', icon: '🏛️' },
      { id: 'create-treasure', name: 'Create Treasure', category: 'legacy', command: 'workflow legacy treasure', description: 'Create knowledge treasure', icon: '💎' },
      
      // Progress Category
      { id: 'check-milestones', name: 'Check Milestones', category: 'progress', command: 'workflow checkpoint check', description: 'Check milestone completion', icon: '🎯' },
      { id: 'sync-systems', name: 'Sync Systems', category: 'progress', command: 'workflow sync auto', description: 'Synchronize all systems', icon: '🔄' },
      
      // System Category
      { id: 'system-status', name: 'System Status', category: 'system', command: 'workflow status overview', description: 'Complete system status', icon: '💻' },
      { id: 'organize-files', name: 'Organize Files', category: 'system', command: 'workflow organize', description: 'Clean repository structure', icon: '🧹' },
      { id: 'ai-assist', name: 'AI Assist', category: 'system', command: 'workflow assist run', description: 'Get AI assistance', icon: '🤖' }
    ];
  }

  // System Monitoring
  async getSystemStats(): Promise<SystemStats> {
    if (this.isApiMode) {
      const response = await fetch(`${this.baseUrl}/system/stats`);
      return response.json();
    }

    return {
      cpu: '15%',
      memory: '2.1GB / 8GB',
      storage: '45GB / 100GB',
      network: '12.5 MB/s',
      uptime: '2d 14h 32m',
      processes: 127
    };
  }

  // Command Execution
  async executeCommand(command: string): Promise<{ success: boolean; output: string }> {
    if (this.isApiMode) {
      const response = await fetch(`${this.baseUrl}/execute`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ command })
      });
      return response.json();
    }

    // Mock command execution with TinyCore patterns
    console.log(`[uDESK Core] Executing: ${command}`);
    
    // Simulate different command responses
    if (command.includes('todo create')) {
      return {
        success: true,
        output: '✅ TODO created successfully\n🎯 Added to current milestone\n📊 Progress updated'
      };
    } else if (command.includes('progress')) {
      return {
        success: true,
        output: '📊 Progress: 61% complete\n🎯 Current milestone: CHEST Desktop\n✅ 11/18 TODOs completed'
      };
    } else if (command.includes('sync')) {
      return {
        success: true,
        output: '🔄 Synchronizing systems...\n✅ Variable system updated\n✅ Progress tracking synced\n✅ Milestones checked'
      };
    } else {
      return {
        success: true,
        output: `✅ Command executed: ${command}\n📝 Output from uDESK core system`
      };
    }
  }

  // Real-time updates (Future: WebSocket connection)
  onDataUpdate(callback: (data: any) => void) {
    // Future: Implement WebSocket connection to uDESK core
    // For now, simulate periodic updates
    setInterval(() => {
      callback({
        type: 'progress_update',
        timestamp: new Date().toISOString(),
        data: { progress: Math.random() * 100 }
      });
    }, 30000); // Update every 30 seconds
  }
}

// Export singleton instance
export const uDeskDataService = new UDeskDataService();
export default uDeskDataService;
