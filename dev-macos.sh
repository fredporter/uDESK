#!/bin/bash
# uDESK development helper for macOS

cd "$(dirname "$0")"

case "$1" in
    "setup")
        echo "🔧 Setting up uDESK development environment..."
        chmod +x *.sh packaging/*.sh isos/*.sh
        
        # Download TinyCore if needed
        if [ ! -f TinyCore-current.iso ]; then
            echo "📥 Downloading TinyCore..."
            curl -L -o TinyCore-current.iso "http://tinycorelinux.net/15.x/x86_64/release/TinyCore-current.iso"
        fi
        
        echo "✅ Setup complete!"
        ;;
        
    "build")
        echo "🔨 Building uDESK packages..."
        ./packaging/build_udos_core.sh
        ./packaging/build_udos_roles.sh
        echo "✅ Build complete! Check build/ directory"
        ;;
        
    "test")
        echo "🧪 Running M1 tests..."
        ./test-m1-macos.sh
        ;;
        
    "status")
        echo "📊 uDESK Development Status"
        echo ""
        echo "📁 Project structure:"
        echo "  • src/udos-core/     $(find src/udos-core -type f | wc -l | tr -d ' ') files"
        echo "  • packaging/         $(find packaging -name "*.sh" | wc -l | tr -d ' ') scripts"
        echo "  • docs/             $(find docs -name "*.md" | wc -l | tr -d ' ') documents"
        
        echo ""
        echo "🔨 Build artifacts:"
        if [ -d build ]; then
            ls -la build/
        else
            echo "  • No packages built yet"
        fi
        
        echo ""
        echo "🎯 Next actions:"
        echo "  • ./dev-macos.sh build  - Build packages"
        echo "  • ./dev-macos.sh test   - Run tests"
        ;;
        
    "clean")
        echo "🧹 Cleaning build artifacts..."
        rm -rf build/ out/
        echo "✅ Clean complete!"
        ;;
        
    *)
        echo "🚀 uDESK Development Helper (macOS)"
        echo ""
        echo "Commands:"
        echo "  setup   - Initial setup and tool installation"
        echo "  build   - Build uDESK packages" 
        echo "  test    - Run M1 validation tests"
        echo "  status  - Show project status"
        echo "  clean   - Clean build artifacts"
        echo ""
        echo "Quick start:"
        echo "  ./dev-macos.sh setup"
        echo "  ./dev-macos.sh build"
        echo "  ./dev-macos.sh test"
        ;;
esac
