#!/bin/bash
# TinyCore ISO Download with Robust Mirror Fallback System
# Part of uDESK v1.0.7.2

set -e

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
        
        # Download ISO with progress bar
        if curl -L --connect-timeout 10 --max-time 600 --fail \
            --progress-bar "$mirror$ISO_NAME" -o "$ISO_DIR/$ISO_NAME.tmp"; then
            
            echo "  ✓ ISO downloaded - verifying..."
            
            # Verify checksum
            cd "$ISO_DIR"
            if md5sum -c "$CHECKSUM_NAME.tmp" 2>/dev/null; then
                mv "$CHECKSUM_NAME.tmp" "$CHECKSUM_NAME"
                mv "$ISO_NAME.tmp" "$ISO_NAME"
                echo "✅ TinyCore ISO downloaded and verified successfully!"
                echo "📂 Location: $ISO_DIR/$ISO_NAME"
                exit 0
            else
                echo "  ❌ Checksum verification failed"
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
echo "🔧 Troubleshooting:"
echo "   - Check internet connection"
echo "   - Verify firewall settings"
echo "   - Try manual download from: http://tinycorelinux.net/"
echo "   - Place ISO manually in: $ISO_DIR/$ISO_NAME"
exit 1
