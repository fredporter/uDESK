#!/bin/bash
# uDESK TODO Sync - Synchronize EXPRESS-DEV-TODOS.md with variable system
# Ensures consistency between markdown file and variable system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Sync changes from EXPRESS-DEV-TODOS.md to variable system
sync_to_variables() {
    echo "🔄 Syncing TODO changes to variable system..."
    "${SCRIPT_DIR}/todo-variables.sh" import
    echo "✅ Variable system updated"
}

# Show current sync status
show_sync_status() {
    echo "📊 TODO Sync Status"
    echo "═══════════════════"
    
    local express_file="${SCRIPT_DIR}/../EXPRESS-DEV-TODOS.md"
    local completed_in_file=$(grep -c "✅.*COMPLETED" "${express_file}" 2>/dev/null || echo "0")
    
    echo "Express Dev TODOs file: ${completed_in_file} completed"
    
    "${SCRIPT_DIR}/todo-variables.sh" list
}

# Auto-sync when TODO status changes
auto_sync() {
    echo "🔄 Auto-syncing TODO systems..."
    sync_to_variables
    
    # Update progress tracking
    if [[ -f "${SCRIPT_DIR}/sprint-progress.sh" ]]; then
        echo ""
        echo "📊 Updated Sprint Progress:"
        "${SCRIPT_DIR}/sprint-progress.sh" | head -20
    fi
}

case "${1:-status}" in
    "sync")
        sync_to_variables
        ;;
    "status")
        show_sync_status
        ;;
    "auto")
        auto_sync
        ;;
    *)
        echo "Usage: todo-sync [sync|status|auto]"
        exit 1
        ;;
esac
