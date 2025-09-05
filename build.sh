#!/bin/bash
# uDESK v1.0.7 Build System - Enhanced Interactive Setup

set -e

UDESK_VERSION="1.0.7"
BUILD_MODE=${1:-""}
TARGET_PLATFORM=${2:-$(uname -m)}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration file
UDESK_CONFIG="${HOME}/.udesk/config"
UDESK_DIR="${HOME}/.udesk"

# Create config directory if it doesn't exist
mkdir -p "${UDESK_DIR}"

# ASCII Art Functions
show_udesk_logo() {
    # Polaroid palette colors
    local cyan='\033[96m'      # Bright cyan
    local magenta='\033[95m'   # Bright magenta  
    local yellow='\033[93m'    # Bright yellow
    local green='\033[92m'     # Bright green
    local blue='\033[94m'      # Bright blue
    local red='\033[91m'       # Bright red
    local white='\033[97m'     # Bright white
    local reset='\033[0m'      # Reset color
    
    echo ""
    echo -e "    ${cyan}██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗${reset}"
    echo -e "    ${magenta}██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝${reset}"
    echo -e "    ${yellow}██║   ██║██║  ██║█████╗  ███████╗█████╔╝ ${reset}"
    echo -e "    ${green}██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ ${reset}"
    echo -e "    ${blue}╚██████╔╝██████╔╝███████╗███████║██║  ██╗${reset}"
    echo -e "    ${red} ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝${reset}"
    echo ""
    echo -e "    ${white}Universal Desktop OS${reset}"
    echo -e "    ${cyan}v${UDESK_VERSION}${reset}"
    echo ""
}

show_build_art() {
    local mode=$1
    case "${mode}" in
        "user")
            echo "    👤 USER MODE"
            echo "    ════════════"
            echo "    Standard interface for all roles"
            echo "    GHOST → TOMB → DRONE → CRYPT → IMP → KNIGHT → SORCERER → WIZARD"
            ;;
        "wizard")
            echo "    🧙‍♀️ WIZARD ROLE"
            echo "    ══════════════"
            echo "    Highest user role with extension development"
            echo "    Extension development: Always available"
            echo "    Dev Mode: Core system development (restricted to uDESK/dev)"
            ;;
        "dev")
            echo "    🔧 DEV MODE"
            echo "    ═══════════════"
            echo "    Legacy developer mode (deprecated)"
            echo "    Use wizard role with [DEV-MODE] instead"
            ;;
        "iso")
            echo "    💿 ISO BUILD MODE"
            echo "    ═════════════════"
            echo "    Bootable TinyCore Linux image"
            echo "    Complete standalone system"
            ;;
    esac
    echo ""
}

show_role_art() {
    local role=$1
    case "${role}" in
        "GHOST")
            echo "    👻 GHOST - System Monitor"
            echo "    Basic system information and monitoring"
            ;;
        "TOMB")
            echo "    ⚰️ TOMB - Archive Manager"
            echo "    File management and archive operations"
            ;;
        "DRONE")
            echo "    🤖 DRONE - Automation Assistant"
            echo "    Basic workflow automation and scripting"
            ;;
        "CRYPT")
            echo "    🔐 CRYPT - Security Specialist"
            echo "    Encryption, security tools, and protection"
            ;;
        "IMP")
            echo "    😈 IMP - Script Master"
            echo "    Full scripting environment and tools"
            ;;
        "KNIGHT")
            echo "    ⚔️ KNIGHT - System Administrator"
            echo "    System administration and network tools"
            ;;
        "SORCERER")
            echo "    🔮 SORCERER - Smart Features"
            echo "    Advanced automation and intelligence"
            ;;
        "WIZARD")
            echo "    🧙‍♂️ WIZARD - Highest User Role"
            echo "    Full system control and development"
            ;;
    esac
    echo ""
}

# Default configuration
# Default configuration
load_config() {
    if [ -f "${UDESK_CONFIG}" ]; then
        source "${UDESK_CONFIG}"
    else
        # Set defaults
        UDESK_DEFAULT_ROLE="GHOST"
        UDESK_DEFAULT_MODE="user"
        UDESK_AUTO_LAUNCH="true"
        UDESK_SHOW_TIPS="true"
        UDESK_THEME="default"
        save_config
    fi
}

save_config() {
    cat > "${UDESK_CONFIG}" << EOF
# uDESK v1.0.7 Configuration
UDESK_DEFAULT_ROLE="${UDESK_DEFAULT_ROLE:-GHOST}"
UDESK_DEFAULT_MODE="${UDESK_DEFAULT_MODE:-user}"
UDESK_AUTO_LAUNCH="${UDESK_AUTO_LAUNCH:-true}"
UDESK_SHOW_TIPS="${UDESK_SHOW_TIPS:-true}"
UDESK_THEME="${UDESK_THEME:-default}"
EOF
}

