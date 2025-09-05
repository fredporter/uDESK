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
    mkdir -p "$HOME/uDESK/build/iso"
    
    # Check if ISO already exists
    if [ -f "$HOME/uDESK/build/iso/TinyCore-current.iso" ]; then
        echo "📀 TinyCore ISO already exists - skipping download"
        echo "📂 Location: ~/uDESK/build/iso/TinyCore-current.iso"
        return 0
    fi
    
    echo "📀 Downloading TinyCore ISO (direct method)..."
    
    if curl -L --connect-timeout 15 --max-time 300 --fail --progress-bar \
        "http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso" \
        -o "$HOME/uDESK/build/iso/TinyCore-current.iso.tmp"; then
        
        echo "✅ TinyCore ISO downloaded successfully!"
        mv "$HOME/uDESK/build/iso/TinyCore-current.iso.tmp" "$HOME/uDESK/build/iso/TinyCore-current.iso"
        echo "📂 Location: ~/uDESK/build/iso/TinyCore-current.iso"
        return 0
    else
        echo "⚠️  TinyCore ISO download failed, but uDESK will work without it"
        echo "   You can download it manually later from: http://tinycorelinux.net/downloads.html"
        rm -f "$HOME/uDESK/build/iso/TinyCore-current.iso.tmp"
        return 1
    fi
}

# Function to test and launch uDOS
test_and_launch_udos() {
    echo ""
    echo "🔧 Testing installation..."
    
    # Test and launch uDOS (prefer wizard mode for first-time setup)
    if [ -f "$HOME/uDESK/build/wizard/udos-wizard" ]; then
        echo "✅ uDOS Wizard found - launching..."
        echo ""
        echo "=== Starting uDOS Wizard ==="
        cd "$HOME/uDESK"
        ./build/wizard/udos-wizard || echo "⚠️  uDOS exited"
    elif [ -f "$HOME/uDESK/build/user/udos" ]; then
        echo "✅ uDOS found - launching..."
        echo ""
        echo "=== Starting uDOS ==="
        cd "$HOME/uDESK"
        ./build/user/udos || echo "⚠️  uDOS exited"
    else
        echo "⚠️  uDOS binary not found, trying build..."
        if [ -f "$HOME/uDESK/dev/build.sh" ]; then
            echo "🔨 Building uDOS (Wizard Mode for first-time setup)..."
            cd "$HOME/uDESK"
            bash dev/build.sh wizard
            if [ -f "build/wizard/udos-wizard" ]; then
                echo "✅ Build successful - launching Wizard Mode..."
                echo ""
                echo "=== Starting uDOS Wizard ==="
                ./build/wizard/udos-wizard || echo "⚠️  uDOS exited"
            fi
        else
            echo "⚠️  Build script not found in dev/ - binaries may need manual compilation"
        fi
    fi
}

