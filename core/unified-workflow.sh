#!/bin/bash
# uDESK Unified Workflow Management Commands v1.0.7.3
# Comprehensive commands integrating all workflow components

set -e

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ucode-input.sh"

# Unified command framework
WORKFLOW_COMMANDS_VERSION="1.0.7.3"

# Command categories (bash 3.2 compatible)
WORKFLOW_CATEGORIES_todo="TODO management and tracking"
WORKFLOW_CATEGORIES_progress="Sprint and milestone progress"
WORKFLOW_CATEGORIES_assist="AI-powered development assistance"
WORKFLOW_CATEGORIES_vars="Variable system management"
WORKFLOW_CATEGORIES_checkpoint="Milestone checkpoints"
WORKFLOW_CATEGORIES_sync="System synchronization"
WORKFLOW_CATEGORIES_status="Comprehensive status overview"
WORKFLOW_CATEGORIES_hierarchy="Mission/milestone/move relationships"
WORKFLOW_CATEGORIES_advance="Intelligent workflow advancement"
WORKFLOW_CATEGORIES_organize="Repository structure management"

# Show unified workflow command menu
show_workflow_menu() {
    echo "🔧 uDESK Unified Workflow Management v${WORKFLOW_COMMANDS_VERSION}"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "🎯 **WORKFLOW CATEGORIES**"
    echo ""
    
    local categories="todo progress assist vars checkpoint sync status hierarchy advance organize"
    for category in $categories; do
        local desc_var="WORKFLOW_CATEGORIES_${category}"
        local description="${!desc_var}"
        echo "📋 **${category^^}**: ${description}"
        show_category_commands "$category"
        echo ""
    done
    
    echo "💡 **QUICK ACTIONS**"
    echo "  workflow overview         # Complete system status"
    echo "  workflow next             # Get next recommended action"
    echo "  workflow complete [TODO]  # Mark TODO complete + sync all"
    echo "  workflow start [TODO]     # Start TODO + update all systems"
    echo ""
}

# Show commands for a specific category
show_category_commands() {
    local category="$1"
    
    case "$category" in
        "todo")
            echo "    todo list             # List all TODOs"
            echo "    todo show [ID]        # Show TODO details" 
            echo "    todo complete [ID]    # Mark TODO complete"
            echo "    todo start [ID]       # Start TODO (in progress)"
            ;;
        "progress")
            echo "    progress show         # Full sprint progress"
            echo "    progress milestones   # Milestone status"
            echo "    progress summary      # Quick progress summary"
            ;;
        "assist")
            echo "    assist run            # Context suggestions"
            echo "    assist show           # Interactive suggestions"
            echo "    assist config         # Configure auto-assist"
            ;;
        "vars")
            echo "    vars list             # Variable system status"
            echo "    vars show [TODO]      # TODO variable details"
            echo "    vars get [TODO] [VAR] # Get variable value"
            echo "    vars set [TODO] [VAR] [VAL] # Set variable"
            ;;
        "checkpoint")
            echo "    checkpoint check      # Auto-check milestones"
            echo "    checkpoint create     # Manual checkpoint"
            echo "    checkpoint history    # Show checkpoint history"
            ;;
        "sync")
            echo "    sync auto             # Full system sync"
            echo "    sync status           # Show sync status"
            ;;
        "status")
            echo "    status overview       # Complete system status"
            echo "    status quick          # Quick status summary"
            ;;
        "hierarchy")
            echo "    hierarchy show        # Complete hierarchy view"
            echo "    hierarchy integrated  # Unified workflow integration"
            echo "    hierarchy context [TODO] # TODO hierarchy context"
            echo "    hierarchy next        # Next recommended TODO"
            ;;
        "advance")
            echo "    advance report        # Comprehensive advancement report"
            echo "    advance analyze       # Analyze current TODO state"
            echo "    advance suggest       # Get intelligent action suggestions"
            echo "    advance track         # Track workflow momentum"
            ;;
        "organize")
            echo "    organize              # Auto-organize misplaced files"
            echo "    check-structure       # Show current repository structure"
            ;;
    esac
}