# Setup wizard for first-time users
run_setup_wizard() {
    clear
    show_udesk_logo
    echo "🎯 First-Time Setup Wizard"
    echo "══════════════════════════"
    echo ""
    echo "Welcome to uDESK! Let us configure your preferences."
    echo ""
    
    # Role selection
    echo "� Select your starting role:"
    echo ""
    echo "   1) 👻 GHOST     - Basic system monitoring (recommended for beginners)"
    echo "   2) ⚰️ TOMB      - File management and archives"
    echo "   3) 🤖 DRONE     - Basic workflow automation"
    echo "   4) 🔐 CRYPT     - Security tools and encryption"
    echo "   5) 😈 IMP       - Full scripting environment"
    echo "   6) ⚔️ KNIGHT    - System administration"
    echo "   7) 🔮 SORCERER  - Advanced smart features"
    echo "   8) 🧙‍♂️ WIZARD    - Complete system access"
    echo ""
    read -p "Choose role (1-8) [1]: " role_choice
    
    case ${role_choice:-1} in
        1) UDESK_DEFAULT_ROLE="GHOST" ;;
        2) UDESK_DEFAULT_ROLE="TOMB" ;;
        3) UDESK_DEFAULT_ROLE="DRONE" ;;
        4) UDESK_DEFAULT_ROLE="CRYPT" ;;
        5) UDESK_DEFAULT_ROLE="IMP" ;;
        6) UDESK_DEFAULT_ROLE="KNIGHT" ;;
        7) UDESK_DEFAULT_ROLE="SORCERER" ;;
        8) UDESK_DEFAULT_ROLE="WIZARD" ;;
        *) UDESK_DEFAULT_ROLE="GHOST" ;;
    esac
    
    echo ""
    show_role_art "${UDESK_DEFAULT_ROLE}"
    
    # Mode selection
    echo "🎯 Select your preferred mode:"
    echo ""
    echo "   1) 👤 User Mode      - Standard interface (recommended)"
    echo "   2) 🧙‍♀️ Wizard Role   - Highest user role with extension development"
    echo "   3) 🔧 Dev Mode       - Legacy dev mode (use wizard role instead)"
    echo ""
    read -p "Choose mode (1-3) [1]: " mode_choice
    
    case ${mode_choice:-1} in
        1) UDESK_DEFAULT_MODE="user" ;;
        2) UDESK_DEFAULT_MODE="wizard" ;;
        3) UDESK_DEFAULT_MODE="dev" ;;
        *) UDESK_DEFAULT_MODE="user" ;;
    esac
    
    # Auto-launch preference
    echo ""
    read -p "🚀 Auto-launch uDESK after build? (y/n) [y]: " auto_launch
    case ${auto_launch:-y} in
        [Yy]*) UDESK_AUTO_LAUNCH="true" ;;
        *) UDESK_AUTO_LAUNCH="false" ;;
    esac
    
    # Tips preference
    echo ""
    read -p "💡 Show helpful tips? (y/n) [y]: " show_tips
    case ${show_tips:-y} in
        [Yy]*) UDESK_SHOW_TIPS="true" ;;
        *) UDESK_SHOW_TIPS="false" ;;
    esac
    
    # Theme selection
    echo ""
    echo "🎨 Select interface theme:"
    echo ""
    echo "   1) 🎯 POLAROID   - Clean modern interface (default)"
    echo "   2) 📺 Retro      - Classic terminal styling"
    echo "   3) 🌙 Dark       - Dark mode interface"
    echo "   4) ☀️ Light      - Light mode interface"
    echo ""
    read -p "Choose theme (1-4) [1]: " theme_choice
    
    case ${theme_choice:-1} in
        1) UDESK_THEME="default" ;;
        2) UDESK_THEME="retro" ;;
        3) UDESK_THEME="dark" ;;
        4) UDESK_THEME="light" ;;
        *) UDESK_THEME="default" ;;
    esac
    
    save_config
    
    echo ""
    echo "✅ Setup complete! Configuration saved to: ${UDESK_CONFIG}"
    echo ""
    echo "📋 Your Settings:"
    echo "   Role: ${UDESK_DEFAULT_ROLE}"
    echo "   Mode: ${UDESK_DEFAULT_MODE}"
    echo "   Auto-launch: ${UDESK_AUTO_LAUNCH}"
    echo "   Show tips: ${UDESK_SHOW_TIPS}"
    if [ "${UDESK_THEME}" = "default" ]; then
        echo "   Theme: POLAROID (default)"
    else
        echo "   Theme: ${UDESK_THEME}"
    fi
    echo ""
    read -p "Press Enter to continue..."
}

