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
