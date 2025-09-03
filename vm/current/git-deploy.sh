#!/bin/bash
# uDOS VM Git-Based Deployment Script
# Supports UTM, QEMU, VirtualBox with VIRTDS and SPICE

set -e

# Configuration
REPO_URL="https://github.com/fredporter/uDESK.git"
VM_SETUP_DIR="/tmp/udos-vm-setup"
SPICE_PORT="${SPICE_PORT:-5900}"
VIRTDS_MOUNT="${VIRTDS_MOUNT:-/mnt/virtds}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Banner
show_banner() {
    clear
    cat << 'BANNER_EOF'
    
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    ██╗   ██╗██████╗  ██████╗ ███████╗                       ║
    ║    ██║   ██║██╔══██╗██╔═══██╗██╔════╝                       ║
    ║    ██║   ██║██║  ██║██║   ██║███████╗                       ║
    ║    ██║   ██║██║  ██║██║   ██║╚════██║                       ║
    ║    ╚██████╔╝██████╔╝╚██████╔╝███████║                       ║
    ║     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝                       ║
    ║                                                              ║
    ║              Git-Based VM Deployment v1.0.5                 ║
    ║              with VIRTDS & SPICE Support                     ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝

BANNER_EOF
}

# Detect VM environment
detect_vm_environment() {
    log_info "Detecting VM environment..."
    
    if [ -d "/Applications/UTM.app" ] || [ -n "$UTM_DATA" ]; then
        VM_TYPE="UTM"
        log_success "UTM environment detected"
    elif command -v qemu-system-x86_64 >/dev/null 2>&1; then
        VM_TYPE="QEMU"
        log_success "QEMU environment detected"
    elif command -v VBoxManage >/dev/null 2>&1; then
        VM_TYPE="VIRTUALBOX"
        log_success "VirtualBox environment detected"
    else
        VM_TYPE="GENERIC"
        log_warning "Generic Linux environment (no specific VM detected)"
    fi
    
    export VM_TYPE
}

# Setup networking
setup_networking() {
    log_info "Setting up networking..."
    
    # Enable DHCP
    if command -v dhcp.sh >/dev/null 2>&1; then
        sudo dhcp.sh
        log_success "DHCP enabled via dhcp.sh"
    elif command -v dhcpcd >/dev/null 2>&1; then
        sudo dhcpcd eth0
        log_success "DHCP enabled via dhcpcd"
    elif command -v udhcpc >/dev/null 2>&1; then
        sudo udhcpc -i eth0
        log_success "DHCP enabled via udhcpc"
    else
        log_warning "No DHCP client found, network may need manual configuration"
    fi
    
    # Test connectivity
    if ping -c 1 github.com >/dev/null 2>&1; then
        log_success "Network connectivity confirmed"
        return 0
    else
        log_error "Network connectivity failed"
        return 1
    fi
}

# Setup SPICE integration
setup_spice() {
    log_info "Setting up SPICE integration..."
    
    case "$VM_TYPE" in
        UTM|QEMU)
            # Check for SPICE
            if command -v spice-vdagent >/dev/null 2>&1; then
                sudo spice-vdagent
                log_success "SPICE agent started"
            else
                log_info "Installing SPICE tools..."
                tce-load -wi spice-vdagent.tcz 2>/dev/null || log_warning "SPICE not available in repository"
            fi
            
            # Setup SPICE clipboard
            if [ -n "$DISPLAY" ]; then
                export SPICE_CLIPBOARD=1
                log_success "SPICE clipboard enabled"
            fi
            ;;
        *)
            log_info "SPICE not applicable for $VM_TYPE"
            ;;
    esac
}

# Setup VIRTDS (VirtIO Data Sharing)
setup_virtds() {
    log_info "Setting up VIRTDS (VirtIO Data Sharing)..."
    
    # Create mount point
    sudo mkdir -p "$VIRTDS_MOUNT"
    
    # Try multiple VirtIO share tags
    for tag in virtds share shared uDESK data mac-share; do
        log_info "Trying VirtIO tag: $tag"
        if sudo mount -t 9p -o trans=virtio,version=9p2000.L,cache=loose "$tag" "$VIRTDS_MOUNT" 2>/dev/null; then
            log_success "Mounted VirtIO share: $tag → $VIRTDS_MOUNT"
            
            # Set permissions
            sudo chmod 777 "$VIRTDS_MOUNT" 2>/dev/null || true
            
            # Create convenience aliases
            echo "alias virtds='cd $VIRTDS_MOUNT && ls -la'" >> ~/.profile
            echo "alias shared='cd $VIRTDS_MOUNT && ls -la'" >> ~/.profile
            echo "alias copy-from-host='ls -la $VIRTDS_MOUNT'" >> ~/.profile
            
            # Show contents
            log_info "Share contents:"
            ls -la "$VIRTDS_MOUNT" 2>/dev/null || log_warning "Cannot list share contents"
            
            export VIRTDS_AVAILABLE=1
            return 0
        fi
    done
    
    log_warning "No VirtIO shares found (this is normal for some VM configurations)"
    export VIRTDS_AVAILABLE=0
}

