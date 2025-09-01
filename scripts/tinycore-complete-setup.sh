#!/bin/bash
# Complete TinyCore Setup Script for uDESK + Claude Code
# Run this inside TinyCore VM terminal for full automated setup
# 
# Usage: ./tinycore-complete-setup.sh [options]
# Options:
#   --offline       Skip network-dependent installs
#   --no-claude     Skip Claude Code installation
#   --help          Show this help

set -e

# Configuration
SCRIPT_VERSION="1.0.0"
UDESK_VERSION="1.0.6"
CLAUDE_URL="https://github.com/anthropics/claude-code/releases/latest/download/claude-code-linux-x64.tar.gz"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Parse command line arguments
OFFLINE=false
NO_CLAUDE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --offline)
            OFFLINE=true
            shift
            ;;
        --no-claude)
            NO_CLAUDE=true
            shift
            ;;
        --help)
            echo "TinyCore Complete Setup for uDESK v$SCRIPT_VERSION"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --offline       Skip network-dependent installs"
            echo "  --no-claude     Skip Claude Code installation"
            echo "  --help          Show this help"
            echo ""
            echo "This script will:"
            echo "  1. Install uDESK core system"
            echo "  2. Set up development tools"
            echo "  3. Install Claude Code AI assistant"
            echo "  4. Configure persistence"
            echo "  5. Create development environment"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

print_step() {
    echo -e "${PURPLE}→ $1${NC}"
}

# Check if we're running in TinyCore
check_tinycore() {
    if ! command -v tce-load >/dev/null 2>&1; then
        print_error "This script must run inside TinyCore Linux"
        print_info "Boot TinyCore first, then run this script"
        exit 1
    fi
    
    print_success "Running in TinyCore Linux"
}

# Check network connectivity
check_network() {
    if [ "$OFFLINE" = true ]; then
        print_warning "Offline mode - skipping network checks"
        return 0
    fi
    
    print_step "Checking network connectivity..."
    
    if ping -c 1 -W 5 google.com >/dev/null 2>&1; then
        print_success "Network connectivity verified"
        return 0
    else
        print_warning "No network connectivity"
        print_info "Trying to enable networking..."
        
        # Try to enable networking
        if command -v dhcp.sh >/dev/null 2>&1; then
            sudo dhcp.sh
            sleep 3
            
            if ping -c 1 -W 5 google.com >/dev/null 2>&1; then
                print_success "Network enabled successfully"
                return 0
            fi
        fi
        
        print_warning "Could not establish network connection"
        print_info "Some features will be limited"
        NO_CLAUDE=true
        return 1
    fi
}

# Find uDESK packages
find_udesk_packages() {
    print_step "Locating uDESK packages..."
    
    # Common locations for packages
    local locations=(
        "/mnt/sdb1"      # USB/shared folder
        "/mnt/hdb1"      # Alternative mount
        "/tmp"           # Dragged files
        "/home/tc"       # Downloaded files
        "."              # Current directory
    )
    
    for location in "${locations[@]}"; do
        if [ -f "$location/udos-core.tcz" ]; then
            PKG_DIR="$location"
            print_success "Found uDESK packages in: $PKG_DIR"
            return 0
        fi
    done
    
    print_error "uDESK packages not found!"
    print_info "Please ensure .tcz files are available in one of these locations:"
    for location in "${locations[@]}"; do
        echo "  - $location"
    done
    print_info "Or drag the package files into the VM"
    exit 1
}

# Set up persistence
setup_persistence() {
    print_step "Setting up TCE persistence..."
    
    if [ ! -d "/mnt/sda1/tce" ]; then
        sudo mkdir -p /mnt/sda1/tce/{optional,ondemand}
        sudo chmod 775 /mnt/sda1/tce
        print_success "TCE persistence directories created"
    else
        print_success "TCE persistence already configured"
    fi
}

# Install uDESK packages
install_udesk() {
    print_step "Installing uDESK core system..."
    
    # Install core package
    print_info "Loading udos-core..."
    tce-load -i "$PKG_DIR/udos-core.tcz"
    
    # Install admin role (default)
    print_info "Loading udos-role-admin..."
    tce-load -i "$PKG_DIR/udos-role-admin.tcz"
    
    # Test installation
    if command -v udos-info >/dev/null 2>&1; then
        print_success "uDESK core installed successfully!"
        
        # Show system info
        print_header "uDESK System Information"
        udos-info
        echo ""
        
        # Show current role
        if command -v udos-detect-role >/dev/null 2>&1; then
            print_info "Current role: $(udos-detect-role)"
        fi
    else
        print_error "uDESK installation failed"
        exit 1
    fi
}

