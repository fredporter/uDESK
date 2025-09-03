#!/bin/sh
echo "uDOS Bootstrap Installer"
echo "========================"

# Install curl first if not available
if ! which curl >/dev/null 2>&1; then
    echo "Installing curl..."
    tce-load -wi curl
fi

# Now run the main installation
if which curl >/dev/null 2>&1; then
    echo "curl available, downloading main installer..."
    curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install-minimal.sh | sh
else
    echo "❌ curl installation failed, using manual method..."
    
    # Fallback: Create basic uDOS manually
    echo "📝 Creating basic uDOS installation..."
    
    sudo mkdir -p /usr/local/bin
    sudo mkdir -p /usr/local/share/udos/templates
    
    # Create minimal udos command
    sudo tee /usr/local/bin/udos << 'EOF'
#!/bin/bash
# uDOS v1.0.0 - Bootstrap Installation

VERSION="1.0.0-bootstrap"
UDOS_HOME="${HOME}/.udos"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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
    echo -e "${YELLOW}💡 Install curl and rerun for full features${NC}"
}

show_info() {
    echo -e "${BLUE}📊 uDOS System Information${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Version: ${VERSION}"
    echo "User: ${USER} ($(id -u))"
    echo "Home: ${UDOS_HOME}"
    echo "Status: Bootstrap installation"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To get full uDOS features:"
    echo "1. tce-load -wi curl"
    echo "2. curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash"
}

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

case "$1" in
    init) init_udos ;;
    info|status) show_info ;;
    var) shift; manage_vars "$@" ;;
    version) echo "uDOS ${VERSION}" ;;
    upgrade)
        echo "🔄 Upgrading to full uDOS..."
        if command -v curl >/dev/null 2>&1; then
            curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash
        else
            echo "❌ curl required for upgrade. Run: tce-load -wi curl"
        fi
        ;;
    help)
        echo -e "${BLUE}uDOS v${VERSION} - Bootstrap Installation${NC}"
        echo ""
        echo "Commands:"
        echo "  init     Initialize uDOS environment"
        echo "  info     Show system information"
        echo "  var      Variable management"
        echo "  upgrade  Upgrade to full uDOS (requires curl)"
        echo "  version  Show version"
        echo "  help     Show this help"
        ;;
    *)
        echo -e "${BLUE}uDOS v${VERSION}${NC} - Type 'udos help' for commands"
        echo -e "${YELLOW}💡 Run 'udos upgrade' for full features${NC}"
        ;;
esac
EOF

    sudo chmod +x /usr/local/bin/udos
    
    # Add to persistence
    if [ -f /opt/.filetool.lst ]; then
        grep -qxF 'usr/local/bin/udos' /opt/.filetool.lst || echo 'usr/local/bin/udos' >> /opt/.filetool.lst
        grep -qxF 'home/tc/.udos' /opt/.filetool.lst || echo 'home/tc/.udos' >> /opt/.filetool.lst
    fi
    
    # Initialize
    udos init
    
    echo ""
    echo "✅ uDOS Bootstrap Installation Complete!"
    echo ""
    echo "Basic commands available:"
    echo "  udos version"
    echo "  udos info"
    echo "  udos var set TEST=hello"
    echo "  udos var get TEST"
    echo ""
    echo "To upgrade to full uDOS:"
    echo "  tce-load -wi curl"
    echo "  udos upgrade"
    echo ""
fi