# Install essential tools
install_tools() {
    log_info "Installing essential tools..."
    
    # Core tools for git operations
    local tools="git bash curl wget nano"
    
    if command -v tce-load >/dev/null 2>&1; then
        # TinyCore
        for tool in $tools; do
            if ! command -v "$tool" >/dev/null 2>&1; then
                log_info "Installing $tool..."
                tce-load -wi "$tool.tcz" 2>/dev/null || log_warning "Failed to install $tool"
            fi
        done
    elif command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu
        sudo apt-get update && sudo apt-get install -y $tools
    elif command -v yum >/dev/null 2>&1; then
        # RHEL/CentOS
        sudo yum install -y $tools
    elif command -v apk >/dev/null 2>&1; then
        # Alpine
        sudo apk add $tools
    else
        log_warning "Package manager not detected, tools may need manual installation"
    fi
    
    log_success "Essential tools installation completed"
}

# Clone and setup uDOS via Git
setup_udos_via_git() {
    log_info "Setting up uDOS via Git..."
    
    # Clean any existing setup
    rm -rf "$VM_SETUP_DIR"
    mkdir -p "$VM_SETUP_DIR"
    cd "$VM_SETUP_DIR"
    
    # Clone repository
    log_info "Cloning uDESK repository..."
    if git clone "$REPO_URL" .; then
        log_success "Repository cloned successfully"
    else
        log_error "Failed to clone repository"
        return 1
    fi
    
    # Run installation
    log_info "Running uDOS installation..."
    if [ -f "vm/current/install.sh" ]; then
        chmod +x vm/current/install.sh
        ./vm/current/install.sh
        log_success "uDOS installation completed"
    else
        log_error "Installation script not found"
        return 1
    fi
    
    # Setup auto-startup
    log_info "Configuring auto-startup..."
    if ! grep -q "udos" ~/.profile 2>/dev/null; then
        echo '# uDOS Auto-Setup' >> ~/.profile
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.profile
        echo 'udos init >/dev/null 2>&1' >> ~/.profile
        echo 'udos role detect >/dev/null 2>&1' >> ~/.profile
        echo 'echo "🚀 uDOS Ready! Type: udos help"' >> ~/.profile
        log_success "Auto-startup configured"
    else
        log_info "Auto-startup already configured"
    fi
}

# Setup persistence for TinyCore
setup_persistence() {
    if [ -f "/opt/.filetool.lst" ]; then
        log_info "Setting up TinyCore persistence..."
        
        # Add key paths to persistence
        local paths="
        usr/local/bin/udos
        usr/local/bin/uvar
        usr/local/bin/udata
        usr/local/bin/utpl
        usr/local/share/udos
        opt/udos
        home/tc/.udos
        home/tc/.profile
        "
        
        for path in $paths; do
            if ! grep -q "^$path$" /opt/.filetool.lst 2>/dev/null; then
                echo "$path" | sudo tee -a /opt/.filetool.lst >/dev/null
            fi
        done
        
        log_success "TinyCore persistence configured"
    fi
}

# Verify complete installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Test uDOS commands
    if command -v udos >/dev/null 2>&1; then
        log_success "udos command available"
        
        if udos version >/dev/null 2>&1; then
            log_success "udos version works"
        else
            log_warning "udos version check failed"
        fi
        
        if udos role >/dev/null 2>&1; then
            log_success "udos role detection works"
        else
            log_warning "udos role detection failed"
        fi
    else
        log_error "udos command not found"
        return 1
    fi
    
    # Test wrapper commands
    for cmd in uvar udata utpl; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log_success "$cmd wrapper available"
        else
            log_warning "$cmd wrapper not found"
        fi
    done
    
    return 0
}

# Main deployment function
main() {
    show_banner
    
    log_info "Starting Git-based uDOS VM deployment..."
    
    # Setup sequence
    detect_vm_environment
    
    if setup_networking; then
        install_tools
        setup_spice
        setup_virtds
        setup_udos_via_git
        setup_persistence
        
        if verify_installation; then
            show_banner
            log_success "🎉 Git-based uDOS deployment completed successfully!"
            echo ""
            log_info "Environment Summary:"
            log_info "VM Type: $VM_TYPE"
            log_info "VirtDS Available: ${VIRTDS_AVAILABLE:-0}"
            log_info "SPICE Enabled: ${SPICE_CLIPBOARD:-0}"
            echo ""
            log_info "Quick Commands:"
            log_info "  udos help     - Show all commands"
            log_info "  udos info     - System information"
            log_info "  udos role     - Role information"
            if [ "$VIRTDS_AVAILABLE" = "1" ]; then
                log_info "  shared        - Access shared folder"
                log_info "  copy-from-host - List shared files"
            fi
            echo ""
            log_success "Ready for M2 development! 🚀"
        else
            log_error "Installation verification failed"
            exit 1
        fi
    else
        log_error "Network setup failed. Please check VM network configuration."
        exit 1
    fi
}

# Handle command line arguments
case "${1:-deploy}" in
    deploy)
        main
        ;;
    network)
        setup_networking
        ;;
    spice)
        setup_spice
        ;;
    virtds)
        setup_virtds
        ;;
    verify)
        verify_installation
        ;;
    *)
        echo "Usage: $0 [deploy|network|spice|virtds|verify]"
        echo "  deploy  - Full deployment (default)"
        echo "  network - Setup networking only"
        echo "  spice   - Setup SPICE only"
        echo "  virtds  - Setup VirtDS only"
        echo "  verify  - Verify installation only"
        ;;
esac
