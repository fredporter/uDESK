#!/bin/sh
# Node.js Installation Script for TinyCore Linux
# Part of uDOS Ecosystem Enhancement

VERSION="1.0.0"

log() { echo "${2:+$2 }$1"; }
err() { echo "❌ $1" >&2; }
info() { echo "ℹ️  $1"; }

check_tinycore() {
    if ! command -v tce-load >/dev/null 2>&1; then
        err "TinyCore package manager not found"
        info "This script requires TinyCore Linux"
        return 1
    fi
    
    log "TinyCore Linux detected" "✅"
    return 0
}

check_nodejs() {
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version 2>/dev/null || echo "not installed")
        log "Node.js already installed: $NODE_VERSION" "✅"
        log "npm version: $NPM_VERSION" "📦"
        return 0
    else
        log "Node.js not installed" "⚠️"
        return 1
    fi
}

install_nodejs() {
    log "Installing Node.js..." "📦"
    
    # Install Node.js extension
    if tce-load -wi nodejs; then
        log "Node.js package installed" "✅"
    else
        err "Failed to install nodejs package"
        info "Try running: tce-load -wi nodejs"
        return 1
    fi
    
    # Install npm if available separately
    if tce-load -wi npm 2>/dev/null; then
        log "npm package installed" "✅"
    else
        info "npm package not available separately (may be included with Node.js)"
    fi
    
    # Verify installation
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        log "Node.js installation successful: $NODE_VERSION" "✅"
        
        if command -v npm >/dev/null 2>&1; then
            NPM_VERSION=$(npm --version)
            log "npm available: $NPM_VERSION" "📦"
        else
            info "npm not available - Node.js basic functionality only"
        fi
        
        return 0
    else
        err "Node.js installation verification failed"
        return 1
    fi
}

install_development_tools() {
    log "Installing Node.js development tools..." "🔧"
    
    # Try to install development package
    if tce-load -wi nodejs-dev 2>/dev/null; then
        log "Node.js development tools installed" "✅"
    else
        info "Node.js development tools not available"
    fi
    
    # Try to install build tools
    if tce-load -wi build-essential 2>/dev/null; then
        log "Build tools installed" "✅"
    else
        info "Build tools not available"
    fi
}

configure_ecosystem() {
    log "Configuring uDOS ecosystem for Node.js..." "⚙️"
    
    # Update uDOS ecosystem settings
    UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
    mkdir -p "$UDOS_HOME/ecosystem"
    
    # Create ecosystem configuration
    cat > "$UDOS_HOME/ecosystem/nodejs.conf" << EOF
# Node.js Configuration for uDOS Ecosystem
# Generated: $(date)

NODE_VERSION=$(node --version 2>/dev/null || echo "unknown")
NPM_VERSION=$(npm --version 2>/dev/null || echo "unknown")
INSTALLED=$(date +%Y-%m-%d)
ENHANCED_MODE=true

# Feature flags
JAVASCRIPT_PLUGINS=true
NPM_SUPPORT=$(if command -v npm >/dev/null 2>&1; then echo "true"; else echo "false"; fi)
REMOTE_REGISTRY=true
EOF
    
    log "Ecosystem configuration updated" "✅"
}

show_status() {
    echo "🌐 Node.js Installation Status"
    echo ""
    
    # System information
    echo "System: $(cat /etc/issue 2>/dev/null | head -1 || echo "Unknown")"
    echo "TinyCore: $(if command -v tce-load >/dev/null 2>&1; then echo "Available"; else echo "Not available"; fi)"
    echo ""
    
    # Node.js status
    if command -v node >/dev/null 2>&1; then
        echo "Node.js: ✅ $(node --version)"
        echo "Location: $(which node)"
    else
        echo "Node.js: ❌ Not installed"
    fi
    
    # npm status
    if command -v npm >/dev/null 2>&1; then
        echo "npm: ✅ $(npm --version)"
        echo "Location: $(which npm)"
    else
        echo "npm: ❌ Not available"
    fi
    
    # uDOS ecosystem status
    UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
    if [ -f "$UDOS_HOME/ecosystem/nodejs.conf" ]; then
        echo "uDOS Config: ✅ Configured"
    else
        echo "uDOS Config: ⚠️  Not configured"
    fi
}

# Main execution
case "${1:-install}" in
    install)
        log "uDOS Node.js Installer v$VERSION" "🚀"
        echo ""
        
        # Check if we're on TinyCore
        if ! check_tinycore; then
            exit 1
        fi
        
        # Check current status
        if check_nodejs; then
            echo ""
            info "Node.js is already installed"
            read -p "Reinstall anyway? (y/N): " answer
            case $answer in
                [Yy]*) ;;
                *) log "Installation cancelled" "✋"; exit 0 ;;
            esac
        fi
        
        echo ""
        
        # Install Node.js
        if install_nodejs; then
            echo ""
            
            # Ask about development tools
            read -p "Install development tools? (y/N): " answer
            case $answer in
                [Yy]*) 
                    echo ""
                    install_development_tools
                    ;;
            esac
            
            echo ""
            configure_ecosystem
            
            echo ""
            log "Installation complete!" "🎉"
            log "Restart your shell or run: source ~/.profile" "💡"
            log "Test with: udos ecosystem help" "🔧"
        else
            err "Installation failed"
            exit 1
        fi
        ;;
        
    status)
        show_status
        ;;
        
    remove)
        log "Removing Node.js..." "🗑"
        if command -v tce-load >/dev/null 2>&1; then
            # TinyCore doesn't have a standard remove command
            # Extensions are typically removed by deleting from /tmp/tcloop
            info "To remove Node.js on TinyCore:"
            echo "1. Remove from onboot.lst: sudo sed -i '/nodejs/d' /opt/bootlocal.sh"
            echo "2. Reboot system"
            echo "3. Or manually remove: sudo rm -rf /tmp/tcloop/nodejs*"
        else
            err "Remove not supported on this system"
        fi
        ;;
        
    help|--help|-h)
        echo "🌐 uDOS Node.js Installer v$VERSION"
        echo ""
        echo "Commands:"
        echo "  install    Install Node.js and configure uDOS"
        echo "  status     Show installation status"
        echo "  remove     Show removal instructions"
        echo "  help       Show this help"
        echo ""
        echo "Examples:"
        echo "  ./install-nodejs.sh install"
        echo "  ./install-nodejs.sh status"
        echo ""
        echo "This script installs Node.js on TinyCore Linux and configures"
        echo "the uDOS ecosystem for enhanced plugin capabilities."
        ;;
        
    *)
        err "Unknown command: $1"
        echo "Use: $0 help"
        exit 1
        ;;
esac
