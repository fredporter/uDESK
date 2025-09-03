#!/bin/sh
# uDOS Ecosystem Manager - Shell-based with Node.js detection
# Works with or without Node.js, provides enhanced features when available

VERSION="1.0.0"
UDOS_HOME="${UDOS_HOME:-$HOME/.udos}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
UDOS_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
ECOSYSTEM_DIR="$SCRIPT_DIR"
PLUGINS_DIR="$UDOS_ROOT/share/udos/plugins"
CONFIG_DIR="$UDOS_ROOT/etc/udos"

# Color output
log() { echo "${2:+$2 }$1"; }
err() { echo "❌ $1" >&2; }
info() { echo "ℹ️  $1"; }

# Initialize directories
init_dirs() {
    mkdir -p "$UDOS_HOME/ecosystem/cache"
    mkdir -p "$UDOS_HOME/ecosystem/installed"
    mkdir -p "$PLUGINS_DIR/core"
    mkdir -p "$PLUGINS_DIR/community"
    mkdir -p "$PLUGINS_DIR/local"
    mkdir -p "$CONFIG_DIR/security"
}

# Check Node.js availability
check_nodejs() {
    if command -v node >/dev/null 2>&1; then
        NODE_AVAILABLE=true
        NODE_VERSION=$(node --version)
        log "Node.js available: $NODE_VERSION" "✅"
        return 0
    else
        NODE_AVAILABLE=false
        log "Node.js not available - using basic mode" "⚠️"
        return 1
    fi
}

# Install Node.js on TinyCore
install_nodejs() {
    if ! command -v tce-load >/dev/null 2>&1; then
        err "TinyCore package manager not found"
        info "This feature requires TinyCore Linux"
        return 1
    fi
    
    log "Installing Node.js..." "📦"
    
    if tce-load -wi nodejs 2>/dev/null; then
        log "Node.js installed successfully" "✅"
        check_nodejs
        return 0
    else
        err "Failed to install Node.js"
        info "Try: tce-load -wi nodejs"
        return 1
    fi
}

# Plugin registry management (shell-based)
registry_file="$UDOS_HOME/ecosystem/registry.txt"

registry_add() {
    plugin_id="$1"
    plugin_name="$2"
    plugin_version="$3"
    plugin_type="${4:-local}"
    
    # Format: id|name|version|type|installed_date
    echo "$plugin_id|$plugin_name|$plugin_version|$plugin_type|$(date +%Y-%m-%d)" >> "$registry_file"
}

registry_remove() {
    plugin_id="$1"
    
    if [ -f "$registry_file" ]; then
        grep -v "^$plugin_id|" "$registry_file" > "$registry_file.tmp"
        mv "$registry_file.tmp" "$registry_file"
    fi
}

registry_list() {
    if [ ! -f "$registry_file" ]; then
        echo "No plugins installed"
        return
    fi
    
    echo "Installed Plugins:"
    echo ""
    
    while IFS='|' read -r id name version type installed; do
        [ -z "$id" ] && continue
        
        # Check if plugin still exists
        plugin_dir="$PLUGINS_DIR/$type/$id"
        if [ -d "$plugin_dir" ]; then
            status="✅"
        else
            status="❌"
        fi
        
        echo "  $status $name ($id)"
        echo "      Version: $version"
        echo "      Type: $type"
        echo "      Installed: $installed"
        echo ""
    done < "$registry_file"
}

registry_get() {
    plugin_id="$1"
    
    if [ -f "$registry_file" ]; then
        grep "^$plugin_id|" "$registry_file" | head -1
    fi
}