# Interactive mode selection
interactive_mode_selection() {
    clear
    show_udesk_logo
    echo "� Interactive Mode Selection"
    echo "═════════════════════════════"
    echo ""
    echo "Available build modes:"
    echo ""
    echo "   1) 👤 User Mode      - Standard users (all roles)"
    echo "                         Access: User workspace only"
    echo "                         Commands: [BACKUP], [RESTORE], [INFO], [HELP]"
    echo ""
    echo "   2) 🧙‍♀️ Wizard Role     - Highest user role with extension development"
    echo "                         Extension development: Always available"
    echo "                         Commands: [CREATE-EXT], [BUILD-TCZ], [DEV-MODE]"
    echo ""
    echo "   3) 🔧 Dev Mode        - Legacy developer mode (deprecated)"
    echo "                         Access: Dev workspace only"
    echo "                         Commands: [BUILD-CORE], [BUILD-ISO], [SYSTEM-INFO]"
    echo ""
    echo "   4) 💿 ISO Build      - Bootable TinyCore image"
    echo "   5) 🧪 Test All       - Test all build modes"
    echo "   6) 🧹 Clean          - Clean build artifacts"
    echo "   7) ⚙️ Setup          - Run setup wizard"
    echo "   8) 📋 Config         - Show current configuration"
    echo ""
    
    # Show current config
    load_config
    echo "📋 Current Settings: 👤 Role=${UDESK_DEFAULT_ROLE}, 🎯 Mode=${UDESK_DEFAULT_MODE}, 🎨 Theme=${UDESK_THEME}"
    echo ""
    
    read -p "Select mode (1-8) or press Enter for default [${UDESK_DEFAULT_MODE}]: " choice
    
    case ${choice} in
        1) BUILD_MODE="user" ;;
        2) BUILD_MODE="wizard" ;;
        3) BUILD_MODE="dev" ;;
        4) BUILD_MODE="iso" ;;
        5) BUILD_MODE="test" ;;
        6) BUILD_MODE="clean" ;;
        7) run_setup_wizard; BUILD_MODE="${UDESK_DEFAULT_MODE}" ;;
        8) show_config; interactive_mode_selection; return ;;
        "") BUILD_MODE="${UDESK_DEFAULT_MODE}" ;;
        *) echo "❌ Invalid choice"; sleep 1; interactive_mode_selection; return ;;
    esac
}

# Show current configuration
show_config() {
    clear
    load_config
    show_udesk_logo
    echo "📋 Configuration"
    echo "════════════════"
    echo ""
    echo "Config file: ${UDESK_CONFIG}"
    echo ""
    echo "Settings:"
    echo "   Default Role:    ${UDESK_DEFAULT_ROLE}"
    echo "   Default Mode:    ${UDESK_DEFAULT_MODE}"
    echo "   Auto-launch:     ${UDESK_AUTO_LAUNCH}"
    echo "   Show tips:       ${UDESK_SHOW_TIPS}"
    echo "   Theme:           ${UDESK_THEME}"
    echo ""
    echo "Environment:"
    echo "   Current Role:    ${UDESK_ROLE:-${UDESK_DEFAULT_ROLE}}"
    echo "   Current Mode:    ${UDESK_MODE:-user}"
    echo "   Platform:        $(uname -s) $(uname -m)"
    echo "   Home:            ${HOME}"
    echo "   Project:         ${PROJECT_ROOT}"
    echo ""
    show_role_art "${UDESK_DEFAULT_ROLE}"
    read -p "Press Enter to continue..."
}

# Apply theme
apply_theme() {
    case "${UDESK_THEME}" in
        "retro")
            export UDESK_PS1="[uDESK:${UDESK_ROLE:-GHOST}]$ "
            export UDESK_COLORS="retro"
            ;;
        "dark")
            export UDESK_PS1="🌙 uDESK> "
            export UDESK_COLORS="dark"
            ;;
        "light")
            export UDESK_PS1="☀️ uDESK> "
            export UDESK_COLORS="light"
            ;;
        *)
            export UDESK_PS1="uDESK> "
            export UDESK_COLORS="default"
            ;;
    esac
}

# Show helpful tips
show_tips() {
    if [ "${UDESK_SHOW_TIPS}" = "true" ]; then
        echo ""
        echo "💡 Tips for uDESK v1.0.7:"
        case "${BUILD_MODE}" in
            "user")
                echo "   • Type [HELP] to see all available commands"
                echo "   • Use [BACKUP] to save your work regularly"
                echo "   • Progress through roles: GHOST → TOMB → DRONE → CRYPT → IMP → KNIGHT → SORCERER → WIZARD"
                echo "   • Configuration saved in .udesk/config"
                echo "   • Repository synced automatically in uDESK/repository/"
                echo "   • Workspace available in uMEMORY/"
                ;;
            "wizard")
                echo "   • Extension development always available in user workspace"
                echo "   • Use [DEV-MODE] for core development (from uDESK/dev only)"
                echo "   • Type [CREATE-EXT] to build your own extensions"
                echo "   • Share your extensions with the community"
                echo "   • WIZARD role with flexible capabilities"
                echo "   • User workspace: uDESK/uMEMORY/sandbox/"
                echo "   • Dev workspace: uDESK/dev/"
                ;;
            "dev")
                echo "   • Legacy developer mode (deprecated)"
                echo "   • Use wizard role with [DEV-MODE] instead"
                echo "   • Limited to dev workspace: uDESK/dev/"
                echo "   • Use [BUILD-CORE] to compile system components"
                ;;
        esac
        echo ""
    fi
}

