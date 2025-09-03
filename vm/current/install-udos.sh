#!/bin/sh
set -e

# uDOS Hybrid Distribution Manager
# Automatically detects and uses the best installation method

VERSION="1.0.5"
GITHUB_BASE="https://raw.githubusercontent.com/fredporter/uDESK/main"
TCZ_REPO="http://repo.tinycorelinux.net/14.x/x86_64/tcz"

# ASCII Art Banner
show_banner() {
    cat << 'BANNER_EOF'

    ██╗   ██╗██████╗  ██████╗ ███████╗
    ██║   ██║██╔══██╗██╔═══██╗██╔════╝
    ██║   ██║██║  ██║██║   ██║███████╗
    ██║   ██║██║  ██║██║   ██║╚════██║
    ╚██████╔╝██████╔╝╚██████╔╝███████║
     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝

    Universal Device Operating System
    Hybrid Distribution Manager v1.0.5

BANNER_EOF
}

# Logging functions
log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1"
}

log_warning() {
    echo "⚠️  $1"
}

# Network connectivity check
check_network() {
    if curl -s --connect-timeout 5 --max-time 10 https://github.com >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Check if uDOS is already installed
check_existing_installation() {
    if [ -f /usr/local/bin/udos ]; then
        EXISTING_VERSION=$(udos version 2>/dev/null | head -1 | grep -o 'v[0-9.]*' || echo "unknown")
        return 0
    else
        return 1
    fi
}

# GitHub installation method
install_from_github() {
    log_info "Installing uDOS from GitHub (latest version)..."
    
    if check_network; then
        INSTALLER_URL="${GITHUB_BASE}/vm/auto-complete-install.sh"
        
        log_info "Downloading installer from GitHub..."
        if curl -sL "$INSTALLER_URL" -o /tmp/udos-github-install.sh; then
            chmod +x /tmp/udos-github-install.sh
            log_info "Running GitHub installer..."
            
            # Set environment for automated installation
            export UDOS_VNC_PASSWORD="${UDOS_VNC_PASSWORD:-udos2024}"
            export UDOS_AUTO_VNC="${UDOS_AUTO_VNC:-yes}"
            export UDOS_DESKTOP="${UDOS_DESKTOP:-yes}"
            
            if /tmp/udos-github-install.sh; then
                log_success "GitHub installation completed successfully!"
                return 0
            else
                log_error "GitHub installation failed"
                return 1
            fi
        else
            log_error "Failed to download from GitHub"
            return 1
        fi
    else
        log_error "No network connectivity for GitHub installation"
        return 1
    fi
}

# TCZ package installation method
install_from_tcz() {
    log_info "Installing uDOS as TinyCore extension (.tcz)..."
    
    # Check if TCZ is available locally
    if [ -f udos.tcz ]; then
        log_info "Found local udos.tcz package"
        if tce-load -i udos.tcz; then
            log_success "TCZ installation completed successfully!"
            return 0
        else
            log_error "Failed to load local TCZ package"
            return 1
        fi
    elif check_network; then
        log_info "Downloading udos.tcz from repository..."
        # In a real implementation, this would download from TCZ repo or GitHub releases
        log_warning "TCZ package not yet available in official repository"
        log_info "Falling back to GitHub installation..."
        return 1
    else
        log_error "No local TCZ package and no network connectivity"
        return 1
    fi
}

# Offline installation method
install_from_offline() {
    log_info "Checking for offline installation bundle..."
    
    # Check for offline bundle in common locations
    for location in /tmp /media /mnt /opt; do
        if [ -f "$location/udos-offline-install.sh" ]; then
            log_info "Found offline installer at $location"
            chmod +x "$location/udos-offline-install.sh"
            if "$location/udos-offline-install.sh"; then
                log_success "Offline installation completed successfully!"
                return 0
            else
                log_error "Offline installation failed"
                return 1
            fi
        fi
    done
    
    log_warning "No offline installation bundle found"
    return 1
}

# Update existing installation
update_installation() {
    log_info "Updating existing uDOS installation..."
    
    if check_network; then
        UPDATE_URL="${GITHUB_BASE}/vm/update-udos.sh"
        
        if curl -sL "$UPDATE_URL" -o /tmp/udos-update.sh; then
            chmod +x /tmp/udos-update.sh
            if /tmp/udos-update.sh; then
                log_success "Update completed successfully!"
                return 0
            else
                log_error "Update failed"
                return 1
            fi
        else
            log_error "Failed to download update script"
            return 1
        fi
    else
        log_error "Network required for updates"
        return 1
    fi
}

# Auto-detect best installation method
auto_detect_method() {
    log_info "Auto-detecting best installation method..."
    
    # Priority order: existing -> offline -> tcz -> github
    
    if check_existing_installation; then
        log_info "Found existing installation ($EXISTING_VERSION)"
        echo "update"
    elif [ -f /tmp/udos-offline-install.sh ] || [ -f /media/udos-offline-install.sh ]; then
        log_info "Found offline installation bundle"
        echo "offline"
    elif [ -f udos.tcz ] || [ -f /tmp/udos.tcz ]; then
        log_info "Found TCZ package"
        echo "tcz"
    elif check_network; then
        log_info "Network available - using GitHub"
        echo "github"
    else
        log_error "No installation method available"
        echo "none"
    fi
}

# Show installation options
show_options() {
    echo ""
    echo "Installation Options:"
    echo "===================="
    echo ""
    echo "Available methods:"
    echo "  github  - Install from GitHub (latest, requires network)"
    echo "  tcz     - Install as TinyCore extension package"
    echo "  offline - Install from local bundle (no network needed)"
    echo "  update  - Update existing installation"
    echo "  auto    - Auto-detect best method (default)"
    echo ""
    echo "Usage examples:"
    echo "  $0                    # Auto-detect and install"
    echo "  $0 github             # Force GitHub installation"
    echo "  $0 tcz                # Force TCZ installation"
    echo "  $0 offline            # Force offline installation"
    echo "  $0 update             # Update existing installation"
    echo ""
    echo "Environment variables:"
    echo "  UDOS_VNC_PASSWORD     # Set VNC password (default: udos2024)"
    echo "  UDOS_AUTO_VNC         # Auto-start VNC (default: yes)"
    echo "  UDOS_DESKTOP          # Install desktop (default: yes)"
    echo ""
}

# Post-installation verification
verify_installation() {
    log_info "Verifying installation..."
    
    if [ -f /usr/local/bin/udos ]; then
        INSTALLED_VERSION=$(udos version 2>/dev/null || echo "Unknown version")
        log_success "uDOS installed successfully!"
        echo ""
        echo "Installation Summary:"
        echo "===================="
        echo "Version: $INSTALLED_VERSION"
        echo "Location: /usr/local/bin/udos"
        echo ""
        echo "Quick Start:"
        echo "  udos help         # Show all commands"
        echo "  udos info         # System information"
        echo "  udos auto         # Start full environment"
        echo ""
        
        # Test basic functionality
        if udos version >/dev/null 2>&1; then
            log_success "Basic functionality verified"
        else
            log_warning "Installation may have issues"
        fi
        
        return 0
    else
        log_error "Installation verification failed"
        return 1
    fi
}

# Main execution
main() {
    show_banner
    
    case "${1:-auto}" in
        github)
            install_from_github && verify_installation
            ;;
        tcz)
            install_from_tcz || install_from_github && verify_installation
            ;;
        offline)
            install_from_offline && verify_installation
            ;;
        update)
            if check_existing_installation; then
                update_installation && verify_installation
            else
                log_error "No existing installation found to update"
                log_info "Use 'auto' or 'github' to install"
                exit 1
            fi
            ;;
        auto)
            METHOD=$(auto_detect_method)
            case "$METHOD" in
                update)
                    log_info "Existing installation detected"
                    read -p "Update existing installation? [Y/n] " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                        update_installation && verify_installation
                    else
                        log_info "Keeping existing installation"
                        verify_installation
                    fi
                    ;;
                offline)
                    install_from_offline && verify_installation
                    ;;
                tcz)
                    install_from_tcz || install_from_github && verify_installation
                    ;;
                github)
                    install_from_github && verify_installation
                    ;;
                none)
                    log_error "No installation method available!"
                    echo ""
                    echo "Possible solutions:"
                    echo "1. Connect to network for GitHub installation"
                    echo "2. Download udos.tcz package manually"
                    echo "3. Get offline installation bundle"
                    exit 1
                    ;;
            esac
            ;;
        help|--help|-h)
            show_options
            ;;
        version|--version|-v)
            echo "uDOS Hybrid Distribution Manager v$VERSION"
            ;;
        *)
            log_error "Unknown option: $1"
            show_options
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
