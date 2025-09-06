#!/bin/bash
# uDESK TODO Variable System v1.0.7.3
# Integrates TODOs as first-class citizens in uMEMORY/workflows/

set -e

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ucode-input.sh"

# uDESK Variable System Paths
UDESK_ROOT="$HOME/uDESK"
UMEMORY_ROOT="${UDESK_ROOT}/uMEMORY"
WORKFLOWS_ROOT="${UMEMORY_ROOT}/workflows"
VARIABLES_ROOT="${UMEMORY_ROOT}/variables"
TODOS_ROOT="${WORKFLOWS_ROOT}/todos"

# TODO Variable Structure
TODO_REGISTRY="${VARIABLES_ROOT}/todo-registry.conf"
TODO_ACTIVE="${VARIABLES_ROOT}/todo-active.conf"
TODO_COMPLETED="${VARIABLES_ROOT}/todo-completed.conf"
TODO_METADATA="${VARIABLES_ROOT}/todo-metadata.json"

# Ensure uDESK directory structure exists
init_udesk_variable_system() {
    echo "🔧 Initializing uDESK TODO Variable System..."
    
    # Create required directories
    mkdir -p "${UMEMORY_ROOT}"/{variables,workflows/{todos,missions,milestones,moves,goals}}
    mkdir -p "${TODOS_ROOT}"/{active,completed,archived}
    
    # Initialize variable files if they don't exist
    if [[ ! -f "${TODO_REGISTRY}" ]]; then
        cat > "${TODO_REGISTRY}" << 'EOF'
# uDESK TODO Registry - Variable System Integration
# Format: TODO_ID=STATUS:PRIORITY:CATEGORY:TIMESTAMP
# Status: ACTIVE, IN_PROGRESS, COMPLETED, ARCHIVED
# Priority: HIGH, MEDIUM, LOW
# Category: EXPRESS_DEV, WORKFLOW, CHESTER, INFRASTRUCTURE

TODO_REGISTRY_VERSION=1.0.7.3
TODO_SYSTEM_INITIALIZED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF
        echo "✅ Created TODO registry: ${TODO_REGISTRY}"
    fi
    
    if [[ ! -f "${TODO_ACTIVE}" ]]; then
        cat > "${TODO_ACTIVE}" << 'EOF'
# Active TODO Variables
# Auto-managed by uDESK TODO Variable System
ACTIVE_TODO_COUNT=0
CURRENT_MILESTONE=""
CURRENT_SPRINT="v1.0.7.3"
IN_PROGRESS_TODOS=""
EOF
        echo "✅ Created active TODO variables: ${TODO_ACTIVE}"
    fi
    
    if [[ ! -f "${TODO_COMPLETED}" ]]; then
        cat > "${TODO_COMPLETED}" << 'EOF'
# Completed TODO Variables  
# Auto-managed by uDESK TODO Variable System
COMPLETED_TODO_COUNT=0
LAST_COMPLETED_TODO=""
LAST_COMPLETION_TIME=""
COMPLETION_STREAK=0
EOF
        echo "✅ Created completed TODO variables: ${TODO_COMPLETED}"
    fi
    
    if [[ ! -f "${TODO_METADATA}" ]]; then
        cat > "${TODO_METADATA}" << 'EOF'
{
  "system_version": "1.0.7.3",
  "initialized": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "total_todos": 0,
  "active_sprint": "v1.0.7.3",
  "milestones": {
    "express_dev_system": {
      "todos": ["TODO-001", "TODO-002", "TODO-003", "TODO-004", "TODO-005"],
      "status": "COMPLETED",
      "completion_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    },
    "workflow_system": {
      "todos": ["TODO-006", "TODO-007", "TODO-008", "TODO-009", "TODO-010"],
      "status": "IN_PROGRESS",
      "completion_date": null
    },
    "chester_desktop": {
      "todos": ["TODO-011", "TODO-012", "TODO-013", "TODO-014"],
      "status": "PENDING",
      "completion_date": null
    },
    "infrastructure": {
      "todos": ["TODO-015", "TODO-016", "TODO-017", "TODO-018"],
      "status": "PENDING", 
      "completion_date": null
    }
  }
}
EOF
        echo "✅ Created TODO metadata: ${TODO_METADATA}"
    fi
    
    echo "✅ uDESK TODO Variable System initialized"
}

# Import TODOs from EXPRESS-DEV-TODOS.md into variable system
import_express_todos() {
    local express_file="${SCRIPT_DIR}/../uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md"
    
    if [[ ! -f "${express_file}" ]]; then
        echo "❌ EXPRESS-DEV-TODOS.md not found"
        return 1
    fi
    
    echo "📥 Importing TODOs from EXPRESS-DEV-TODOS.md..."
    
    # Clear existing registry entries
    sed -i.bak '/^TODO-/d' "${TODO_REGISTRY}"
    rm -f "${TODO_REGISTRY}.bak"
    
    # Reset counters
    echo "ACTIVE_TODO_COUNT=0" > "${TODO_ACTIVE}"
    echo "COMPLETED_TODO_COUNT=0" > "${TODO_COMPLETED}"
    
    local active_count=0
    local completed_count=0
    local in_progress_todos=""
    local last_completed=""
    local last_completed_time=""
    
    # Parse EXPRESS-DEV-TODOS.md and import to variable system
    while IFS= read -r line; do
        if [[ "$line" =~ ^//[[:space:]]*TODO-([0-9]+):[[:space:]]*(.*)$ ]]; then
            local todo_id="TODO-${BASH_REMATCH[1]}"
            local todo_content="${BASH_REMATCH[2]}"
            
            # Determine status, priority, and category
            local status="ACTIVE"
            local priority="MEDIUM"
            local category="EXPRESS_DEV"
            
            if [[ "$todo_content" =~ ✅.*COMPLETED ]]; then
                status="COMPLETED"
                ((completed_count++))
                last_completed="$todo_id"
                last_completed_time="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
            elif [[ "$todo_content" =~ 🚧.*IN\ PROGRESS ]]; then
                status="IN_PROGRESS"
                ((active_count++))
                if [[ -n "$in_progress_todos" ]]; then
                    in_progress_todos="${in_progress_todos},$todo_id"
                else
                    in_progress_todos="$todo_id"
                fi
            else
                ((active_count++))
            fi
            
            # Determine category based on TODO number
            if [[ "${BASH_REMATCH[1]}" -le 5 ]]; then
                category="EXPRESS_DEV"
                priority="HIGH"
            elif [[ "${BASH_REMATCH[1]}" -le 10 ]]; then
                category="WORKFLOW"
                priority="HIGH"
            elif [[ "${BASH_REMATCH[1]}" -le 14 ]]; then
                category="CHESTER"
                priority="MEDIUM"
            else
                category="INFRASTRUCTURE"
                priority="MEDIUM"
            fi
            
            # Add to registry
            echo "${todo_id}=${status}:${priority}:${category}:$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "${TODO_REGISTRY}"
            
            # Create individual TODO variable file
            local todo_file="${TODOS_ROOT}/active/${todo_id}.conf"
            if [[ "$status" == "COMPLETED" ]]; then
                todo_file="${TODOS_ROOT}/completed/${todo_id}.conf"
            fi
            
            cat > "${todo_file}" << EOF
# uDESK TODO Variable: ${todo_id}
TODO_ID="${todo_id}"
TODO_STATUS="${status}"
TODO_PRIORITY="${priority}"
TODO_CATEGORY="${category}"
TODO_DESCRIPTION="${todo_content}"
TODO_CREATED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
TODO_UPDATED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
EOF
        fi
    done < "${express_file}"
    
    # Update active TODO variables
    cat >> "${TODO_ACTIVE}" << EOF
CURRENT_MILESTONE="workflow_system"
CURRENT_SPRINT="v1.0.7.3"
ACTIVE_TODO_COUNT=${active_count}
IN_PROGRESS_TODOS="${in_progress_todos}"
EOF
    
    # Update completed TODO variables
    cat >> "${TODO_COMPLETED}" << EOF
COMPLETED_TODO_COUNT=${completed_count}
LAST_COMPLETED_TODO="${last_completed}"
LAST_COMPLETION_TIME="${last_completed_time}"
COMPLETION_STREAK=${completed_count}
EOF
    
    echo "✅ Imported ${active_count} active and ${completed_count} completed TODOs"
}

# Get TODO variable value
get_todo_variable() {
    local todo_id="$1"
    local variable="$2"
    
    # Look for TODO in active or completed directories
    for todo_dir in "${TODOS_ROOT}/active" "${TODOS_ROOT}/completed"; do
        local todo_file="${todo_dir}/${todo_id}.conf"
        if [[ -f "${todo_file}" ]]; then
            source "${todo_file}"
            case "${variable}" in
                "status") echo "${TODO_STATUS}" ;;
                "priority") echo "${TODO_PRIORITY}" ;;
                "category") echo "${TODO_CATEGORY}" ;;
                "description") echo "${TODO_DESCRIPTION}" ;;
                "created") echo "${TODO_CREATED}" ;;
                "updated") echo "${TODO_UPDATED}" ;;
                *) echo "Unknown variable: ${variable}" ;;
            esac
            return 0
        fi
    done
    
    echo "TODO not found: ${todo_id}"
    return 1
}