# Unified TODO management with full integration
unified_todo_command() {
    local action="$1"
    local todo_id="$2"
    
    case "$action" in
        "list")
            echo "📋 UNIFIED TODO OVERVIEW"
            echo "═══════════════════════"
            "${SCRIPT_DIR}/sprint-progress.sh" | head -15
            echo ""
            echo "🔧 Variable System Status:"
            "${SCRIPT_DIR}/todo-variables.sh" list | tail -10
            ;;
        "show")
            if [[ -z "$todo_id" ]]; then
                prompt_text "Enter TODO ID (e.g., TODO-007)" todo_id
            fi
            echo "📋 UNIFIED TODO DETAILS: ${todo_id}"
            echo "═══════════════════════════════"
            echo ""
            echo "🔧 Variable System:"
            "${SCRIPT_DIR}/todo-variables.sh" show "$todo_id"
            echo ""
            echo "📊 Sprint Context:"
            grep "$todo_id" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" || echo "Not found in sprint file"
            ;;
        "complete")
            if [[ -z "$todo_id" ]]; then
                prompt_text "Enter TODO ID to complete (e.g., TODO-007)" todo_id
            fi
            
            echo "🎯 UNIFIED TODO COMPLETION: ${todo_id}"
            echo "═══════════════════════════════════════"
            echo ""
            
            # Update sprint tracking
            echo "1️⃣ Updating sprint progress..."
            "${SCRIPT_DIR}/todo-management.sh" complete "${todo_id#TODO-}"
            
            # Update variable system
            echo "2️⃣ Updating variable system..."
            "${SCRIPT_DIR}/todo-variables.sh" set "$todo_id" status COMPLETED
            
            # Sync all systems
            echo "3️⃣ Synchronizing all systems..."
            "${SCRIPT_DIR}/todo-sync.sh" auto >/dev/null
            
            # Check for milestone completion
            echo "4️⃣ Checking milestone completion..."
            "${SCRIPT_DIR}/milestone-checkpoints.sh" check
            
            # Show auto-assist for next steps
            echo "5️⃣ Getting next recommendations..."
            echo ""
            "${SCRIPT_DIR}/auto-assist.sh" run
            
            echo "✅ UNIFIED TODO COMPLETION SUCCESSFUL!"
            ;;
        "start")
            if [[ -z "$todo_id" ]]; then
                prompt_text "Enter TODO ID to start (e.g., TODO-008)" todo_id
            fi
            
            echo "🚀 UNIFIED TODO START: ${todo_id}"
            echo "═══════════════════════════════"
            echo ""
            
            # Update sprint tracking
            echo "1️⃣ Marking as in progress..."
            "${SCRIPT_DIR}/todo-management.sh" start "${todo_id#TODO-}"
            
            # Update variable system
            echo "2️⃣ Updating variable system..."
            "${SCRIPT_DIR}/todo-variables.sh" set "$todo_id" status IN_PROGRESS
            
            # Sync systems
            echo "3️⃣ Synchronizing systems..."
            "${SCRIPT_DIR}/todo-sync.sh" auto >/dev/null
            
            # Show context-aware assistance
            echo "4️⃣ Getting contextual assistance..."
            echo ""
            "${SCRIPT_DIR}/auto-assist.sh" show
            
            echo "✅ UNIFIED TODO START SUCCESSFUL!"
            ;;
        *)
            echo "Unknown TODO action: $action"
            echo "Available: list, show, complete, start"
            return 1
            ;;
    esac
}

# Unified progress tracking with all components
unified_progress_command() {
    local action="$1"
    
    case "$action" in
        "show"|"")
            echo "📊 UNIFIED PROGRESS OVERVIEW"
            echo "═══════════════════════════════"
            "${SCRIPT_DIR}/sprint-progress.sh"
            echo ""
            echo "🔧 Variable System Integration:"
            "${SCRIPT_DIR}/todo-variables.sh" list | tail -8
            ;;
        "milestones")
            echo "🏆 UNIFIED MILESTONE STATUS"
            echo "═══════════════════════════"
            "${SCRIPT_DIR}/sprint-progress.sh" | grep -A 20 "MILESTONE STATUS:"
            echo ""
            "${SCRIPT_DIR}/milestone-checkpoints.sh" history
            ;;
        "summary")
            echo "📈 QUICK PROGRESS SUMMARY"
            echo "═══════════════════════"
            local completed=$(grep -c "✅.*COMPLETED" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md")
            local total=18
            local percentage=$((completed * 100 / total))
            echo "  Overall: ${completed}/${total} TODOs (${percentage}%)"
            echo "  Express Dev: ✅ COMPLETE (5/5)"
            echo "  Workflow: 🚧 IN PROGRESS ($(grep -E "TODO-00[6-9]|TODO-010" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | grep -c "✅.*COMPLETED")/5)"
            echo "  CHESTER: ⏳ PENDING (0/4)"
            echo "  Infrastructure: ⏳ PENDING (0/4)"
            ;;
        *)
            echo "Unknown progress action: $action"
            echo "Available: show, milestones, summary"
            return 1
            ;;
    esac
}