# Show launch options after build
show_launch_options() {
    echo ""
    echo "🚀 Launch Options:"
    
    # Core build launch
    case "${BUILD_MODE}" in
        "user")
            echo "   Terminal:      ./build/user/udos"
            echo "   Test:          echo \"HELP\" | ./build/user/udos"
            ;;
        "wizard")
            echo "   Terminal:      ./build/wizard/udos-wizard"
            echo "   Test:          echo \"[HELP]\" | ./build/wizard/udos-wizard"
            ;;
        "dev")
            echo "   Terminal:      ./dev/udos-dev"
            echo "   Test:          echo \"[HELP]\" | ./dev/udos-dev"
            ;;
        "iso")
            echo "   ISO Ready:     build/iso/udesk.tcz"
            echo "   TinyCore:      Load udesk.tcz in TinyCore Linux"
            ;;
        "iso")
            echo "   ISO Ready:     build/iso/udesk.tcz"
            echo "   TinyCore:      Load udesk.tcz in TinyCore Linux"
            ;;
    esac
    
    # Tauri desktop app option
    if [ -d "app" ]; then
        echo ""
        echo "📱 Desktop App (Tauri):"
        if [ -f "app/package.json" ]; then
            echo "   Development:   cd app && npm run tauri dev"
            echo "   Production:    cd app && npm run tauri build"
            echo "   Setup Guide:   ./setup-tauri.sh"
        else
            echo "   Setup Script:  ./setup-tauri.sh"
            echo "   Manual Setup:  cd app && npm install"
        fi
    fi
    
    # TinyCore integration option
    if [ -f "system/tinycore/build-tcz.sh" ] || [ "${BUILD_MODE}" = "iso" ]; then
        echo ""
        echo "💿 TinyCore Integration:"
        if [ "${BUILD_MODE}" = "iso" ]; then
            echo "   Ready:         build/iso/cde/optional/udesk.tcz"
            echo "   Install:       tce-load -i udesk.tcz"
        else
            echo "   Setup Script:  ./setup-tinycore.sh"
            echo "   Build TCZ:     cd system/tinycore && ./build-tcz.sh"
            echo "   Full ISO:      ./build.sh iso"
        fi
        echo "   VM Guide:      ./setup-tinycore.sh (option 5)"
        echo "   Docker Build:  ./setup-tinycore.sh (option 1)"
    fi
    
    # Interactive setup option
    echo ""
    echo "⚙️  Setup Scripts:"
    echo "   Tauri App:     ./setup-tauri.sh"
    echo "   TinyCore:      ./setup-tinycore.sh"
    echo "   Platform:      ./uDESK-macOS.sh (or ./uDESK-Ubuntu.sh)"
    echo "   Configuration: ./build.sh setup"
    echo "   All modes:     ./build.sh test"
    
    # Quick actions
    echo ""
    echo "⚡ Quick Actions:"
    echo "   Next build:    ./build.sh [user|wizard|developer|iso]"
    echo "   Clean:         ./build.sh clean"
    echo "   Help:          ./build.sh --help"
}

# Main execution starts here
load_config

# Check if this is first run
if [ ! -f "${UDESK_CONFIG}" ]; then
    run_setup_wizard
fi

# If no mode specified, show interactive selection
if [ -z "${BUILD_MODE}" ]; then
    interactive_mode_selection
fi

# Set environment variables
export UDESK_ROLE="${UDESK_ROLE:-${UDESK_DEFAULT_ROLE}}"
export UDESK_MODE="${BUILD_MODE}"
apply_theme

clear
show_udesk_logo
echo "🔨 Build System"
echo "═══════════════"
echo "📁 Project: ${PROJECT_ROOT}"
echo "🏗️  Platform: ${TARGET_PLATFORM}"
echo "👤 Role: ${UDESK_ROLE}"
if [ "${UDESK_THEME}" = "default" ]; then
    echo "🎨 Theme: POLAROID (default)"
else
    echo "🎨 Theme: ${UDESK_THEME}"
fi
echo ""

show_build_art "${BUILD_MODE}"
detect_build_env() {
    if [ -f /opt/bootlocal.sh ]; then
        echo "tinycore"
    elif command -v docker &> /dev/null && [ -f Dockerfile.dev ]; then
        echo "container"
    elif command -v gcc &> /dev/null; then
        echo "host"
    else
        echo "minimal"
    fi
}

BUILD_ENV=$(detect_build_env)
# Load configuration
load_config

# Show startup sequence
show_udesk_logo
show_build_art

# Interactive mode if no arguments provided or if --interactive flag
if [ -z "$BUILD_MODE" ] || [ "$1" = "--interactive" ] || [ "$1" = "-i" ]; then
    run_setup_wizard
    interactive_mode_selection
    
    # Get user selection
    echo ""
    read -p "Enter selection: " selection
    
    case $selection in
        1) BUILD_MODE="user" ;;
        2) BUILD_MODE="wizard" ;;
        3) BUILD_MODE="developer" ;;
        4) BUILD_MODE="iso" ;;
        5) BUILD_MODE="test" ;;
        6) BUILD_MODE="clean" ;;
        c|config) show_config; exit 0 ;;
        q|quit|exit) echo "👋 Goodbye!"; exit 0 ;;
        *) echo "❌ Invalid selection"; exit 1 ;;
    esac
    
    echo ""
    echo "✅ Selected: $BUILD_MODE"
    echo ""
