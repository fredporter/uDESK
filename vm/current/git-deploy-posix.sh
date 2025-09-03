#!/bin/sh
# uDOS VM Git-Based Deployment Script (POSIX Compatible)
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

log_info() { echo "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo "${GREEN}✅ $1${NC}"; }
log_warning() { echo "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo "${RED}❌ $1${NC}"; }

# Simple banner for POSIX shell
show_banner() {
    clear
    echo ""
    echo "    ██╗   ██╗██████╗  ██████╗ ███████╗"
    echo "    ██║   ██║██╔══██╗██╔═══██╗██╔════╝"
    echo "    ██║   ██║██║  ██║██║   ██║███████╗"
    echo "    ██║   ██║██║  ██║██║   ██║╚════██║"
    echo "    ╚██████╔╝██████╔╝╚██████╔╝███████║"
    echo "     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝"
    echo ""
    echo "    Git-Based VM Deployment v1.0.5"
    echo "    with VIRTDS & SPICE Support"
    echo ""
}

# Quick network test
test_network() {
    log_info "Testing network connectivity..."
    if ping -c 1 github.com >/dev/null 2>&1; then
        log_success "Network connectivity confirmed"
        return 0
    else
        log_error "No network connectivity to github.com"
        log_info "Please check VM network settings"
        return 1
    fi
}

# Install tools for TinyCore
install_tinycore_tools() {
    log_info "Installing tools for TinyCore..."
    
    # Essential tools
    for tool in git curl wget bash nano; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            log_info "Installing $tool..."
            if tce-load -wi "$tool.tcz" 2>/dev/null; then
                log_success "Installed $tool"
            else
                log_warning "Failed to install $tool"
            fi
        else
            log_info "$tool already available"
        fi
    done
}

# Setup VirtIO shared folders
setup_shared_folder() {
    log_info "Setting up shared folders..."
    
    sudo mkdir -p /mnt/shared
    
    # Try common share tags
    for tag in share shared uDESK udeskshare mac-share; do
        log_info "Trying share tag: $tag"
        if sudo mount -t 9p -o trans=virtio,version=9p2000.L "$tag" /mnt/shared 2>/dev/null; then
            log_success "Mounted share: $tag"
            ls -la /mnt/shared
            return 0
        fi
    done
    
    log_warning "No shared folders found (this is normal for some setups)"
    return 1
}

# Git clone and install
git_install_udos() {
    log_info "Installing uDOS via Git..."
    
    # Clean setup
    rm -rf "$VM_SETUP_DIR"
    mkdir -p "$VM_SETUP_DIR"
    cd "$VM_SETUP_DIR"
    
    # Clone repository
    log_info "Cloning uDESK repository..."
    if git clone "$REPO_URL" .; then
        log_success "Repository cloned"
    else
        log_error "Failed to clone repository"
        return 1
    fi
    
    # Run installation
    if [ -f "vm/current/install.sh" ]; then
        log_info "Running uDOS installation..."
        chmod +x vm/current/install.sh
        ./vm/current/install.sh
        log_success "uDOS installed"
    else
        log_error "Installation script not found"
        return 1
    fi
    
    # Setup auto-startup
    if ! grep -q "udos" ~/.profile 2>/dev/null; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.profile
        echo 'udos init >/dev/null 2>&1' >> ~/.profile
        echo 'echo "🚀 uDOS Ready! Type: udos help"' >> ~/.profile
        log_success "Auto-startup configured"
    fi
}

# Verify installation
verify_udos() {
    log_info "Verifying uDOS installation..."
    
    if command -v udos >/dev/null 2>&1; then
        log_success "udos command available"
        if udos version >/dev/null 2>&1; then
            log_success "udos version works"
            return 0
        else
            log_warning "udos version failed"
            return 1
        fi
    else
        log_error "udos command not found"
        return 1
    fi
}

# Main function
main() {
    show_banner
    
    log_info "Starting POSIX-compatible uDOS deployment..."
    
    # Basic checks
    if ! test_network; then
        exit 1
    fi
    
    # Install tools
    if command -v tce-load >/dev/null 2>&1; then
        install_tinycore_tools
    else
        log_warning "Not TinyCore - assuming tools are available"
    fi
    
    # Setup shared folders (optional)
    setup_shared_folder || true
    
    # Install uDOS
    if git_install_udos; then
        if verify_udos; then
            show_banner
            log_success "🎉 uDOS deployment completed successfully!"
            echo ""
            log_info "Quick commands:"
            log_info "  udos help     - Show all commands"
            log_info "  udos version  - System information"
            log_info "  udos role     - Role information"
            echo ""
            log_success "Ready for M2 development! 🚀"
        else
            log_error "Installation verification failed"
            exit 1
        fi
    else
        log_error "Installation failed"
        exit 1
    fi
}

# Run main function
main "$@"
