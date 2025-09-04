#!/bin/bash
# uDESK v1.0.7 - TinyCore ISO Download Script
# Downloads the latest TinyCore Linux ISO for uDESK integration

set -e

VERSION="16.1"
MIRRORS=(
    "http://distro.ibiblio.org/tinycorelinux/${VERSION}/x86/release"
    "http://repo.tinycorelinux.net/${VERSION}/x86/release"
    "https://mirrors.kernel.org/tinycorelinux/${VERSION}/x86/release"
    "http://tinycorelinux.net/dl/${VERSION}/x86/release"
)

DOWNLOAD_DIR="${HOME}/uDESK/tinycore"
ISO_FILE="${DOWNLOAD_DIR}/TinyCore-${VERSION}.iso"
TEMP_FILE="${ISO_FILE}.tmp"

echo "📥 uDESK TinyCore Download Script"
echo "================================="
echo ""
echo "TinyCore Linux ${VERSION} - Minimal Linux Distribution"
echo "Official GitHub: https://github.com/tinycorelinux"
echo "License: GPL-2.0 (Free to redistribute)"
echo ""

# Create download directory
mkdir -p "${DOWNLOAD_DIR}"

# Check if ISO already exists
if [ -f "${ISO_FILE}" ]; then
    echo "✅ TinyCore ${VERSION} already downloaded:"
    echo "   Location: ${ISO_FILE}"
    echo "   Size: $(ls -lh "${ISO_FILE}" | awk '{print $5}')"
    echo "   SHA1: $(shasum "${ISO_FILE}" | awk '{print $1}')"
    echo ""
    read -p "Re-download? (y/n) [n]: " redownload
    case ${redownload:-n} in
        [Yy]*) rm -f "${ISO_FILE}" ;;
        *) echo "Using existing file."; exit 0 ;;
    esac
fi

echo "🔍 Finding fastest mirror..."

# Function to test mirror availability
test_mirror() {
    local mirror="$1"
    local test_url="${mirror}/TinyCore-${VERSION}.iso"
    
    if command -v curl >/dev/null 2>&1; then
        curl -s -I --connect-timeout 5 "${test_url}" >/dev/null 2>&1
    elif command -v wget >/dev/null 2>&1; then
        wget -q --spider --timeout=5 "${test_url}" >/dev/null 2>&1
    else
        return 1
    fi
}

# Find working mirror
WORKING_MIRROR=""
for mirror in "${MIRRORS[@]}"; do
    echo -n "Testing ${mirror}... "
    if test_mirror "$mirror"; then
        echo "✅ Available"
        WORKING_MIRROR="$mirror"
        break
    else
        echo "❌ Unavailable"
    fi
done

if [ -z "$WORKING_MIRROR" ]; then
    echo ""
    echo "❌ No working mirrors found. Please check your internet connection."
    echo ""
    echo "Alternative download options:"
    echo "1. Manual download: http://tinycorelinux.net/downloads.html"
    echo "2. GitHub releases: https://github.com/tinycorelinux (check releases)"
    echo "3. Official site: http://distro.ibiblio.org/tinycorelinux/"
    exit 1
fi

DOWNLOAD_URL="${WORKING_MIRROR}/TinyCore-${VERSION}.iso"
echo ""
echo "🔄 Downloading TinyCore ${VERSION}..."
echo "Source: ${DOWNLOAD_URL}"
echo "Target: ${ISO_FILE}"
echo ""

# Download with progress and resume support
if command -v curl >/dev/null 2>&1; then
    curl -L -C - --progress-bar -o "${TEMP_FILE}" "${DOWNLOAD_URL}"
elif command -v wget >/dev/null 2>&1; then
    wget -c --progress=bar:force -O "${TEMP_FILE}" "${DOWNLOAD_URL}"
else
    echo "❌ Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Verify download and move to final location
if [ -f "${TEMP_FILE}" ] && [ -s "${TEMP_FILE}" ]; then
    mv "${TEMP_FILE}" "${ISO_FILE}"
    echo ""
    echo "✅ Download completed successfully!"
    echo ""
    echo "📄 File Information:"
    echo "   Location: ${ISO_FILE}"
    echo "   Size: $(ls -lh "${ISO_FILE}" | awk '{print $5}')"
    echo "   Type: $(file "${ISO_FILE}" | cut -d: -f2-)"
    echo "   SHA1: $(shasum "${ISO_FILE}" | awk '{print $1}')"
    echo ""
    echo "🚀 Integration with uDESK:"
    echo "   1. ISO Build:     ./build.sh iso"
    echo "   2. TinyCore Setup: ./setup-tinycore.sh"
    echo "   3. VM Testing:    ./setup-tinycore.sh (option 5)"
    echo "   4. Docker Build:  ./setup-tinycore.sh (option 1)"
    echo ""
    echo "💿 Direct Usage:"
    echo "   1. Boot from USB: dd if=${ISO_FILE} of=/dev/sdX bs=4M"
    echo "   2. VM Boot Media: Use ${ISO_FILE} in VirtualBox/VMware"
    echo "   3. CD/DVD Burn:   Use any burning software"
    echo ""
    echo "📚 Documentation:"
    echo "   • TinyCore Book: http://tinycorelinux.net/book.html"
    echo "   • GitHub Repo:   https://github.com/tinycorelinux"
    echo "   • uDESK Docs:    uDESK/repository/docs/"
    echo "   • Official Site: http://tinycorelinux.net/"
else
    echo "❌ Download failed or file is empty!"
    rm -f "${TEMP_FILE}"
    exit 1
fi