fi

# Create workspace and directory structure
setup_workspace() {
    local workspace_dir="uMEMORY"
    local config_dir=".udesk"
    local home_dir="${HOME}/uDESK"
    local memory_dir="${HOME}/uDESK/uMEMORY"
    local repo_url="https://github.com/fredporter/uDESK.git"
    local repo_dir="${home_dir}/repository"
    
    echo "📁 Setting up uDESK workspace..."
    
    # Create ~/uDESK/ home directory structure
    if [ ! -d "${home_dir}" ]; then
        mkdir -p "${home_dir}"/{workspace,projects,docs,scripts}
        echo "✅ Created uDESK/ home directory structure"
        
        # Clone repository on first setup
        echo "🔄 Cloning uDESK repository for first-time setup..."
        if command -v git >/dev/null 2>&1; then
            cd "${home_dir}"
            if git clone "${repo_url}" repository 2>/dev/null; then
                echo "✅ Successfully cloned uDESK repository to uDESK/repository"
                # Copy key files from repository to main directory
                if [ -d "${repo_dir}" ]; then
                    cp -r "${repo_dir}/docs" "${home_dir}/" 2>/dev/null || true
                    cp "${repo_dir}/README.md" "${home_dir}/" 2>/dev/null || true
                    cp "${repo_dir}/LICENSE" "${home_dir}/" 2>/dev/null || true
                    echo "📋 Copied documentation and key files"
                fi
            else
                echo "⚠️  Could not clone repository (offline or access issue)"
            fi
            cd - >/dev/null
        else
            echo "⚠️  Git not available - repository sync skipped"
        fi
    else
        # Update existing repository if git is available
        if [ -d "${repo_dir}/.git" ] && command -v git >/dev/null 2>&1; then
            echo "🔄 Updating uDESK repository..."
            cd "${repo_dir}"
            if git pull origin main >/dev/null 2>&1; then
                echo "✅ Repository updated to latest version"
                # Update docs if they exist
                if [ -d "${repo_dir}/docs" ]; then
                    cp -r "${repo_dir}/docs" "${home_dir}/" 2>/dev/null || true
                    echo "📋 Updated documentation"
                fi
            else
                echo "⚠️  Could not update repository (offline or conflicts)"
            fi
            cd - >/dev/null
        fi
    fi
    
    # Create ~/uMEMORY/ workspace directory (separate from installation)
    if [ ! -d "${memory_dir}" ]; then
        mkdir -p "${memory_dir}"/{projects,docs,extensions,backups,restore}
        echo "✅ Created uMEMORY/ workspace structure"
        
        # Create restore function template
        cat > "${memory_dir}/restore/README.md" << 'EOF'
# uDESK Restore & Repair Functions

This directory contains restore and repair utilities for uDESK.

## Available Functions

### Restore Repository
- Repairs corrupted git repository
- Downloads fresh copy if needed
- Preserves user data

### Restore Workspace  
- Recreates uMEMORY/ structure
- Restores default configuration
- Maintains project integrity

### System Repair
- Validates installation paths
- Fixes permission issues
- Rebuilds core components

## Usage

Run from uDESK build system:
```bash
./build.sh user
# Then use [RESTORE] command
```

## Location

Repository: uDESK/repository/
Workspace: uMEMORY/
Config: .udesk/
EOF
        echo "📋 Created restore function templates"
    fi
    
    # Create config directory  
    if [ ! -d "${HOME}/${config_dir}" ]; then
        mkdir -p "${HOME}/${config_dir}"/{backups,themes,extensions}
        echo "✅ Created .udesk configuration directory"
    fi
    
    # Create build directories
    mkdir -p build/{user,wizard,developer,iso}
    mkdir -p src/{user,wizard,developer,shared}
}

# Apply theme settings
apply_theme

echo "🔍 Build environment: ${BUILD_ENV}"

# Set up workspace and directories
setup_workspace

case $BUILD_MODE in
    "user")
        echo "👤 USER MODE BUILD"
        echo "   Target: Standard users (all roles)"
        echo "   Access: User workspace only"
        
        mkdir -p build/user
        
        # Create user mode uCODE interpreter with theme support
        cat > "build/user/udos.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

