// Workflow Data Service for parsing uDESK core workflow scripts and TODO files
// Integrates with EXPRESS-DEV-TODOS.md and workflow-hierarchy.sh

export interface WorkflowTodo {
  id: string;
  number: string;
  title: string;
  description: string;
  status: 'not-started' | 'in-progress' | 'completed';
  priority: 'high' | 'medium' | 'low';
  milestone?: string;
  file: string;
  line: number;
}

export interface WorkflowMilestone {
  id: string;
  title: string;
  description: string;
  todos: WorkflowTodo[];
  completed: boolean;
  progress: number;
}

export interface WorkflowMission {
  id: string;
  title: string;
  description: string;
  milestones: WorkflowMilestone[];
  progress: number;
  status: 'active' | 'completed' | 'planned';
}

export interface WorkflowHierarchy {
  goal: string;
  mission: WorkflowMission;
  totalProgress: number;
  stats: {
    totalTodos: number;
    completedTodos: number;
    totalMilestones: number;
    completedMilestones: number;
  };
}

export class WorkflowDataService {
  private static instance: WorkflowDataService;
  private readonly baseDir: string = '/Users/fredbook/Code/uDESK';
  private todoFile: string = 'uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md';
  private cachedData: WorkflowHierarchy | null = null;
  
  private constructor() {}

  public static getInstance(): WorkflowDataService {
    if (!WorkflowDataService.instance) {
      WorkflowDataService.instance = new WorkflowDataService();
    }
    return WorkflowDataService.instance;
  }

  // Parse EXPRESS-DEV-TODOS.md file
  public async parseExpressDevTodos(): Promise<WorkflowTodo[]> {
    try {
      // In Tauri, we'll simulate reading the file
      // In production, use Tauri's fs API
      const mockTodoContent = `
# uDESK Express Dev Mode - TODO Integration Test

## Express Dev Sprint v1.0.7.3

// TODO-001: ✅ Express vs Dev Mode activation flow - COMPLETED
// TODO-002: ✅ AI-guided planning session system - COMPLETED  
// TODO-003: ✅ VSCode TODO Tree integration - COMPLETED
// TODO-004: ✅ Auto-assist mode activation - COMPLETED
// TODO-005: ✅ Workflow command completion - COMPLETED

// MILESTONE: Express Dev System Complete

// TODO-006: ✅ TODOs into uDESK variable system - COMPLETED
// TODO-007: ✅ Unified workflow commands - COMPLETED
// TODO-008: ✅ Mission/milestone/move/todo hierarchy - COMPLETED
// TODO-009: ✅ Workflow advancement engine - COMPLETED
// TODO-010: ✅ Big picture progress visualization - COMPLETED

// MILESTONE: Workflow System Complete

// TODO-011: ✅ TinyCore-inspired Tauri interface - COMPLETED
// TODO-012: 🚧 Desktop workflow widgets - IN PROGRESS
// TODO-013: VSCode browser simulation integration
// TODO-014: Production app with dock integration

// MILESTONE: CHEST Desktop Complete

// TODO-015: Dual structure deployment system
// TODO-016: VSCode workspace configuration
// TODO-017: Development-to-local deployment tools
// TODO-018: Comprehensive testing framework

// MILESTONE: Infrastructure Complete
`;

      return this.parseTodoContent(mockTodoContent);
    } catch (error) {
      console.error('Failed to parse EXPRESS-DEV-TODOS.md:', error);
      return [];
    }
  }

