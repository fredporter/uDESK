#!/usr/bin/env node
/**
 * uDOS M3 Window Management System
 * Core window detection and manipulation for desktop integration
 */

const { execSync, exec } = require('child_process');
const fs = require('fs');
const path = require('path');

class WindowManager {
    constructor() {
        this.platform = process.platform;
        this.windows = new Map();
        this.activeWindow = null;
        
        console.log(`🪟 M3 Window Manager initialized for ${this.platform}`);
    }

    /**
     * Detect all available windows on the system
     */
    async detectWindows() {
        try {
            let windowList = [];
            
            switch (this.platform) {
                case 'darwin': // macOS
                    windowList = await this.detectMacOSWindows();
                    break;
                case 'linux':
                    windowList = await this.detectLinuxWindows();
                    break;
                case 'win32':
                    windowList = await this.detectWindowsWindows();
                    break;
                default:
                    console.log('⚠️  Platform not supported for window detection');
                    return [];
            }
            
            // Update internal window map
            this.windows.clear();
            windowList.forEach(window => {
                this.windows.set(window.id, window);
            });
            
            console.log(`✅ Detected ${windowList.length} windows`);
            return windowList;
            
        } catch (error) {
            console.error('❌ Window detection failed:', error.message);
            return [];
        }
    }

    /**
     * macOS window detection using AppleScript
     */
    async detectMacOSWindows() {
        const script = `
            tell application "System Events"
                set windowList to {}
                repeat with proc in (every process whose background only is false)
                    try
                        repeat with win in (every window of proc)
                            set windowInfo to {name of win, id of win, name of proc}
                            set end of windowList to windowInfo
                        end repeat
                    end try
                end repeat
                return windowList
            end tell
        `;
        
        try {
            const result = execSync(`osascript -e '${script}'`, { encoding: 'utf8' });
            const windows = this.parseAppleScriptOutput(result);
            return windows;
        } catch (error) {
            console.error('macOS window detection failed:', error.message);
            return [];
        }
    }

    /**
     * Linux window detection using wmctrl or xdotool
     */
    async detectLinuxWindows() {
        try {
            // Try wmctrl first
            const result = execSync('wmctrl -l -x', { encoding: 'utf8' });
            return this.parseWmctrlOutput(result);
        } catch (error) {
            try {
                // Fallback to xdotool
                const result = execSync('xdotool search --name ".*"', { encoding: 'utf8' });
                return this.parseXdotoolOutput(result);
            } catch (fallbackError) {
                console.error('Linux window detection failed:', fallbackError.message);
                return [];
            }
        }
    }

    /**
     * Windows window detection using PowerShell
     */
    async detectWindowsWindows() {
        const script = `
            Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | 
            Select-Object Id, ProcessName, MainWindowTitle | 
            ConvertTo-Json
        `;
        
        try {
            const result = execSync(`powershell -Command "${script}"`, { encoding: 'utf8' });
            return this.parsePowerShellOutput(result);
        } catch (error) {
            console.error('Windows window detection failed:', error.message);
            return [];
        }
    }

    /**
     * Focus on a specific window
     */
    async focusWindow(windowId) {
        try {
            const window = this.windows.get(windowId);
            if (!window) {
                throw new Error(`Window ${windowId} not found`);
            }

            switch (this.platform) {
                case 'darwin':
                    await this.focusMacOSWindow(window);
                    break;
                case 'linux':
                    await this.focusLinuxWindow(window);
                    break;
                case 'win32':
                    await this.focusWindowsWindow(window);
                    break;
            }
            
            this.activeWindow = window;
            console.log(`✅ Focused window: ${window.title}`);
            
        } catch (error) {
            console.error('❌ Window focus failed:', error.message);
        }
    }

    /**
     * Move window to specific position and size
     */
    async moveWindow(windowId, x, y, width, height) {
        try {
            const window = this.windows.get(windowId);
            if (!window) {
                throw new Error(`Window ${windowId} not found`);
            }

            switch (this.platform) {
                case 'darwin':
                    await this.moveMacOSWindow(window, x, y, width, height);
                    break;
                case 'linux':
                    await this.moveLinuxWindow(window, x, y, width, height);
                    break;
                case 'win32':
                    await this.moveWindowsWindow(window, x, y, width, height);
                    break;
            }
            
            console.log(`✅ Moved window: ${window.title} to (${x},${y}) ${width}x${height}`);
            
        } catch (error) {
            console.error('❌ Window move failed:', error.message);
        }
    }

    // Platform-specific helper methods
    parseAppleScriptOutput(output) {
        // Parse AppleScript list format
        const windows = [];
        // Implementation for parsing AppleScript output
        return windows;
    }

    parseWmctrlOutput(output) {
        const windows = [];
        const lines = output.trim().split('\n');
        
        lines.forEach(line => {
            const parts = line.split(/\s+/);
            if (parts.length >= 4) {
                windows.push({
                    id: parts[0],
                    desktop: parts[1],
                    class: parts[2],
                    title: parts.slice(3).join(' '),
                    platform: 'linux'
                });
            }
        });
        
        return windows;
    }

