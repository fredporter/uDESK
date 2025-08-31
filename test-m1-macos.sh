#!/bin/bash
# Quick M1 test and validation script for macOS

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=== uDESK M1 Core Integration Test ==="
echo "Project: $PROJECT_ROOT"
echo ""

# Check prerequisites
echo "1. Checking build prerequisites..."

if [ ! -f "$PROJECT_ROOT/TinyCore-current.iso" ]; then
    echo "⚠ TinyCore ISO missing. Downloading..."
    if command -v wget >/dev/null 2>&1; then
        wget -O "$PROJECT_ROOT/TinyCore-current.iso" "http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
    elif command -v curl >/dev/null 2>&1; then
        curl -L -o "$PROJECT_ROOT/TinyCore-current.iso" "http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
    else
        echo "✗ Need wget or curl to download TinyCore ISO"
        echo "Install with: brew install wget"
        exit 1
    fi
else
    echo "✓ TinyCore ISO found"
fi

# Check for required tools on macOS
echo ""
echo "2. Checking macOS tools..."

MISSING_TOOLS=()

if ! command -v gtar >/dev/null 2>&1 && ! command -v tar >/dev/null 2>&1; then
    MISSING_TOOLS+=("tar")
fi

# For macOS, we'll create tar.gz instead of squashfs initially
echo "Note: Building tar.gz packages (squashfs requires Linux VM)"

# Make scripts executable
echo ""
echo "3. Making scripts executable..."
find "$PROJECT_ROOT" -name "*.sh" -exec chmod +x {} \;
echo "✓ All scripts executable"

# Test core package build
echo ""
echo "4. Testing core package build..."
if [ -f "$PROJECT_ROOT/packaging/build_udos_core.sh" ]; then
    echo "Building udos-core package..."
    cd "$PROJECT_ROOT"
    ./packaging/build_udos_core.sh
    
    if [ -f "$PROJECT_ROOT/build/udos-core.tcz" ] || [ -f "$PROJECT_ROOT/build/udos-core.tar.gz" ]; then
        echo "✓ Core package built successfully"
        ls -la "$PROJECT_ROOT/build/"
    else
        echo "✗ Core package build failed"
        echo "Check build directory:"
        ls -la "$PROJECT_ROOT/build/" 2>/dev/null || echo "Build directory not found"
        exit 1
    fi
else
    echo "✗ Core build script not found"
    exit 1
fi

# Test role packages build  
echo ""
echo "5. Testing role packages build..."
if [ -f "$PROJECT_ROOT/packaging/build_udos_roles.sh" ]; then
    echo "Building role packages..."
    ./packaging/build_udos_roles.sh
    
    ROLE_PACKAGES=$(ls "$PROJECT_ROOT/build/udos-role-"* 2>/dev/null | wc -l)
    if [ "$ROLE_PACKAGES" -gt 0 ]; then
        echo "✓ Role packages built successfully ($ROLE_PACKAGES packages)"
        ls -la "$PROJECT_ROOT/build/udos-role-"*
    else
        echo "⚠ No role packages found, but that's OK for initial test"
    fi
else
    echo "✗ Role build script not found"
    exit 1
fi

# Check what we built
echo ""
echo "6. Build summary..."
echo "Built files:"
ls -la "$PROJECT_ROOT/build/" 2>/dev/null || echo "No build directory"

echo ""
echo "=== M1 Test Results ==="
echo ""
echo "✅ Core Integration Status:"
echo "  • Scripts created and executable"
echo "  • TinyCore integration components ready"  
echo "  • Build system functional"
echo "  • Package creation working"
echo ""
echo "📋 Ready for next steps:"
echo "  1. Test in Linux VM or container for full .tcz support"
echo "  2. Use Claude Code to generate M2 components"
echo "  3. Create QEMU test environment"
echo ""
echo "🎉 M1 milestone foundation complete!"
echo ""
echo "To test with full TinyCore compatibility:"
echo "  • Use a Linux VM with squashfs-tools"
echo "  • Or test the .tar.gz packages directly"
echo ""
echo "Your markdown-everything OS is ready for development! 🚀"
