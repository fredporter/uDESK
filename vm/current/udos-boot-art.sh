#!/bin/sh
# uDOS Boot ASCII Art and Integration
# TinyCore Linux bootlocal.sh integration

# ASCII Art for boot sequence
show_udos_boot_art() {
    clear
    cat << 'BOOT_EOF'

    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    ██╗   ██╗██████╗  ██████╗ ███████╗                       ║
    ║    ██║   ██║██╔══██╗██╔═══██╗██╔════╝                       ║
    ║    ██║   ██║██║  ██║██║   ██║███████╗                       ║
    ║    ██║   ██║██║  ██║██║   ██║╚════██║                       ║
    ║    ╚██████╔╝██████╔╝╚██████╔╝███████║                       ║
    ║     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝                       ║
    ║                                                              ║
    ║              Universal Device Operating System                ║
    ║                        v1.0.5                               ║
    ║                                                              ║
    ║              Initializing TinyCore Environment...           ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝

BOOT_EOF
    
    echo "Loading uDOS services..."
    sleep 2
}

# Compact version for login prompt
show_udos_login_art() {
    cat << 'LOGIN_EOF'

    ██╗   ██╗██████╗  ██████╗ ███████╗
    ██║   ██║██╔══██╗██╔═══██╗██╔════╝
    ██║   ██║██║  ██║██║   ██║███████╗
    ██║   ██║██║  ██║██║   ██║╚════██║
    ╚██████╔╝██████╔╝╚██████╔╝███████║
     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝

    Universal Device Operating System v1.0.5
    TinyCore Linux + uDOS Integration

LOGIN_EOF
}

# Minimal version for terminal prompt
show_udos_minimal() {
    echo "uDOS v1.0.5 | $(date '+%H:%M') | $(whoami)@$(hostname)"
}

# Initialize uDOS environment
init_udos_environment() {
    # Set up uDOS paths
    export UDOS_HOME="/opt/udos"
    export UDOS_CONFIG="$HOME/.udos"
    export UDOS_VERSION="1.0.5"
    
    # Add uDOS to PATH if not already there
    case ":$PATH:" in
        *:/usr/local/bin:*) ;;
        *) export PATH="/usr/local/bin:$PATH" ;;
    esac
    
    # Create config directory
    [ ! -d "$UDOS_CONFIG" ] && mkdir -p "$UDOS_CONFIG"
    
    # Initialize role detection
    if [ -x /usr/local/bin/udos-detect-role ]; then
        UDOS_ROLE=$(udos-detect-role)
        export UDOS_ROLE
    else
        export UDOS_ROLE="basic"
    fi
    
    # Set up VNC if configured
    if [ "$UDOS_AUTO_VNC" = "yes" ] && [ -x /usr/local/bin/udos-vnc ]; then
        udos-vnc start >/dev/null 2>&1 &
    fi
}

# Bootlocal.sh integration
setup_boot_integration() {
    BOOTLOCAL="/opt/bootlocal.sh"
    
    # Check if already integrated
    if grep -q "uDOS Boot Integration" "$BOOTLOCAL" 2>/dev/null; then
        echo "uDOS boot integration already configured"
        return 0
    fi
    
    echo "Setting up uDOS boot integration..."
    
    # Backup existing bootlocal.sh
    if [ -f "$BOOTLOCAL" ]; then
        cp "$BOOTLOCAL" "$BOOTLOCAL.backup.$(date +%Y%m%d)"
    fi
    
    # Create or append to bootlocal.sh
    cat >> "$BOOTLOCAL" << 'BOOTLOCAL_EOF'

# uDOS Boot Integration
if [ -f /usr/local/bin/udos-boot-art ]; then
    /usr/local/bin/udos-boot-art boot
fi

# Initialize uDOS environment
if [ -f /usr/local/bin/udos-boot-art ]; then
    /usr/local/bin/udos-boot-art init
fi

BOOTLOCAL_EOF

    chmod +x "$BOOTLOCAL"
    echo "Boot integration configured"
}

