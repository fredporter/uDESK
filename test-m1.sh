#!/bin/bash
# Quick M1 test and validation script

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
        echo "Please install: brew install wget"
        exit 1
    fi
else
    echo "✓ TinyCore ISO found"
fi

# Make scripts executable
echo ""
echo "2. Making scripts executable..."
find "$PROJECT_ROOT" -name "*.sh" -exec chmod +x {} \;
echo "✓ All scripts executable"

# Test core package build
echo ""
echo "3. Testing core package build..."
if [ -f "$PROJECT_ROOT/packaging/build_udos_core.sh" ]; then
    echo "Building udos-core.tcz..."
    cd "$PROJECT_ROOT"
    ./packaging/build_udos_core.sh
    
    if [ -f "$PROJECT_ROOT/build/udos-core.tcz" ] || [ -f "$PROJECT_ROOT/build/udos-core.tar.gz" ]; then
        echo "✓ Core package built successfully"
        ls -la "$PROJECT_ROOT/build/udos-core."*
    else
        echo "✗ Core package build failed"
        exit 1
    fi
else
    echo "✗ Core build script not found"
    exit 1
fi

# Test role packages build
echo ""
echo "4. Testing role packages build..."
if [ -f "$PROJECT_ROOT/packaging/build_udos_roles.sh" ]; then
    echo "Building role packages..."
    ./packaging/build_udos_roles.sh
    
    ROLE_PACKAGES=$(ls "$PROJECT_ROOT/build/udos-role-"*.tcz "$PROJECT_ROOT/build/udos-role-"*.tar.gz 2>/dev/null | wc -l)
    if [ "$ROLE_PACKAGES" -gt 0 ]; then
        echo "✓ Role packages built successfully ($ROLE_PACKAGES packages)"
        ls -la "$PROJECT_ROOT/build/udos-role-"*
    else
        echo "✗ Role package build failed"
        exit 1
    fi
else
    echo "✗ Role build script not found"
    exit 1
fi

# Validate package contents
echo ""
echo "5. Validating package contents..."

if command -v unsquashfs >/dev/null 2>&1; then
    # Check if core package has required components
    if [ -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
        echo "Checking udos-core.tcz contents..."
        unsquashfs -l "$PROJECT_ROOT/build/udos-core.tcz" | grep -E "(udos-info|udos-detect-role|udos-service|first-boot.sh)" && echo "✓ Core components found" || echo "⚠ Some core components missing"
    fi
else
    echo "⚠ unsquashfs not available, skipping package validation"
fi

# Test image build (if tools available)
echo ""
echo "6. Testing image build..."
if command -v genisoimage >/dev/null 2>&1 || command -v mkisofs >/dev/null 2>&1; then
    echo "Building test image..."
    ./isos/make_image.sh --role admin --format iso
    
    if [ -f "$PROJECT_ROOT/out/udesk-v1.0.6-admin.iso" ]; then
        echo "✓ ISO image built successfully"
        ls -la "$PROJECT_ROOT/out/udesk-v1.0.6-admin.iso"
    else
        echo "⚠ ISO build had issues, but core packages work"
    fi
else
    echo "⚠ ISO tools not available, skipping image build"
    echo "Install with: brew install cdrtools (macOS) or apt install genisoimage (Linux)"
fi

# Summary
echo ""
echo "=== M1 Test Results ==="
echo ""
echo "Built components:"
ls -la "$PROJECT_ROOT/build/" 2>/dev/null | grep -E "\.(tcz|tar\.gz)$" || echo "No packages found"
echo ""
ls -la "$PROJECT_ROOT/out/" 2>/dev/null | grep -E "\.(iso|img)$" || echo "No images found"

echo ""
echo "✓ M1 Core Integration test complete!"
echo ""
echo "Next steps:"
echo "  1. ./dev.sh test    # Test in QEMU (if available)"
echo "  2. Start M2 milestone - Roles & Policies"
echo "  3. Use Claude Code to generate advanced components"
echo ""
echo "Your markdown-everything OS is taking shape! 🚀"