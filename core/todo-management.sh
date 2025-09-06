#!/bin/bash
# uDESK Express Dev - TODO Management Integration
# Integrates VSCode TODO Tree with uDESK workflow system

set -e

# Source dependencies  
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ucode-input.sh"

# Configuration
TODO_FILE="${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md"
SPRINT_VERSION="v1.0.7.3"

# TODO Management Functions
show_todo_status() {
    echo "=== uDESK Express Dev TODO Status ==="
    echo "Sprint: ${SPRINT_VERSION}"
    echo "File: ${TODO_FILE}"
    echo ""
    
    # Count completed vs total TODOs
    local completed=$(grep -c "✅.*COMPLETED" "${TODO_FILE}" 2>/dev/null || echo "0")
    local total=$(grep -c "TODO-[0-9]" "${TODO_FILE}" 2>/dev/null || echo "0")
    local in_progress=$(grep -c "🚧.*IN PROGRESS" "${TODO_FILE}" 2>/dev/null || echo "0")
    
    echo "Progress: ${completed}/${total} completed, ${in_progress} in progress"
    echo ""
    
    # Show milestones
    echo "=== Milestones ==="
    grep "MILESTONE:" "${TODO_FILE}" | while read -r line; do
        echo "  ${line}"
    done
    echo ""
    
    # Show active TODOs
    echo "=== Active TODOs ==="
    grep -E "TODO-[0-9]+:" "${TODO_FILE}" | grep -v "✅.*COMPLETED" | while read -r line; do
        echo "  ${line}"
    done
}

mark_todo_completed() {
    local todo_num="$1"
    if [[ -z "$todo_num" ]]; then
        prompt_text "Enter TODO number (e.g., 003)" todo_num
    fi
    
    local todo_pattern="TODO-${todo_num}:"
    
    if grep -q "${todo_pattern}" "${TODO_FILE}"; then
        # Replace status with completed
        sed -i.bak "s|${todo_pattern}.*|${todo_pattern} ✅ $(sed -n "s|.*${todo_pattern}[^-]*\(.*\) -.*|\1|p" "${TODO_FILE}" | head -1) - COMPLETED|" "${TODO_FILE}"
        echo "✅ Marked TODO-${todo_num} as completed"
        
        # Remove backup file
        rm -f "${TODO_FILE}.bak"
        
        # Check if milestone is complete
        check_milestone_completion
    else
        echo "❌ TODO-${todo_num} not found"
        return 1
    fi
}

mark_todo_in_progress() {
    local todo_num="$1"
    if [[ -z "$todo_num" ]]; then
        prompt_text "Enter TODO number (e.g., 004)" todo_num
    fi
    
    local todo_pattern="TODO-${todo_num}:"
    
    if grep -q "${todo_pattern}" "${TODO_FILE}"; then
        # Replace status with in progress
        sed -i.bak "s|${todo_pattern}.*|${todo_pattern} 🚧 $(sed -n "s|.*${todo_pattern}[^-]*\(.*\) -.*|\1|p" "${TODO_FILE}" | head -1) - IN PROGRESS|" "${TODO_FILE}"
        echo "🚧 Marked TODO-${todo_num} as in progress"
        
        # Remove backup file
        rm -f "${TODO_FILE}.bak"
    else
        echo "❌ TODO-${todo_num} not found"
        return 1
    fi
}

check_milestone_completion() {
    echo ""
    echo "=== Checking Milestone Completion ==="
    
    # Express Dev System (TODO-001 to TODO-005)
    local express_completed=$(grep -E "TODO-00[1-5]:.*✅.*COMPLETED" "${TODO_FILE}" | wc -l | tr -d ' ')
    if [[ "$express_completed" == "5" ]]; then
        echo "🎯 MILESTONE: Express Dev System Complete!"
    else
        echo "📋 Express Dev System: ${express_completed}/5 completed"
    fi
    
    # Workflow System (TODO-006 to TODO-010) 
    local workflow_completed=$(grep -E "TODO-0(0[6-9]|10):.*✅.*COMPLETED" "${TODO_FILE}" | wc -l | tr -d ' ')
    if [[ "$workflow_completed" == "5" ]]; then
        echo "🎯 MILESTONE: Workflow System Complete!"
    else
        echo "📋 Workflow System: ${workflow_completed}/5 completed"
    fi
    
    # CHEST Desktop (TODO-011 to TODO-014)
    local chest_completed=$(grep -E "TODO-01[1-4]:.*✅.*COMPLETED" "${TODO_FILE}" | wc -l | tr -d ' ')
    if [[ "$chest_completed" == "4" ]]; then
        echo "🎯 MILESTONE: CHEST Desktop Complete!"
    else
        echo "📋 CHEST Desktop: ${chest_completed}/4 completed"
    fi
    
    # Infrastructure (TODO-015 to TODO-018)
    local infra_completed=$(grep -E "TODO-01[5-8]:.*✅.*COMPLETED" "${TODO_FILE}" | wc -l | tr -d ' ')
    if [[ "$infra_completed" == "4" ]]; then
        echo "🎯 MILESTONE: Infrastructure Complete!"
    else
        echo "📋 Infrastructure: ${infra_completed}/4 completed"
    fi
    
    # Overall sprint completion
    local total_completed=$(grep -E "TODO-[0-9]+:.*✅.*COMPLETED" "${TODO_FILE}" | wc -l | tr -d ' ')
    if [[ "$total_completed" == "18" ]]; then
        echo ""
        echo "🚀 MISSION COMPLETE: uDESK Express Dev Mode ${SPRINT_VERSION} ready for release!"
    fi
}

open_in_vscode() {
    echo "Opening TODO Tree in VSCode..."
    code "${TODO_FILE}"
    
    # Show command palette hint
    echo ""
    echo "💡 Tips for VSCode TODO Tree:"
    echo "  - Press Ctrl+Shift+P and search 'Todo Tree' to access commands"
    echo "  - View TODO Tree panel in Explorer sidebar"
    echo "  - Click on any TODO to jump to its location"
    echo "  - TODOs are color-coded: ✅ Green (completed), 🚧 Yellow (in progress)"
}

# Main command interface
case "${1:-status}" in
    "status"|"show")
        show_todo_status
        ;;
    "complete"|"done")
        mark_todo_completed "$2"
        ;;
    "start"|"progress")
        mark_todo_in_progress "$2"
        ;;
    "milestone"|"milestones")
        check_milestone_completion
        ;;
    "vscode"|"open")
        open_in_vscode
        ;;
    "help"|"--help")
        echo "uDESK TODO Management Commands:"
        echo "  todo status          - Show current TODO status"
        echo "  todo complete [NUM]  - Mark TODO-NUM as completed"
        echo "  todo start [NUM]     - Mark TODO-NUM as in progress"
        echo "  todo milestones      - Check milestone completion"
        echo "  todo vscode          - Open TODO Tree in VSCode"
        echo ""
        echo "Examples:"
        echo "  todo complete 004    - Mark TODO-004 as completed"
        echo "  todo start 005       - Mark TODO-005 as in progress"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'todo help' for available commands"
        exit 1
        ;;
esac
