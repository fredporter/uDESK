import React, { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/core';
import { ThemeName } from '../lib/themes';
import './Setup.css';

interface SetupProps {
  theme: ThemeName;
  onComplete: () => void;
  onBack: () => void;
}

interface SystemInfo {
  os: string;
  arch: string;
  nodeVersion?: string;
  rustVersion?: string;
  hasGcc: boolean;
  hasGit: boolean;
  uDeskInstalled: boolean;
}

interface InstallStep {
  id: string;
  name: string;
  description: string;
  status: 'pending' | 'running' | 'completed' | 'error';
  output?: string;
}

export const Setup: React.FC<SetupProps> = ({ theme, onComplete, onBack }) => {
  const [currentStep, setCurrentStep] = useState<'welcome' | 'check' | 'install' | 'configure' | 'complete'>('welcome');
  const [systemInfo, setSystemInfo] = useState<SystemInfo | null>(null);
  const [installSteps, setInstallSteps] = useState<InstallStep[]>([]);
  const [isInstalling, setIsInstalling] = useState(false);
  const [selectedComponents, setSelectedComponents] = useState({
    nodejs: true,
    rust: true,
    dependencies: true,
    workspace: true,
  });

  useEffect(() => {
    if (currentStep === 'check') {
      checkSystemRequirements();
    }
  }, [currentStep]);

  const checkSystemRequirements = async () => {
    try {
      const info = await invoke<SystemInfo>('get_system_info');
      setSystemInfo(info);
      
      // Generate install steps based on missing components
      const steps: InstallStep[] = [];
      
      if (!info.nodeVersion && selectedComponents.nodejs) {
        steps.push({
          id: 'nodejs',
          name: 'Install Node.js',
          description: 'Required for the desktop app and modern features',
          status: 'pending'
        });
      }
      
      if (!info.rustVersion && selectedComponents.rust) {
        steps.push({
          id: 'rust',
          name: 'Install Rust',
          description: 'Required for building Tauri applications',
          status: 'pending'
        });
      }
      
      if (!info.hasGcc && selectedComponents.dependencies) {
        steps.push({
          id: 'build-tools',
          name: 'Install Build Tools',
          description: 'Xcode Command Line Tools for compiling native code',
          status: 'pending'
        });
      }
      
      if (!info.uDeskInstalled && selectedComponents.workspace) {
        steps.push({
          id: 'workspace',
          name: 'Setup Workspace',
          description: 'Initialize uDESK workspace and configuration',
          status: 'pending'
        });
      }
      
      if (steps.length === 0) {
        steps.push({
          id: 'complete',
          name: 'System Ready',
          description: 'All requirements are satisfied',
          status: 'completed'
        });
      }
      
      setInstallSteps(steps);
    } catch (error) {
      console.error('Failed to check system requirements:', error);
    }
  };

  const runInstallation = async () => {
    setIsInstalling(true);
    
    for (const step of installSteps) {
      if (step.status === 'completed') continue;
      
      setInstallSteps(prev => prev.map(s => 
        s.id === step.id ? { ...s, status: 'running' } : s
      ));
      
      try {
        const result = await invoke<string>('install_component', { 
          component: step.id 
        });
        
        setInstallSteps(prev => prev.map(s => 
          s.id === step.id ? { 
            ...s, 
            status: 'completed', 
            output: result 
          } : s
        ));
      } catch (error) {
        setInstallSteps(prev => prev.map(s => 
          s.id === step.id ? { 
            ...s, 
            status: 'error', 
            output: String(error) 
          } : s
        ));
        break;
      }
      
      // Add a small delay between steps
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    setIsInstalling(false);
    
    // Check if all steps completed successfully
    const allCompleted = installSteps.every(step => step.status === 'completed');
    if (allCompleted) {
      setCurrentStep('complete');
    }
  };

  const renderWelcome = () => (
    <div className="setup-welcome">
      <div className="setup-header">
        <h1>🚀 Welcome to uDESK v1.0.7</h1>
        <p>Universal Desktop Operating System</p>
      </div>
      
      <div className="setup-content">
        <div className="feature-grid">
          <div className="feature-card">
            <h3>🖥️ Terminal Interface</h3>
            <p>Classic command-line access with full uCODE functionality</p>
          </div>
          
          <div className="feature-card">
            <h3>📱 Modern Desktop App</h3>
            <p>Tauri-based GUI with visual tools and setup wizards</p>
          </div>
          
          <div className="feature-card">
            <h3>🔧 Development Tools</h3>
            <p>Complete development environment with Rust and Node.js</p>
          </div>
          
          <div className="feature-card">
            <h3>🎨 Customizable Themes</h3>
            <p>Multiple visual themes including retro, neon, and minimalist</p>
          </div>
        </div>
        
        <div className="setup-actions">
          <button 
            className="btn btn-primary"
            onClick={() => setCurrentStep('check')}
          >
            Get Started
          </button>
          <button 
            className="btn btn-secondary"
            onClick={onBack}
          >
            Skip Setup
          </button>
        </div>
      </div>
    </div>
  );

  const renderSystemCheck = () => (
    <div className="setup-check">
      <div className="setup-header">
        <h2>🔍 System Requirements Check</h2>
        <p>Checking your system for required components...</p>
      </div>
      
      {systemInfo && (
        <div className="system-info">
          <div className="info-grid">
            <div className="info-item">
              <span className="label">Operating System:</span>
              <span className="value">{systemInfo.os}</span>
            </div>
            <div className="info-item">
              <span className="label">Architecture:</span>
              <span className="value">{systemInfo.arch}</span>
            </div>
            <div className="info-item">
              <span className="label">Node.js:</span>
              <span className={`value ${systemInfo.nodeVersion ? 'success' : 'error'}`}>
                {systemInfo.nodeVersion || 'Not installed'}
              </span>
            </div>
            <div className="info-item">
              <span className="label">Rust:</span>
              <span className={`value ${systemInfo.rustVersion ? 'success' : 'error'}`}>
                {systemInfo.rustVersion || 'Not installed'}
              </span>
            </div>
            <div className="info-item">
              <span className="label">Build Tools:</span>
              <span className={`value ${systemInfo.hasGcc ? 'success' : 'error'}`}>
                {systemInfo.hasGcc ? 'Available' : 'Missing'}
              </span>
            </div>
            <div className="info-item">
              <span className="label">Git:</span>
              <span className={`value ${systemInfo.hasGit ? 'success' : 'error'}`}>
                {systemInfo.hasGit ? 'Available' : 'Missing'}
              </span>
            </div>
          </div>
          
          <div className="component-selection">
            <h3>Select Components to Install:</h3>
            <div className="checkbox-group">
              <label>
                <input
                  type="checkbox"
                  checked={selectedComponents.nodejs}
                  onChange={(e) => setSelectedComponents(prev => ({
                    ...prev,
                    nodejs: e.target.checked
                  }))}
                  disabled={!!systemInfo.nodeVersion}
                />
                Node.js Runtime
                {systemInfo.nodeVersion && <span className="already-installed">✅ Already installed</span>}
              </label>
              
              <label>
                <input
                  type="checkbox"
                  checked={selectedComponents.rust}
                  onChange={(e) => setSelectedComponents(prev => ({
                    ...prev,
                    rust: e.target.checked
                  }))}
                  disabled={!!systemInfo.rustVersion}
                />
                Rust Toolchain
                {systemInfo.rustVersion && <span className="already-installed">✅ Already installed</span>}
              </label>
              
              <label>
                <input
                  type="checkbox"
                  checked={selectedComponents.dependencies}
                  onChange={(e) => setSelectedComponents(prev => ({
                    ...prev,
                    dependencies: e.target.checked
                  }))}
                  disabled={systemInfo.hasGcc}
                />
                Build Dependencies
                {systemInfo.hasGcc && <span className="already-installed">✅ Already installed</span>}
              </label>
              
              <label>
                <input
                  type="checkbox"
                  checked={selectedComponents.workspace}
                  onChange={(e) => setSelectedComponents(prev => ({
                    ...prev,
                    workspace: e.target.checked
                  }))}
                />
                Initialize Workspace
              </label>
            </div>
          </div>
          
          <div className="setup-actions">
            <button 
              className="btn btn-primary"
              onClick={() => {
                checkSystemRequirements();
                setCurrentStep('install');
              }}
            >
              Proceed with Installation
            </button>
            <button 
              className="btn btn-secondary"
              onClick={() => setCurrentStep('welcome')}
            >
              Back
            </button>
          </div>
        </div>
      )}
    </div>
  );

  const renderInstallation = () => (
    <div className="setup-install">
      <div className="setup-header">
        <h2>⚙️ Installing Components</h2>
        <p>Setting up your uDESK environment...</p>
      </div>
      
      <div className="install-progress">
        {installSteps.map((step, index) => (
          <div key={step.id} className={`install-step step-${step.status}`}>
            <div className="step-header">
              <div className="step-icon">
                {step.status === 'completed' && '✅'}
                {step.status === 'running' && '⏳'}
                {step.status === 'error' && '❌'}
                {step.status === 'pending' && '⏸️'}
              </div>
              <div className="step-info">
                <h4>{step.name}</h4>
                <p>{step.description}</p>
              </div>
            </div>
            {step.output && (
              <div className="step-output">
                <pre>{step.output}</pre>
              </div>
            )}
          </div>
        ))}
      </div>
      
      <div className="setup-actions">
        {!isInstalling && installSteps.some(step => step.status === 'pending') && (
          <button 
            className="btn btn-primary"
            onClick={runInstallation}
          >
            Start Installation
          </button>
        )}
        
        {isInstalling && (
          <div className="installing-indicator">
            <div className="spinner"></div>
            <span>Installing...</span>
          </div>
        )}
        
        <button 
          className="btn btn-secondary"
          onClick={() => setCurrentStep('check')}
          disabled={isInstalling}
        >
          Back
        </button>
      </div>
    </div>
  );

  const renderComplete = () => (
    <div className="setup-complete">
      <div className="setup-header">
        <h2>🎉 Setup Complete!</h2>
        <p>uDESK is ready to use</p>
      </div>
      
      <div className="completion-summary">
        <div className="success-message">
          <h3>✅ Installation Successful</h3>
          <p>All components have been installed and configured successfully.</p>
        </div>
        
        <div className="next-steps">
          <h3>🚀 What's Next?</h3>
          <ul>
            <li>🖥️ Try the terminal interface with classic uCODE commands</li>
            <li>📱 Explore the modern desktop app features</li>
            <li>🎨 Customize your theme and workspace</li>
            <li>📖 Read the documentation to learn more</li>
          </ul>
        </div>
        
        <div className="quick-actions">
          <h3>⚡ Quick Actions</h3>
          <div className="action-buttons">
            <button 
              className="btn btn-primary"
              onClick={onComplete}
            >
              Launch uDESK
            </button>
            <button 
              className="btn btn-secondary"
              onClick={() => invoke('open_documentation')}
            >
              Open User Manual
            </button>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className={`setup-container theme-${theme}`}>
      {currentStep === 'welcome' && renderWelcome()}
      {currentStep === 'check' && renderSystemCheck()}
      {currentStep === 'install' && renderInstallation()}
      {currentStep === 'complete' && renderComplete()}
    </div>
  );
};
