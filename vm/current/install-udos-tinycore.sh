#!/bin/sh
set -e

# uDOS TinyCore VM Installation Script
# Optimized for git clone installation method

VERSION="1.0.5"

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
    TinyCore VM Installer v1.0.5

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

# Check if we're in the right directory
check_repository() {
    if [ ! -d "build/uDOS-core" ] || [ ! -d "src/udos-core" ]; then
        log_error "Not in uDESK repository root or missing build files"
        log_info "Please run from /home/tc/Code/uDESK directory"
        log_info "And ensure you've cloned the complete repository"
        exit 1
    fi
    log_success "Repository structure verified"
}

# Install uDOS system files
install_udos_files() {
    log_info "Installing uDOS core files..."
    
    # Create target directories
    sudo mkdir -p /usr/local/share/udos
    sudo mkdir -p /opt/udos
    sudo mkdir -p /usr/local/bin
    
    # Copy main executable
    if [ -f "build/uDOS-core/usr/local/share/udos/udos" ]; then
        sudo cp build/uDOS-core/usr/local/share/udos/udos /usr/local/share/udos/
        log_success "Main udos executable installed"
    else
        log_error "Main udos executable not found in build/"
        exit 1
    fi
    
    # Copy any additional files from build
    if [ -d "build/uDOS-core/usr/local/share/udos" ]; then
        sudo cp -r build/uDOS-core/usr/local/share/udos/* /usr/local/share/udos/ 2>/dev/null || true
    fi
    
    # Copy files from src if they exist
    if [ -d "src/udos-core/opt/udos" ]; then
        sudo cp -r src/udos-core/opt/udos/* /opt/udos/ 2>/dev/null || true
        log_success "Additional udos files installed to /opt/udos"
    fi
    
    # Make all files executable
    sudo chmod +x /usr/local/share/udos/*
    sudo chmod +x /opt/udos/* 2>/dev/null || true
    
    log_success "uDOS files installed successfully"
}

# Setup PATH configuration
setup_path() {
    log_info "Configuring PATH..."
    
    # Add to user's profile
    if ! grep -q "/usr/local/share/udos" ~/.profile 2>/dev/null; then
        echo 'export PATH=$PATH:/usr/local/share/udos' >> ~/.profile
        log_success "Added uDOS to PATH in ~/.profile"
    fi
    
    # Add to bashrc if it exists
    if [ -f ~/.bashrc ] && ! grep -q "/usr/local/share/udos" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/share/udos' >> ~/.bashrc
        log_success "Added uDOS to PATH in ~/.bashrc"
    fi
    
    # Export for current session
    export PATH=$PATH:/usr/local/share/udos
    
    log_success "PATH configured successfully"
}

# Create convenience scripts
create_scripts() {
    log_info "Creating convenience scripts..."
    
    # Create udos symlink in /usr/local/bin for global access
    sudo ln -sf /usr/local/share/udos/udos /usr/local/bin/udos
    
    log_success "Convenience scripts created"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check if udos command is accessible
    if command -v udos >/dev/null 2>&1; then
        log_success "udos command is accessible"
        
        # Test basic functionality
        if udos version >/dev/null 2>&1; then
            log_success "udos version command works"
        else
            log_warning "udos command found but version check failed"
        fi
    else
        log_error "udos command not accessible in PATH"
        log_info "Try running: source ~/.profile"
        return 1
    fi
    
    return 0
}

# Main installation process
main() {
    show_banner
    
    log_info "Starting uDOS installation for TinyCore VM..."
    log_info "Working directory: $(pwd)"
    
    # Check repository structure
    check_repository
    
    # Install files
    install_udos_files
    
    # Setup PATH
    setup_path
    
    # Create convenience scripts
    create_scripts
    
    # Verify installation
    if verify_installation; then
        log_success "uDOS installation completed successfully!"
        echo ""
        log_info "To start using uDOS:"
        log_info "1. Run: source ~/.profile"
        log_info "2. Test: udos version"
        log_info "3. Help: udos help"
        echo ""
        log_success "Welcome to the Universal Device Operating System!"
    else
        log_error "Installation verification failed"
        echo ""
        log_info "Manual steps to fix:"
        log_info "1. Run: export PATH=\$PATH:/usr/local/share/udos"
        log_info "2. Run: source ~/.profile"
        log_info "3. Test: /usr/local/share/udos/udos version"
    fi
}

# Run main function
main "$@"
