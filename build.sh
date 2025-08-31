#!/bin/bash
# Master build script for uDESK v1.0.6

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
VERSION="1.0.6"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Parse command line arguments
CLEAN=false
BUILD_CORE=true
BUILD_ROLES=true
BUILD_IMAGE=true
ROLE="standard"
FORMAT="iso"

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --core-only)
            BUILD_ROLES=false
            BUILD_IMAGE=false
            shift
            ;;
        --roles-only)
            BUILD_CORE=false
            BUILD_IMAGE=false
            shift
            ;;
        --image-only)
            BUILD_CORE=false
            BUILD_ROLES=false
            shift
            ;;
        --role)
            ROLE="$2"
            shift 2
            ;;
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --help)
            echo "uDESK Build System v$VERSION"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Build Options:"
            echo "  --clean         Clean build directory before building"
            echo "  --core-only     Build only udos-core package"
            echo "  --roles-only    Build only role packages"
            echo "  --image-only    Build only ISO/IMG (requires existing packages)"
            echo ""
            echo "Image Options:"
            echo "  --role <role>   Default role for image (basic|standard|admin)"
            echo "  --format <fmt>  Output format (iso|img)"
            echo ""
            echo "Examples:"
            echo "  $0                           # Build everything"
            echo "  $0 --clean --role admin     # Clean build with admin role"
            echo "  $0 --core-only              # Build only core package"
            echo "  $0 --image-only --role basic # Build basic role image"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_header "uDESK Build System v$VERSION"
echo "Project: $PROJECT_ROOT"
echo "Target Role: $ROLE"
echo "Format: $FORMAT"
echo ""

# Clean build directory if requested
if [ "$CLEAN" = true ]; then
    print_header "Cleaning Build Directory"
    rm -rf "$PROJECT_ROOT/build"
    rm -rf "$PROJECT_ROOT/out"
    print_success "Build directory cleaned"
    echo ""
fi

# Ensure directories exist
mkdir -p "$PROJECT_ROOT"/{build,out}

# Check prerequisites
print_header "Checking Prerequisites"

# Check for required tools
MISSING_TOOLS=()

if ! command -v mksquashfs >/dev/null 2>&1; then
    MISSING_TOOLS+=("squashfs-tools")
fi

if ! command -v genisoimage >/dev/null 2>&1 && ! command -v mkisofs >/dev/null 2>&1; then
    MISSING_TOOLS+=("genisoimage or mkisofs")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    print_warning "Missing tools: ${MISSING_TOOLS[*]}"
    print_warning "Some features may not work properly"
else
    print_success "All required tools found"
fi

# Check for TinyCore base
TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
if [ ! -f "$TINYCORE_ISO" ] && [ "$BUILD_IMAGE" = true ]; then
    print_warning "TinyCore base ISO not found at $TINYCORE_ISO"
    print_warning "Image building will be skipped"
    BUILD_IMAGE=false
fi

echo ""

# Build core package
if [ "$BUILD_CORE" = true ]; then
    print_header "Building Core Package"
    if bash "$PROJECT_ROOT/packaging/build_udos_core.sh"; then
        print_success "Core package built successfully"
    else
        print_error "Core package build failed"
        exit 1
    fi
    echo ""
fi

# Build role packages  
if [ "$BUILD_ROLES" = true ]; then
    print_header "Building Role Packages"
    if bash "$PROJECT_ROOT/packaging/build_udos_roles.sh"; then
        print_success "Role packages built successfully"
    else
        print_error "Role package build failed"
        exit 1
    fi
    echo ""
fi

# Build image
if [ "$BUILD_IMAGE" = true ]; then
    print_header "Building System Image"
    if bash "$PROJECT_ROOT/isos/make_image.sh" --role "$ROLE" --format "$FORMAT"; then
        print_success "System image built successfully"
    else
        print_error "System image build failed"
        exit 1
    fi
    echo ""
fi

# Show build results
print_header "Build Summary"

if [ -d "$PROJECT_ROOT/build" ]; then
    echo "Built packages:"
    find "$PROJECT_ROOT/build" -name "*.tcz" -o -name "*.tar.gz" | while read -r file; do
        size=$(du -h "$file" | cut -f1)
        echo "  • $(basename "$file") ($size)"
    done
fi

if [ -d "$PROJECT_ROOT/out" ]; then
    echo ""
    echo "Built images:"
    find "$PROJECT_ROOT/out" -name "*.iso" -o -name "*.img" | while read -r file; do
        size=$(du -h "$file" | cut -f1)
        echo "  • $(basename "$file") ($size)"
    done
fi

echo ""
print_header "Next Steps"

if [ -f "$PROJECT_ROOT/out/udesk-v$VERSION-$ROLE.$FORMAT" ]; then
    echo "Test your build:"
    echo "  ./isos/run_qemu.sh --image out/udesk-v$VERSION-$ROLE.$FORMAT"
    echo ""
    echo "Or write to USB:"
    echo "  sudo dd if=out/udesk-v$VERSION-$ROLE.$FORMAT of=/dev/sdX bs=4M status=progress"
fi

echo ""
echo "Documentation:"
echo "  • Installation: docs/INSTALL.md"
echo "  • Roles: docs/ROLES.md"
echo "  • Development: docs/BUILD.md"

echo ""
print_success "Build completed successfully!"

# Generate build manifest
cat > "$PROJECT_ROOT/build/manifest.md" << EOF
# uDESK v$VERSION Build Manifest

**Built**: $(date)  
**Host**: $(hostname)  
**Builder**: $(whoami)  
**Target Role**: $ROLE  
**Format**: $FORMAT

## Built Components

### Packages
$(find "$PROJECT_ROOT/build" -name "*.tcz" -o -name "*.tar.gz" | while read -r file; do
    size=$(du -h "$file" | cut -f1)
    echo "- $(basename "$file") ($size)"
done)

### Images  
$(find "$PROJECT_ROOT/out" -name "*.iso" -o -name "*.img" | while read -r file; do
    size=$(du -h "$file" | cut -f1)
    echo "- $(basename "$file") ($size)"
done)

## Build Configuration
- Clean build: $CLEAN
- Core built: $BUILD_CORE
- Roles built: $BUILD_ROLES
- Image built: $BUILD_IMAGE

## Test Commands
\`\`\`bash
# Run in QEMU
./isos/run_qemu.sh --image out/udesk-v$VERSION-$ROLE.$FORMAT

# Check package contents
unsquashfs -l build/udos-core.tcz

# View build logs
cat build/*.log
\`\`\`

*Generated by uDESK build system*
EOF

print_success "Build manifest created: build/manifest.md"