void show_welcome_art() {
    const char* theme = getenv("UDESK_COLORS");
    const char* role = getenv("UDESK_ROLE");
    
    printf("\n");
    if (theme && strcmp(theme, "retro") == 0) {
        printf("    ┌─────────────────────────────────────┐\n");
        printf("    │         uDESK v1.0.7 USER          │\n");
        printf("    │    Universal Desktop OS             │\n");
        printf("    └─────────────────────────────────────┘\n");
    } else {
        // Polaroid palette colors
        printf("    \033[96m██╗   ██╗██████╗ ███████╗███████╗██╗  ██╗\033[0m\n");
        printf("    \033[95m██║   ██║██╔══██╗██╔════╝██╔════╝██║ ██╔╝\033[0m\n");
        printf("    \033[93m██║   ██║██║  ██║█████╗  ███████╗█████╔╝ \033[0m\n");
        printf("    \033[92m██║   ██║██║  ██║██╔══╝  ╚════██║██╔═██╗ \033[0m\n");
        printf("    \033[94m╚██████╔╝██████╔╝███████╗███████║██║  ██╗\033[0m\n");
        printf("    \033[91m ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝\033[0m\n");
        printf("            \033[97mUSER MODE v1.0.7\033[0m\n");
    }
    
    if (role) {
        if (strcmp(role, "GHOST") == 0) {
            printf("    👻 GHOST - System Monitor\n");
        } else if (strcmp(role, "TOMB") == 0) {
            printf("    ⚰️ TOMB - Archive Manager\n");
        } else if (strcmp(role, "DRONE") == 0) {
            printf("    🤖 DRONE - Automation Assistant\n");
        } else if (strcmp(role, "CRYPT") == 0) {
            printf("    🔐 CRYPT - Security Specialist\n");
        } else if (strcmp(role, "IMP") == 0) {
            printf("    😈 IMP - Script Master\n");
        } else if (strcmp(role, "KNIGHT") == 0) {
            printf("    ⚔️ KNIGHT - System Administrator\n");
        } else if (strcmp(role, "SORCERER") == 0) {
            printf("    🔮 SORCERER - Smart Features\n");
        } else if (strcmp(role, "WIZARD") == 0) {
            printf("    🧙‍♂️ WIZARD - Complete Access\n");
        }
    }
    printf("\n");
}

const char* get_prompt() {
    const char* theme = getenv("UDESK_COLORS");
    const char* ps1 = getenv("UDESK_PS1");
    if (ps1) return ps1;
    
    if (theme && strcmp(theme, "retro") == 0) {
        return "[uDESK:USER]$ ";
    } else if (theme && strcmp(theme, "dark") == 0) {
        return "🌙 uDESK> ";
    } else if (theme && strcmp(theme, "light") == 0) {
        return "☀️ uDESK> ";
    }
    return "uDESK> ";
}

int validate_user_path(const char* path) {
    char* home = getenv("HOME");
    if (home && strncmp(path, home, strlen(home)) == 0) return 1;
    if (strncmp(path, "/workspace/user/", 16) == 0) return 1;
    printf("❌ Access denied: %s (user workspace only)\n", path);
    return 0;
}

