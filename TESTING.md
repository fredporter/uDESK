# uDOS CLI Testing Infrastructure

## 🚀 Quick Start

### 1. Deploy to VM
```bash
./test-vm.sh deploy
```

### 2. Test functionality
```bash
./test-vm.sh test
```

### 3. Connect to VM
```bash
./test-vm.sh connect
```

## 📋 Available Commands

### VM Management
- `./test-vm.sh deploy` - Deploy latest uDOS CLI to VM
- `./test-vm.sh test` - Run functionality tests
- `./test-vm.sh connect` - SSH into VM
- `./test-vm.sh full-setup` - Complete VM setup

### AI Assistant
- `./test-vm.sh ai "your question"` - Test Gemini AI assistant

## 🛠️ Setup Requirements

### VM Configuration
1. **IP Address**: Update `VM_IP` in `test-vm.sh` (default: 192.168.64.2)
2. **SSH Access**: Ensure passwordless SSH to VM
3. **TinyCore**: VM running TinyCore Linux

### Gemini AI Setup (Free)
1. Get API key: https://makersuite.google.com/app/apikey
2. In VM: `ai-setup`
3. Enter your free API key

## 📁 Directory Structure

```
/Users/fredbook/Code/uDESK/
├── build/uDOS-core/          # CLI tools
│   ├── usr/local/bin/        # udos, uvar, udata, utpl
│   ├── usr/local/share/udos/ # System templates
│   └── usr/local/tce.installed/ # Post-install hooks
├── vm/                       # VM scripts
│   ├── auto-install.sh       # Auto VM setup
│   └── setup-gemini.sh       # AI assistant setup
├── test-vm.sh               # Main testing script
└── docs/                    # Documentation
    ├── user-roles.md        # Linux user mapping
    └── uDASH-architecture.md # Cross-platform UI
```

## 🧪 Testing Workflow

### Development Cycle
1. **Edit** CLI tools in `build/uDOS-core/usr/local/bin/`
2. **Deploy**: `./test-vm.sh deploy`
3. **Test**: `./test-vm.sh test`
4. **Iterate**: Repeat until satisfied

### Example Test Session
```bash
# Deploy latest changes
./test-vm.sh deploy

# Test basic functionality
./test-vm.sh test

# Test AI assistant
./test-vm.sh ai "how do I use uDOS variables?"

# Manual testing
./test-vm.sh connect
# In VM:
udos init
udos var set MY_VAR="test value"
udos var get MY_VAR
udos tpl list
```

## 🎯 Core uDOS Commands

### Main CLI (`udos`)
- `udos init` - Initialize environment
- `udos info` - System information
- `udos var` - Variable management
- `udos data` - Data operations  
- `udos tpl` - Template management

### Variable Management (`uvar`)
- `uvar set KEY=VALUE` - Set variable
- `uvar get KEY` - Get variable
- `uvar list` - List all variables

### Data Management (`udata`)
- `echo '{}' | udata save file` - Save data
- `udata load file` - Load data
- `udata list` - List data files

### Template Management (`utpl`)
- `utpl list` - List templates
- `utpl create template output` - Create from template
- `utpl show template` - Show template content

## 🔧 Troubleshooting

### VM Connection Issues
- Verify VM IP: `./test-vm.sh connect`
- Check SSH keys: `ssh-copy-id tc@your-vm-ip`

### Command Not Found
- Redeploy: `./test-vm.sh deploy`
- Check permissions: `ls -la /usr/local/bin/udos*`

### AI Assistant Issues
- Setup API key: `ai-setup` in VM
- Test manually: `ai "hello world"`

## 📚 Next Steps

1. **Test basic functionality** with this infrastructure
2. **Build desktop components** (uDOS-desktop.tcz)
3. **Create packaging scripts** for .tcz generation
4. **Implement cross-platform uDASH** interface

This testing infrastructure provides rapid iteration for uDOS CLI development!
