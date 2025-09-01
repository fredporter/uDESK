#!/bin/sh
# uDOS TinyCore Simple Installer - Pure POSIX shell only

echo "uDOS Simple Installer for TinyCore"
echo "=================================="

# Create directories
echo "Creating directories..."
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/local/share/udos/templates
mkdir -p ~/.udos/vars
mkdir -p ~/.udos/data
mkdir -p ~/.udos/templates
mkdir -p ~/.udos/logs

# Create main udos command
echo "Installing udos command..."
sudo tee /usr/local/bin/udos > /dev/null << 'EOF'
#!/bin/sh
VERSION="1.0.5"
UDOS_HOME="${HOME}/.udos"

case "$1" in
    version)
        echo "uDOS v${VERSION} - Role Hierarchy System"
        ;;
    init)
        mkdir -p "${UDOS_HOME}/vars"
        mkdir -p "${UDOS_HOME}/data"
        mkdir -p "${UDOS_HOME}/templates"
        mkdir -p "${UDOS_HOME}/logs"
        echo "UDOS_VERSION=${VERSION}" > "${UDOS_HOME}/vars/config.env"
        echo "USER_ROLE=APPRENTICE" >> "${UDOS_HOME}/vars/config.env"
        echo "UDOS_GRID_SIZE=16" >> "${UDOS_HOME}/vars/config.env"
        echo "uDOS initialized"
        ;;
    info)
        echo "uDOS v${VERSION}"
        echo "Home: ${UDOS_HOME}"
        if [ -f "${UDOS_HOME}/vars/config.env" ]; then
            echo "Status: Configured"
        else
            echo "Status: Run 'udos init'"
        fi
        ;;
    var)
        shift
        uvar "$@"
        ;;
    data)
        shift
        udata "$@"
        ;;
    tpl)
        shift
        utpl "$@"
        ;;
    role)
        udos-detect-role
        ;;
    help)
        echo "uDOS v${VERSION} Commands:"
        echo "  init     - Initialize uDOS"
        echo "  version  - Show version"
        echo "  info     - Show info"
        echo "  var      - Variable operations"
        echo "  data     - Data operations"
        echo "  tpl      - Template operations"
        echo "  role     - Show current role"
        echo "  help     - Show this help"
        ;;
    *)
        echo "uDOS v${VERSION} - Universal Data Operations System"
        echo "Usage: udos <command>"
        echo "Try: udos help"
        ;;
esac
EOF

# Create uvar command
echo "Installing uvar command..."
sudo tee /usr/local/bin/uvar > /dev/null << 'EOF'
#!/bin/sh
UDOS_HOME="${HOME}/.udos"
VAR_DIR="${UDOS_HOME}/vars"

case "$1" in
    set)
        mkdir -p "$VAR_DIR"
        echo "$3" > "${VAR_DIR}/$2"
        echo "Variable $2 set"
        ;;
    get)
        if [ -f "${VAR_DIR}/$2" ]; then
            cat "${VAR_DIR}/$2"
        else
            echo "Variable $2 not found"
        fi
        ;;
    list)
        if [ -d "$VAR_DIR" ]; then
            ls -la "$VAR_DIR"
        else
            echo "No variables set"
        fi
        ;;
    help)
        echo "uvar commands:"
        echo "  set KEY VALUE - Set variable"
        echo "  get KEY       - Get variable"
        echo "  list          - List variables"
        ;;
    *)
        echo "Usage: uvar set|get|list|help"
        ;;
esac
EOF

# Create udata command
echo "Installing udata command..."
sudo tee /usr/local/bin/udata > /dev/null << 'EOF'
#!/bin/sh
UDOS_HOME="${HOME}/.udos"
DATA_DIR="${UDOS_HOME}/data"

case "$1" in
    save)
        mkdir -p "$DATA_DIR"
        cat > "${DATA_DIR}/$2"
        echo "Data saved to $2"
        ;;
    load)
        if [ -f "${DATA_DIR}/$2" ]; then
            cat "${DATA_DIR}/$2"
        else
            echo "Data file $2 not found"
        fi
        ;;
    list)
        if [ -d "$DATA_DIR" ]; then
            ls -la "$DATA_DIR"
        else
            echo "No data files"
        fi
        ;;
    help)
        echo "udata commands:"
        echo "  save FILE - Save data to file"
        echo "  load FILE - Load data from file"
        echo "  list      - List data files"
        ;;
    *)
        echo "Usage: udata save|load|list|help"
        ;;
esac
EOF

# Create utpl command
echo "Installing utpl command..."
sudo tee /usr/local/bin/utpl > /dev/null << 'EOF'
#!/bin/sh
UDOS_HOME="${HOME}/.udos"
TPL_DIR="${UDOS_HOME}/templates"

case "$1" in
    create)
        mkdir -p "$TPL_DIR"
        cat > "${TPL_DIR}/$2"
        echo "Template $2 created"
        ;;
    use)
        if [ -f "${TPL_DIR}/$2" ]; then
            cat "${TPL_DIR}/$2"
        else
            echo "Template $2 not found"
        fi
        ;;
    list)
        if [ -d "$TPL_DIR" ]; then
            ls -la "$TPL_DIR"
        else
            echo "No templates"
        fi
        ;;
    help)
        echo "utpl commands:"
        echo "  create NAME - Create template"
        echo "  use NAME    - Use template"
        echo "  list        - List templates"
        ;;
    *)
        echo "Usage: utpl create|use|list|help"
        ;;
esac
EOF

# Create role detection
echo "Installing udos-detect-role..."
sudo tee /usr/local/bin/udos-detect-role > /dev/null << 'EOF'
#!/bin/sh
UDOS_HOME="${HOME}/.udos"
ROLE_FILE="${UDOS_HOME}/vars/USER_ROLE"

if [ -f "$ROLE_FILE" ]; then
    ROLE=$(cat "$ROLE_FILE")
else
    ROLE="APPRENTICE"
fi

echo "Current Role: $ROLE"
echo "Role Hierarchy: GHOST -> APPRENTICE -> SCRIBE -> SCHOLAR -> SAGE -> MASTER -> ARCHITECT -> WIZARD"
EOF

# Make all executable
echo "Setting permissions..."
sudo chmod +x /usr/local/bin/udos
sudo chmod +x /usr/local/bin/uvar
sudo chmod +x /usr/local/bin/udata
sudo chmod +x /usr/local/bin/utpl
sudo chmod +x /usr/local/bin/udos-detect-role

# Initialize
echo "Initializing uDOS..."
udos init

# Test installation
echo ""
echo "Testing installation..."
udos version
echo ""

echo "Installation Complete!"
echo "Try these commands:"
echo "  udos help"
echo "  udos var set TEST hello"
echo "  udos var get TEST"
echo "  udos role"
