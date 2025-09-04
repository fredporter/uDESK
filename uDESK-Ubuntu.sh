#!/bin/bash
# uDESK v1.0.7 - Ubuntu/Debian Launcher with GUI Options

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🐧 uDESK v1.0.7 - Ubuntu Launcher"
echo "=================================="
echo "📁 Working directory: $SCRIPT_DIR"
echo ""

# Check if we're on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ This launcher is for Ubuntu/Debian systems"
    echo "   Use Launch-uDESK-macOS.command or uDESK-Windows.bat instead"
    read -p "Press any key to exit..."
    exit 1
fi

# Check for build tools
if ! command -v gcc &> /dev/null; then
    echo "📦 Installing build essentials..."
    echo "   This will install gcc, make, and other development tools"
    echo ""
    sudo apt update
    sudo apt install -y build-essential git curl
    echo ""
    echo "✅ Build tools installed successfully"
fi

# Set environment
export UDESK_ROLE="GHOST"
export UDESK_MODE="USER"

echo "🚀 Starting uDESK..."
echo "   Platform: Ubuntu $(lsb_release -rs 2>/dev/null || echo 'Unknown')"
echo "   Architecture: $(uname -m)"
echo "   Role: $UDESK_ROLE"
echo "   Mode: $UDESK_MODE"
echo ""

# Check if build.sh exists
if [ ! -f "./build.sh" ]; then
    echo "❌ build.sh not found in current directory"
    echo "   Make sure this launcher is in your uDESK folder"
    read -p "Press any key to exit..."
    exit 1
fi

# Function to show startup menu
show_startup_menu() {
    echo "🚀 uDESK Startup Options"
    echo "========================"
    echo ""
    echo "Choose your preferred interface:"
    echo ""
    echo "1) 🖥️  Terminal Interface (Classic)"
    echo "   - Command-line uCODE interface"
    echo "   - Direct access to all functions"
    echo "   - Best for experienced users"
    echo ""
    echo "2) 📱 Desktop App (Modern GUI)"
    echo "   - Modern Tauri-based interface"
    echo "   - Setup wizard and visual tools"
    echo "   - Best for new users"
    echo ""
    echo "3) ⚙️  Setup & Configuration"
    echo "   - Configure uDESK settings"
    echo "   - Install dependencies"
    echo "   - System diagnostics"
    echo ""
    echo "4) 📖 Documentation & Help"
    echo "   - Open user manual"
    echo "   - View README and guides"
    echo "   - Architecture documentation"
    echo ""
    echo "5) 🔧 Developer Mode"
    echo "   - Build development version"
    echo "   - Access developer tools"
    echo "   - Advanced configuration"
    echo ""
    echo "6) ❌ Exit"
    echo ""
    echo -n "Select option [1-6]: "
}

# Function to launch desktop app
launch_desktop_app() {
    echo ""
    echo "📱 Starting uDESK Desktop App..."
    echo ""
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js not found"
        echo "   Install with: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
        echo "                 sudo apt-get install -y nodejs"
        echo ""
        read -p "Would you like to install Node.js automatically? [y/N]: " install_node
        if [[ $install_node =~ ^[Yy]$ ]]; then
            echo "📦 Installing Node.js LTS..."
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
            echo "✅ Node.js installation complete"
        else
            read -p "Press any key to return to menu..."
            return
        fi
    fi
    
    # Check if dependencies are installed
    cd app/udesk-app
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing dependencies..."
        npm install
    fi
    
    echo "🚀 Launching Tauri development server..."
    echo "   The desktop app will open automatically"
    echo "   Close the app window to return to this menu"
    echo ""
    
    npm run tauri dev
    cd ../../
}

