#!/bin/bash
# M2 Integration Test Script for TinyCore VM
# Tests complete Web UI + Command Bridge + Role Adaptation

set -e

echo "🚀 uDOS M2 Integration Test"
echo "=========================="
echo ""

# Check if uDOS is installed
if ! command -v udos >/dev/null 2>&1; then
    echo "❌ uDOS not found. Please install M1 first:"
    echo "   cd /tmp && git clone https://github.com/fredporter/uDESK.git"
    echo "   cd uDESK && ./vm/current/install.sh"
    exit 1
fi

echo "✅ uDOS M1 detected"
udos version

echo ""
echo "📊 Setting up M2 integration test..."

# Create test directory
TEST_DIR="/tmp/udos-m2-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Copy M2 integration files
echo "📁 Copying M2 integration files..."
cp /tmp/uDESK/dev/m2-integration/*.js .

# Create test HTML page
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>uDOS M2 Integration Test</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Courier New', monospace;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d3748 100%);
            color: #ffffff;
            min-height: 100vh;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: rgba(44, 62, 80, 0.95);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            color: #00ff88;
            font-size: 24px;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .card {
            background: #2d3748;
            border-radius: 8px;
            border: 1px solid #4a5568;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 255, 136, 0.2);
        }
        
        .card-header {
            background: rgba(44, 62, 80, 0.8);
            padding: 16px 20px;
            border-bottom: 1px solid #4a5568;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-header h3 {
            font-size: 16px;
            color: #00ff88;
        }
        
        .card-content {
            padding: 20px;
        }
        
        .btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn:hover {
            background: #2980b9;
        }
        
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
        }
        
        .test-results {
            background: #1a1a1a;
            padding: 16px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .success { color: #00ff88; }
        .error { color: #ff4444; }
        .info { color: #3498db; }
        .warning { color: #f39c12; }
        
        .admin-panel {
            border: 2px dashed #ff4444;
            opacity: 0.7;
        }
        
        .dev-tools {
            border: 2px dashed #f39c12;
            opacity: 0.7;
        }
        
        .security-tools {
            border: 2px dashed #3498db;
            opacity: 0.7;
        }
        
        .test-controls {
            margin: 20px 0;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .role-simulator {
            background: #2d3748;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid #4a5568;
        }
        
        .role-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        
        .role-btn {
            padding: 6px 12px;
            border: 1px solid #4a5568;
            background: #1a1a1a;
            color: #ffffff;
            border-radius: 4px;
            cursor: pointer;
            font-size: 11px;
        }
        
        .role-btn:hover {
            background: #4a5568;
        }
        
        .role-btn.active {
            background: #00ff88;
            color: #000000;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 uDOS M2 Integration Test</h1>
            <div class="header-info">
                <span id="status">Initializing...</span>
            </div>
        </div>
        
        <div class="test-controls">
            <button class="btn" onclick="runTests()">🧪 Run All Tests</button>
            <button class="btn" onclick="testWebBridge()">🔗 Test Web Bridge</button>
            <button class="btn" onclick="testRoleUI()">🎭 Test Role UI</button>
            <button class="btn" onclick="testIntegration()">⚡ Test Integration</button>
            <button class="btn" onclick="clearResults()">🗑️ Clear</button>
        </div>
        
        <div class="role-simulator">
            <h3>🎭 Role Simulator</h3>
            <p>Test role-based UI adaptation:</p>
            <div class="role-buttons">
                <button class="role-btn" onclick="simulateRole('GHOST', 10)">👻 GHOST</button>
                <button class="role-btn" onclick="simulateRole('TOMB', 20)">⚱️ TOMB</button>
                <button class="role-btn" onclick="simulateRole('CRYPT', 30)">💀 CRYPT</button>
                <button class="role-btn" onclick="simulateRole('DRONE', 40)">🤖 DRONE</button>
                <button class="role-btn" onclick="simulateRole('KNIGHT', 50)">⚔️ KNIGHT</button>
                <button class="role-btn" onclick="simulateRole('IMP', 60)">👹 IMP</button>
                <button class="role-btn" onclick="simulateRole('SORCERER', 80)">🔮 SORCERER</button>
                <button class="role-btn" onclick="simulateRole('WIZARD', 100)">🧙 WIZARD</button>
            </div>
        </div>
        
        <div class="dashboard-grid">
            <!-- Basic Overview (always visible) -->
            <div class="card" data-section="overview">
                <div class="card-header">
                    <h3>📊 System Overview</h3>
                    <button class="btn btn-sm">Refresh</button>
                </div>
                <div class="card-content">
                    <div class="test-results" id="overview-status">
                        System loading...
                    </div>
                </div>
            </div>
            
            <!-- Security Tools (Knight+ only) -->
            <div class="card security-tools" data-min-level="50">
                <div class="card-header">
                    <h3>🔒 Security Tools</h3>
                    <span style="font-size: 11px; opacity: 0.7;">Knight+ Only</span>
                </div>
                <div class="card-content">
                    <p>Advanced security features require Knight role or higher.</p>
                    <button class="btn" data-requires-feature="security">Security Scan</button>
                </div>
            </div>
            
            <!-- Dev Tools (Imp+ only) -->
            <div class="card dev-tools" data-min-level="60">
                <div class="card-header">
                    <h3>🔧 Development Tools</h3>
                    <span style="font-size: 11px; opacity: 0.7;">Imp+ Only</span>
                </div>
                <div class="card-content">
                    <p>Development features require Imp role or higher.</p>
                    <button class="btn" data-requires-feature="development">Debug Console</button>
                </div>
            </div>
            
            <!-- Admin Panel (Sorcerer+ only) -->
            <div class="card admin-panel" data-min-level="80">
                <div class="card-header">
                    <h3>⚙️ Admin Panel</h3>
                    <span style="font-size: 11px; opacity: 0.7;">Sorcerer+ Only</span>
                </div>
                <div class="card-content">
                    <p>Administrative features require Sorcerer role or higher.</p>
                    <button class="btn" data-requires-feature="advanced">System Config</button>
                </div>
            </div>
            
            <!-- Test Results -->
            <div class="card">
                <div class="card-header">
                    <h3>🧪 Test Results</h3>
                    <button class="btn btn-sm" onclick="clearResults()">Clear</button>
                </div>
                <div class="card-content">
                    <div class="test-results" id="test-output">
                        Ready to run tests...
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include M2 Integration Scripts -->
    <script src="udos-web-bridge.js"></script>
    <script src="udos-role-ui.js"></script>
    <script src="udos-m2-complete.js"></script>
    
    <script>
        let testOutput = document.getElementById('test-output');
        let statusEl = document.getElementById('status');
        let currentRole = 'GHOST';
        
        function log(message, type = 'info') {
            const timestamp = new Date().toLocaleTimeString();
            const colors = {
                info: 'info',
                success: 'success',
                error: 'error',
                warning: 'warning'
            };
            testOutput.innerHTML += `<div class="${colors[type]}">[${timestamp}] ${message}</div>`;
            testOutput.scrollTop = testOutput.scrollHeight;
        }
        
        function clearResults() {
            testOutput.innerHTML = '';
            log('Test results cleared', 'info');
        }
        
        async function testWebBridge() {
            log('🔗 Testing Web Bridge...', 'info');
            
            try {
                if (typeof uDOSWebBridge === 'undefined') {
                    throw new Error('uDOSWebBridge not loaded');
                }
                
                const bridge = new uDOSWebBridge();
                await bridge.init();
                
                // Test basic commands
                const versionResult = await bridge.runCommand('udos version');
                if (versionResult.success) {
                    log('✅ Version command successful', 'success');
                    log(`   Output: ${versionResult.stdout.split('\\n')[0]}`, 'info');
                } else {
                    log('⚠️ Version command failed, using mock mode', 'warning');
                }
                
                const roleResult = await bridge.runCommand('udos role');
                if (roleResult.success) {
                    log('✅ Role command successful', 'success');
                } else {
                    log('⚠️ Role command using mock data', 'warning');
                }
                
                log('✅ Web Bridge test completed', 'success');
                
            } catch (error) {
                log(`❌ Web Bridge test failed: ${error.message}`, 'error');
            }
        }
        
        async function testRoleUI() {
            log('🎭 Testing Role UI...', 'info');
            
            try {
                if (typeof uDOSRoleUI === 'undefined') {
                    throw new Error('uDOSRoleUI not loaded');
                }
                
                // Test role adaptation
                const roles = ['GHOST', 'KNIGHT', 'WIZARD'];
                
                for (const role of roles) {
                    log(`Testing role: ${role}`, 'info');
                    simulateRole(role, role === 'GHOST' ? 10 : role === 'KNIGHT' ? 50 : 100);
                    await new Promise(resolve => setTimeout(resolve, 500));
                }
                
                log('✅ Role UI test completed', 'success');
                
            } catch (error) {
                log(`❌ Role UI test failed: ${error.message}`, 'error');
            }
        }
        
        async function testIntegration() {
            log('⚡ Testing M2 Integration...', 'info');
            
            try {
                if (window.uDOSM2) {
                    const status = window.uDOSM2.getStatus();
                    log(`Integration Status:`, 'info');
                    log(`  Initialized: ${status.initialized}`, status.initialized ? 'success' : 'error');
                    log(`  Bridge: ${status.bridge}`, status.bridge ? 'success' : 'error');
                    log(`  Role UI: ${status.roleUI}`, status.roleUI ? 'success' : 'error');
                    
                    if (status.currentRole) {
                        log(`  Current Role: ${status.currentRole.role} (${status.currentRole.level})`, 'info');
                    }
                    
                    log('✅ Integration test completed', 'success');
                } else {
                    log('❌ M2 Integration not found', 'error');
                }
                
            } catch (error) {
                log(`❌ Integration test failed: ${error.message}`, 'error');
            }
        }
        
        async function runTests() {
            clearResults();
            log('🚀 Starting comprehensive M2 tests...', 'info');
            
            await testWebBridge();
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            await testRoleUI();
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            await testIntegration();
            
            log('🎉 All tests completed!', 'success');
        }
        
        function simulateRole(role, level) {
            currentRole = role;
            
            // Update active button
            document.querySelectorAll('.role-btn').forEach(btn => btn.classList.remove('active'));
            event?.target?.classList.add('active');
            
            // Force role adaptation if M2 is available
            if (window.uDOSM2 && window.uDOSM2.roleUI) {
                window.uDOSM2.roleUI.forceRoleUpdate(role);
                log(`🎭 Simulated role change to: ${role} (${level})`, 'info');
            } else {
                log(`⚠️ M2 not ready, role simulation limited`, 'warning');
            }
            
            // Update status
            statusEl.textContent = `Role: ${role} (${level})`;
        }
        
        // Auto-run basic test on load
        setTimeout(() => {
            if (window.uDOSM2) {
                statusEl.textContent = 'M2 Ready!';
                log('🚀 M2 Integration loaded successfully', 'success');
                
                // Show initial system status
                document.getElementById('overview-status').innerHTML = `
                    <div class="success">✅ M2 Integration Active</div>
                    <div class="info">📊 Dashboard Connected</div>
                    <div class="info">🎭 Role UI Ready</div>
                    <div class="info">🔗 Command Bridge Online</div>
                `;
            } else {
                statusEl.textContent = 'Loading...';
            }
        }, 2000);
        
        // Test role adaptation on page load
        setTimeout(() => {
            simulateRole('GHOST', 10);
        }, 3000);
    </script>
</body>
</html>
EOF

echo "✅ Created test HTML page"

# Create simple HTTP server script
cat > server.sh << 'EOF'
#!/bin/bash
# Simple HTTP server for M2 testing

PORT=8080
echo "🌐 Starting HTTP server on port $PORT..."
echo "   Open: http://localhost:$PORT"
echo "   Press Ctrl+C to stop"
echo ""

# Try different HTTP servers
if command -v python3 >/dev/null 2>&1; then
    python3 -m http.server $PORT
elif command -v python >/dev/null 2>&1; then
    python -m SimpleHTTPServer $PORT
elif command -v busybox >/dev/null 2>&1; then
    busybox httpd -f -p $PORT
else
    echo "❌ No HTTP server available"
    echo "   Install: tce-load -wi python3.tcz"
    echo "   Or manually open index.html in browser"
    exit 1
fi
EOF

chmod +x server.sh

echo ""
echo "🎉 M2 Integration test setup complete!"
echo ""
echo "📋 Test Instructions:"
echo "1. Start HTTP server:  ./server.sh"
echo "2. Open browser:       http://localhost:8080"
echo "3. Run tests:          Click 'Run All Tests'"
echo "4. Test roles:         Use role simulator buttons"
echo ""
echo "🔍 What to test:"
echo "- Web bridge connects to udos commands"
echo "- Role UI hides/shows elements based on role"
echo "- Integration works with real uDOS system"
echo "- Role switching adapts interface correctly"
echo ""
echo "📂 Test files created in: $TEST_DIR"
echo "🚀 Ready for M2 testing!"
