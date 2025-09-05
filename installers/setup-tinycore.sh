#!/bin/bash
# uDESK v1.0.7 - TinyCore Integration Setup Script
# Sets up TinyCore Linux integration and ISO building

set -e

echo "💿 uDESK v1.0.7 - TinyCore Integration Setup"
echo "============================================="
echo ""
echo "💡 Note: This setup automatically syncs with the latest uDESK repository"
echo "   Repository location: uDESK/repository/"
echo "   TinyCore files: uDESK/repository/system/tinycore/"
echo "   Workspace: uMEMORY/"
echo ""

# Check if we're in the right directory
if [ ! -f "build.sh" ] || [ ! -d "core" ]; then
    echo "❌ Please run this script from the uDESK root directory"
    echo "   Current: $(pwd)"
    echo "   Expected: Directory containing build.sh and core/"
    exit 1
fi

echo "🔍 Checking TinyCore setup options..."
echo ""

# Check for TinyCore ISO
TINYCORE_ISO=""
if [ -f "${HOME}/uDESK/tinycore/TinyCore-16.1.iso" ]; then
    TINYCORE_ISO="${HOME}/uDESK/tinycore/TinyCore-16.1.iso"
    echo "✅ TinyCore ISO found: $(basename $TINYCORE_ISO)"
elif [ -f "TinyCore-current.iso" ]; then
    TINYCORE_ISO="TinyCore-current.iso"
    echo "✅ TinyCore ISO found: $TINYCORE_ISO"
else
    echo "📥 TinyCore ISO not found - download script available"
fi

# Check for existing TinyCore tools
TINYCORE_AVAILABLE=false
DOCKER_AVAILABLE=false
VM_OPTION=false

if command -v tce-load &> /dev/null; then
    echo "✅ TinyCore environment detected"
    TINYCORE_AVAILABLE=true
elif command -v docker &> /dev/null; then
    echo "🐳 Docker available for TinyCore containers"
    DOCKER_AVAILABLE=true
else
    echo "💻 Virtual machine setup available"
    VM_OPTION=true
fi

echo ""
echo "🎯 TinyCore Setup Options:"
echo ""

if [ -z "$TINYCORE_ISO" ]; then
    echo "0) 📥 Download TinyCore ISO (required first)"
fi

if [ "$TINYCORE_AVAILABLE" = true ]; then
    echo "1) 🔨 Build uDESK.tcz package (native)"
    echo "2) 📦 Install uDESK in current TinyCore"
    echo "3) 🧪 Test uDESK TCZ package"
elif [ "$DOCKER_AVAILABLE" = true ]; then
    echo "1) 🐳 Build uDESK.tcz with Docker"
    echo "2) 💿 Create bootable ISO with Docker"
    echo "3) 🧪 Test TinyCore container"
fi

if [ "$VM_OPTION" = true ]; then
    echo "4) 📥 Download TinyCore ISO"
    echo "5) 🖥️  Setup VM instructions"
fi

echo "6) 📖 Show TinyCore commands"
echo "7) 🔄 Return to uDESK root"
echo ""

read -p "Choose option (0-7): " choice

case $choice in
    0)
        if [ -z "$TINYCORE_ISO" ]; then
            echo ""
            echo "📥 Downloading TinyCore ISO..."
            ./download-tinycore.sh
            echo ""
            echo "🔄 Restart this script to use the downloaded ISO"
        else
            echo "✅ TinyCore ISO already available: $TINYCORE_ISO"
        fi
        ;;
    1)
        if [ "$TINYCORE_AVAILABLE" = true ]; then
            echo ""
            echo "🔨 Building uDESK.tcz package natively..."
            
            # Build uDESK components first
            echo "📦 Building uDESK components..."
            ./build.sh user
            ./build.sh wizard
            ./build.sh developer
            
            # Create TCZ structure
            echo "🏗️  Creating TCZ package structure..."
            mkdir -p build/tcz/{usr/local/bin,usr/local/share/udesk}
            
            # Copy binaries
            cp build/user/udos build/tcz/usr/local/bin/
            cp build/wizard/udos-wizard build/tcz/usr/local/bin/
            cp build/developer/udos-developer build/tcz/usr/local/bin/
            
            # Copy documentation
            cp -r core/docs build/tcz/usr/local/share/udesk/
            
            # Create TCZ package
            cd build/tcz
            find . -type f | sort > ../udesk.tcz.list
            tar -czf ../udesk.tcz *
            cd ../..
            
            echo "✅ uDESK.tcz created: build/udesk.tcz"
            echo "📦 Install with: tce-load -i build/udesk.tcz"
            
        elif [ "$DOCKER_AVAILABLE" = true ]; then
            echo ""
            echo "🐳 Building uDESK.tcz with Docker..."
            echo "   Using TinyCore container for clean build environment"
            
            # Create Dockerfile for TinyCore build
            cat > Dockerfile.tinycore << 'EOF'