int execute_user_ucode(const char* command) {
    // Convert input to uppercase for processing  
    char upper_cmd[256];
    char original_cmd[256];
    strncpy(original_cmd, command, 255);
    original_cmd[255] = '\0';
    
    // Handle both [COMMAND] shortcode and direct command formats
    const char* clean_cmd = command;
    if (command[0] == '[' && command[strlen(command)-1] == ']') {
        // Remove brackets for shortcode format
        strncpy(upper_cmd, command + 1, strlen(command) - 2);
        upper_cmd[strlen(command) - 2] = '\0';
        clean_cmd = upper_cmd;
    } else {
        strncpy(upper_cmd, command, 255);
        upper_cmd[255] = '\0';
        clean_cmd = upper_cmd;
    }
    
    // Convert to uppercase for consistent processing
    for (int i = 0; clean_cmd[i] && i < 255; i++) {
        upper_cmd[i] = toupper(clean_cmd[i]);
    }
    upper_cmd[strlen(clean_cmd)] = '\0';
    
    if (strncmp(upper_cmd, "BACKUP", 6) == 0) {
        printf("📦 Creating user backup...\n");
        system("mkdir -p ~/uDESK/uMEMORY/.local/backups && tar -czf ~/uDESK/uMEMORY/.local/backups/user-$(date +%Y%m%d-%H%M).tar.gz ~/uDESK/uMEMORY/sandbox/ ~/uDESK/uMEMORY/projects/ 2>/dev/null");
        printf("✅ Backup saved to uDESK/uMEMORY/.local/backups/\n");
        return 0;
    }
    if (strncmp(upper_cmd, "RESTORE", 7) == 0) {
        printf("📥 Available backups:\n");
        system("ls -la ~/uDESK/uMEMORY/.local/backups/user-*.tar.gz 2>/dev/null | head -5 || echo '   No backups found'");
        printf("💡 To restore: tar -xzf uDESK/uMEMORY/.local/backups/user-YYYYMMDD-HHMM.tar.gz -C uDESK/\n");
        return 0;
    }
    if (strncmp(upper_cmd, "INFO", 4) == 0) {
        printf("ℹ️  uDESK v1.0.7 - User Mode\n");
        printf("   Role: %s\n", getenv("UDESK_ROLE") ?: "GHOST");
        
        const char* theme = getenv("UDESK_COLORS") ?: "default";
        if (strcmp(theme, "default") == 0) {
            printf("   Theme: POLAROID (default)\n");
        } else {
            printf("   Theme: %s\n", theme);
        }
        
        printf("   Workspace: uMEMORY/\n");
        printf("   Config: .udesk/\n");
        printf("   Home: uDESK/\n");
        printf("   Platform: %s\n", getenv("UDESK_MODE") ?: "user");
        return 0;
    }
    if (strncmp(upper_cmd, "HELP", 4) == 0) {
        printf("📖 uDESK v1.0.7 User Commands\n\n");
        printf("USER uCODE COMMANDS:\n");
        printf("  BACKUP   - Backup your files and config\n");
        printf("  RESTORE  - Show available backups\n");
        printf("  INFO     - System information\n");
        printf("  HELP     - This help\n\n");
        printf("ROLE PROGRESSION:\n");
        printf("  👻 GHOST → ⚰️ TOMB → 🤖 DRONE → 🔐 CRYPT → 😈 IMP → ⚔️ KNIGHT → 🔮 SORCERER → 🧙‍♂️ WIZARD\n\n");
        printf("SHELL COMMANDS:\n");
        printf("  EXIT, QUIT - Leave uDESK\n");
        printf("  CONFIG     - Show configuration\n");
        printf("  ROLE       - Show role information\n");
        printf("  THEME      - Show theme settings\n");
        return 0;
    }
    if (strncmp(upper_cmd, "CONFIG", 6) == 0) {
        printf("📋 Configuration:\n");
        system("cat ~/uDESK/uMEMORY/config/udesk.conf 2>/dev/null || echo '   No config file found'");
        return 0;
    }
    if (strncmp(upper_cmd, "ROLE", 4) == 0) {
        const char* role = getenv("UDESK_ROLE") ?: "GHOST";
        printf("👤 Current role: %s\n", role);
        if (strcmp(role, "GHOST") == 0) {
            printf("   👻 GHOST - Basic system monitoring\n");
            printf("   Next: ⚰️ TOMB (Archive management)\n");
        } else if (strcmp(role, "WIZARD") == 0) {
            printf("   🧙‍♂️ WIZARD - Complete system access\n");
            printf("   💡 Try: ./build.sh wizard\n");
        }
        return 0;
    }
    if (strncmp(upper_cmd, "THEME", 5) == 0) {
        const char* theme = getenv("UDESK_COLORS") ?: "default";
        if (strcmp(theme, "default") == 0) {
            printf("🎨 Theme: POLAROID (default)\n");
        } else {
            printf("🎨 Theme: %s\n", theme);
        }
        printf("   Prompt: %s\n", get_prompt());
        printf("   Available: POLAROID (default), retro, dark, light\n");
        return 0;
    }
    
    printf("❌ Unknown command: %s\n", original_cmd);
    printf("   Use HELP for available commands\n");
    return 1;
}

int main(int argc, char *argv[]) {
    const char* role = getenv("UDESK_ROLE") ?: "GHOST";
    const char* theme = getenv("UDESK_COLORS") ?: "default";
    
    show_welcome_art();
    
    // Display theme in POLAROID format if default
    if (strcmp(theme, "default") == 0) {
        printf("Role: %s | Theme: POLAROID (default)\n", role);
    } else {
        printf("Role: %s | Theme: %s\n", role, theme);
    }
    
    printf("Commands: BACKUP, RESTORE, INFO, HELP, CONFIG, EXIT\n");
    printf("Format: Direct commands or [SHORTCODE] syntax\n\n");
    
    char input[256];
    while (1) {
        printf("%s", get_prompt());
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
            strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
            printf("👋 Goodbye! Thanks for using uDESK v1.0.7\n");
            break;
        }
        
        execute_user_ucode(input);
    }
    return 0;
}
EOF
        
        gcc -o "build/user/udos" "build/user/udos.c"
        echo "✅ User mode build complete"
        echo "🚀 Run: ./build/user/udos"
        ;;
        
    "wizard")
        echo "🧙‍♀️ WIZARD ROLE BUILD"
        echo "   Target: WIZARD role users"
        echo "   Extension development: Always available"
        
        mkdir -p build/wizard
        
        # Copy existing unified wizard and core header
        cp dev/udos-wizard.c build/wizard/
        cp dev/udos-core.h build/wizard/
        
        # Compile wizard
        gcc -o "build/wizard/udos-wizard" "build/wizard/udos-wizard.c"
        echo "✅ Wizard role build complete"
        echo "🧙‍♀️ Run: UDESK_ROLE=WIZARD ./build/wizard/udos-wizard"
        ;;
        
    "developer")
        echo "🔧 DEVELOPER MODE BUILD"
        echo "   Target: uDESK core developers"
        echo "   Access: Full system modification"
        
        mkdir -p build/developer
        
        # Create developer mode shell
        cat > "build/developer/udos-developer.c" << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int execute_developer_ucode(const char* command) {
    if (strncmp(command, "[BUILD-CORE]", 12) == 0) {
        printf("🔧 Building uDESK core system...\n");
        system("./build.sh user && ./build.sh wizard");
        printf("   Core system build complete\n");
        return 0;
    }
    
    if (strncmp(command, "[BUILD-ISO]", 11) == 0) {
        printf("💿 Building TinyCore ISO...\n");
        system("./build.sh iso");
        return 0;
    }
    
    if (strncmp(command, "[SYSTEM-INFO]", 13) == 0) {
        printf("🔧 uDESK Developer System Information\n");
        printf("   Version: 1.0.7\n");
        printf("   Build Environment: %s\n", getenv("BUILD_ENV") ?: "host");
        printf("   Developer Access: FULL\n");
        system("ls -la build/");
        return 0;
    }
    
    if (strncmp(command, "[HELP]", 6) == 0) {
        printf("📖 uDESK v1.0.7 Developer Commands\n\n");
        printf("DEVELOPER COMMANDS:\n");
        printf("  [BUILD-CORE]   - Build all core components\n");
        printf("  [BUILD-ISO]    - Build TinyCore ISO\n");
        printf("  [SYSTEM-INFO]  - Developer system information\n");
        printf("  [HELP]         - This help\n\n");
        printf("🔧 Full system access enabled\n");
        return 0;
    }
    
    printf("❌ Unknown developer command: %s\n", command);
    return 1;
}