# Function to run setup and configuration
run_setup() {
    echo ""
    echo "⚙️  uDESK Setup & Configuration"
    echo "==============================="
    echo ""
    
    # Quick system check
    echo "🔍 System Information:"
    echo "   OS: Ubuntu $(lsb_release -rs 2>/dev/null || echo 'Unknown')"
    echo "   Architecture: $(uname -m)"
    echo "   Shell: $SHELL"
    echo ""
    
    echo "📦 Checking dependencies..."
    
    # Check build tools
    if command -v gcc &> /dev/null; then
        echo "   ✅ GCC/Build tools"
    else
        echo "   ❌ GCC/Build tools (required for building)"
    fi
    
    # Check Node.js
    if command -v node &> /dev/null; then
        echo "   ✅ Node.js $(node --version)"
    else
        echo "   ❌ Node.js (required for desktop app)"
    fi
    
    # Check Rust
    if command -v cargo &> /dev/null; then
        echo "   ✅ Rust $(rustc --version | cut -d' ' -f2)"
    else
        echo "   ❌ Rust (required for Tauri app)"
    fi
    
    echo ""
    echo "🔧 Setup Options:"
    echo "1) Install missing dependencies"
    echo "2) Setup Tauri development environment"
    echo "3) Run system diagnostics"
    echo "4) Clean and rebuild everything"
    echo "5) Return to main menu"
    echo ""
    echo -n "Select option [1-5]: "
    
    read setup_choice
    case $setup_choice in
        1)
            echo ""
            echo "📦 Installing dependencies..."
            if ! command -v node &> /dev/null; then
                echo "Installing Node.js..."
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt-get install -y nodejs
            fi
            if ! command -v cargo &> /dev/null; then
                echo "Installing Rust..."
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                source ~/.cargo/env
            fi
            echo "✅ Dependencies installation complete"
            ;;
        2)
            echo ""
            echo "🔧 Setting up Tauri environment..."
            ./setup-tauri.sh
            ;;
        3)
            echo ""
            echo "🔍 Running diagnostics..."
            ./build.sh test
            ;;
        4)
            echo ""
            echo "🧹 Cleaning and rebuilding..."
            ./build.sh clean
            ./build.sh user
            ;;
        5|*)
            return
            ;;
    esac
    
    echo ""
    read -p "Press any key to return to menu..."
}

# Function to show documentation
show_documentation() {
    echo ""
    echo "📖 Opening Documentation..."
    echo ""
    
    echo "Available documentation:"
    echo "1) User Manual (UCODE-MANUAL.md)"
    echo "2) README (README.md)"
    echo "3) Architecture Guide (ARCHITECTURE.md)"
    echo "4) Quick Start Guide (QUICKSTART.md)"
    echo "5) Return to menu"
    echo ""
    echo -n "Select document [1-5]: "
    
    read doc_choice
    case $doc_choice in
        1)
            if command -v xdg-open &> /dev/null; then
                xdg-open core/docs/UCODE-MANUAL.md
            else
                less core/docs/UCODE-MANUAL.md
            fi
            ;;
        2)
            if command -v xdg-open &> /dev/null; then
                xdg-open README.md
            else
                less README.md
            fi
            ;;
        3)
            if command -v xdg-open &> /dev/null; then
                xdg-open core/docs/ARCHITECTURE.md
            else
                less core/docs/ARCHITECTURE.md
            fi
            ;;
        4)
            if command -v xdg-open &> /dev/null; then
                xdg-open core/docs/QUICKSTART.md
            else
                less core/docs/QUICKSTART.md
            fi
            ;;
        5|*)
            return
            ;;
    esac
    
    echo "📖 Documentation opened"
    echo ""
    read -p "Press any key to return to menu..."
}

# Build and run
echo "🔨 Building uDESK User Mode..."
if ./build.sh user; then
    echo ""
    echo "✅ uDESK Build Complete!"
    echo ""
    
    # Main menu loop
    while true; do
        show_startup_menu
        read choice
        
        case $choice in
            1)
                echo ""
                echo "🚀 Launching Terminal Interface..."
                echo "   Type 'exit' to quit, [HELP] for commands"
                echo ""
                
                if [ -f "./build/user/udos" ]; then
                    ./build/user/udos
                else
                    echo "❌ User mode binary not found after build"
                    read -p "Press any key to return to menu..."
                fi
                ;;
            2)
                launch_desktop_app
                ;;
            3)
                run_setup
                ;;
            4)
                show_documentation
                ;;
            5)
                echo ""
                echo "🔧 Developer Mode - Building developer version..."
                ./build.sh developer
                if [ -f "./build/developer/udos-developer" ]; then
                    ./build/developer/udos-developer
                else
                    echo "❌ Developer binary not found"
                    read -p "Press any key to return to menu..."
                fi
                ;;
            6)
                echo ""
                echo "👋 Goodbye!"
                exit 0
                ;;
            *)
                echo ""
                echo "❌ Invalid option. Please select 1-6."
                echo ""
                read -p "Press any key to continue..."
                ;;
        esac
    done
else
    echo ""
    echo "❌ Build failed! Check error messages above"
    read -p "Press any key to exit..."
    exit 1
fi

echo ""
echo "👋 uDESK session ended"
echo "   Run this script again to restart"
read -p "Press any key to close..."
