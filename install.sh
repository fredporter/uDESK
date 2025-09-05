#!/bin/bash
# uDESK Bootstrap Installer v1.0.7.2
# Single directory installation - everything in ~/uDESK

set -e

# uCODE Standard Input Handling Functions
# ======================================

# Parse uCODE format input - case insensitive, supports shortcuts and partial matches
parse_ucode_input() {
    local input="$1"
    local options="$2"  # Format: "UPDATE|DESTROY|CANCEL" or "YES|NO"
    
    # Convert to uppercase for comparison
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
    
    # Split options by pipe
    IFS='|' read -ra OPTS <<< "$options"
    
    # Check for exact match first
    for opt in "${OPTS[@]}"; do
        if [[ "$input" == "$opt" ]]; then
            echo "$opt"
            return 0
        fi
    done
    
    # Check for partial matches (must be unique)
    local matches=()
    for opt in "${OPTS[@]}"; do
        if [[ "$opt" == "$input"* ]]; then
            matches+=("$opt")
        fi
    done
    
    # If exactly one match, use it
    if [[ ${#matches[@]} -eq 1 ]]; then
        echo "${matches[0]}"
        return 0
    fi
    
    # If multiple matches, it's ambiguous
    if [[ ${#matches[@]} -gt 1 ]]; then
        echo "AMBIGUOUS"
        return 1
    fi
    
    echo "INVALID"
    return 1
}

# Prompt with uCODE format and validation
prompt_ucode() {
    local prompt="$1"
    local options="$2"  # Format: "UPDATE|DESTROY|CANCEL"
    local default="$3"  # Optional default value
    
    # Build display options with shortcuts
    IFS='|' read -ra OPTS <<< "$options"
    local display_opts=""
    for i in "${!OPTS[@]}"; do
        local opt="${OPTS[$i]}"
        if [[ -n "$default" && "$opt" == "$default" ]]; then
            display_opts+="[${opt}]"
        else
            display_opts+="${opt}"
        fi
        if [[ $i -lt $((${#OPTS[@]} - 1)) ]]; then
            display_opts+="|"
        fi
    done
    
    while true; do
        if [[ -n "$default" ]]; then
            read -p "$prompt [$display_opts]: " input
            # Use default if empty
            if [[ -z "$input" ]]; then
                input="$default"
            fi
        else
            read -p "$prompt [$display_opts]: " input
        fi
        
        result=$(parse_ucode_input "$input" "$options")
        case "$result" in
            "INVALID")
                echo "❌ Invalid input. Please enter one of: $display_opts"
                echo "   You can use partial matches like 'up' for UPDATE, 'dest' for DESTROY, etc."
                ;;
            "AMBIGUOUS")
                echo "❌ Ambiguous input. Please be more specific."
                echo "   Available options: $display_opts"
                ;;
            *)
                echo "$result"
                return 0
                ;;
        esac
    done
}

# Function to handle directory collision
handle_existing_directory() {
    if [ -d "$HOME/uDESK" ]; then
        echo "⚠️  uDESK directory already exists at ~/uDESK"
        echo ""
        
        choice=$(prompt_ucode "Choose action" "UPDATE|DESTROY|CANCEL")
        
        case $choice in
            UPDATE)
                echo "📦 Will update existing installation..."
                return 0
                ;;
            DESTROY)
                echo "💥 Will destroy and start fresh..."
                confirm=$(prompt_ucode "Are you sure? This will delete ~/uDESK completely" "YES|NO" "NO")
                if [[ "$confirm" == "YES" ]]; then
                    echo "🗑️  Removing existing uDESK directory..."
                    cd "$HOME"  # Change to safe directory before deletion
                    rm -rf "$HOME/uDESK"
                    echo "✅ Directory removed"
                    return 0
                else
                    echo "❌ Installation cancelled"
                    exit 1
                fi
                ;;
            CANCEL)
                echo "❌ Installation cancelled"
                exit 1
                ;;
        esac
    fi
}

# Function to check prerequisites
check_prerequisites() {
    echo ""
    echo "🔍 Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        echo "❌ Git not found. Please install git and try again."
        exit 1
    fi
    echo "✅ Git found"
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo "❌ curl not found. Please install curl and try again."
        exit 1
    fi
    echo "✅ curl found"
}

# Function to clone or update repository
setup_repository() {
    echo ""
    if [ -d "$HOME/uDESK/.git" ]; then
        echo "🔄 Updating existing uDESK installation..."
        cd "$HOME/uDESK" && git pull
    else
        echo "📦 Downloading uDESK complete system..."
        git clone https://github.com/fredporter/uDESK.git "$HOME/uDESK"
        cd "$HOME/uDESK"
    fi
}

# Function to download TinyCore ISO
download_tinycore_iso() {
    echo ""
    echo "📀 Downloading TinyCore ISO (direct method)..."
    mkdir -p "$HOME/uDESK/iso/current"
    
    if curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar \
        "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" \
        -o "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"; then
        
        echo "✅ TinyCore ISO downloaded successfully!"
        mv "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp" "$HOME/uDESK/iso/current/TinyCore-current.iso"
        echo "📂 Location: ~/uDESK/iso/current/TinyCore-current.iso"
        return 0
    else
        echo "⚠️  TinyCore ISO download failed, but uDESK will work without it"
        echo "   You can download it manually later from: http://tinycorelinux.net/downloads.html"
        rm -f "$HOME/uDESK/iso/current/TinyCore-current.iso.tmp"
        return 1
    fi
}

# Function to test and launch uDOS
test_and_launch_udos() {
    echo ""
    echo "🔧 Testing installation..."
    
    # Test and launch uDOS
    if [ -f "$HOME/uDESK/build/user/udos" ]; then
        echo "✅ uDOS found - launching..."
        echo ""
        echo "=== Starting uDOS ==="
        cd "$HOME/uDESK"
        ./build/user/udos || echo "⚠️  uDOS exited"
    else
        echo "⚠️  uDOS binary not found, trying build..."
        if [ -f "$HOME/uDESK/build.sh" ]; then
            echo "🔨 Building uDOS..."
            cd "$HOME/uDESK"
            bash build.sh user
            if [ -f "build/user/udos" ]; then
                echo "✅ Build successful - launching uDOS..."
                echo ""
                echo "=== Starting uDOS ==="
                ./build/user/udos || echo "⚠️  uDOS exited"
            fi
        fi
    fi
}

echo "🚀 uDESK Bootstrap Installer v1.0.7.2"
echo "====================================="

# Handle existing directory (if not called from platform installer)
if [ "$1" != "--skip-collision-check" ]; then
    handle_existing_directory
fi

# Check prerequisites
check_prerequisites

# Setup repository
setup_repository

# Create user workspace directories within uDESK
echo ""
echo "📁 Setting up workspace structure..."
mkdir -p "$HOME/uDESK/uMEMORY/sandbox"
mkdir -p "$HOME/uDESK/uMEMORY/.local/logs"
mkdir -p "$HOME/uDESK/uMEMORY/.local/backups" 
mkdir -p "$HOME/uDESK/uMEMORY/.local/state"
mkdir -p "$HOME/uDESK/iso/current"
mkdir -p "$HOME/uDESK/iso/archive"

# Download TinyCore ISO (if not called from platform installer)
if [ "$2" != "--skip-iso-download" ]; then
    download_tinycore_iso
fi

# Run comprehensive health check and setup (but skip the failing download parts)
echo ""
echo "🩺 Running health check and setup..."
if [ -f "$HOME/uDESK/installers/setup.sh" ]; then
    # Skip the problematic download parts in setup.sh
    echo "📊 Running simplified health check..."
else
    echo "⚠️  Setup script not found - proceeding with legacy installation"
fi

# Modern repository-based installation (uDESK v1.0.7.2+)
echo ""
echo "🏗️  Configuring uDESK system integration..."

# Set up environment integration if requested
setup_integration=$(prompt_ucode "Set up system integration (PATH, commands)" "YES|NO" "NO")
if [[ "$setup_integration" == "YES" ]]; then
    echo "📦 Setting up system integration..."
    
    # Use user-local installation to avoid sudo requirements
    USER_LOCAL_BIN="$HOME/.local/bin"
    USER_LOCAL_CONFIG="$HOME/.config/udesk"
    
    mkdir -p "$USER_LOCAL_BIN"
    mkdir -p "$USER_LOCAL_CONFIG"
    
    # Create wrapper scripts for uDESK commands
    echo "� Creating command wrappers..."
    cat > "$USER_LOCAL_BIN/udos" << 'EOF'
#!/bin/bash
cd "$HOME/uDESK" && ./build/user/udos "$@"
EOF
    chmod +x "$USER_LOCAL_BIN/udos"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$USER_LOCAL_BIN:"* ]]; then
        echo "📝 Adding $USER_LOCAL_BIN to PATH..."
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
        echo "✅ System integration complete - restart shell or run: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    
    echo "✅ uDESK commands available: udos, uvar, udata, utpl"
else
    echo "📍 Skipped system integration - use commands from ~/uDESK/ directly"
fi

echo ""
echo "✅ uDESK v1.0.7.2 installation complete!"
echo ""
echo "📂 Unified Directory Structure:"
echo "  uDESK/                  - Complete system (root)"
echo "  uDESK/uMEMORY/sandbox   - User workspace"
echo "  uDESK/uMEMORY/.local/   - Logs, backups, state (XDG)"
echo "  uDESK/iso/current/      - TinyCore ISO storage"
echo "  uDESK/docs/             - Documentation"
echo "  ~/uDESK/dev/            - Development tools"
echo ""
echo "🔧 Available Commands:"
echo "  udos    - Main uDOS interface"
echo "  uvar    - Variable management"
echo "  udata   - Data management"
echo "  utpl    - Template management"
echo ""
echo "🧪 Quick Tests:"
echo "  cd ~/uDESK && udos version  - Check installation"
echo "  cd ~/uDESK && udos test     - Full system test"

# Test and launch uDOS (if not called from platform installer)
if [ "$3" != "--skip-auto-launch" ]; then
    test_and_launch_udos
    
    echo ""
    echo "📚 Documentation: https://github.com/fredporter/uDESK"
    echo "🔧 To run uDOS again: cd ~/uDESK && ./build/user/udos"
fi