  // Parse TODO content and extract structured data
  private parseTodoContent(content: string): WorkflowTodo[] {
    const lines = content.split('\n');
    const todos: WorkflowTodo[] = [];
    let currentMilestone = '';

    lines.forEach((line, index) => {
      // Check for milestone markers
      const milestoneMatch = line.match(/\/\/\s*MILESTONE:\s*(.+)/);
      if (milestoneMatch) {
        currentMilestone = milestoneMatch[1];
        return;
      }

      // Parse TODO items
      const todoMatch = line.match(/\/\/\s*TODO-(\d+):\s*(.+)/);
      if (todoMatch) {
        const [, number, description] = todoMatch;
        const isCompleted = description.includes('✅') || description.includes('COMPLETED');
        const isInProgress = description.includes('🚧') || description.includes('IN PROGRESS');
        
        let status: WorkflowTodo['status'] = 'not-started';
        if (isCompleted) status = 'completed';
        else if (isInProgress) status = 'in-progress';

        const cleanDescription = description
          .replace(/✅.*COMPLETED/, '')
          .replace(/🚧.*IN PROGRESS/, '')
          .replace(/- COMPLETED$/, '')
          .trim();

        todos.push({
          id: `todo-${number}`,
          number: number.padStart(3, '0'),
          title: cleanDescription,
          description: cleanDescription,
          status,
          priority: this.determinePriority(number),
          milestone: currentMilestone,
          file: this.todoFile,
          line: index + 1
        });
      }
    });

    return todos;
  }

  // Determine priority based on TODO number and content
  private determinePriority(todoNumber: string): WorkflowTodo['priority'] {
    const num = parseInt(todoNumber);
    
    // High priority: Infrastructure and core system TODOs
    if (num <= 5 || num >= 15) return 'high';
    
    // Medium priority: Desktop and workflow TODOs
    if (num >= 11 && num <= 14) return 'medium';
    
    // Low priority: System integration TODOs
    return 'low';
  }

  // Group TODOs into milestones
  public async parseWorkflowMilestones(): Promise<WorkflowMilestone[]> {
    const todos = await this.parseExpressDevTodos();
    const milestoneMap = new Map<string, WorkflowTodo[]>();

    // Group TODOs by milestone
    todos.forEach(todo => {
      const milestone = todo.milestone || 'Unassigned';
      if (!milestoneMap.has(milestone)) {
        milestoneMap.set(milestone, []);
      }
      milestoneMap.get(milestone)!.push(todo);
    });

    // Convert to milestone objects
    const milestones: WorkflowMilestone[] = [];
    milestoneMap.forEach((todos, milestoneTitle) => {
      const completedTodos = todos.filter(t => t.status === 'completed').length;
      const progress = Math.round((completedTodos / todos.length) * 100);
      
      milestones.push({
        id: milestoneTitle.toLowerCase().replace(/\s+/g, '-'),
        title: milestoneTitle,
        description: `${todos.length} TODOs in this milestone`,
        todos: todos.sort((a, b) => a.number.localeCompare(b.number)),
        completed: completedTodos === todos.length,
        progress
      });
    });

    return milestones.sort((a, b) => {
      // Sort by completion status, then by first TODO number
      if (a.completed !== b.completed) return a.completed ? 1 : -1;
      const aFirstTodo = a.todos[0]?.number || '999';
      const bFirstTodo = b.todos[0]?.number || '999';
      return aFirstTodo.localeCompare(bFirstTodo);
    });
  }

  // Build complete workflow hierarchy
  public async getWorkflowHierarchy(): Promise<WorkflowHierarchy> {
    if (this.cachedData) {
      return this.cachedData;
    }

    try {
      const milestones = await this.parseWorkflowMilestones();
      const allTodos = milestones.flatMap(m => m.todos);
      
      const completedTodos = allTodos.filter(t => t.status === 'completed').length;
      const completedMilestones = milestones.filter(m => m.completed).length;
      const totalProgress = Math.round((completedTodos / allTodos.length) * 100);

      const mission: WorkflowMission = {
        id: 'express-dev-v1073',
        title: 'uDESK Express Dev Mode v1.0.7.3',
        description: 'Complete AI-guided development system with workflow integration',
        milestones,
        progress: totalProgress,
        status: completedMilestones === milestones.length ? 'completed' : 'active'
      };

      this.cachedData = {
        goal: 'Build comprehensive uDESK development workflow system',
        mission,
        totalProgress,
        stats: {
          totalTodos: allTodos.length,
          completedTodos,
          totalMilestones: milestones.length,
          completedMilestones
        }
      };

      return this.cachedData;
    } catch (error) {
      console.error('Failed to build workflow hierarchy:', error);
      throw error;
    }
  }