# Unified status overview combining all systems
unified_status_overview() {
    echo "🎯 uDESK UNIFIED WORKFLOW STATUS"
    echo "═══════════════════════════════════════════════════════════"
    echo "Version: ${WORKFLOW_COMMANDS_VERSION} | $(date)"
    echo ""
    
    # Quick sprint summary
    echo "📊 SPRINT SUMMARY"
    echo "─────────────────"
    unified_progress_command summary
    echo ""
    
    # Variable system health
    echo "🔧 VARIABLE SYSTEM"
    echo "──────────────────"
    "${SCRIPT_DIR}/todo-variables.sh" list | grep -E "(Active TODOs|Completed TODOs|Current)"
    echo ""
    
    # Auto-assist status
    echo "🤖 AUTO-ASSIST STATUS"
    echo "─────────────────────"
    "${SCRIPT_DIR}/auto-assist.sh" status | tail -5
    echo ""
    
    # Recent activity
    echo "📈 RECENT ACTIVITY"
    echo "──────────────────"
    echo "Last 3 completed TODOs:"
    grep "✅.*COMPLETED" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | tail -3 | sed 's|^// ||'
    echo ""
    
    # Next recommended action
    echo "🎯 NEXT RECOMMENDED ACTION"
    echo "──────────────────────────"
    local next_todo=$(grep -E "TODO-[0-9]+:" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | grep -v "✅.*COMPLETED" | head -1 | sed 's|^// ||' | cut -d: -f1)
    if [[ -n "$next_todo" ]]; then
        echo "  ⚡ Start: ${next_todo}"
        echo "  💡 Command: workflow start ${next_todo}"
    else
        echo "  🎉 All TODOs completed!"
    fi
}

# Get next recommended action with context
get_next_action() {
    echo "🎯 NEXT ACTION RECOMMENDATION"
    echo "═══════════════════════════════"
    
    # Find next TODO
    local next_todo=$(grep -E "TODO-[0-9]+:" "${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | grep -v "✅.*COMPLETED" | head -1)
    
    if [[ -n "$next_todo" ]]; then
        local todo_id=$(echo "$next_todo" | sed 's|^// ||' | cut -d: -f1)
        local todo_desc=$(echo "$next_todo" | sed 's|^//[^:]*: ||')
        
        echo "📋 Next TODO: ${todo_id}"
        echo "📝 Description: ${todo_desc}"
        echo ""
        echo "🚀 Quick start: workflow start ${todo_id}"
        echo "📊 More info: workflow todo show ${todo_id}"
        echo ""
        
        # Get contextual assistance
        echo "💡 AI Suggestions:"
        "${SCRIPT_DIR}/auto-assist.sh" run
    else
        echo "🎉 All TODOs completed! Time to plan next sprint."
    fi
}

# Main unified command dispatcher
case "${1:-help}" in
    "menu"|"help"|"--help")
        show_workflow_menu
        ;;
    "overview"|"status")
        unified_status_overview
        ;;
    "next")
        get_next_action
        ;;
    "complete")
        unified_todo_command complete "$2"
        ;;
    "start")
        unified_todo_command start "$2"
        ;;
    "todo")
        unified_todo_command "${@:2}"
        ;;
    "progress")
        unified_progress_command "${@:2}"
        ;;
    "assist")
        "${SCRIPT_DIR}/auto-assist.sh" "${@:2}"
        ;;
    "vars")
        "${SCRIPT_DIR}/todo-variables.sh" "${@:2}"
        ;;
    "checkpoint")
        "${SCRIPT_DIR}/milestone-checkpoints.sh" "${@:2}"
        ;;
    "sync")
        "${SCRIPT_DIR}/todo-sync.sh" "${@:2}"
        ;;
    "hierarchy")
        "${SCRIPT_DIR}/hierarchy-integration.sh" "${@:2}"
        ;;
    "advance")
        if [ -f "${SCRIPT_DIR}/workflow-advancement.sh" ]; then
            "${SCRIPT_DIR}/workflow-advancement.sh" "${@:2}"
        else
            echo "❌ Workflow advancement engine not found"
        fi
        ;;
    "organize"|"clean")
        echo "🧹 Organizing repository structure..."
        "${SCRIPT_DIR}/../uMEMORY/sandbox/scripts/organize-files.sh"
        ;;
    "check-structure")
        echo "📁 Current repository structure:"
        echo "================================"
        echo "📋 Root files:"
        ls -1 "${SCRIPT_DIR}/.." | grep -v "^\." | head -20
        echo ""
        echo "📋 uMEMORY structure:"
        ls -la "${SCRIPT_DIR}/../uMEMORY/" | grep "^d" | awk '{print "   " $9}'
        ;;
    *)
        echo "🔧 uDESK Unified Workflow Management"
        echo "Available commands: menu, overview, next, complete, start, todo, progress, assist, vars, checkpoint, sync, hierarchy, advance, organize, check-structure"
        echo "Use 'workflow menu' for full command reference"
        exit 1
        ;;
esac