    parseXdotoolOutput(output) {
        const windows = [];
        const windowIds = output.trim().split('\n');
        
        windowIds.forEach(id => {
            if (id) {
                try {
                    const nameResult = execSync(`xdotool getwindowname ${id}`, { encoding: 'utf8' });
                    windows.push({
                        id: id,
                        title: nameResult.trim(),
                        platform: 'linux'
                    });
                } catch (error) {
                    // Skip windows that can't be queried
                }
            }
        });
        
        return windows;
    }

    parsePowerShellOutput(output) {
        try {
            const data = JSON.parse(output);
            const windows = Array.isArray(data) ? data : [data];
            
            return windows.map(win => ({
                id: win.Id.toString(),
                title: win.MainWindowTitle,
                process: win.ProcessName,
                platform: 'win32'
            }));
        } catch (error) {
            console.error('Failed to parse PowerShell output:', error.message);
            return [];
        }
    }

    // Platform-specific focus methods
    async focusMacOSWindow(window) {
        const script = `
            tell application "System Events"
                set frontmost of process "${window.process}" to true
                tell process "${window.process}"
                    set frontmost of window "${window.title}" to true
                end tell
            end tell
        `;
        execSync(`osascript -e '${script}'`);
    }

    async focusLinuxWindow(window) {
        execSync(`wmctrl -i -a ${window.id}`);
    }

    async focusWindowsWindow(window) {
        const script = `
            Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices;
            public class Win32 {
                [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
                [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
            }'
            [Win32]::ShowWindow([IntPtr]${window.id}, 9)
            [Win32]::SetForegroundWindow([IntPtr]${window.id})
        `;
        execSync(`powershell -Command "${script}"`);
    }

    // Platform-specific move methods
    async moveMacOSWindow(window, x, y, width, height) {
        const script = `
            tell application "System Events"
                tell process "${window.process}"
                    set position of window "${window.title}" to {${x}, ${y}}
                    set size of window "${window.title}" to {${width}, ${height}}
                end tell
            end tell
        `;
        execSync(`osascript -e '${script}'`);
    }

    async moveLinuxWindow(window, x, y, width, height) {
        execSync(`wmctrl -i -r ${window.id} -e 0,${x},${y},${width},${height}`);
    }

    async moveWindowsWindow(window, x, y, width, height) {
        const script = `
            Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices;
            public class Win32 {
                [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int width, int height, bool repaint);
            }'
            [Win32]::MoveWindow([IntPtr]${window.id}, ${x}, ${y}, ${width}, ${height}, $true)
        `;
        execSync(`powershell -Command "${script}"`);
    }

    /**
     * Get current window list formatted for display
     */
    getWindowList() {
        const windows = Array.from(this.windows.values());
        return windows.map(win => ({
            id: win.id,
            title: win.title.substring(0, 50) + (win.title.length > 50 ? '...' : ''),
            process: win.process || 'unknown',
            active: this.activeWindow && this.activeWindow.id === win.id
        }));
    }
}

// CLI interface
if (require.main === module) {
    const wm = new WindowManager();
    
    const command = process.argv[2];
    const args = process.argv.slice(3);
    
    switch (command) {
        case 'detect':
            wm.detectWindows().then(windows => {
                console.log('\n🪟 Window List:');
                windows.forEach(win => {
                    console.log(`  ${win.id}: ${win.title} (${win.process || 'unknown'})`);
                });
            });
            break;
            
        case 'focus':
            if (args[0]) {
                wm.detectWindows().then(() => {
                    wm.focusWindow(args[0]);
                });
            } else {
                console.log('Usage: udos-m3-window.js focus <window-id>');
            }
            break;
            
        case 'move':
            if (args.length >= 5) {
                const [id, x, y, width, height] = args;
                wm.detectWindows().then(() => {
                    wm.moveWindow(id, parseInt(x), parseInt(y), parseInt(width), parseInt(height));
                });
            } else {
                console.log('Usage: udos-m3-window.js move <window-id> <x> <y> <width> <height>');
            }
            break;
            
        case 'list':
            wm.detectWindows().then(() => {
                const windows = wm.getWindowList();
                console.log('\n🪟 Available Windows:');
                windows.forEach(win => {
                    const activeMarker = win.active ? '→ ' : '  ';
                    console.log(`${activeMarker}${win.id}: ${win.title} (${win.process})`);
                });
            });
            break;
            
        default:
            console.log(`
🪟 uDOS M3 Window Manager

Usage:
  udos-m3-window.js detect     - Detect all windows
  udos-m3-window.js list       - List windows with details  
  udos-m3-window.js focus <id> - Focus specific window
  udos-m3-window.js move <id> <x> <y> <w> <h> - Move/resize window

Examples:
  udos-m3-window.js detect
  udos-m3-window.js focus 0x1234567
  udos-m3-window.js move 0x1234567 100 100 800 600
            `);
    }
}

module.exports = WindowManager;