# Function to detect platform
detect_platform() {
    # Check environment variable first (set by platform installers)
    if [ "$UDESK_PLATFORM" = "macos" ]; then
        echo "macos"
        return
    fi
    
    # Check if running on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to launch Tauri app
launch_tauri_app() {
    local is_macos=${1:-false}
    echo ""
    echo "🎨 Launching Modern Tauri Interface..."
    
    if [ -d "$HOME/uDESK/app" ]; then
        cd "$HOME/uDESK/app"
        
        # Check if package.json exists
        if [ ! -f "package.json" ]; then
            echo "⚠️  Tauri app not properly set up (missing package.json)"
            return 1
        fi
        
        # Check if node modules exist
        if [ ! -d "node_modules" ]; then
            echo "📦 Installing Tauri dependencies..."
            if command -v npm &> /dev/null; then
                npm install
                if [ $? -ne 0 ]; then
                    echo "⚠️  npm install failed - check Node.js installation"
                    return 1
                fi
            else
                echo "⚠️  npm not found - install Node.js to use Tauri interface"
                echo "   Download from: https://nodejs.org/"
                return 1
            fi
        fi
        
        # On macOS, build production app for dock integration
        if [ "$is_macos" = "true" ]; then
            echo "🍎 macOS detected - building production app with dock icon..."
            echo "   This may take a few minutes but gives you a proper Mac app!"
            
            if command -v npm &> /dev/null; then
                # Check if Rust is available for Tauri build
                if command -v cargo &> /dev/null; then
                    echo "🏗️  Building production Tauri app..."
                    if npm run tauri:build; then
                        echo "✅ Production app built successfully!"
                        
                        # Find and open the .app bundle
                        APP_BUNDLE=$(find "target/release/bundle/macos/" -name "*.app" -type d 2>/dev/null | head -1)
                        if [ -n "$APP_BUNDLE" ]; then
                            echo "🚀 Opening production app with dock icon..."
                            open "$APP_BUNDLE"
                            echo "✅ uDESK app now available in dock and Applications!"
                            return 0
                        else
                            echo "⚠️  App bundle not found - falling back to development mode"
                        fi
                    else
                        echo "⚠️  Production build failed - falling back to development mode"
                    fi
                else
                    echo "⚠️  Rust/Cargo not found - install for production builds"
                    echo "   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
                    echo "   Falling back to development mode..."
                fi
            fi
        fi
        
        # Launch Tauri app in development mode (fallback or non-macOS)
        echo "🚀 Starting Tauri desktop app (development mode)..."
        if command -v npm &> /dev/null; then
            # Check if tauri is available
            if npm run tauri --version &> /dev/null; then
                echo "   Launching in background..."
                nohup npm run tauri dev > /dev/null 2>&1 &
                sleep 2
                echo "✅ Tauri app launched in background"
                echo "   A desktop window should open shortly..."
            else
                echo "⚠️  Tauri not properly configured in package.json"
            fi
        else
            echo "⚠️  npm not found - install Node.js to use Tauri interface"
        fi
    else
        echo "⚠️  Tauri app directory not found at ~/uDESK/app"
        echo "   The modern desktop interface requires the app directory"
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
mkdir -p "$HOME/uDESK/build/iso"

# Download TinyCore ISO (if not called from platform installer)
if [ "$2" != "--skip-iso-download" ]; then
    download_tinycore_iso
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
echo "  uDESK/build/iso/        - TinyCore ISO storage"
echo "  uDESK/docs/             - Documentation"
echo "  ~/uDESK/dev/            - Development tools"
echo ""
echo "🔧 Available Commands:"
echo "  udos-wizard - Main uDOS Wizard interface (recommended)"
echo "  udos        - Standard uDOS interface"
echo "  uvar        - Variable management"
echo "  udata       - Data management"
echo "  utpl        - Template management"
echo ""
echo "🧪 Quick Tests:"
echo "  cd ~/uDESK && ./build/wizard/udos-wizard  - Launch Wizard mode"
echo "  cd ~/uDESK && ./build/user/udos version   - Check installation"
echo ""
echo "🎨 Desktop App (Tauri):"
echo "  ./launch-tauri.sh       - Launch development app"
echo "  ./launch-tauri.sh --build - Build production app with dock icon"
echo "  ./udesk-app             - Quick launcher command"

# Test and launch uDOS (if not called from platform installer)
if [ "$3" != "--skip-auto-launch" ]; then
    test_and_launch_udos
    
    # Detect platform and launch Tauri with appropriate mode
    platform=$(detect_platform)
    if [ "$platform" = "macos" ]; then
        launch_tauri_app true
    else
        launch_tauri_app false
    fi
    
    echo ""
    echo "📚 Documentation: https://github.com/fredporter/uDESK"
    echo "🔧 To run uDOS again: cd ~/uDESK && ./build/wizard/udos-wizard"
    echo "🎨 To run Tauri GUI: cd ~/uDESK && ./launch-tauri.sh"
    
    # Show macOS-specific message if production build was attempted
    if [ "$(detect_platform)" = "macos" ]; then
        echo "🍎 macOS: Production app with dock icon was built during installation!"
        echo "   Look for uDESK in your dock or Applications folder"
    fi
    echo "🏗️  For dock icon: cd ~/uDESK && ./launch-tauri.sh --build"
fi
