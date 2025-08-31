#!/bin/bash
# uDESK v1.0.6 - Role Package Builder
# Builds all role TCZ packages with markdown focus

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build"
SRC_DIR="$PROJECT_ROOT/src"
VERSION="1.0.6"

echo "=== Building uDESK Role Packages v$VERSION ==="

build_role() {
    local role=$1
    local role_dir="$SRC_DIR/udos-role-$role"
    local build_role_dir="$BUILD_DIR/udos-role-$role"
    
    echo "Building udos-role-$role.tcz..."
    
    rm -rf "$build_role_dir"
    mkdir -p "$build_role_dir"
    cd "$build_role_dir"
    
    # Create role-specific structure
    mkdir -p {usr/local/{bin,etc,share},opt/udos/roles/$role,etc/udos}
    
    # Copy role-specific files
    cp -r "$role_dir"/* . 2>/dev/null || echo "No role-specific files yet"
    
    # Create role marker
    echo "$role" > etc/udos/role-$role
    
    case "$role" in
        basic)
            build_basic_role
            ;;
        standard)
            build_standard_role
            ;;
        admin)
            build_admin_role
            ;;
    esac
    
    # Create TCZ package
    cd "$BUILD_DIR"
    mksquashfs "udos-role-$role" "udos-role-$role.tcz" -noappend 2>/dev/null || {
        echo "mksquashfs not available, creating tar.gz instead"
        tar czf "udos-role-$role.tcz" -C "udos-role-$role" .
    }
    
    echo "✓ udos-role-$role.tcz built successfully"
}

build_basic_role() {
    # Basic role: minimal shell + markdown tools
    cat > opt/udos/roles/basic/manifest.md << 'EOF'
# uDESK Basic Role

## Description
Minimal markdown-focused environment for kiosk and basic usage.

## Features
- ✅ Secure shell access
- ✅ Markdown editing (micro)
- ✅ Markdown viewing (glow)
- ✅ Basic file operations
- ❌ No sudo access
- ❌ No GUI by default
- ❌ No development tools

## Extensions Required
- micro.tcz (or manual install)
- glow.tcz (or manual install)

## Usage
```bash
# Edit markdown
micro document.md

# View markdown beautifully
glow document.md

# System info
udos-info
```
EOF

    # Create basic profile
    cat > opt/udos/roles/basic/profile.sh << 'EOF'
#!/bin/bash
# Basic role environment setup

export UDOS_ROLE="basic"
export EDITOR="micro"
export PAGER="glow"

# Aliases for markdown workflow
alias md='micro'
alias view='glow'
alias info='udos-info'

# Welcome message
if [ -t 1 ] && [ -z "$UDOS_WELCOME_SHOWN" ]; then
    echo "Welcome to uDESK Basic! Type 'info' for system status."
    export UDOS_WELCOME_SHOWN=1
fi
EOF
}

build_standard_role() {
    # Standard role: full desktop + user apps
    cat > opt/udos/roles/standard/manifest.md << 'EOF'
# uDESK Standard Role

## Description
Full desktop environment with markdown-focused productivity tools.

## Features
- ✅ All Basic role features
- ✅ GUI desktop (FLWM)
- ✅ File manager
- ✅ Web browser
- ✅ Limited sudo (services only)
- ✅ User app installation
- ❌ No system development tools

## Extensions Required
- Xvesa.tcz or Xorg-7.7.tcz
- flwm.tcz
- aterm.tcz
- firefox.tcz or other browser
- pcmanfm.tcz (file manager)

## Additional Tools
- Advanced markdown editor options
- Clipboard utilities
- Font packages

## Usage
Desktop environment with markdown at the center of everything.
EOF

    # Create standard sudoers rules
    mkdir -p etc/sudoers.d
    cat > etc/sudoers.d/udos-standard << 'EOF'
# Standard role sudo permissions
%udos ALL=(root) NOPASSWD: /usr/local/etc/init.d/*
%udos ALL=(root) NOPASSWD: /usr/local/bin/udos-service
EOF

    # Standard profile
    cat > opt/udos/roles/standard/profile.sh << 'EOF'
#!/bin/bash
# Standard role environment setup

export UDOS_ROLE="standard"
export EDITOR="micro"
export PAGER="glow"

# Enhanced aliases
alias md='micro'
alias view='glow'
alias info='udos-info'
alias gui='startx'

# Service management
alias services='udos-service list'
alias start-service='udos-service start'
EOF
}

build_admin_role() {
    # Admin role: full development environment
    cat > opt/udos/roles/admin/manifest.md << 'EOF'
# uDESK Admin Role

## Description
Complete development environment with full system access and markdown workflow.

## Features
- ✅ All Standard role features
- ✅ Full sudo access
- ✅ Development toolchain
- ✅ Python + virtualenv
- ✅ System administration
- ✅ Package management

## Extensions Required
- compiletc.tcz
- python3.tcz
- python3-pip.tcz
- git.tcz
- make.tcz
- cmake.tcz

## Development Tools
- Full compiler toolchain
- Python virtual environments
- System debugging tools
- Network administration

## Usage
Complete development environment for building and maintaining uDESK itself.
EOF

    # Admin sudoers - full access
    mkdir -p etc/sudoers.d
    cat > etc/sudoers.d/udos-admin << 'EOF'
# Admin role sudo permissions
%udos-admin ALL=(ALL) NOPASSWD:ALL
EOF

    # Admin profile with development tools
    cat > opt/udos/roles/admin/profile.sh << 'EOF'
#!/bin/bash
# Admin role environment setup

export UDOS_ROLE="admin"
export EDITOR="micro"
export PAGER="glow"

# Development aliases
alias md='micro'
alias view='glow'
alias info='udos-info'
alias gui='startx'
alias build='make'
alias venv='python3 -m venv'

# Development paths
export PATH="/opt/udos/bin:$PATH"
export PYTHONPATH="/opt/udos/lib/python:$PYTHONPATH"

# Welcome for developers
if [ -t 1 ] && [ -z "$UDOS_DEV_WELCOME_SHOWN" ]; then
    echo "uDESK Admin Mode - Full development environment active"
    echo "All system configs are in markdown format for easy editing"
    export UDOS_DEV_WELCOME_SHOWN=1
fi
EOF

    # Create Python venv helper
    cat > usr/local/bin/udos-venv << 'EOF'
#!/bin/bash
# uDESK Python virtual environment helper

VENV_DIR="/opt/udos/venv"
mkdir -p "$VENV_DIR"

case "$1" in
    create)
        if [ -z "$2" ]; then
            echo "Usage: udos-venv create <name>"
            exit 1
        fi
        echo "Creating Python venv: $2"
        python3 -m venv "$VENV_DIR/$2"
        echo "Activate with: source $VENV_DIR/$2/bin/activate"
        ;;
    list)
        echo "Available virtual environments:"
        ls -1 "$VENV_DIR" 2>/dev/null || echo "No virtual environments found"
        ;;
    remove)
        if [ -z "$2" ]; then
            echo "Usage: udos-venv remove <name>"
            exit 1
        fi
        rm -rf "$VENV_DIR/$2"
        echo "Removed venv: $2"
        ;;
    *)
        echo "Usage: udos-venv {create|list|remove} [name]"
        ;;
esac
EOF
    chmod +x usr/local/bin/udos-venv
}

# Build all roles
for role in basic standard admin; do
    build_role "$role"
done

echo ""
echo "✓ All role packages built successfully!"
echo "Location: $BUILD_DIR/"
echo ""
echo "Built packages:"
ls -la "$BUILD_DIR"/*.tcz 2>/dev/null || ls -la "$BUILD_DIR"/*.tar.gz