# Set TODO variable value
set_todo_variable() {
    local todo_id="$1"
    local variable="$2"  
    local value="$3"
    
    # Find TODO file
    for todo_dir in "${TODOS_ROOT}/active" "${TODOS_ROOT}/completed"; do
        local todo_file="${todo_dir}/${todo_id}.conf"
        if [[ -f "${todo_file}" ]]; then
            # Update the variable
            case "${variable}" in
                "status")
                    sed -i.bak "s/TODO_STATUS=.*/TODO_STATUS=\"${value}\"/" "${todo_file}"
                    ;;
                "priority")
                    sed -i.bak "s/TODO_PRIORITY=.*/TODO_PRIORITY=\"${value}\"/" "${todo_file}"
                    ;;
                "description")
                    sed -i.bak "s/TODO_DESCRIPTION=.*/TODO_DESCRIPTION=\"${value}\"/" "${todo_file}"
                    ;;
                *)
                    echo "Cannot set variable: ${variable}"
                    return 1
                    ;;
            esac
            
            # Update timestamp
            sed -i.bak "s/TODO_UPDATED=.*/TODO_UPDATED=\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"/" "${todo_file}"
            rm -f "${todo_file}.bak"
            
            echo "✅ Updated ${todo_id}.${variable} = ${value}"
            return 0
        fi
    done
    
    echo "❌ TODO not found: ${todo_id}"
    return 1
}