  // Get active TODOs (not completed)
  public async getActiveTodos(): Promise<WorkflowTodo[]> {
    const hierarchy = await this.getWorkflowHierarchy();
    return hierarchy.mission.milestones
      .flatMap(m => m.todos)
      .filter(t => t.status !== 'completed')
      .sort((a, b) => {
        // Sort by priority, then by number
        const priorityOrder = { high: 0, medium: 1, low: 2 };
        if (a.priority !== b.priority) {
          return priorityOrder[a.priority] - priorityOrder[b.priority];
        }
        return a.number.localeCompare(b.number);
      });
  }

  // Get progress summary
  public async getProgressSummary(): Promise<{
    overall: number;
    byMilestone: Array<{ name: string; progress: number; status: string }>;
    byPriority: Record<string, { total: number; completed: number }>;
  }> {
    const hierarchy = await this.getWorkflowHierarchy();
    
    const byMilestone = hierarchy.mission.milestones.map(m => ({
      name: m.title,
      progress: m.progress,
      status: m.completed ? 'Complete' : 'In Progress'
    }));

    const allTodos = hierarchy.mission.milestones.flatMap(m => m.todos);
    const byPriority = {
      high: { total: 0, completed: 0 },
      medium: { total: 0, completed: 0 },
      low: { total: 0, completed: 0 }
    };

    allTodos.forEach(todo => {
      byPriority[todo.priority].total++;
      if (todo.status === 'completed') {
        byPriority[todo.priority].completed++;
      }
    });

    return {
      overall: hierarchy.totalProgress,
      byMilestone,
      byPriority
    };
  }

  // Simulate shell script execution
  public async executeWorkflowScript(scriptName: string, args: string[] = []): Promise<any> {
    console.log(`Simulating execution of ${scriptName} with args:`, args);
    
    switch (scriptName) {
      case 'todo-management.sh':
        return this.simulateTodoManagement(args);
      
      case 'workflow-hierarchy.sh':
        return this.simulateWorkflowHierarchy(args);
      
      case 'progress-visualization.sh':
        return this.simulateProgressVisualization(args);
      
      default:
        return { success: true, output: `Executed ${scriptName}`, simulated: true };
    }
  }

  private async simulateTodoManagement(args: string[]): Promise<any> {
    if (args.includes('status')) {
      const hierarchy = await this.getWorkflowHierarchy();
      return {
        success: true,
        output: `Progress: ${hierarchy.stats.completedTodos}/${hierarchy.stats.totalTodos} completed`,
        data: hierarchy.stats
      };
    }
    
    return { success: true, output: 'TODO management command executed' };
  }

  private async simulateWorkflowHierarchy(_args: string[]): Promise<any> {
    const hierarchy = await this.getWorkflowHierarchy();
    return {
      success: true,
      output: 'Workflow hierarchy displayed',
      data: hierarchy
    };
  }

  private async simulateProgressVisualization(_args: string[]): Promise<any> {
    const summary = await this.getProgressSummary();
    return {
      success: true,
      output: 'Progress visualization generated',
      data: summary
    };
  }

  // Clear cache to force refresh
  public clearCache(): void {
    this.cachedData = null;
  }

  // Update TODO status (for testing)
  public async updateTodoStatus(todoId: string, status: WorkflowTodo['status']): Promise<void> {
    // In production, this would update the actual file
    // For now, just clear cache to simulate update
    this.clearCache();
    console.log(`Updated ${todoId} status to ${status}`);
  }
}

export default WorkflowDataService;