# Plugin management
install_plugin() {
    plugin_name="$1"
    
    if [ -z "$plugin_name" ]; then
        err "Plugin name required"
        echo "Usage: udos ecosystem install <name>"
        return 1
    fi
    
    log "Installing plugin: $plugin_name" "🔄"
    
    # Generate plugin ID
    plugin_id=$(echo "$plugin_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    plugin_dir="$PLUGINS_DIR/local/$plugin_id"
    
    if [ -d "$plugin_dir" ]; then
        err "Plugin '$plugin_name' already installed"
        return 1
    fi
    
    # Create plugin directory
    mkdir -p "$plugin_dir"
    
    # Create plugin manifest
    cat > "$plugin_dir/manifest.txt" << EOF
name=$plugin_name
id=$plugin_id
version=1.0.0
type=local
author=Local User
created=$(date +%Y-%m-%d)
description=Local plugin: $plugin_name
main=plugin.sh
EOF
    
    # Create basic plugin script
    cat > "$plugin_dir/plugin.sh" << EOF
#!/bin/sh
# $plugin_name Plugin for uDOS
# Generated: $(date)

PLUGIN_NAME="$plugin_name"
PLUGIN_VERSION="1.0.0"

show_help() {
    echo "📖 \$PLUGIN_NAME Plugin Commands:"
    echo "  help     Show this help"
    echo "  status   Show plugin status"
    echo "  info     Show plugin information"
}

show_status() {
    echo "✅ \$PLUGIN_NAME is running"
    echo "Version: \$PLUGIN_VERSION"
}

show_info() {
    echo "Plugin: \$PLUGIN_NAME"
    echo "Version: \$PLUGIN_VERSION"
    echo "Type: Local"
    echo "Status: Active"
}

# Command handling
case "\${1:-help}" in
    help|--help|-h)
        show_help
        ;;
    status)
        show_status
        ;;
    info)
        show_info
        ;;
    *)
        echo "❌ Unknown command: \$1"
        show_help
        exit 1
        ;;
esac
EOF
    
    chmod +x "$plugin_dir/plugin.sh"
    
    # Register plugin
    registry_add "$plugin_id" "$plugin_name" "1.0.0" "local"
    
    log "Plugin '$plugin_name' installed successfully" "✅"
    log "Location: $plugin_dir" "📁"
    log "Test with: udos ecosystem run $plugin_id help" "🔧"
}

remove_plugin() {
    plugin_id="$1"
    
    if [ -z "$plugin_id" ]; then
        err "Plugin ID required"
        echo "Usage: udos ecosystem remove <id>"
        return 1
    fi
    
    # Find plugin info
    plugin_info=$(registry_get "$plugin_id")
    if [ -z "$plugin_info" ]; then
        err "Plugin '$plugin_id' not found"
        return 1
    fi
    
    # Extract plugin type
    plugin_type=$(echo "$plugin_info" | cut -d'|' -f4)
    plugin_dir="$PLUGINS_DIR/$plugin_type/$plugin_id"
    
    log "Removing plugin: $plugin_id" "🗑"
    
    # Remove plugin directory
    if [ -d "$plugin_dir" ]; then
        rm -rf "$plugin_dir"
    fi
    
    # Remove from registry
    registry_remove "$plugin_id"
    
    log "Plugin '$plugin_id' removed successfully" "✅"
}

run_plugin() {
    plugin_id="$1"
    shift
    command="${1:-help}"
    
    if [ -z "$plugin_id" ]; then
        err "Plugin ID required"
        echo "Usage: udos ecosystem run <id> [command]"
        return 1
    fi
    
    # Find plugin
    plugin_info=$(registry_get "$plugin_id")
    if [ -z "$plugin_info" ]; then
        err "Plugin '$plugin_id' not found"
        info "List plugins with: udos ecosystem list"
        return 1
    fi
    
    # Extract plugin details
    plugin_type=$(echo "$plugin_info" | cut -d'|' -f4)
    plugin_dir="$PLUGINS_DIR/$plugin_type/$plugin_id"
    
    # Find plugin script
    if [ -f "$plugin_dir/plugin.sh" ]; then
        plugin_script="$plugin_dir/plugin.sh"
    elif [ -f "$plugin_dir/index.js" ] && [ "$NODE_AVAILABLE" = "true" ]; then
        plugin_script="$plugin_dir/index.js"
    else
        err "Plugin script not found or incompatible"
        return 1
    fi
    
    log "Running plugin: $plugin_id" "🚀"
    
    # Execute plugin
    if echo "$plugin_script" | grep -q "\.js$"; then
        node "$plugin_script" "$@"
    else
        "$plugin_script" "$@"
    fi
}