# List all TODO variables
list_todo_variables() {
    echo "📊 uDESK TODO Variable System Status"
    echo "═══════════════════════════════════"
    
    # Load counters
    source "${TODO_ACTIVE}"
    source "${TODO_COMPLETED}"
    
    echo "📈 System Status:"
    echo "  Active TODOs: ${ACTIVE_TODO_COUNT}"
    echo "  Completed TODOs: ${COMPLETED_TODO_COUNT}"
    echo "  Current Sprint: ${CURRENT_SPRINT}"
    echo "  Current Milestone: ${CURRENT_MILESTONE}"
    
    if [[ -n "${IN_PROGRESS_TODOS}" ]]; then
        echo "  In Progress: ${IN_PROGRESS_TODOS}"
    fi
    
    if [[ -n "${LAST_COMPLETED_TODO}" ]]; then
        echo "  Last Completed: ${LAST_COMPLETED_TODO} (${LAST_COMPLETION_TIME})"
    fi
    
    echo ""
    echo "📋 TODO Registry Summary:"
    
    # Show categorized TODO counts
    local express_count=$(grep -c ":EXPRESS_DEV:" "${TODO_REGISTRY}" 2>/dev/null || echo "0")
    local workflow_count=$(grep -c ":WORKFLOW:" "${TODO_REGISTRY}" 2>/dev/null || echo "0")
    local chester_count=$(grep -c ":CHESTER:" "${TODO_REGISTRY}" 2>/dev/null || echo "0")
    local infra_count=$(grep -c ":INFRASTRUCTURE:" "${TODO_REGISTRY}" 2>/dev/null || echo "0")
    
    echo "  Express Dev: ${express_count} TODOs"
    echo "  Workflow: ${workflow_count} TODOs"
    echo "  CHESTER: ${chester_count} TODOs"
    echo "  Infrastructure: ${infra_count} TODOs"
}

# Show specific TODO variables
show_todo_details() {
    local todo_id="$1"
    
    if [[ -z "$todo_id" ]]; then
        prompt_text "Enter TODO ID (e.g., TODO-006)" todo_id
    fi
    
    echo "📋 TODO Variable Details: ${todo_id}"
    echo "═══════════════════════════════════"
    
    for variable in status priority category description created updated; do
        local value=$(get_todo_variable "$todo_id" "$variable")
        echo "  ${variable}: ${value}"
    done
}

# Command interface
case "${1:-init}" in
    "init"|"initialize")
        init_udesk_variable_system
        ;;
    "import")
        init_udesk_variable_system
        import_express_todos
        ;;
    "get")
        get_todo_variable "$2" "$3"
        ;;
    "set")
        set_todo_variable "$2" "$3" "$4"
        ;;
    "list"|"status")
        list_todo_variables
        ;;
    "show"|"details")
        show_todo_details "$2"
        ;;
    "help"|"--help")
        echo "🔧 uDESK TODO Variable System Commands"
        echo "════════════════════════════════════"
        echo ""
        echo "Commands:"
        echo "  todo-vars init                    # Initialize variable system"
        echo "  todo-vars import                  # Import from EXPRESS-DEV-TODOS.md"
        echo "  todo-vars list                    # Show system status"
        echo "  todo-vars show [TODO-ID]          # Show TODO details"
        echo "  todo-vars get [TODO-ID] [VAR]     # Get variable value"
        echo "  todo-vars set [TODO-ID] [VAR] [VAL] # Set variable value"
        echo ""
        echo "Integration with uDESK variable system:"
        echo "• TODOs stored in uMEMORY/workflows/todos/"
        echo "• Variables accessible system-wide"
        echo "• Registry maintained in uMEMORY/variables/"
        echo "• TinyCore extension compatible"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'todo-vars help' for available commands"
        exit 1
        ;;
esac
