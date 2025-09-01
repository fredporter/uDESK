#!/bin/bash
# uDESK Development Environment Setup
# Sets up everything you need to develop uDESK

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=== uDESK Development Setup ==="
echo "Project: $PROJECT_ROOT"
echo ""

# Make all scripts executable
echo "Making scripts executable..."
find "$PROJECT_ROOT" -name "*.sh" -exec chmod +x {} \;
echo "✓ Scripts are now executable"

# Check for required tools
echo ""
echo "Checking prerequisites..."

MISSING=()

# Check for squashfs-tools
if ! command -v mksquashfs >/dev/null 2>&1; then
    MISSING+=("squashfs-tools")
fi

# Check for ISO tools
if ! command -v genisoimage >/dev/null 2>&1 && ! command -v mkisofs >/dev/null 2>&1; then
    MISSING+=("genisoimage")
fi

# Check for QEMU
if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
    MISSING+=("qemu-system-x86")
fi

# Check for curl/wget
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    MISSING+=("curl or wget")
fi

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "⚠ Missing tools: ${MISSING[*]}"
    echo ""
    echo "Install with:"
    echo "  Ubuntu/Debian: sudo apt install squashfs-tools genisoimage qemu-system-x86 curl"
    echo "  Arch: sudo pacman -S squashfs-tools cdrtools qemu curl"
    echo "  macOS: brew install squashfs qemu curl"
    echo ""
else
    echo "✓ All required tools found"
fi

# Check for TinyCore base
TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
if [ ! -f "$TINYCORE_ISO" ]; then
    echo ""
    echo "Downloading TinyCore base ISO..."
    if command -v wget >/dev/null 2>&1; then
        wget -O "$TINYCORE_ISO" "http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso"
    elif command -v curl >/dev/null 2>&1; then
        curl -L -o "$TINYCORE_ISO" "http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso"
    else
        echo "⚠ Please download TinyCore manually:"
        echo "  wget http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso"
        exit 1
    fi
    echo "✓ TinyCore ISO downloaded"
else
    echo "✓ TinyCore ISO found"
fi

# Create development directories
echo ""
echo "Setting up development directories..."
mkdir -p {build,out,test,logs}
echo "✓ Development directories created"

# Set up git hooks for markdown
echo ""
echo "Setting up git hooks..."
mkdir -p .git/hooks

cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Ensure all markdown files are valid

echo "Checking markdown files..."

# Find all staged markdown files
STAGED_MD=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$' || true)

if [ -n "$STAGED_MD" ]; then
    echo "Validating markdown files: $STAGED_MD"
    
    # Basic validation - check for common issues
    for file in $STAGED_MD; do
        if [ -f "$file" ]; then
            # Check for basic markdown structure
            if ! grep -q "^#" "$file"; then
                echo "Warning: $file appears to lack markdown headers"
            fi
            echo "✓ $file"
        fi
    done
fi

echo "Markdown validation complete"
EOF

chmod +x .git/hooks/pre-commit
echo "✓ Git hooks configured"

# Create development configuration
echo ""
echo "Creating development configuration..."

cat > dev-config.md << EOF
# uDESK Development Configuration

**Developer**: $(whoami)  
**Host**: $(hostname)  
**Setup Date**: $(date)  
**Project Path**: $PROJECT_ROOT

## Development Environment
- **OS**: $(uname -s)
- **Architecture**: $(uname -m)
- **Shell**: $SHELL

## Tools Status
$(command -v mksquashfs >/dev/null && echo "- ✅ mksquashfs" || echo "- ❌ mksquashfs")
$(command -v genisoimage >/dev/null && echo "- ✅ genisoimage" || echo "- ❌ genisoimage")
$(command -v qemu-system-x86_64 >/dev/null && echo "- ✅ qemu" || echo "- ❌ qemu")
$([ -f "$TINYCORE_ISO" ] && echo "- ✅ TinyCore ISO" || echo "- ❌ TinyCore ISO")

## Quick Commands
\`\`\`bash
# Full build
./build.sh --clean

# Test build
./isos/run_qemu.sh --image out/udesk-v1.0.6-admin.iso

# Core development
./build.sh --core-only

# Role development  
./build.sh --roles-only
\`\`\`

## Markdown Workflow
\`\`\`bash
# Generate with Claude
claude "Create a boot splash screen system for uDESK"

# Review output
glow output.md

# Quick edit if needed
micro output.md

# Integrate and build
mv output.md src/udos-core/etc/udos/
./build.sh --core-only
\`\`\`

## Next Steps
1. Run first build: \`./build.sh --role admin\`
2. Test in QEMU: \`./isos/run_qemu.sh --image out/udesk-v1.0.6-admin.iso\`
3. Start M1 milestone: Core Integration

*Everything ready for markdown-focused OS development!*
EOF

echo "✓ Development configuration created"

# Create quick development script
cat > dev.sh << 'EOF'
#!/bin/bash
# Quick development helper

case "$1" in
    "build")
        echo "Building uDESK..."
        ./build.sh --role admin
        ;;
    "test")
        echo "Testing latest build..."
        LATEST_ISO=$(ls -t out/*.iso | head -1)
        if [ -f "$LATEST_ISO" ]; then
            ./isos/run_qemu.sh --image "$LATEST_ISO"
        else
            echo "No ISO found. Run 'dev build' first."
        fi
        ;;
    "core")
        echo "Building core only..."
        ./build.sh --core-only
        ;;
    "quick")
        echo "Quick core build and test..."
        ./build.sh --core-only
        ./build.sh --image-only --role admin
        LATEST_ISO=$(ls -t out/*.iso | head -1)
        ./isos/run_qemu.sh --image "$LATEST_ISO"
        ;;
    "status")
        echo "Development status:"
        echo ""
        echo "Built packages:"
        ls -la build/*.tcz 2>/dev/null || echo "No packages built yet"
        echo ""
        echo "Built images:"
        ls -la out/*.iso 2>/dev/null || echo "No images built yet"
        echo ""
        echo "Recent activity:"
        ls -lt build/ out/ 2>/dev/null | head -5
        ;;
    "clean")
        echo "Cleaning build artifacts..."
        rm -rf build/ out/
        echo "Clean complete"
        ;;
    *)
        echo "uDESK Development Helper"
        echo ""
        echo "Usage: $0 {build|test|core|quick|status|clean}"
        echo ""
        echo "Commands:"
        echo "  build  - Full build (admin role)"
        echo "  test   - Test latest ISO in QEMU"
        echo "  core   - Build core package only"
        echo "  quick  - Fast core build + test"
        echo "  status - Show build status"
        echo "  clean  - Clean all build artifacts"
        echo ""
        echo "Examples:"
        echo "  ./dev.sh build     # Build everything"
        echo "  ./dev.sh quick     # Quick iteration"
        echo "  ./dev.sh test      # Test latest build"
        ;;
esac
EOF

chmod +x dev.sh
echo "✓ Development helper script created"

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "🚀 Ready to develop uDESK!"
echo ""
echo "Next steps:"
echo "1. ./dev.sh build     # Build your first uDESK image"
echo "2. ./dev.sh test      # Test in QEMU"
echo "3. Start developing with Claude Code + micro + glow!"
echo ""
echo "Your markdown-everything OS awaits! ✨"
