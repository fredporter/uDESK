#!/bin/bash
# TinyCore ISO Download with Robust Mirror Fallback System
# Part of uDESK v1.0.7.2

set -e

ISO_DIR="$echo ""
echo "💥 All mirrors failed - trying direct download..."
echo "🔄 Using working curl command..."

# Try the direct command that works
if curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar \
    "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" \
    -o "$ISO_DIR/TinyCore-current.iso.tmp"; then
    
    echo "✅ Direct download successful!"
    mv "$ISO_DIR/TinyCore-current.iso.tmp" "$ISO_DIR/TinyCore-current.iso"
    echo "📂 Location: $ISO_DIR/TinyCore-current.iso"
    exit 0
fi

echo ""
echo "💥 All download methods failed - unable to download TinyCore ISO"
echo ""
echo "Options:"
echo "1) Continue without TinyCore ISO (uDESK will work without it)"
echo "2) Retry download"  
echo "3) Exit and manually download"
echo ""
echo "🔧 Manual download instructions:"
echo "   - Download from: http://tinycorelinux.net/downloads.html"
echo "   - Place file as: $ISO_DIR/TinyCore-current.iso"
echo ""
read -p "Enter choice (1-3): " choice

# ISO storage paths
ISO_DIR="$HOME/uDESK/iso/current"
ARCHIVE_DIR="$HOME/uDESK/iso/archive"

# Comprehensive TinyCore mirror list with geographic diversity
MIRRORS=(
    "http://tinycorelinux.net/15.x/x86/release/"
    "http://www.tinycorelinux.net/15.x/x86/release/"
    "http://repo.tinycorelinux.net/15.x/x86/release/"
    "http://mirror.arizona.edu/tinycorelinux/15.x/x86/release/"
    "http://distro.ibiblio.org/tinycorelinux/15.x/x86/release/"
    "http://mirror.cs.princeton.edu/pub/mirrors/tinycorelinux/15.x/x86/release/"
    "http://ftp.nluug.nl/os/Linux/distr/tinycorelinux/15.x/x86/release/"
    "http://mirror.switch.ch/ftp/mirror/tinycorelinux/15.x/x86/release/"
    "http://ftp.uni-kl.de/pub/linux/tinycorelinux/15.x/x86/release/"
)

ISO_NAME="TinyCore-current.iso"
CHECKSUM_NAME="TinyCore-current.iso.md5.txt"

echo "🔍 Checking for existing TinyCore ISO..."

# Ensure directories exist
mkdir -p "$ISO_DIR" "$ARCHIVE_DIR"

# Check if current ISO exists and is valid
if [ -f "$ISO_DIR/$ISO_NAME" ] && [ -f "$ISO_DIR/$CHECKSUM_NAME" ]; then
    echo "✓ TinyCore ISO found - verifying checksum..."
    cd "$ISO_DIR"
    if md5sum -c "$CHECKSUM_NAME" 2>/dev/null; then
        echo "✅ ISO verification successful - using existing ISO"
        exit 0
    else
        echo "⚠️  ISO checksum failed - archiving and redownloading..."
        mv "$ISO_NAME" "$ARCHIVE_DIR/TinyCore-$(date +%Y%m%d-%H%M).iso" 2>/dev/null || true
        rm -f "$CHECKSUM_NAME"
    fi
fi

echo "📥 Downloading TinyCore ISO from mirrors..."

# Try each mirror with robust error handling
for i in "${!MIRRORS[@]}"; do
    mirror="${MIRRORS[$i]}"
    echo "🔄 Trying mirror $((i+1))/${#MIRRORS[@]}: $mirror"
    
    # Download checksum first (small file, quick test)
    if curl -L --connect-timeout 10 --max-time 30 --fail \
        "$mirror$CHECKSUM_NAME" -o "$ISO_DIR/$CHECKSUM_NAME.tmp" 2>/dev/null; then
        
        echo "  ✓ Checksum downloaded"
        
        # Download ISO with progress bar and better timeout
        if curl -L --connect-timeout 15 --max-time 900 --fail \
            --retry 2 --retry-delay 5 \
            --progress-bar "$mirror$ISO_NAME" -o "$ISO_DIR/$ISO_NAME.tmp"; then
            
            echo "  ✓ ISO downloaded - verifying..."
            
            # Verify checksum with better error handling
            cd "$ISO_DIR"
            if [ -s "$ISO_NAME.tmp" ] && [ -s "$CHECKSUM_NAME.tmp" ]; then
                # Check if md5sum command exists
                if command -v md5sum &> /dev/null; then
                    if md5sum -c "$CHECKSUM_NAME.tmp" 2>/dev/null; then
                        mv "$CHECKSUM_NAME.tmp" "$CHECKSUM_NAME"
                        mv "$ISO_NAME.tmp" "$ISO_NAME"
                        echo "✅ TinyCore ISO downloaded and verified successfully!"
                        echo "📂 Location: $ISO_DIR/$ISO_NAME"
                        exit 0
                    else
                        echo "  ❌ Checksum verification failed"
                    fi
                elif command -v md5 &> /dev/null; then
                    # macOS alternative
                    expected_checksum=$(cut -d' ' -f1 "$CHECKSUM_NAME.tmp")
                    actual_checksum=$(md5 -q "$ISO_NAME.tmp")
                    if [ "$expected_checksum" = "$actual_checksum" ]; then
                        mv "$CHECKSUM_NAME.tmp" "$CHECKSUM_NAME"
                        mv "$ISO_NAME.tmp" "$ISO_NAME"
                        echo "✅ TinyCore ISO downloaded and verified successfully!"
                        echo "📂 Location: $ISO_DIR/$ISO_NAME"
                        exit 0
                    else
                        echo "  ❌ Checksum verification failed (macOS md5)"
                    fi
                else
                    echo "  ⚠️  No checksum tool available, accepting download"
                    mv "$CHECKSUM_NAME.tmp" "$CHECKSUM_NAME"
                    mv "$ISO_NAME.tmp" "$ISO_NAME"
                    echo "✅ TinyCore ISO downloaded (checksum verification skipped)!"
                    echo "📂 Location: $ISO_DIR/$ISO_NAME"
                    exit 0
                fi
            else
                echo "  ❌ Downloaded files are empty or corrupted"
                rm -f "$ISO_NAME.tmp" "$CHECKSUM_NAME.tmp"
            fi
        else
            echo "  ❌ ISO download failed"
            rm -f "$CHECKSUM_NAME.tmp"
        fi
    else
        echo "  ❌ Mirror unreachable or checksum unavailable"
    fi
    
    # Brief pause between mirror attempts
    [ $i -lt $((${#MIRRORS[@]}-1)) ] && sleep 1
done

echo ""
echo "💥 All mirrors failed - unable to download TinyCore ISO"
echo ""
echo "Options:"
echo "1) Continue without TinyCore ISO (uDESK will work without it)"
echo "2) Retry download"  
echo "3) Exit and manually download"
echo ""
echo "🔧 Manual download instructions:"
echo "   - Download from: http://tinycorelinux.net/downloads.html"
echo "   - Place file as: $ISO_DIR/$ISO_NAME"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo "⚠️  Continuing without TinyCore ISO..."
        echo "📝 You can download it later and place it in: $ISO_DIR/"
        exit 0
        ;;
    2)
        echo "🔄 Retrying download..."
        exec "$0" "$@"
        ;;
    3)
        echo "📖 Manual download required"
        echo "   URL: http://tinycorelinux.net/downloads.html"
        echo "   Save as: $ISO_DIR/$ISO_NAME"
        exit 1
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac
