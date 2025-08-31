#!/bin/bash
# uDESK First Boot Wizard

FIRST_BOOT_FLAG="/etc/udos/first-boot-done"

if [ -f "$FIRST_BOOT_FLAG" ]; then
    exit 0
fi

echo "=== Welcome to uDESK v1.0.6 ==="
echo "Setting up your markdown-focused operating system..."

# Create default role
echo "basic" > /etc/udos/role

# Set up markdown development environment
if command -v tce-load >/dev/null 2>&1; then
    echo "Installing markdown tools..."
    # This would be handled by role packages in practice
    echo "Tools will be installed based on your selected role"
fi

# Create welcome message
cat > /home/tc/welcome.md << 'WELCOME'
# Welcome to uDESK!

Your markdown-focused operating system is ready.

## Quick Start

### View this file beautifully:
```bash
glow welcome.md
```

### Edit markdown files:
```bash
micro myfile.md
```

### Check system status:
```bash
udos-info
```

## Next Steps

1. Choose your role: `echo "standard" > /etc/udos/role`
2. Reboot to activate new role features
3. Start creating with markdown!

*Everything in uDESK is markdown. Even this welcome message.*
WELCOME

touch "$FIRST_BOOT_FLAG"
echo "First boot setup complete!"
