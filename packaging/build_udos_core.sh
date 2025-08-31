#!/bin/bash
# uDESK v1.0.6 - Core TCZ Package Builder
# Builds udos-core.tcz with markdown-focused configurations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build"
SRC_DIR="$PROJECT_ROOT/src/udos-core"
VERSION="1.0.6"

echo "=== Building uDESK Core v$VERSION ==="

# Clean and create build directory
rm -rf "$BUILD_DIR/udos-core"
mkdir -p "$BUILD_DIR/udos-core"

# Create TCZ filesystem structure
cd "$BUILD_DIR/udos-core"
mkdir -p {usr/local/{bin,etc,share},opt/udos,etc/{udos,sudoers.d}}

# Copy core files from src
echo "Copying core files..."
cp -r "$SRC_DIR"/* . 2>/dev/null || echo "No source files yet"

# Create core markdown configs
cat > etc/udos/config.md << 'EOF'
# uDESK Core Configuration

## System Identity
- **Name**: uDESK
- **Version**: 1.0.6
- **Base**: TinyCore Linux
- **Philosophy**: Markdown Everything

## Default Settings
- **Role**: basic
- **GUI**: disabled
- **Persistence**: enabled
- **Network**: dhcp
- **Markdown Editor**: micro
- **Markdown Viewer**: glow

## Boot Configuration
All system configuration is stored in markdown format for human readability and easy modification.
EOF

# Create role detection script
cat > usr/local/bin/udos-detect-role << 'EOF'
#!/bin/bash
# Detect current uDESK role

ROLE_FILE="/etc/udos/role"
CMDLINE_ROLE=$(grep -o 'udos.role=[^ ]*' /proc/cmdline 2>/dev/null | cut -d= -f2)

if [ -n "$CMDLINE_ROLE" ]; then
    echo "$CMDLINE_ROLE"
elif [ -f "$ROLE_FILE" ]; then
    cat "$ROLE_FILE"
else
    echo "basic"
fi
EOF

# Create service helper
cat > usr/local/bin/udos-service << 'EOF'
#!/bin/bash
# uDESK service management helper

ROLE=$(udos-detect-role)
SERVICE_DIR="/usr/local/etc/init.d"

case "$1" in
    list)
        echo "Available services for role: $ROLE"
        find "$SERVICE_DIR" -name "*.md" -exec basename {} .md \;
        ;;
    start)
        if [ -z "$2" ]; then
            echo "Usage: udos-service start <service>"
            exit 1
        fi
        SERVICE_SCRIPT="$SERVICE_DIR/$2.sh"
        if [ -f "$SERVICE_SCRIPT" ]; then
            echo "Starting service: $2"
            "$SERVICE_SCRIPT" start
        else
            echo "Service not found: $2"
            exit 1
        fi
        ;;
    *)
        echo "Usage: udos-service {list|start} [service]"
        ;;
esac
EOF

# Create markdown system info script
cat > usr/local/bin/udos-info << 'EOF'
#!/bin/bash
# Display system information in markdown format

cat << 'MDEOF'
# uDESK System Information

## Current Status
- **Role**: $(udos-detect-role)
- **Uptime**: $(uptime | cut -d, -f1)
- **Load**: $(uptime | awk -F'load average:' '{print $2}')
- **Memory**: $(free -h | awk 'NR==2{print $3"/"$2}')

## Installed Extensions
$(tce-status -i | head -10)

## Network Status
$(ip addr show | grep -E '^[0-9]+:' | cut -d: -f2 | tr -d ' ')

## Markdown Tools
- **Editor**: $(which micro 2>/dev/null && echo "micro available" || echo "micro not installed")
- **Viewer**: $(which glow 2>/dev/null && echo "glow available" || echo "glow not installed")

*Generated: $(date)*
MDEOF
EOF

# Make scripts executable
chmod +x usr/local/bin/*

# Create first-boot wizard
cat > opt/udos/first-boot.sh << 'EOF'
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
EOF

chmod +x opt/udos/first-boot.sh

# Create TCZ package with enhanced compression
echo "Creating udos-core.tcz..."
cd "$BUILD_DIR"

if command -v mksquashfs >/dev/null 2>&1; then
    echo "Using mksquashfs for optimal TCZ compression..."
    mksquashfs udos-core udos-core.tcz -noappend -comp xz -b 1048576
elif command -v gzip >/dev/null 2>&1; then
    echo "Using enhanced tar.gz compression..."
    tar --exclude='._*' -czf udos-core.tcz -C udos-core .
else
    echo "Using basic tar compression..."
    tar -cf udos-core.tcz -C udos-core .
fi

echo "✓ udos-core.tcz built successfully"
echo "Location: $BUILD_DIR/udos-core.tcz"