# Make uDESK persistent
make_persistent() {
    print_step "Making uDESK installation persistent..."
    
    # Copy packages to persistent storage
    sudo cp "$PKG_DIR"/*.tcz /mnt/sda1/tce/optional/
    
    # Add to onboot list
    if ! grep -q "udos-core.tcz" /mnt/sda1/tce/onboot.lst 2>/dev/null; then
        echo "udos-core.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null
    fi
    
    if ! grep -q "udos-role-admin.tcz" /mnt/sda1/tce/onboot.lst 2>/dev/null; then
        echo "udos-role-admin.tcz" | sudo tee -a /mnt/sda1/tce/onboot.lst >/dev/null
    fi
    
    print_success "uDESK will load automatically on boot"
}

# Install development tools
install_dev_tools() {
    if [ "$OFFLINE" = true ]; then
        print_warning "Offline mode - skipping development tools"
        return 0
    fi
    
    print_step "Installing development tools..."
    
    # Essential tools for development
    local tools=(
        "micro.tcz"      # Text editor
        "git.tcz"        # Version control
        "curl.tcz"       # Download tool
        "wget.tcz"       # Alternative download
    )
    
    for tool in "${tools[@]}"; do
        print_info "Installing $tool..."
        if tce-load -wi "$tool" 2>/dev/null; then
            print_success "$tool installed"
        else
            print_warning "Could not install $tool (may not be available)"
        fi
    done
}

# Install Claude Code
install_claude_code() {
    if [ "$NO_CLAUDE" = true ]; then
        print_warning "Skipping Claude Code installation"
        return 0
    fi
    
    if [ "$OFFLINE" = true ]; then
        print_warning "Offline mode - skipping Claude Code"
        return 0
    fi
    
    print_step "Installing Claude Code AI assistant..."
    
    # Create installation directories
    local install_dir="/opt/claude-code"
    local bin_dir="/usr/local/bin"
    
    sudo mkdir -p "$install_dir"
    sudo mkdir -p "$bin_dir"
    
    # Download and install
    print_info "Downloading Claude Code..."
    cd /tmp
    
    if command -v wget >/dev/null 2>&1; then
        wget -O claude-code.tar.gz "$CLAUDE_URL" || {
            print_warning "wget failed, trying curl..."
            curl -L -o claude-code.tar.gz "$CLAUDE_URL" || {
                print_error "Could not download Claude Code"
                return 1
            }
        }
    elif command -v curl >/dev/null 2>&1; then
        curl -L -o claude-code.tar.gz "$CLAUDE_URL" || {
            print_error "Could not download Claude Code"
            return 1
        }
    else
        print_error "No download tool available"
        return 1
    fi
    
    print_info "Extracting Claude Code..."
    tar -xzf claude-code.tar.gz
    
    print_info "Installing Claude Code..."
    sudo mv claude-code "$install_dir/"
    sudo chmod +x "$install_dir/claude-code"
    
    # Create symlinks
    sudo ln -sf "$install_dir/claude-code" "$bin_dir/claude-code"
    sudo ln -sf "$install_dir/claude-code" "$bin_dir/claude"
    
    # Make persistent
    echo "usr/local/bin/claude-code" >> /opt/.filetool.lst 2>/dev/null || true
    echo "opt/claude-code" >> /opt/.filetool.lst 2>/dev/null || true
    
    # Test installation
    if command -v claude-code >/dev/null 2>&1; then
        print_success "Claude Code installed successfully!"
        
        # Try to get version
        print_info "Testing Claude Code..."
        claude-code --version 2>/dev/null || print_info "Claude Code ready (version check requires authentication)"
    else
        print_error "Claude Code installation failed"
        return 1
    fi
    
    # Clean up
    rm -f /tmp/claude-code.tar.gz
}

# Create development shortcuts
create_shortcuts() {
    print_step "Creating development shortcuts..."
    
    # Create quick-start script
    cat > /home/tc/udesk-dev.sh << 'DEV_EOF'
#!/bin/bash
# uDESK Development Quick Start

echo "🚀 uDESK Development Environment"
echo "================================"
echo ""
echo "System Status:"
udos-info 2>/dev/null || echo "uDESK: Not loaded"
echo "Role: $(udos-detect-role 2>/dev/null || echo 'Unknown')"
echo ""
echo "Available Commands:"
echo "  udos-info           - System information"
echo "  udos-detect-role    - Current role"
echo "  udos-service list   - Available services"
echo ""
if command -v claude-code >/dev/null 2>&1; then
    echo "  claude-code         - Start Claude Code AI"
    echo "  claude              - Short alias for Claude Code"
    echo ""
fi
echo "Development Tools:"
command -v micro >/dev/null 2>&1 && echo "  micro <file>        - Text editor"
command -v git >/dev/null 2>&1 && echo "  git                 - Version control"
echo ""
echo "Getting Started:"
echo "  1. Create a project: mkdir my-project && cd my-project"
echo "  2. Start coding: micro README.md"
if command -v claude-code >/dev/null 2>&1; then
    echo "  3. Get AI help: claude-code"
fi
echo ""
echo "Everything in uDESK is markdown! 📝"
DEV_EOF

    chmod +x /home/tc/udesk-dev.sh
    
    # Add to profile for auto-run
    if ! grep -q "udesk-dev.sh" /home/tc/.profile 2>/dev/null; then
        echo "" >> /home/tc/.profile
        echo "# Show uDESK development info on login" >> /home/tc/.profile
        echo "/home/tc/udesk-dev.sh" >> /home/tc/.profile
    fi
    
    print_success "Development environment configured"
}

# Create desktop shortcuts if X is running
create_desktop_shortcuts() {
    if [ -n "$DISPLAY" ] && [ -d "/home/tc/Desktop" ]; then
        print_step "Creating desktop shortcuts..."
        
        # Claude Code shortcut
        if command -v claude-code >/dev/null 2>&1; then
            cat > /home/tc/Desktop/claude-code.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Claude Code
Comment=AI-powered coding assistant
Exec=aterm -e claude-code
Icon=terminal
Terminal=false
Categories=Development;TextEditor;
DESKTOP_EOF
            chmod +x /home/tc/Desktop/claude-code.desktop
            print_success "Claude Code desktop shortcut created"
        fi
        
        # Micro editor shortcut
        if command -v micro >/dev/null 2>&1; then
            cat > /home/tc/Desktop/micro.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Micro Editor
Comment=Modern terminal text editor
Exec=aterm -e micro
Icon=text-editor
Terminal=false
Categories=Development;TextEditor;
DESKTOP_EOF
            chmod +x /home/tc/Desktop/micro.desktop
            print_success "Micro editor desktop shortcut created"
        fi
    fi
}

# Main installation process
main() {
    clear
    print_header "TinyCore Complete Setup for uDESK v$SCRIPT_VERSION"
    echo ""
    print_info "This script will set up a complete uDESK development environment"
    echo ""
    
    # Pre-flight checks
    check_tinycore
    check_network
    find_udesk_packages
    echo ""
    
    # Core installation
    print_header "Core Installation"
    setup_persistence
    install_udesk
    make_persistent
    echo ""
    
    # Development tools
    print_header "Development Environment"
    install_dev_tools
    install_claude_code
    echo ""
    
    # Finishing touches
    print_header "Finalizing Setup"
    create_shortcuts
    create_desktop_shortcuts
    echo ""
    
    # Success summary
    print_header "Installation Complete!"
    print_success "uDESK v$UDESK_VERSION successfully installed"
    
    if command -v claude-code >/dev/null 2>&1; then
        print_success "Claude Code AI assistant available"
    fi
    
    print_success "Development environment configured"
    print_success "Persistence enabled - settings will survive reboots"
    echo ""
    
    print_info "Quick Start Commands:"
    echo "  udesk-dev.sh        - Show development info"
    echo "  udos-info           - System information"
    if command -v claude-code >/dev/null 2>&1; then
        echo "  claude-code         - Start AI coding assistant"
    fi
    echo "  micro README.md     - Create your first markdown file"
    echo ""
    
    print_info "Next Steps:"
    echo "  1. Reboot to test persistence: sudo reboot"
    echo "  2. Create your first project: mkdir ~/my-project"
    echo "  3. Start developing with markdown and AI assistance!"
    echo ""
    
    print_header "Welcome to uDESK - Your Markdown-Everything OS! 🚀"
}

# Run main function
main "$@"