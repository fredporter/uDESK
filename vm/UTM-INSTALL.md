# uDOS One-Liner Installation for UTM TinyCore

## Method 1: Manual Installation (No Internet Required)
Copy and paste this entire script into your TinyCore VM terminal:

```bash
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/manual-install.sh | bash
```

## Method 2: GitHub Direct Download (Requires Internet)
```bash
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash
```

## Method 3: Copy-Paste Installation (Manual)
If GitHub downloads don't work, copy the contents of `vm/manual-install.sh` and paste directly into your VM terminal.

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
