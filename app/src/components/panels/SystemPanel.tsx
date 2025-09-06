import React, { useState, useEffect } from 'react';
import VSCodeIntegrationService from '../../services/vscodeIntegrationService';
import WorkflowDataService from '../../services/workflowDataService';

interface SystemStat {
  label: string;
  value: string;
  unit: string;
  status: 'good' | 'warning' | 'critical';
  icon: string;
}

interface RecentActivity {
  id: string;
  timestamp: string;
  type: 'todo' | 'workflow' | 'legacy' | 'system' | 'vscode';
  message: string;
  icon: string;
}

interface SystemPanelProps {
  className?: string;
}

export const SystemPanel: React.FC<SystemPanelProps> = ({ className = '' }) => {
  const [currentTime, setCurrentTime] = useState(new Date());
  const vscodeService = VSCodeIntegrationService.getInstance();
  const workflowService = WorkflowDataService.getInstance();
  
  const [systemStats, setSystemStats] = useState<SystemStat[]>([
    {
      label: 'CPU Usage',
      value: '12',
      unit: '%',
      status: 'good',
      icon: '⚡'
    },
    {
      label: 'Memory',
      value: '234',
      unit: 'MB',
      status: 'good',
      icon: '🧠'
    },
    {
      label: 'Storage',
      value: '67',
      unit: '%',
      status: 'warning',
      icon: '💾'
    },
    {
      label: 'Network',
      value: '45',
      unit: 'Mbps',
      status: 'good',
      icon: '🌐'
    }
  ]);

  const [recentActivity, setRecentActivity] = useState<RecentActivity[]>([
    {
      id: '1',
      timestamp: '2 min ago',
      type: 'todo',
      message: 'TODO-012 marked in-progress',
      icon: '📝'
    },
    {
      id: '2',
      timestamp: '5 min ago',
      type: 'workflow',
      message: 'Workflow engine executed successfully',
      icon: '⚙️'
    },
    {
      id: '3',
      timestamp: '12 min ago',
      type: 'legacy',
      message: 'New treasure created: TREASURE_001',
      icon: '💎'
    },
    {
      id: '4',
      timestamp: '18 min ago',
      type: 'system',
      message: 'System health check completed',
      icon: '✅'
    }
  ]);

  const [uptime, setUptime] = useState('2:34:56');

  useEffect(() => {
    // Update current time every second
    const timeInterval = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    // Simulate system stats updates
    const statsInterval = setInterval(() => {
      setSystemStats(prev => prev.map(stat => ({
        ...stat,
        value: stat.label === 'CPU Usage' 
          ? String(Math.floor(Math.random() * 30) + 5)
          : stat.label === 'Memory'
          ? String(Math.floor(Math.random() * 100) + 200)
          : stat.value
      })));

      // Update uptime
      const now = new Date();
      const uptimeSeconds = Math.floor(now.getTime() / 1000) % 86400;
      const hours = Math.floor(uptimeSeconds / 3600);
      const minutes = Math.floor((uptimeSeconds % 3600) / 60);
      const seconds = uptimeSeconds % 60;
      setUptime(`${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`);
    }, 5000);

    return () => {
      clearInterval(timeInterval);
      clearInterval(statsInterval);
    };
  }, []);

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'good': return '#32cd32';
      case 'warning': return '#ffd700';
      case 'critical': return '#ff4444';
      default: return '#888888';
    }
  };

  const getActivityTypeColor = (type: string) => {
    switch (type) {
      case 'todo': return '#1e90ff';
      case 'workflow': return '#32cd32';
      case 'legacy': return '#ffd700';
      case 'system': return '#ff6b6b';
      default: return '#888888';
    }
  };

  return (
    <div className={`system-panel ${className}`}>
      <div className="panel-header">
        <h3 className="panel-title">
          ⚡ System Monitor
        </h3>
        <div className="system-time">
          {currentTime.toLocaleTimeString()}
        </div>
      </div>

      {/* System Stats */}
      <div className="stats-section">
        <div className="section-label">System Performance</div>
        <div className="stats-grid">
          {systemStats.map((stat, index) => (
            <div key={index} className="stat-item">
              <div className="stat-icon">{stat.icon}</div>
              <div className="stat-content">
                <div className="stat-label">{stat.label}</div>
                <div className="stat-value">
                  <span className="value">{stat.value}</span>
                  <span className="unit">{stat.unit}</span>
                  <span 
                    className="status-indicator"
                    style={{ color: getStatusColor(stat.status) }}
                  >
                    ●
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* System Info */}
      <div className="info-section">
        <div className="info-row">
          <span className="info-label">Uptime:</span>
          <span className="info-value">{uptime}</span>
        </div>
        <div className="info-row">
          <span className="info-label">Theme:</span>
          <span className="info-value">TinyCore</span>
        </div>
        <div className="info-row">
          <span className="info-label">Build:</span>
          <span className="info-value">v1.0.7</span>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="activity-section">
        <div className="section-label">Recent Activity</div>
        <div className="activity-list">
          {recentActivity.slice(0, 3).map((activity) => (
            <div key={activity.id} className="activity-item">
              <span 
                className="activity-icon"
                style={{ color: getActivityTypeColor(activity.type) }}
              >
                {activity.icon}
              </span>
              <div className="activity-content">
                <div className="activity-message">{activity.message}</div>
                <div className="activity-timestamp">{activity.timestamp}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Quick Actions */}
      <div className="panel-footer">
        <button 
          className="panel-action-btn"
          onClick={() => vscodeService.openTerminal('uDESK System')}
        >
          � Terminal
        </button>
        <button 
          className="panel-action-btn"
          onClick={() => vscodeService.executeWorkflowScript('workflow-hierarchy.sh', ['status'])}
        >
          🔧 Scripts
        </button>
        <button 
          className="panel-action-btn"
          onClick={() => {
            workflowService.clearCache();
            // Refresh system data
            setCurrentTime(new Date());
          }}
        >
          🔄 Refresh
        </button>
      </div>
    </div>
  );
};
