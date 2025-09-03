#!/bin/bash
# Manual installation script for UTM TinyCore VM
# Run this script inside your TinyCore VM

echo "🚀 uDOS Manual Installation for UTM..."

# Create directory structure
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/local/share/udos/templates
sudo mkdir -p /usr/local/tce.installed

# Install dependencies
echo "📦 Installing dependencies..."
tce-load -wi bash
tce-load -wi coreutils
tce-load -wi curl
tce-load -wi git

# Create main udos command
echo "📝 Creating udos CLI..."
sudo tee /usr/local/bin/udos << 'EOF'
#!/bin/bash
# uDOS v1.0.0 - Manual Installation

VERSION="1.0.0"
UDOS_HOME="${HOME}/.udos"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialize uDOS
init_udos() {
    echo -e "${BLUE}🚀 Initializing uDOS environment...${NC}"
    mkdir -p "${UDOS_HOME}"/{vars,data,templates,logs}
    
    cat > "${UDOS_HOME}/vars/config.env" << EOL
UDOS_VERSION=${VERSION}
UDOS_GRID_SIZE=16
UDOS_PALETTE=retro8
UDOS_EDITOR=micro
USER_ROLE=${USER}
INITIALIZED=$(date)
EOL
    
    echo -e "${GREEN}✅ uDOS initialized at ${UDOS_HOME}${NC}"
}

# Show system info
show_info() {
    echo -e "${BLUE}📊 uDOS System Information${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Version: ${VERSION}"
    echo "User: ${USER} ($(id -u))"
    echo "Home: ${UDOS_HOME}"
    
    if [ -f "${UDOS_HOME}/vars/config.env" ]; then
        source "${UDOS_HOME}/vars/config.env"
        echo "Grid: ${UDOS_GRID_SIZE}×${UDOS_GRID_SIZE}"
        echo "Editor: ${UDOS_EDITOR}"
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Variable management
manage_vars() {
    case "$1" in
        set)
            if [[ "$2" == *"="* ]]; then
                key="${2%%=*}"
                value="${2#*=}"
                mkdir -p "${UDOS_HOME}/vars"
                echo "$value" > "${UDOS_HOME}/vars/${key}.var"
                echo -e "${GREEN}✅ ${key}=${value}${NC}"
            else
                echo -e "${RED}❌ Use: udos var set KEY=VALUE${NC}"
            fi
            ;;
        get)
            if [ -f "${UDOS_HOME}/vars/$2.var" ]; then
                cat "${UDOS_HOME}/vars/$2.var"
            else
                echo -e "${RED}❌ Variable '$2' not found${NC}"
            fi
            ;;
        list)
            echo -e "${YELLOW}Variables:${NC}"
            if [ -d "${UDOS_HOME}/vars" ]; then
                for var in "${UDOS_HOME}/vars"/*.var; do
                    if [ -f "$var" ]; then
                        key=$(basename "$var" .var)
                        value=$(cat "$var")
                        echo "  ${key}=${value}"
                    fi
                done
            fi
            ;;
        *)
            echo "Commands: set KEY=VALUE, get KEY, list"
            ;;
    esac
}

# Main command dispatcher
case "$1" in
    init)
        init_udos
        ;;
    info|status)
        show_info
        ;;
    var)
        shift
        manage_vars "$@"
        ;;
    version)
        echo "uDOS ${VERSION}"
        ;;
    help)
        echo -e "${BLUE}uDOS v${VERSION}${NC}"
        echo ""
        echo "Commands:"
        echo "  init     Initialize uDOS environment"
        echo "  info     Show system information"
        echo "  var      Variable management"
        echo "  version  Show version"
        echo "  help     Show this help"
        ;;
    *)
        echo -e "${BLUE}uDOS v${VERSION}${NC} - Type 'udos help' for commands"
        ;;
esac
EOF

# Make executable
sudo chmod +x /usr/local/bin/udos

# Create simple uvar command
sudo tee /usr/local/bin/uvar << 'EOF'
#!/bin/bash
# Simple uvar wrapper
udos var "$@"
EOF

sudo chmod +x /usr/local/bin/uvar

# Add to persistence
echo "💾 Adding to persistent storage..."
if [ -f /opt/.filetool.lst ]; then
    grep -qxF 'usr/local/bin/udos' /opt/.filetool.lst || echo 'usr/local/bin/udos' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/uvar' /opt/.filetool.lst || echo 'usr/local/bin/uvar' >> /opt/.filetool.lst
    grep -qxF 'home/tc/.udos' /opt/.filetool.lst || echo 'home/tc/.udos' >> /opt/.filetool.lst
fi

# Initialize for current user
udos init

echo ""
echo "✅ uDOS Manual Installation Complete!"
echo ""
echo "Test commands:"
echo "  udos version"
echo "  udos info"
echo "  udos var set TEST=hello"
echo "  udos var get TEST"
echo ""
