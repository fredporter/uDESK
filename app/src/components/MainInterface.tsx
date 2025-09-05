import React, { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/core';
import { ThemeName, getTheme } from '../lib/themes';
import { BootSequence } from './BootSequence';
import { Setup } from './Setup';

interface MainInterfaceProps {
  theme: ThemeName;
  onThemeChange: (theme: ThemeName) => void;
}

interface UCodeCommand {
  id: string;
  command: string;
  output: string;
  timestamp: number;
  success: boolean;
}

export const MainInterface: React.FC<MainInterfaceProps> = ({ theme, onThemeChange }) => {
  const [isBooted, setIsBooted] = useState(false);
  const [currentView, setCurrentView] = useState<'desktop' | 'terminal' | 'container' | 'setup'>('desktop');
  const [commandHistory, setCommandHistory] = useState<UCodeCommand[]>([]);
  const [currentCommand, setCurrentCommand] = useState('');
  const [containerStatus, setContainerStatus] = useState<'stopped' | 'starting' | 'running' | 'error'>('stopped');
  const [extensions, setExtensions] = useState<string[]>([]);
  const [showFirstTimeSetup, setShowFirstTimeSetup] = useState(false);

  useEffect(() => {
    if (isBooted) {
      loadExtensions();
      checkContainerStatus();
      checkFirstTimeSetup();
    }
  }, [isBooted]);

  const checkFirstTimeSetup = async () => {
    try {
      const needsSetup = await invoke<boolean>('needs_first_time_setup');
      setShowFirstTimeSetup(needsSetup);
      if (needsSetup) {
        setCurrentView('setup');
      }
    } catch (error) {
      console.error('Failed to check setup status:', error);
    }
  };

  const loadExtensions = async () => {
    try {
      const exts = await invoke<string[]>('list_available_extensions');
      setExtensions(exts);
    } catch (error) {
      console.error('Failed to load extensions:', error);
    }
  };

  const checkContainerStatus = async () => {
    try {
      const status = await invoke<boolean>('check_container_status');
      setContainerStatus(status ? 'running' : 'stopped');
    } catch (error) {
      setContainerStatus('error');
    }
  };

  const executeUCodeCommand = async (command: string) => {
    const id = Date.now().toString();
    
    try {
      setCommandHistory(prev => [...prev, {
        id,
        command,
        output: 'Executing...',
        timestamp: Date.now(),
        success: true
      }]);

      const result = await invoke<string>('execute_ucode_command', { command });
      
      setCommandHistory(prev => prev.map(cmd => 
        cmd.id === id 
          ? { ...cmd, output: result, success: true }
          : cmd
      ));
      
    } catch (error) {
      setCommandHistory(prev => prev.map(cmd => 
        cmd.id === id 
          ? { ...cmd, output: `Error: ${error}`, success: false }
          : cmd
      ));
    }
  };

  const handleCommandSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (currentCommand.trim()) {
      executeUCodeCommand(currentCommand.trim());
      setCurrentCommand('');
    }
  };

  const startContainer = async () => {
    setContainerStatus('starting');
    try {
      await invoke('start_udesk_container');
      setContainerStatus('running');
    } catch (error) {
      setContainerStatus('error');
      console.error('Failed to start container:', error);
    }
  };

  const stopContainer = async () => {
    try {
      await invoke('stop_udesk_container');
      setContainerStatus('stopped');
    } catch (error) {
      console.error('Failed to stop container:', error);
    }
  };

  if (!isBooted) {
    return <BootSequence onBootComplete={() => setIsBooted(true)} />;
  }

  const currentTheme = getTheme(theme);

  return (
    <div className="main-interface">
      <div className="desktop-header">
        <div className="logo-area">
          <span className="system-logo">{currentTheme.displayName}</span>
          <span className="version">uDESK v1.0.7</span>
        </div>
        
        <div className="header-controls">
          <div className="view-switcher">
            <button 
              className={currentView === 'desktop' ? 'active' : ''}
              onClick={() => setCurrentView('desktop')}
            >
              Desktop
            </button>
            <button 
              className={currentView === 'terminal' ? 'active' : ''}
              onClick={() => setCurrentView('terminal')}
            >
              Terminal
            </button>
            <button 
              className={currentView === 'container' ? 'active' : ''}
              onClick={() => setCurrentView('container')}
            >
              Container
            </button>
            <button 
              className={currentView === 'setup' ? 'active' : ''}
              onClick={() => setCurrentView('setup')}
            >
              Setup
            </button>
          </div>
          
          <div className="theme-selector">
            {(['polaroid', 'c64', 'macintosh', 'mode7'] as ThemeName[]).map(themeName => (
              <button
                key={themeName}
                onClick={() => onThemeChange(themeName)}
                className={`theme-button ${theme === themeName ? 'active' : ''}`}
              >
                {getTheme(themeName).displayName}
              </button>
            ))}
          </div>
        </div>
      </div>

      <div className="desktop-content">
        {currentView === 'desktop' && (
          <div className="desktop-view">
            <div className="desktop-icons">
              <div className="icon-grid">
                <div className="desktop-icon" onClick={() => setCurrentView('terminal')}>
                  <div className="icon-image">📟</div>
                  <div className="icon-label">uDOS Terminal</div>
                </div>
                
                <div className="desktop-icon" onClick={() => setCurrentView('container')}>
                  <div className="icon-image">🐳</div>
                  <div className="icon-label">TinyCore Container</div>
                </div>
                
                <div className="desktop-icon" onClick={() => setCurrentView('setup')}>
                  <div className="icon-image">🛠️</div>
                  <div className="icon-label">Setup & Install</div>
                </div>
                
                <div className="desktop-icon">
                  <div className="icon-image">📁</div>
                  <div className="icon-label">File Manager</div>
                </div>
                
                <div className="desktop-icon">
                  <div className="icon-image">⚙️</div>
                  <div className="icon-label">Settings</div>
                </div>
              </div>
            </div>
            
            <div className="desktop-sidebar">
              <div className="sidebar-section">
                <h3>System Status</h3>
                <div className="status-item">
                  <span>Container:</span>
                  <span className={`status ${containerStatus}`}>
                    {containerStatus.toUpperCase()}
                  </span>
                </div>
                <div className="status-item">
                  <span>Extensions:</span>
                  <span>{extensions.length} loaded</span>
                </div>
                <div className="status-item">
                  <span>Theme:</span>
                  <span>{currentTheme.displayName}</span>
                </div>
              </div>
              
              <div className="sidebar-section">
                <h3>Quick Actions</h3>
                <button 
                  onClick={containerStatus === 'stopped' ? startContainer : stopContainer}
                  disabled={containerStatus === 'starting'}
                  className="action-button"
                >
                  {containerStatus === 'stopped' ? 'Start Container' : 
                   containerStatus === 'starting' ? 'Starting...' : 
                   'Stop Container'}
                </button>
                
                <button 
                  onClick={() => setCurrentView('terminal')}
                  className="action-button"
                >
                  Open Terminal
                </button>
              </div>
            </div>
          </div>
        )}

        {currentView === 'terminal' && (
          <div className="terminal-view">
            <div className="terminal-header">
              <span>uDOS Shell - uCODE Command Interface</span>
              <div className="terminal-controls">
                <button onClick={() => setCommandHistory([])}>Clear</button>
              </div>
            </div>
            
            <div className="terminal-content">
              <div className="command-history">
                {commandHistory.map(cmd => (
                  <div key={cmd.id} className="command-entry">
                    <div className="command-input">
                      <span className="prompt">udesk$ </span>
                      <span className="command">{cmd.command}</span>
                    </div>
                    <div className={`command-output ${cmd.success ? 'success' : 'error'}`}>
                      {cmd.output}
                    </div>
                  </div>
                ))}
              </div>
              
              <form onSubmit={handleCommandSubmit} className="command-form">
                <span className="prompt">udesk$ </span>
                <input
                  type="text"
                  value={currentCommand}
                  onChange={(e) => setCurrentCommand(e.target.value)}
                  placeholder="Enter uCODE command... e.g., [HELP], [STATUS], [LIST|TCZ]"
                  className="command-input-field"
                  autoFocus
                />
              </form>
            </div>
          </div>
        )}

        {currentView === 'container' && (
          <div className="container-view">
            <div className="container-header">
              <span>TinyCore Container Management</span>
              <div className="container-status">
                Status: <span className={`status ${containerStatus}`}>
                  {containerStatus.toUpperCase()}
                </span>
              </div>
            </div>
            
            <div className="container-content">
              <div className="container-info">
                <h3>Container Information</h3>
                <div className="info-grid">
                  <div className="info-item">
                    <span>Base Image:</span>
                    <span>TinyCore Linux Latest</span>
                  </div>
                  <div className="info-item">
                    <span>Extensions:</span>
                    <span>{extensions.length} available</span>
                  </div>
                  <div className="info-item">
                    <span>Status:</span>
                    <span className={containerStatus}>{containerStatus}</span>
                  </div>
                  <div className="info-item">
                    <span>uDOS Integration:</span>
                    <span>Active</span>
                  </div>
                </div>
              </div>
              
              <div className="container-controls">
                <h3>Container Actions</h3>
                <div className="control-buttons">
                  <button 
                    onClick={startContainer}
                    disabled={containerStatus === 'running' || containerStatus === 'starting'}
                    className="control-button start"
                  >
                    Start Container
                  </button>
                  
                  <button 
                    onClick={stopContainer}
                    disabled={containerStatus === 'stopped'}
                    className="control-button stop"
                  >
                    Stop Container
                  </button>
                  
                  <button 
                    onClick={loadExtensions}
                    className="control-button refresh"
                  >
                    Refresh Extensions
                  </button>
                  
                  <button 
                    onClick={() => setCurrentView('terminal')}
                    disabled={containerStatus !== 'running'}
                    className="control-button terminal"
                  >
                    Open Shell
                  </button>
                </div>
              </div>
              
              <div className="extension-list">
                <h3>Available Extensions</h3>
                <div className="extensions">
                  {extensions.map((ext, index) => (
                    <div key={index} className="extension-item">
                      <span className="extension-name">{ext}</span>
                      <span className="extension-status">Ready</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}
        
        {currentView === 'setup' && (
          <Setup 
            theme={theme}
            onComplete={() => {
              setShowFirstTimeSetup(false);
              setCurrentView('desktop');
            }}
            onBack={() => setCurrentView('desktop')}
          />
        )}
      </div>
    </div>
  );
};