FROM busybox:latest
WORKDIR /workspace
COPY . .
RUN chmod +x build.sh
CMD ["./build.sh", "iso"]
EOF
            
            echo "🏗️  Building in TinyCore container..."
            docker build -f Dockerfile.tinycore -t udesk-tinycore .
            docker run -v "$(pwd)/build:/workspace/build" udesk-tinycore
            
            echo "✅ Container build complete"
            echo "📦 TCZ package: build/udesk.tcz"
        fi
        ;;
        
    2)
        if [ "$TINYCORE_AVAILABLE" = true ]; then
            echo ""
            echo "📦 Installing uDESK in current TinyCore..."
            
            # Build TCZ if not exists
            if [ ! -f "build/udesk.tcz" ]; then
                echo "🔨 Building TCZ package first..."
                $0  # Recursively run option 1
            fi
            
            echo "⬇️  Installing uDESK TCZ..."
            sudo tce-load -i build/udesk.tcz
            
            echo "✅ uDESK installed!"
            echo "🚀 Launch with: udos"
            
        elif [ "$DOCKER_AVAILABLE" = true ]; then
            echo ""
            echo "💿 Creating bootable ISO with Docker..."
            ./build.sh iso
            echo "✅ Bootable ISO ready: build/iso/"
        fi
        ;;
        
    3)
        echo ""
        echo "🧪 Testing TinyCore integration..."
        
        if [ "$TINYCORE_AVAILABLE" = true ]; then
            echo "Testing installed uDESK..."
            if command -v udos &> /dev/null; then
                echo "✅ uDESK found in PATH"
                echo "🧪 Running quick test..."
                echo "INFO" | udos
            else
                echo "❌ uDESK not found. Install with option 2."
            fi
        else
            echo "🐳 Testing TinyCore container..."
            docker run --rm -it tinycore/tinycore:latest /bin/sh -c "echo 'TinyCore container working'"
        fi
        ;;
        
    4)
        if [ "$VM_OPTION" = true ]; then
            echo ""
            echo "📥 Downloading TinyCore ISO..."
            
            mkdir -p downloads
            cd downloads
            
            echo "⬇️  Downloading TinyCore64-current.iso..."
            if command -v curl &> /dev/null; then
                curl -O http://tinycorelinux.net/13.x/x86_64/release/TinyCore64-current.iso
            elif command -v wget &> /dev/null; then
                wget http://tinycorelinux.net/13.x/x86_64/release/TinyCore64-current.iso
            else
                echo "❌ curl or wget required for download"
                echo "   Manual download: http://tinycorelinux.net/13.x/x86_64/release/TinyCore64-current.iso"
            fi
            
            cd ..
            echo "✅ TinyCore ISO downloaded to downloads/"
        fi
        ;;
        
    5)
        echo ""
        echo "🖥️  Virtual Machine Setup Instructions:"
        echo ""
        echo "📋 Requirements:"
        echo "   • VM software: VirtualBox, VMware, or QEMU"
        echo "   • TinyCore ISO: downloads/TinyCore64-current.iso"
        echo "   • Memory: 512MB minimum, 1GB recommended"
        echo "   • Storage: 1GB for testing, 4GB for development"
        echo ""
        echo "🚀 Quick QEMU setup:"
        echo "   qemu-system-x86_64 -m 1024 -cdrom downloads/TinyCore64-current.iso"
        echo ""
        echo "📦 Inside TinyCore VM:"
        echo "   1. Boot TinyCore"
        echo "   2. tce-load -wi compiletc"
        echo "   3. tce-load -wi bash"
        echo "   4. Copy udesk.tcz to VM"
        echo "   5. tce-load -i udesk.tcz"
        echo "   6. udos"
        echo ""
        echo "💾 VirtualBox setup:"
        echo "   1. New VM → Linux → Other Linux (64-bit)"
        echo "   2. Memory: 1024MB"
        echo "   3. Storage: 4GB dynamic disk"
        echo "   4. Boot from TinyCore ISO"
        echo ""
        ;;
        
    6)
        echo ""
        echo "📖 TinyCore Commands Reference:"
        echo ""
        echo "🔧 Package Management:"
        echo "   tce-load -wi package    # Install package with dependencies"
        echo "   tce-load -i package.tcz # Install local TCZ package"
        echo "   tce-load -l            # List installed packages"
        echo ""
        echo "🏗️  uDESK Commands:"
        echo "   ./build.sh iso         # Build uDESK ISO"
        echo "   tce-load -i udesk.tcz  # Install uDESK"
        echo "   udos                   # Launch uDESK"
        echo ""
        echo "💾 Persistence:"
        echo "   filetool.sh -b         # Backup current state"
        echo "   filetool.sh -r         # Restore from backup"
        echo ""
        echo "🐳 Docker Commands:"
        echo "   docker run -it tinycore/tinycore"
        echo "   docker build -t udesk-tc ."
        echo ""
        ;;
        
    7)
        echo ""
        echo "🔄 Returning to uDESK root directory..."
        echo "📁 Current directory: $(pwd)"
        ;;
        
    *)
        echo ""
        echo "❌ Invalid option"
        ;;
esac

echo ""
echo "✅ TinyCore setup operations complete!"
echo ""
echo "🎯 Next Steps:"
if [ "$TINYCORE_AVAILABLE" = true ]; then
    echo "   • Build TCZ:    $0 (option 1)"
    echo "   • Install:      tce-load -i build/udesk.tcz"
    echo "   • Launch:       udos"
elif [ "$DOCKER_AVAILABLE" = true ]; then
    echo "   • Build ISO:    ./build.sh iso"
    echo "   • Test:         docker run -it tinycore/tinycore"
else
    echo "   • Download ISO: $0 (option 4)"
    echo "   • Setup VM:     $0 (option 5)"
    echo "   • Install Docker for container builds"
fi
echo "   • uDESK CLI:    ./build.sh user && ./build/user/udos"
echo ""
