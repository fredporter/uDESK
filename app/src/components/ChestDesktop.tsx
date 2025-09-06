import React, { useState, useEffect } from 'react';
import { ThemeName, getTheme, themeAssets } from '../lib/themes';
import { TodoPanel } from './panels/TodoPanel';
import { ProgressPanel } from './panels/ProgressPanel';
import { WorkflowPanel } from './panels/WorkflowPanel';
import { SystemPanel } from './panels/SystemPanel';
import { udosGridSystem } from '../services/udosGridSystem';
import ErrorBoundary from './ErrorBoundary';
import './ChestDesktop.css';
import './panels/Panels.css';

interface ChestDesktopProps {
  theme: ThemeName;
  onThemeChange: (theme: ThemeName) => void;
}

interface DesktopIcon {
  id: string;
  label: string;
  icon: string;
  action: () => void;
}

interface TaskbarApp {
  id: string;
  name: string;
  icon: string;
  active: boolean;
}

export const ChestDesktop: React.FC<ChestDesktopProps> = ({ theme, onThemeChange }) => {
  const [currentTime, setCurrentTime] = useState(new Date());
  const [taskbarApps, setTaskbarApps] = useState<TaskbarApp[]>([
    { id: 'file-manager', name: 'Files', icon: '📁', active: false },
    { id: 'terminal', name: 'Terminal', icon: '⚡', active: false },
    { id: 'workflow', name: 'Workflow', icon: '⚙️', active: false },
    { id: 'progress', name: 'Progress', icon: '📊', active: false },
  ]);

  const [desktopIcons, setDesktopIcons] = useState<DesktopIcon[]>([
    {
      id: 'terminal',
      label: 'Terminal',
      icon: '⚡',
      action: () => openTerminal(),
    },
    {
      id: 'workflow',
      label: 'Unified Workflow',
      icon: '⚙️',
      action: () => openWorkflow(),
    },
    {
      id: 'progress',
      label: 'Progress Dashboard',
      icon: '📊',
      action: () => openProgress(),
    },
    {
      id: 'legacy',
      label: 'Legacy Archive',
      icon: '🏛️',
      action: () => openLegacy(),
    },
    {
      id: 'files',
      label: 'File Manager',
      icon: '📁',
      action: () => openFiles(),
    },
    {
      id: 'settings',
      label: 'Settings',
      icon: '⚙️',
      action: () => openSettings(),
    },
  ]);

  const [activeWindow, setActiveWindow] = useState<string | null>(null);
  const [showWidgets, setShowWidgets] = useState(true);
  const [terminalHistory, setTerminalHistory] = useState<string[]>([
    'CHEST Desktop v1.0.0 (TinyCore Linux inspired)',
    'Welcome to uDESK Unified Workflow System',
    '',
    'Available commands:',
    '  workflow --help    Show all workflow commands',
    '  progress           Show progress dashboard',
    '  legacy --list      List legacy archive items',
    '  todo --status      Show TODO status',
    '',
  ]);
  const [terminalInput, setTerminalInput] = useState('');
  const [systemStats, setSystemStats] = useState({
    cpu: '2%',
    memory: '234MB',
    uptime: '2:34:56',
  });

  // Initialize uDOS Grid System and get CSS variables
  const udosVariables = udosGridSystem.generateCSSVariables();
  
  useEffect(() => {
    // Apply uDOS grid system variables to CSS
    const root = document.documentElement;
    Object.entries(udosVariables).forEach(([key, value]) => {
      root.style.setProperty(key, value);
    });
    
    // Initialize panel tiles in the grid
    udosGridSystem.setDisplayMode('DESKTOP');
    udosGridSystem.clearGrid();
    
    // Create panel tiles
    const panelPositions = udosGridSystem.calculatePanelLayout(4);
    const panelTypes = ['todo', 'progress', 'workflow', 'system'] as const;
    
    panelTypes.forEach((type, index) => {
      if (panelPositions[index]) {
        const tile = udosGridSystem.createPanelTile(
          `panel-${type}`,
          panelPositions[index],
          type
        );
        udosGridSystem.addTileToGrid(tile);
      }
    });
  }, []);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const openTerminal = () => {
    setActiveWindow('terminal');
    updateTaskbar('terminal', true);
  };

  const openWorkflow = () => {
    setActiveWindow('workflow');
    updateTaskbar('workflow', true);
  };

  const openProgress = () => {
    setActiveWindow('progress');
    updateTaskbar('progress', true);
  };

  const openLegacy = () => {
    setActiveWindow('legacy');
  };

  const openFiles = () => {
    setActiveWindow('file-manager');
    updateTaskbar('file-manager', true);
  };

  const openSettings = () => {
    setActiveWindow('settings');
  };

  const executeCommand = (command: string) => {
    const cmd = command.trim().toLowerCase();
    setTerminalHistory(prev => [...prev, `${themeAssets.prompts[theme] || 'tc@chest:~$'} ${command}`]);
    
    switch (cmd) {
      case 'workflow --help':
        setTerminalHistory(prev => [...prev, 
          '',
          'Unified Workflow Commands:',
          '  workflow create-todo <title>  Create a new TODO item',
          '  workflow run                  Execute workflow engine',
          '  workflow status               Show workflow status',
          '  workflow archive <id>         Archive a completed mission',
          '',
        ]);
        break;
        
      case 'progress':
        setTerminalHistory(prev => [...prev,
          '',
          '📊 Progress Dashboard:',
          '──────────────────────────────────────',
          '  TODOs Completed: 10/18 (55%)',
          '  Legacy Items: 4 archives created',
          '  System Health: ████████░░ 80%',
          '  Workflow Status: Active',
          '',
          '█████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░ 55%',
          '',
        ]);
        break;
        
      case 'legacy --list':
        setTerminalHistory(prev => [...prev,
          '',
          '🏛️ Legacy Archive Items:',
          '──────────────────────────────────────',
          '  💎 TREASURE_20250906_194210 (Value: 10/10)',
          '  🏛️ ARCHIVE_20250906_194546_uDOS_LEGACY_v1',
          '  🏛️ ARCHIVE_20250906_194335_uDOS_LEGACY_v1',
          '  📖 STORY_20250906_194227_uDOS_LEGACY_v1',
          '',
          'Total: 4 legacy items preserved',
          '',
        ]);
        break;
        
      case 'todo --status':
        setTerminalHistory(prev => [...prev,
          '',
          '✅ TODO Status Report:',
          '──────────────────────────────────────',
          '  🏁 Completed: 10 items',
          '  🚀 In Progress: 1 item (TODO-011)',
          '  📋 Pending: 7 items',
          '  📊 Overall Progress: 55%',
          '',
          'Current milestone: CHEST Desktop',
          '',
        ]);
        break;
        
      case 'clear':
        setTerminalHistory([]);
        return;
        
      case 'help':
        setTerminalHistory(prev => [...prev,
          '',
          'Available commands:',
          '  workflow --help    Show workflow commands',
          '  progress           Show progress dashboard',
          '  legacy --list      List legacy items',
          '  todo --status      Show TODO status',
          '  clear              Clear terminal',
          '  help               Show this help',
          '',
        ]);
        break;
        
      default:
        setTerminalHistory(prev => [...prev, `Command not found: ${command}`, '']);
    }
  };

  const handleTerminalSubmit = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && terminalInput.trim()) {
      executeCommand(terminalInput);
      setTerminalInput('');
    }
  };

  const updateTaskbar = (appId: string, active: boolean) => {
    setTaskbarApps(prev => 
      prev.map(app => 
        app.id === appId ? { ...app, active } : app
      )
    );
  };

  const closeWindow = () => {
    setActiveWindow(null);
    setTaskbarApps(prev => prev.map(app => ({ ...app, active: false })));
  };

  const currentTheme = getTheme(theme);
  const themeLogo = themeAssets.logos[theme] || themeAssets.logos.tinycore;

  return (
    <div className="chest-desktop">
      {/* Desktop Background */}
      <div className="desktop-background">
        
        {/* Desktop Icons Grid */}
        <div className="desktop-icons">
          {desktopIcons.map((icon) => (
            <div
              key={icon.id}
              className="desktop-icon"
              onDoubleClick={icon.action}
              title={icon.label}
            >
              <div className="icon-graphic">{icon.icon}</div>
              <div className="icon-label">{icon.label}</div>
            </div>
          ))}
        </div>

        {/* Active Window */}
        {activeWindow && (
          <div className="window-container">
            <div className="window">
              <div className="window-titlebar">
                <div className="window-title">
                  {activeWindow === 'terminal' && '⚡ Terminal'}
                  {activeWindow === 'workflow' && '⚙️ Unified Workflow'}
                  {activeWindow === 'progress' && '📊 Progress Dashboard'}
                  {activeWindow === 'file-manager' && '📁 File Manager'}
                  {activeWindow === 'settings' && '⚙️ Settings'}
                </div>
                <div className="window-controls">
                  <button className="window-minimize">−</button>
                  <button className="window-maximize">□</button>
                  <button className="window-close" onClick={closeWindow}>×</button>
                </div>
              </div>
              <div className="window-content">
                {activeWindow === 'terminal' && (
                  <div className="terminal-window">
                    <pre>{themeLogo}</pre>
                    <div className="terminal-content">
                      {terminalHistory.map((line, index) => (
                        <div key={index} className="terminal-line">{line}</div>
                      ))}
                      <div className="terminal-input-line">
                        <span className="terminal-prompt">
                          {themeAssets.prompts[theme] || 'tc@chest:~$'}
                        </span>
                        <input
                          type="text"
                          value={terminalInput}
                          onChange={(e) => setTerminalInput(e.target.value)}
                          onKeyDown={handleTerminalSubmit}
                          className="terminal-input"
                          autoFocus
                          spellCheck={false}
                        />
                        <span className="cursor">_</span>
                      </div>
                    </div>
                  </div>
                )}
                {activeWindow === 'workflow' && (
                  <div className="workflow-window">
                    <h3>🔄 Unified Workflow Commands</h3>
                    <div className="command-grid">
                      <button className="workflow-cmd">📝 Create TODO</button>
                      <button className="workflow-cmd">🏃 Run Workflow</button>
                      <button className="workflow-cmd">📊 Show Progress</button>
                      <button className="workflow-cmd">🏛️ Archive Mission</button>
                      <button className="workflow-cmd">🔍 Analyze Moves</button>
                      <button className="workflow-cmd">💎 Create Treasure</button>
                    </div>
                  </div>
                )}
                {activeWindow === 'progress' && (
                  <div className="progress-window">
                    <h3>📊 Progress Overview</h3>
                    <div className="progress-stats">
                      <div className="stat-item">
                        <span className="stat-label">TODOs Completed:</span>
                        <span className="stat-value">10/18 (55%)</span>
                      </div>
                      <div className="stat-item">
                        <span className="stat-label">Legacy Items:</span>
                        <span className="stat-value">4 items</span>
                      </div>
                      <div className="progress-bar">
                        <div className="progress-fill" style={{ width: '55%' }}></div>
                      </div>
                    </div>
                  </div>
                )}
                {activeWindow === 'file-manager' && (
                  <div className="files-window">
                    <h3>📁 uDESK File System</h3>
                    <div className="file-tree">
                      <div className="folder">📁 core/</div>
                      <div className="folder">📁 uMEMORY/</div>
                      <div className="folder">📁 src/</div>
                      <div className="folder">📁 app/</div>
                      <div className="file">📄 README.md</div>
                      <div className="file">📄 EXPRESS-DEV-TODOS.md</div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Panels Container */}
      {showWidgets && (
        <div className="widgets-panel">
          <div className="widgets-header">
            <h3>📊 Dashboard Panels</h3>
            <button 
              className="toggle-widgets-btn"
              onClick={() => setShowWidgets(false)}
              title="Hide Panels"
            >
              ×
            </button>
          </div>
          <div className="widgets-container">
            <ErrorBoundary panelName="TodoPanel">
              <TodoPanel className="widget-item" />
            </ErrorBoundary>
            <ErrorBoundary panelName="ProgressPanel">
              <ProgressPanel className="widget-item" />
            </ErrorBoundary>
            <ErrorBoundary panelName="WorkflowPanel">
              <WorkflowPanel 
                className="widget-item"
                onActionExecute={(command: string) => {
                  // Add command to terminal history
                  setTerminalHistory(prev => [...prev, `Executed: ${command}`, '']);
                }}
              />
            </ErrorBoundary>
            <ErrorBoundary panelName="SystemPanel">
              <SystemPanel className="widget-item" />
            </ErrorBoundary>
          </div>
        </div>
      )}

      {/* Show Panels Button (when hidden) */}
      {!showWidgets && (
        <button 
          className="show-widgets-btn"
          onClick={() => setShowWidgets(true)}
          title="Show Panels"
        >
          📊
        </button>
      )}

      {/* Bottom Taskbar */}
      <div className="taskbar">
        
        {/* Start Menu */}
        <div className="start-menu">
          <div className="start-button">
            <span className="start-icon">⚡</span>
            <span className="start-text">CHEST</span>
          </div>
        </div>

        {/* Running Applications */}
        <div className="taskbar-apps">
          {taskbarApps.map((app) => (
            <div
              key={app.id}
              className={`taskbar-app ${app.active ? 'active' : ''}`}
              onClick={() => {
                if (app.id === 'terminal') openTerminal();
                if (app.id === 'workflow') openWorkflow();
                if (app.id === 'progress') openProgress();
                if (app.id === 'file-manager') openFiles();
              }}
            >
              <span className="app-icon">{app.icon}</span>
              <span className="app-name">{app.name}</span>
            </div>
          ))}
        </div>

        {/* System Tray */}
        <div className="system-tray">
          <div className="system-stats">
            <span title="CPU Usage">{systemStats.cpu}</span>
            <span title="Memory Usage">{systemStats.memory}</span>
          </div>
          <button 
            className="widgets-toggle"
            onClick={() => setShowWidgets(!showWidgets)}
            title={showWidgets ? 'Hide Panels' : 'Show Panels'}
          >
            📊
          </button>
          <div className="system-time">
            {currentTime.toLocaleTimeString()}
          </div>
        </div>
      </div>
    </div>
  );
};
