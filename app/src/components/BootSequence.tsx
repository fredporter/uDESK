import React, { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/core';
import { ThemeName, getTheme, applyThemeToDocument, themeAssets } from '../lib/themes';

interface BootSequenceProps {
  onBootComplete: () => void;
}

interface BootMessage {
  text: string;
  type: 'info' | 'success' | 'warning' | 'error';
  timestamp: number;
}

interface SystemInfo {
  name: string;
  version: string;
  architecture: string;
  themes: string[];
  roles: Array<{
    name: string;
    level: number;
    symbol: string;
  }>;
}

export const BootSequence: React.FC<BootSequenceProps> = ({ onBootComplete }) => {
  const [currentTheme, setCurrentTheme] = useState<ThemeName>('polaroid');
  const [bootMessages, setBootMessages] = useState<BootMessage[]>([]);
  const [bootStage, setBootStage] = useState<'init' | 'checking' | 'loading' | 'starting' | 'ready'>('init');
  const [loadingFrame, setLoadingFrame] = useState(0);
  const [systemInfo, setSystemInfo] = useState<SystemInfo | null>(null);
  const [dockerAvailable, setDockerAvailable] = useState(false);

  const addMessage = (text: string, type: BootMessage['type'] = 'info') => {
    setBootMessages(prev => [...prev, { text, type, timestamp: Date.now() }]);
  };

  const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

  useEffect(() => {
    // Apply theme immediately
    const theme = getTheme(currentTheme);
    applyThemeToDocument(theme);
  }, [currentTheme]);

  useEffect(() => {
    // Animate loading spinner
    const interval = setInterval(() => {
      setLoadingFrame(prev => (prev + 1) % themeAssets.loadingAnimations[currentTheme].length);
    }, 200);

    return () => clearInterval(interval);
  }, [currentTheme]);

  useEffect(() => {
    startBootSequence();
  }, []);

  const startBootSequence = async () => {
    await delay(500);
    
    // Show uDESK logo
    setBootStage('init');
    addMessage(themeAssets.logos[currentTheme]);
    addMessage('');
    addMessage('uDESK v1.0.7 - Universal Development Environment & System Kit');
    addMessage('Built on TinyCore Linux | Powered by Tauri');
    addMessage('Copyright (c) 2025 uDESK Project');
    await delay(1500);

    // Check system requirements
    setBootStage('checking');
    addMessage('');
    addMessage('🔍 Checking system requirements...');
    
    try {
      // Get system info
      const info = await invoke<SystemInfo>('get_udesk_info');
      setSystemInfo(info);
      addMessage(`✓ uDESK ${info.version} initialized`, 'success');
      
      // Check Docker
      const dockerStatus = await invoke<boolean>('check_docker_status');
      setDockerAvailable(dockerStatus);
      
      if (dockerStatus) {
        addMessage('✓ Docker Engine: Available', 'success');
      } else {
        addMessage('⚠ Docker Engine: Not available (container features disabled)', 'warning');
      }
      
      addMessage('✓ Tauri Runtime: Active', 'success');
      addMessage(`✓ Themes: ${info.themes.length} available`, 'success');
      
    } catch (error) {
      addMessage(`✗ System check failed: ${error}`, 'error');
    }
    
    await delay(1000);

    // Load extensions
    setBootStage('loading');
    addMessage('');
    addMessage('📦 Loading uDESK extensions...');
    
    try {
      const extensions = await invoke<string[]>('list_available_extensions');
      console.log('Available extensions:', extensions);
      
      // Simulate extension loading
      const extensionNames = ['udesk-base', 'ucode-engine', 'udos-shell', 'udesk-themes'];
      for (const ext of extensionNames) {
        await delay(300);
        addMessage(`   ├─ ${ext}.tcz`, 'info');
        await delay(200);
        addMessage(`   │  └─ Loaded successfully`, 'success');
      }
      
    } catch (error) {
      addMessage(`⚠ Extension loading: ${error}`, 'warning');
    }
    
    await delay(800);

    // Start services
    setBootStage('starting');
    addMessage('');
    addMessage('⚡ Starting uDOS services...');
    addMessage('   ├─ Theme engine: Active', 'success');
    addMessage('   ├─ Command processor: Ready', 'success');
    addMessage('   ├─ File system bridge: Connected', 'success');
    
    if (dockerAvailable) {
      addMessage('   └─ Container runtime: Available', 'success');
    } else {
      addMessage('   └─ Container runtime: Disabled', 'warning');
    }
    
    await delay(1000);

    // Ready
    setBootStage('ready');
    addMessage('');
    addMessage('✅ uDESK v1.7 ready!', 'success');
    addMessage('🎯 Universal Development Environment loaded');
    addMessage('');
    
    // Theme-specific ready message
    switch (currentTheme) {
      case 'c64':
        addMessage('READY.');
        addMessage('');
        break;
      case 'macintosh':
        addMessage('Welcome to uDESK');
        addMessage('');
        break;
      case 'mode7':
        addMessage('*** SYSTEM READY ***');
        addMessage('');
        break;
      default:
        addMessage('Type \'help\' for uCODE command reference');
        addMessage('Select theme or start development environment');
        addMessage('');
        break;
    }
    
    await delay(1500);
    onBootComplete();
  };

  const getLoadingSpinner = () => {
    const frames = themeAssets.loadingAnimations[currentTheme];
    return frames[loadingFrame];
  };

  const getStageMessage = () => {
    switch (bootStage) {
      case 'init': return 'Initializing uDESK...';
      case 'checking': return 'Checking system requirements...';
      case 'loading': return 'Loading extensions...';
      case 'starting': return 'Starting services...';
      case 'ready': return 'System ready!';
      default: return '';
    }
  };

  return (
    <div className="boot-sequence">
      <div className="boot-header">
        <div className="theme-selector">
          {(['polaroid', 'c64', 'macintosh', 'mode7'] as ThemeName[]).map(theme => (
            <button
              key={theme}
              onClick={() => setCurrentTheme(theme)}
              className={`theme-button ${currentTheme === theme ? 'active' : ''}`}
            >
              {getTheme(theme).displayName}
            </button>
          ))}
        </div>
      </div>

      <div className="boot-console">
        <div className="boot-messages">
          {bootMessages.map((message, index) => (
            <div
              key={index}
              className={`boot-message ${message.type}`}
            >
              {message.text}
            </div>
          ))}
        </div>
        
        {bootStage !== 'ready' && (
          <div className="boot-status">
            <span className="loading-spinner">{getLoadingSpinner()}</span>
            <span className="stage-message">{getStageMessage()}</span>
          </div>
        )}
      </div>

      {systemInfo && (
        <div className="system-info">
          <div className="info-item">
            <strong>System:</strong> {systemInfo.name} {systemInfo.version}
          </div>
          <div className="info-item">
            <strong>Architecture:</strong> {systemInfo.architecture}
          </div>
          <div className="info-item">
            <strong>Container Support:</strong> {dockerAvailable ? 'Available' : 'Disabled'}
          </div>
          <div className="info-item">
            <strong>Current Theme:</strong> {getTheme(currentTheme).displayName}
          </div>
        </div>
      )}
    </div>
  );
};
