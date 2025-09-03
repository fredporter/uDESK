#!/bin/sh
set -e

# uDOS TinyCore Installation Script v1.0.5
# Installs the modular uDOS system

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
    Clean TinyCore Installation v1.0.5

BANNER_EOF
}

# Logging functions
log_info() { echo "ℹ️  $1"; }
log_success() { echo "✅ $1"; }
log_error() { echo "❌ $1"; }
log_warning() { echo "⚠️  $1"; }

# Check if we're in the right directory
check_repository() {
    if [ ! -d "build/clean-udos" ]; then
        log_error "Clean uDOS build not found"
        log_info "Please run from uDESK repository root"
        log_info "Expected: build/clean-udos/ directory"
        exit 1
    fi
    log_success "Clean uDOS build found"
}

# Install the clean uDOS structure
install_clean_udos() {
    log_info "Installing clean uDOS structure..."
    
    # Install main executables
    log_info "Installing main executables..."
    sudo mkdir -p /usr/local/bin
    
    for exec_file in build/clean-udos/usr/local/bin/*; do
        if [ -f "$exec_file" ]; then
            exec_name=$(basename "$exec_file")
            sudo cp "$exec_file" "/usr/local/bin/"
            sudo chmod +x "/usr/local/bin/$exec_name"
            log_success "Installed $exec_name"
        fi
    done
    
    # Install system files
    log_info "Installing system files..."
    sudo mkdir -p /usr/local/share/udos
    
    if [ -d "build/clean-udos/usr/local/share/udos" ]; then
        sudo cp -r build/clean-udos/usr/local/share/udos/* /usr/local/share/udos/
        log_success "System files installed"
    fi
    
    # Create optional directories
    log_info "Creating optional directories..."
    sudo mkdir -p /opt/udos/{bin,config,logs}
    
    log_success "Clean uDOS installation completed"
}

# Setup PATH configuration
setup_path() {
    log_info "Configuring PATH..."
    
    # Add to user's profile
    if ! grep -q "/usr/local/bin" ~/.profile 2>/dev/null; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.profile
        log_success "Updated PATH in ~/.profile"
    else
        log_info "PATH already configured in ~/.profile"
    fi
    
    # Export for current session
    export PATH="/usr/local/bin:$PATH"
    
    log_success "PATH configured successfully"
}

# Setup persistence for TinyCore
setup_persistence() {
    log_info "Setting up TinyCore persistence..."
    
    FILETOOL_LST="/opt/.filetool.lst"
    
    # Add uDOS paths to persistence
    for path in "usr/local/bin/udos" "usr/local/bin/uvar" "usr/local/bin/udata" "usr/local/bin/utpl" "usr/local/share/udos" "opt/udos"; do
        if ! grep -q "^$path$" "$FILETOOL_LST" 2>/dev/null; then
            echo "$path" | sudo tee -a "$FILETOOL_LST" >/dev/null
            log_success "Added $path to persistence"
        fi
    done
    
    log_success "TinyCore persistence configured"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check if udos command is accessible
    if command -v udos >/dev/null 2>&1; then
        log_success "udos command is accessible"
        
        # Test version command
        if udos version >/dev/null 2>&1; then
            log_success "udos version command works"
        else
            log_warning "udos command found but version check failed"
        fi
    else
        log_error "udos command not accessible in PATH"
        return 1
    fi
    
    # Check wrapper commands
    for cmd in uvar udata utpl; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log_success "$cmd wrapper accessible"
        else
            log_warning "$cmd wrapper not accessible"
        fi
    done
    
    return 0
}

# Initialize user environment
initialize_environment() {
    log_info "Initializing uDOS environment..."
    
    # Run udos init
    if udos init >/dev/null 2>&1; then
        log_success "uDOS environment initialized"
    else
        log_warning "Failed to initialize uDOS environment"
    fi
    
    # Detect role
    if udos role detect >/dev/null 2>&1; then
        role=$(udos role info 2>/dev/null | grep "Current Role:" | cut -d' ' -f3 || echo "Unknown")
        log_success "Role detected: $role"
    else
        log_warning "Failed to detect role"
    fi
}

# Main installation process
main() {
    show_banner
    
    log_info "Starting clean uDOS installation for TinyCore..."
    log_info "Working directory: $(pwd)"
    
    # Check repository structure
    check_repository
    
    # Install clean structure
    install_clean_udos
    
    # Setup PATH
    setup_path
    
    # Setup TinyCore persistence
    setup_persistence
    
    # Initialize environment
    initialize_environment
    
    # Verify installation
    if verify_installation; then
        show_banner
        log_success "🎉 Clean uDOS installation completed successfully!"
        echo ""
        log_info "Available commands:"
        log_info "Display Format              Actual Command"
        log_info "──────────────              ──────────────"
        log_info "UDOS HELP                   udos help"
        log_info "UDOS INIT                   udos init"
        log_info "UDOS ROLE DETECT            udos role detect"
        log_info "UDOS VAR SET KEY=VALUE      udos var set KEY=VALUE"
        log_info "UVAR GET KEY                uvar get KEY"
        echo ""
        log_info "Quick start:"
        log_info "  Type: udos help         (Show all commands)"
        log_info "  Type: udos info         (Show system information)"  
        log_info "  Type: udos role info    (Show your role)"
        echo ""
        log_success "Welcome to the clean, modular uDOS!"
        echo ""
        log_success "💡 Commands shown in CAPS, type in lowercase"
    else
        log_error "Installation verification failed"
        echo ""
        log_info "Manual steps to fix:"
        log_info "1. Run: export PATH=/usr/local/bin:\$PATH"
        log_info "2. Run: source ~/.profile"
        log_info "3. Test: udos version"
    fi
}

# Run main function
main "$@"
