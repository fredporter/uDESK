# uDOS Workflow Testing Guide - Node.js Installation & Validation

## Quick Node.js Installation

### macOS (Homebrew)
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js
brew install node

# Verify installation
node --version
npm --version
```

### Ubuntu/Debian
```bash
# Update package index
sudo apt update

# Install Node.js and npm
sudo apt install nodejs npm

# Verify installation
node --version
npm --version
```

### CentOS/RHEL/Fedora
```bash
# Install Node.js
sudo dnf install nodejs npm
# OR for older systems: sudo yum install nodejs npm

# Verify installation
node --version
npm --version
```

## uDOS Workflow Testing

### 1. Test Workflow System
```bash
cd /path/to/uDESK
./usr/bin/udos test workflow
```

Expected output with Node.js:
```
🧪 Workflow System Test
──────────────────────────
✅ Workflow engine: Available
   ✅ Engine functional
✅ Smart system: Available  
   ✅ Smart functional
✅ Template system: Available
   ✅ Templates functional
✅ Language system: Available
✅ Node.js: Available (v18.x.x)

Workflow Test Summary:
  • Workflow workflow for task execution
  • Smart pattern recognition for suggestions
  • Template generation for rapid development
  • Natural language processing for intuitive commands
```

### 2. Test Workflow Engine
```bash
# List available workflows (should show empty initially)
./usr/bin/udos workflow list

# Create a simple test workflow
./usr/bin/udos workflow create '{
  "name": "Test Workflow",
  "description": "Simple test of workflow engine",
  "actions": [
    {
      "type": "notification",
      "title": "Workflow Test",
      "message": "Workflow engine is working!"
    },
    {
      "type": "command", 
      "command": "echo \"Workflow executed at $(date)\""
    }
  ]
}'

# List workflows again (should show the new workflow)
./usr/bin/udos workflow list

# Execute the workflow
./usr/bin/udos workflow run <workflow-id>
```

### 3. Test Smart Pattern Recognition
```bash
# Check initial smart stats
./usr/bin/udos smart stats

# Teach smart system some commands
./usr/bin/udos smart learn "udos info"
./usr/bin/udos smart learn "udos data backup"
./usr/bin/udos smart learn "udos test quick"

# Get smart suggestions
./usr/bin/udos smart suggest

# Test prediction
./usr/bin/udos smart predict "udos data"
```

### 4. Test Smart Templates
```bash
# List built-in templates
./usr/bin/udos templates list

# Test template generation
./usr/bin/udos templates generate bash-script '{
  "NAME": "test-script",
  "AUTHOR": "Test User",
  "DESCRIPTION": "Testing uDOS Workflow template system",
  "MAIN_CONTENT": "echo \"Template system working!\""
}'

# Get template suggestions
./usr/bin/udos templates suggest '{"fileName": "backup.sh"}'

# Test learning from existing file
echo '#!/bin/bash\necho "Learning test"' > /tmp/test-script.sh
./usr/bin/udos templates learn /tmp/test-script.sh
```

### 5. Test Natural Language Processing
```bash
# Test basic NLP understanding
./usr/bin/udos language "backup my data"
./usr/bin/udos language "show system status" 
./usr/bin/udos language "list all templates"
./usr/bin/udos language "create a backup workflow"

# Test complex queries
./usr/bin/udos language "backup data and then show system status"
./usr/bin/udos language "what can you help me with?"

# Test entity extraction
./usr/bin/udos language "set variable TEST_VAR to hello world"
./usr/bin/udos language "focus window Terminal"
```

## Expected Results

### Successful uDOS Workflow Installation
- All components show ✅ Available
- No error messages during testing
- Workflows can be created and executed
- Smart learns from commands and provides suggestions
- Templates generate correctly
- NLP understands and converts queries

### Common Success Indicators
```bash
# Workflow creation success
Created workflow: <workflow-id>

# Smart learning success  
🧠 Learning: udos-info (count: 1)

# Template generation success
📄 Generated content from template: Bash Script

# NLP understanding success
✅ Understood: I'll backup your data.
📊 Confidence: 95%
💻 Recommended Commands:
  1. udos data backup
```

## Performance Benchmarks

### Expected Response Times
- **Workflow creation**: < 1 second
- **Smart suggestions**: < 2 seconds  
- **Template generation**: < 1 second
- **NLP processing**: < 3 seconds

### Resource Usage
- **Memory**: 50-100MB per uDOS Workflow component
- **CPU**: Minimal during idle, brief spikes during Smart processing
- **Disk**: ~5MB for uDOS Workflow scripts, variable for learning data

## Troubleshooting Quick Tests

### If Node.js Test Fails
```bash
# Check Node.js installation
which node
node --version

# Check PATH
echo $PATH | grep -o '[^:]*node[^:]*'

# Reinstall if needed
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### If Components Show Missing
```bash
# Check file locations
ls -la /usr/share/udos/udos-m4-*.js

# Check permissions
chmod +x /usr/share/udos/udos-m4-*.js

# Check for correct paths in udos command
grep -n "udos_share=" /usr/bin/udos
```

### If Smart Learning Fails
```bash
# Check/create data directory
mkdir -p /tmp/udos-m4-data
ls -la /tmp/udos-m4-data

# Test with simple command
./usr/bin/udos smart learn "test"
```

## Complete Test Script

Save as `test-m4.sh` for automated testing:

```bash
#!/bin/bash
echo "🧪 uDOS Workflow Complete Test Suite"
echo "========================"

# Test 1: Basic uDOS Workflow availability
echo "1. Testing uDOS Workflow system..."
./usr/bin/udos test workflow

# Test 2: Workflow functionality  
echo -e "\n2. Testing workflows..."
WORKFLOW_ID=$(./usr/bin/udos workflow create '{"name":"Test","actions":[{"type":"command","command":"echo test"}]}' | grep -o 'workflow-[a-f0-9]*' | head -1)
if [ ! -z "$WORKFLOW_ID" ]; then
    echo "✅ Workflow created: $WORKFLOW_ID"
    ./usr/bin/udos workflow run $WORKFLOW_ID
else
    echo "❌ Workflow creation failed"
fi

# Test 3: Smart learning
echo -e "\n3. Testing Smart learning..."
./usr/bin/udos smart learn "test command"
./usr/bin/udos smart suggest

# Test 4: Templates
echo -e "\n4. Testing templates..."
./usr/bin/udos templates list | head -5

# Test 5: NLP
echo -e "\n5. Testing NLP..."
./usr/bin/udos language "show system status"

echo -e "\n✅ uDOS Workflow testing complete!"
```

Run with:
```bash
chmod +x test-m4.sh
./test-m4.sh
```

This comprehensive testing ensures uDOS Workflow is fully functional and ready for production use.
