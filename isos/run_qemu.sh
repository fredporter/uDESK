#!/bin/bash
# uDESK QEMU Test Runner

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Default options
MEMORY="1024"
IMAGE=""
HEADLESS=false

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        --image)
            IMAGE="$2"
            shift 2
            ;;
        --memory)
            MEMORY="$2"
            shift 2
            ;;
        --headless)
            HEADLESS=true
            shift
            ;;
        --help)
            echo "Usage: $0 --image <path> [options]"
            echo "Options:"
            echo "  --image <path>     Path to uDESK ISO/IMG file"
            echo "  --memory <MB>      RAM allocation (default: 1024)"
            echo "  --headless         Run without GUI"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$IMAGE" ]; then
    echo "Error: --image parameter required"
    echo "Available images:"
    find "$PROJECT_ROOT/out" -name "*.iso" -o -name "*.img" 2>/dev/null || echo "No images found in out/"
    exit 1
fi

if [ ! -f "$IMAGE" ]; then
    echo "Error: Image file not found: $IMAGE"
    exit 1
fi

echo "=== Running uDESK in QEMU ==="
echo "Image: $IMAGE"
echo "Memory: ${MEMORY}MB"

# Build QEMU command
QEMU_CMD="qemu-system-x86_64"
QEMU_ARGS="-m $MEMORY -cdrom '$IMAGE' -boot d"

# Add display options
if [ "$HEADLESS" = true ]; then
    QEMU_ARGS="$QEMU_ARGS -nographic"
else
    QEMU_ARGS="$QEMU_ARGS -display sdl"
fi

# Add network
QEMU_ARGS="$QEMU_ARGS -netdev user,id=net0 -device rtl8139,netdev=net0"

# Enable KVM if available
if [ -c /dev/kvm ]; then
    QEMU_ARGS="$QEMU_ARGS -enable-kvm"
fi

echo "Starting QEMU..."
echo "Command: $QEMU_CMD $QEMU_ARGS"
echo ""
echo "Tips:"
echo "- Press Ctrl+Alt+G to release mouse (GUI mode)"
echo "- Press Ctrl+A then X to quit (headless mode)"
echo "- Login as 'tc' user"
echo "- Test markdown tools: 'micro test.md' and 'glow test.md'"
echo ""

eval "$QEMU_CMD $QEMU_ARGS"