int main(int argc, char *argv[]) {
    printf("🔧 uDESK v1.0.7 - Developer Mode\n");
    printf("⚠️  WARNING: Full system access enabled\n");
    printf("Commands: [BUILD-CORE], [BUILD-ISO], [SYSTEM-INFO], [HELP], EXIT\n\n");
    
    char input[256];
    while (1) {
        printf("Dev> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        
        input[strcspn(input, "\n")] = 0;
        
        if (strcmp(input, "exit") == 0 || strcmp(input, "quit") == 0 || 
            strcmp(input, "EXIT") == 0 || strcmp(input, "QUIT") == 0) {
            printf("Developer session ended\n");
            break;
        }
        
        execute_developer_ucode(input);
    }
    return 0;
}
EOF
        
        gcc -o "build/developer/udos-developer" "build/developer/udos-developer.c"
        echo "✅ Developer mode build complete"
        echo "🔧 Run: ./build/developer/udos-developer"
        ;;
        
    "iso")
        echo "💿 ISO BUILD"
        if [ "$BUILD_ENV" = "tinycore" ]; then
            echo "🔥 Building TinyCore ISO with uDESK..."
            
            # Create ISO workspace
            mkdir -p build/iso/boot
            mkdir -p build/iso/cde/optional
            
            # Build user components first
            ./build.sh user
            ./build.sh wizard-plus
            
            # Create TCZ package
            mkdir -p build/iso/tcz/usr/local/bin
            cp build/user/udos build/iso/tcz/usr/local/bin/
            cp build/wizard-plus/udos-wizard-plus build/iso/tcz/usr/local/bin/
            
            cd build/iso/tcz
            find . -type f | sort > ../udesk.tcz.list
            tar -czf ../cde/optional/udesk.tcz *
            cd ../../..
            
            echo "✅ ISO components ready in build/iso/"
        else
            echo "❌ ISO build requires TinyCore environment"
            echo "   Use: docker run -v \$(pwd):/workspace tinycore/tinycore ./build.sh iso"
        fi
        ;;
        
    "test")
        echo "🧪 TESTING BUILDS"
        
        echo "Testing User Mode..."
        if [ -f "build/user/udos" ]; then
            echo "[INFO]" | ./build/user/udos
        fi
        
        echo "Testing Wizard+ Mode..."
        if [ -f "build/wizard-plus/udos-wizard-plus" ]; then
            echo "[PLUS-STATUS]" | UDESK_ROLE=WIZARD ./build/wizard-plus/udos-wizard-plus
        fi
        
        echo "Testing Developer Mode..."
        if [ -f "build/developer/udos-developer" ]; then
            echo "[SYSTEM-INFO]" | ./build/developer/udos-developer
        fi
        ;;
        
    "clean")
        echo "🧹 Cleaning build artifacts..."
        rm -rf build/*
        echo "✅ Clean complete"
        ;;
        
    *)
        echo "❌ Unknown build mode: $BUILD_MODE"
        echo ""
        echo "Usage: $0 MODE [PLATFORM]"
        echo ""
        echo "Build modes:"
        echo "  user        - User mode (standard users)"
        echo "  wizard      - Wizard role (highest user role with extension development)"
        echo "  developer   - Developer mode (core developers)"
        echo "  iso         - Bootable ISO image"
        echo "  test        - Test all builds"
        echo "  clean       - Clean build artifacts"
        echo ""
        echo "Examples:"
        echo "  $0 user              # User mode build"
        echo "  $0 wizard            # Wizard role build"
        echo "  $0 developer         # Developer mode build"
        exit 1
        ;;
esac

echo ""
echo "🎉 Build complete!"
echo "📁 Artifacts in: build/${BUILD_MODE}/"

# Show launch options
show_launch_options

# Show completion tips
show_tips

# Save current configuration
save_config
