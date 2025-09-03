#!/bin/sh
# uDOS VM Auto-Startup Script
# Automatically sets up uDOS environment when VM launches

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo "${GREEN}✅ $1${NC}"; }
log_warning() { echo "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo "${RED}❌ $1${NC}"; }

# Auto-startup sequence
udos_auto_startup() {
    clear
    
    # Show uDOS banner
    cat << 'STARTUP_EOF'
    
    ██╗   ██╗██████╗  ██████╗ ███████╗
    ██║   ██║██╔══██╗██╔═══██╗██╔════╝
    ██║   ██║██║  ██║██║   ██║███████╗
    ██║   ██║██║  ██║██║   ██║╚════██║
    ╚██████╔╝██████╔╝╚██████╔╝███████║
     ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝
    
    Universal Device Operating System
    Auto-Startup Sequence
    
STARTUP_EOF

    log_info "Initializing uDOS environment..."
    
    # Check if uDOS is available
    if ! command -v udos >/dev/null 2>&1; then
        log_warning "uDOS not found in PATH, adding..."
        export PATH="/usr/local/bin:$PATH"
        
        if ! command -v udos >/dev/null 2>&1; then
            log_error "uDOS not installed. Run ./vm/current/install.sh first"
            return 1
        fi
    fi
    
    # Initialize uDOS environment
    log_info "Initializing uDOS..."
    if udos init >/dev/null 2>&1; then
        log_success "uDOS environment initialized"
    else
        log_warning "uDOS environment already initialized"
    fi
    
    # Detect and display role
    log_info "Detecting user role..."
    if udos role detect >/dev/null 2>&1; then
        log_success "Role detection completed"
    fi
    
    # Display system status
    echo ""
    log_info "System Status:"
    udos version
    echo ""
    udos role
    echo ""
    
    # Show available commands
    log_info "Quick Commands:"
    echo "${BLUE}  udos help${NC}     - Show all commands"
    echo "${BLUE}  udos info${NC}     - System information"
    echo "${BLUE}  udos role${NC}     - Role information"
    echo "${BLUE}  uvar list${NC}     - List variables"
    echo "${BLUE}  udata list${NC}    - List data"
    echo ""
    
    log_success "uDOS ready! Happy computing! 🚀"
    echo ""
}

# Auto-startup with options
case "${1:-auto}" in
    auto)
        udos_auto_startup
        ;;
    silent)
        # Silent mode - just ensure PATH and initialization
        export PATH="/usr/local/bin:$PATH"
        udos init >/dev/null 2>&1
        udos role detect >/dev/null 2>&1
        ;;
    verbose)
        # Verbose mode with full diagnostics
        udos_auto_startup
        echo ""
        log_info "Detailed System Information:"
        echo "PATH: $PATH"
        echo "UDOS_HOME: ${UDOS_HOME:-$HOME/.udos}"
        echo "Working Directory: $(pwd)"
        echo "User: $(whoami)"
        echo "Shell: $SHELL"
        ;;
    *)
        echo "Usage: $0 [auto|silent|verbose]"
        echo "  auto    - Default startup with banner (default)"
        echo "  silent  - Silent initialization only"
        echo "  verbose - Full startup with diagnostics"
        ;;
esac