# User profile integration
setup_profile_integration() {
    PROFILE="$HOME/.profile"
    
    # Check if already integrated
    if grep -q "uDOS Profile Integration" "$PROFILE" 2>/dev/null; then
        echo "uDOS profile integration already configured"
        return 0
    fi
    
    echo "Setting up uDOS profile integration..."
    
    # Create or append to .profile
    cat >> "$PROFILE" << 'PROFILE_EOF'

# uDOS Profile Integration
if [ -f /usr/local/bin/udos-boot-art ]; then
    /usr/local/bin/udos-boot-art login
fi

# uDOS environment setup
if [ -f /usr/local/bin/udos-boot-art ]; then
    /usr/local/bin/udos-boot-art init >/dev/null 2>&1
fi

# uDOS quick commands
alias udos-info='udos info'
alias udos-help='udos help'
alias udos-status='udos status'

PROFILE_EOF

    echo "Profile integration configured"
}

# Terminal integration
setup_terminal_integration() {
    BASHRC="$HOME/.bashrc"
    
    # Only if bash is available
    if [ -f /bin/bash ]; then
        cat >> "$BASHRC" << 'BASHRC_EOF'

# uDOS Terminal Integration
if [ -f /usr/local/bin/udos-boot-art ]; then
    PS1="\[\033[1;32m\]\$(udos-boot-art minimal)\[\033[0m\] \$ "
fi

BASHRC_EOF
    fi
    
    # For ash/sh (TinyCore default)
    ASHRC="$HOME/.ashrc"
    cat >> "$ASHRC" << 'ASHRC_EOF'

# uDOS Terminal Integration
if [ -f /usr/local/bin/udos-boot-art ]; then
    PS1="$(udos-boot-art minimal) $ "
fi

ASHRC_EOF
}

# Main execution based on argument
case "${1:-help}" in
    boot)
        show_udos_boot_art
        ;;
    login)
        show_udos_login_art
        ;;
    minimal)
        show_udos_minimal
        ;;
    init)
        init_udos_environment
        ;;
    setup)
        echo "Setting up uDOS boot integration..."
        setup_boot_integration
        setup_profile_integration
        setup_terminal_integration
        echo "uDOS boot integration complete!"
        echo ""
        echo "Integration configured for:"
        echo "- Boot sequence (/opt/bootlocal.sh)"
        echo "- User login (~/.profile)"
        echo "- Terminal prompt (~/.ashrc)"
        echo ""
        echo "Restart or run 'source ~/.profile' to activate"
        ;;
    remove)
        echo "Removing uDOS boot integration..."
        # Remove from bootlocal.sh
        if [ -f /opt/bootlocal.sh.backup.* ]; then
            cp /opt/bootlocal.sh.backup.* /opt/bootlocal.sh
            echo "Restored original bootlocal.sh"
        fi
        # Remove from profile files
        sed -i '/uDOS.*Integration/,/^$/d' "$HOME/.profile" 2>/dev/null
        sed -i '/uDOS.*Integration/,/^$/d' "$HOME/.ashrc" 2>/dev/null
        sed -i '/uDOS.*Integration/,/^$/d' "$HOME/.bashrc" 2>/dev/null
        echo "Boot integration removed"
        ;;
    test)
        echo "Testing ASCII art displays..."
        echo ""
        echo "=== Boot Art ==="
        show_udos_boot_art
        echo ""
        echo "=== Login Art ==="
        show_udos_login_art
        echo ""
        echo "=== Minimal ==="
        show_udos_minimal
        echo ""
        ;;
    help|*)
        echo "uDOS Boot ASCII Art and Integration"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  boot     - Show boot sequence ASCII art"
        echo "  login    - Show login ASCII art"
        echo "  minimal  - Show minimal status line"
        echo "  init     - Initialize uDOS environment"
        echo "  setup    - Configure boot integration"
        echo "  remove   - Remove boot integration"
        echo "  test     - Test all ASCII art displays"
        echo "  help     - Show this help"
        echo ""
        ;;
esac
