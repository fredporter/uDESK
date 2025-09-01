#!/bin/bash
# uDESK UTM Setup - Updated for Code/TinyCore-current.iso
# Automatically detects QEMU and chooses best setup method

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$PROJECT_ROOT/utm-ready"

echo "🚀 uDESK UTM Setup (Updated)"
echo "============================="

# Find TinyCore ISO - check Code directory first
TINYCORE_ISO=""
if [ -f "/Users/fredbook/Code/TinyCore-current.iso" ]; then
    TINYCORE_ISO="/Users/fredbook/Code/TinyCore-current.iso"
    echo "✅ Found working TinyCore ISO in Code directory"
elif [ -f "$PROJECT_ROOT/TinyCore-current.iso" ]; then
    TINYCORE_ISO="$PROJECT_ROOT/TinyCore-current.iso"
    echo "✅ Found TinyCore ISO in project directory"
else
    # Check for any ISO files
    for iso in "$PROJECT_ROOT"/*.iso /Users/fredbook/Code/*.iso; do
        if [ -f "$iso" ]; then
            TINYCORE_ISO="$iso"
            echo "✅ Found ISO: $(basename "$iso")"
            break
        fi
    done
fi

if [ -z "$TINYCORE_ISO" ]; then
    echo "❌ No TinyCore ISO found!"
    echo ""
    echo "Please copy your working TinyCore ISO to:"
    echo "  /Users/fredbook/Code/TinyCore-current.iso"
    echo ""
    exit 1
fi

# Check for uDESK packages
echo "📦 Checking uDESK packages..."
if [ ! -f "$PROJECT_ROOT/build/udos-core.tcz" ]; then
    echo "Building uDESK packages first..."
    cd "$PROJECT_ROOT"
    ./build.sh --clean
    cd "$PROJECT_ROOT"
fi

# Determine setup method
if command -v qemu-img >/dev/null 2>&1; then
    echo "🔧 QEMU detected - Using automated UTM VM creation"
    METHOD="AUTO"
else
    echo "📁 Using manual setup method (no QEMU dependency)"
    METHOD="MANUAL"
fi

# Create setup directory
rm -rf "$SETUP_DIR"
mkdir -p "$SETUP_DIR"

if [ "$METHOD" = "AUTO" ]; then
    echo "🤖 Running automated UTM setup..."
    ./utm-auto-setup.sh
else
    echo "📋 Creating manual setup package..."
    
    # Create manual setup
    mkdir -p "$SETUP_DIR/udesk-packages"
    
    # Copy files
    cp "$TINYCORE_ISO" "$SETUP_DIR/"
    cp "$PROJECT_ROOT/build"/*.tcz "$SETUP_DIR/udesk-packages/"
    
    # Copy Claude Code installer if it exists
    if [ -f "$PROJECT_ROOT/utm-setup/shared-folder/install-claude-code.sh" ]; then
        cp "$PROJECT_ROOT/utm-setup/shared-folder/install-claude-code.sh" "$SETUP_DIR/udesk-packages/"
        chmod +x "$SETUP_DIR/udesk-packages/install-claude-code.sh"
    fi
    
    # Create installer
    cat > "$SETUP_DIR/udesk-packages/install-udesk.sh" << 'INSTALL_EOF'
#!/bin/bash
echo "🚀 Installing uDESK in TinyCore..."
echo "================================="

# Check if we're in TinyCore
if ! command -v tce-load >/dev/null 2>&1; then
    echo "❌ This script must run inside TinyCore Linux"
    echo "Boot TinyCore first, then run this script"
    exit 1
fi

# Set up persistence directory
echo "📁 Setting up persistence..."
sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}
sudo chmod 775 /mnt/sda1/tce

# Find package directory (could be /tmp, /mnt/sdb1, etc.)
PKG_DIR=""
for dir in "$(pwd)" /tmp /mnt/sdb1 /home/tc; do
    if [ -f "$dir/udos-core.tcz" ]; then
        PKG_DIR="$dir"
        break
    fi
done

if [ -z "$PKG_DIR" ]; then
    echo "❌ uDESK packages not found!"
    echo "Make sure .tcz files are in current directory"
    exit 1
fi

echo "📦 Installing uDESK packages from: $PKG_DIR"

# Install packages
echo "Loading udos-core..."
tce-load -i "$PKG_DIR/udos-core.tcz"

echo "Loading udos-role-admin..."
tce-load -i "$PKG_DIR/udos-role-admin.tcz"

# Test installation
if command -v udos-info >/dev/null 2>&1; then
    echo "✅ uDESK installed successfully!"
    echo ""
    echo "🎉 Welcome to uDESK!"
    echo "==================="
    udos-info
    echo ""
    echo "Current role: $(udos-detect-role)"
    echo ""
else
    echo "❌ Installation failed"
    exit 1
fi

# Make persistent
echo "💾 Making installation persistent..."
sudo cp "$PKG_DIR"/*.tcz /mnt/sda1/tce/optional/
echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null
echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null

echo "✅ uDESK will now load automatically on boot"
echo ""
echo "🤖 Optional: Install Claude Code AI assistant"
echo "  ./install-claude-code.sh    # Requires internet"
echo ""
echo "🔄 Reboot to test: sudo reboot"
echo "🎯 Or continue using uDESK now!"
INSTALL_EOF

    chmod +x "$SETUP_DIR/udesk-packages/install-udesk.sh"
    
    # Create instructions
    cat > "$SETUP_DIR/SETUP-INSTRUCTIONS.md" << 'INSTRUCTIONS_EOF'
# 🚀 uDESK UTM Setup Instructions

## Step 1: Create UTM VM

1. **Open UTM** on your Mac
2. **Create New VM** → **Virtualize** → **Linux**
3. **Configure VM:**
   - **Boot ISO:** `TinyCore-current.iso` (in this folder)
   - **RAM:** 1024 MB (1 GB)
   - **Storage:** 4 GB
   - **Display:** **Console Only** ⚠️ *This fixes "display not active" errors*
   - **Network:** NAT or Bridged

## Step 2: Boot TinyCore

1. **Start the VM**
2. **Wait for TinyCore to boot** (text interface is normal)
3. **Login:** username `tc` (no password)

## Step 3: Install uDESK

**Method 1 - Drag & Drop:**
1. Drag `udesk-packages` folder into VM window
2. In TinyCore: `cd /tmp/udesk-packages`
3. Run: `./install-udesk.sh`

**Method 2 - Shared Folder:**
1. Set UTM shared folder to `udesk-packages`
2. In TinyCore: `sudo mount /dev/sdb1 /mnt/sdb1`
3. Run: `/mnt/sdb1/install-udesk.sh`

## Step 4: Test uDESK

```bash
udos-info              # System information
udos-detect-role       # Should show "admin"
udos-service list      # Available services
```

## Step 5: Persistence

Your uDESK installation is automatically persistent!
- Reboot: `sudo reboot`
- uDESK will load automatically

## Troubleshooting

**"Display not active" error:**
- Set Display to "Console Only" in UTM settings

**Packages not found:**
- Ensure .tcz files are copied to VM
- Check: `ls *.tcz` shows the package files

**Network issues:**
- In TinyCore: `sudo dhcp.sh`

---

## 🎉 Success!

Your markdown-focused operating system is ready!

**Quick commands:**
- `micro filename.md` - Edit markdown files
- `echo "# Hello uDESK!" > test.md` - Create markdown
- `cat test.md` - View files

*Everything in uDESK is markdown! 🚀*
INSTRUCTIONS_EOF

    echo ""
    echo "✅ Manual UTM setup package created!"
    echo "===================================="
fi

echo ""
echo "📁 Setup location: $SETUP_DIR"
echo "💿 Using ISO: $(basename "$TINYCORE_ISO")"
echo "📦 uDESK packages: $(ls "$PROJECT_ROOT/build"/*.tcz | wc -l | tr -d ' ') files"
echo "📏 Total size: $(du -sh "$SETUP_DIR" 2>/dev/null | cut -f1 || echo "N/A")"
echo ""

if [ "$METHOD" = "MANUAL" ]; then
    echo "📋 Setup method: Manual (follow SETUP-INSTRUCTIONS.md)"
    echo ""
    echo "🚀 Quick start:"
    echo "1. Open UTM"
    echo "2. Create VM with Console Only display"
    echo "3. Use TinyCore-current.iso"
    echo "4. Follow instructions in setup folder"
else
    echo "🤖 Setup method: Automated (UTM VM created)"
    echo ""
    echo "🚀 Your VM is ready in UTM!"
fi

# Open folder
if command -v open >/dev/null 2>&1; then
    echo ""
    echo "Opening setup folder..."
    open "$SETUP_DIR"
fi

echo ""
echo "🎉 uDESK UTM setup complete!"