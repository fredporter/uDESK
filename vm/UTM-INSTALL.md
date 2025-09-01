# uDOS Installation for UTM TinyCore

## 🚀 Quick Install (2 Commands)

### Step 1: Install curl
```bash
tce-load -wi curl
```

### Step 2: Install uDOS
```bash
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash
```

That's it! 🎉

## 🧪 Test Installation
```bash
udos version
udos init
udos info
udos var set TEST=hello
udos var get TEST
```

## After Installation
Test with these commands:
```bash
udos version
udos init
udos info
udos var set TEST=hello
udos var get TEST
```

## Troubleshooting UTM Issues

### Shared Folders Not Working
- UTM shared folders require specific configuration
- Use GitHub download method instead
- Manual copy-paste always works

### No Internet in VM
- Check UTM network settings (NAT mode)
- Use manual installation script instead
- Copy files via SSH if host connection works

### Installation Not Persisting
- Ensure `/opt/.filetool.lst` exists
- Run `filetool.sh -b` to backup
- Check TinyCore persistence is enabled

## Quick Test Workflow
```bash
# Install
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash

# Test basic functionality
udos init
udos var set EDITOR=micro
udos var set THEME=retro8
udos var list
udos info

# Test template system
udos tpl list
udos tpl create document.md my-test.md
cat my-test.md
```