info_plugin() {
    plugin_id="$1"
    
    if [ -z "$plugin_id" ]; then
        err "Plugin ID required"
        echo "Usage: udos ecosystem info <id>"
        return 1
    fi
    
    plugin_info=$(registry_get "$plugin_id")
    if [ -z "$plugin_info" ]; then
        err "Plugin '$plugin_id' not found"
        return 1
    fi
    
    # Parse plugin info
    plugin_name=$(echo "$plugin_info" | cut -d'|' -f2)
    plugin_version=$(echo "$plugin_info" | cut -d'|' -f3)
    plugin_type=$(echo "$plugin_info" | cut -d'|' -f4)
    plugin_installed=$(echo "$plugin_info" | cut -d'|' -f5)
    
    echo "📦 Plugin Information: $plugin_name"
    echo ""
    echo "ID: $plugin_id"
    echo "Version: $plugin_version"
    echo "Type: $plugin_type"
    echo "Installed: $plugin_installed"
    
    # Check plugin directory
    plugin_dir="$PLUGINS_DIR/$plugin_type/$plugin_id"
    if [ -d "$plugin_dir" ]; then
        echo "Status: ✅ Available"
        echo "Location: $plugin_dir"
        
        # Check for manifest
        if [ -f "$plugin_dir/manifest.txt" ]; then
            description=$(grep "^description=" "$plugin_dir/manifest.txt" | cut -d'=' -f2-)
            author=$(grep "^author=" "$plugin_dir/manifest.txt" | cut -d'=' -f2-)
            [ "$description" ] && echo "Description: $description"
            [ "$author" ] && echo "Author: $author"
        fi
    else
        echo "Status: ❌ Missing"
    fi
}

update_ecosystem() {
    log "Updating ecosystem..." "🔄"
    
    # Check Node.js availability
    check_nodejs
    
    # Validate installed plugins
    if [ -f "$registry_file" ]; then
        working=0
        total=0
        
        while IFS='|' read -r id name version type installed; do
            [ -z "$id" ] && continue
            total=$((total + 1))
            
            plugin_dir="$PLUGINS_DIR/$type/$id"
            if [ -d "$plugin_dir" ]; then
                working=$((working + 1))
            else
                log "Plugin '$id' directory missing" "⚠️"
            fi
        done < "$registry_file"
        
        log "Ecosystem update complete - $working/$total plugins working" "✅"
    else
        log "No plugins installed" "💡"
    fi
}

# Enhanced mode with Node.js
use_enhanced_mode() {
    if [ "$NODE_AVAILABLE" = "true" ] && [ -f "$ECOSYSTEM_DIR/udos-ecosystem.js" ]; then
        log "Using enhanced Node.js mode" "🚀"
        UDOS_ROOT="$UDOS_ROOT" node "$ECOSYSTEM_DIR/udos-ecosystem.js" "$@"
        return $?
    else
        return 1
    fi
}

# Main command handling
init_dirs
check_nodejs

# Try enhanced mode first if available
if [ "$1" != "install-nodejs" ] && use_enhanced_mode "$@" 2>/dev/null; then
    exit $?
fi

# Fall back to basic mode
case "${1:-help}" in
    help|--help|-h)
        echo "🌐 uDOS Ecosystem Manager v$VERSION"
        echo ""
        echo "Mode: $(if [ "$NODE_AVAILABLE" = "true" ]; then echo "Enhanced (Node.js)"; else echo "Basic (Shell)"; fi)"
        echo ""
        echo "Commands:"
        echo "  install <name>          Install a plugin"
        echo "  remove <id>             Remove a plugin"
        echo "  list                    List installed plugins"
        echo "  run <id> [command]      Run a plugin command"
        echo "  info <id>               Show plugin information"
        echo "  update                  Update ecosystem"
        if [ "$NODE_AVAILABLE" = "false" ]; then
            echo "  install-nodejs          Install Node.js (TinyCore only)"
        fi
        echo ""
        echo "Examples:"
        echo "  udos ecosystem install my-plugin"
        echo "  udos ecosystem list"
        echo "  udos ecosystem run my-plugin status"
        ;;
    install)
        shift
        install_plugin "$@"
        ;;
    remove)
        shift
        remove_plugin "$@"
        ;;
    list)
        registry_list
        ;;
    run)
        shift
        run_plugin "$@"
        ;;
    info)
        shift
        info_plugin "$@"
        ;;
    update)
        update_ecosystem
        ;;
    install-nodejs)
        install_nodejs
        ;;
    *)
        err "Unknown command: $1"
        echo "💡 Use: udos ecosystem help"
        exit 1
        ;;
esac
