#!/bin/bash
# uDESK Hierarchy Integration System v1.0.7.3
# Enhanced Mission/Milestone/Move/TODO relationship management

set -e

# Set script directory and source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Only source variable functions without interactive components
TODO_VARS_SCRIPT="$SCRIPT_DIR/todo-variables.sh"

# Configuration
WORKFLOW_DIR="$HOME/uDESK/uMEMORY/workflows"
EXPRESS_TODOS="$SCRIPT_DIR/../EXPRESS-DEV-TODOS.md"

# Colors for hierarchy visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Ensure directories exist
mkdir -p "$WORKFLOW_DIR"/{goals,missions,milestones,moves,todos}

# ═══════════════════════════════════════════════════════════════════════
# CORE HIERARCHY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════

# Get real TODO status from EXPRESS-DEV-TODOS.md and variable system
get_real_todo_status() {
    local todo_id="$1"
    
    if [[ -f "$EXPRESS_TODOS" ]]; then
        if grep -q "^// $todo_id: ✅.*COMPLETED" "$EXPRESS_TODOS"; then
            echo "COMPLETED"
        elif grep -q "^// $todo_id:" "$EXPRESS_TODOS"; then
            # Check if variable system file exists and get status
            local var_file="$HOME/uDESK/uMEMORY/variables/todo-active.conf"
            if [[ -f "$var_file" ]]; then
                local status=$(grep "^${todo_id}\.status=" "$var_file" 2>/dev/null | cut -d'=' -f2 || echo "ACTIVE")
                case "$status" in
                    "IN_PROGRESS") echo "IN_PROGRESS" ;;
                    "COMPLETED") echo "COMPLETED" ;;
                    *) echo "ACTIVE" ;;
                esac
            else
                echo "ACTIVE"
            fi
        else
            echo "NOT_FOUND"
        fi
    else
        echo "NO_TODO_FILE"
    fi
}

# Get TODO description from EXPRESS-DEV-TODOS.md
get_real_todo_description() {
    local todo_id="$1"
    
    if [[ -f "$EXPRESS_TODOS" ]]; then
        grep "^// $todo_id:" "$EXPRESS_TODOS" | head -1 | sed "s|^// $todo_id: ||" | sed 's|✅ ||' | sed 's| - COMPLETED||'
    else
        echo "TODO description not found"
    fi
}

# Get all active TODOs from EXPRESS-DEV-TODOS.md
get_active_todos() {
    if [[ -f "$EXPRESS_TODOS" ]]; then
        grep "^// TODO-" "$EXPRESS_TODOS" | grep -v "✅.*COMPLETED" | sed 's|^// ||' | sed 's|:.*||' | sort -V
    fi
}

# Get completed TODOs from EXPRESS-DEV-TODOS.md
get_completed_todos() {
    if [[ -f "$EXPRESS_TODOS" ]]; then
        grep "^// TODO-" "$EXPRESS_TODOS" | grep "✅.*COMPLETED" | sed 's|^// ||' | sed 's|:.*||' | sort -V
    fi
}

# ═══════════════════════════════════════════════════════════════════════
# MISSION-MILESTONE-MOVE-TODO RELATIONSHIP MAPPING
# ═══════════════════════════════════════════════════════════════════════

# Define hierarchical relationships based on current sprint structure
get_mission_for_todo() {
    local todo_id="$1"
    local todo_num=$(echo "$todo_id" | sed 's/TODO-0*//')
    
    # Based on EXPRESS-DEV-TODOS.md structure - use string comparison to avoid octal issues
    if [[ "$todo_num" =~ ^[1-5]$ ]]; then
        echo "Express Dev Foundation"
    elif [[ "$todo_num" =~ ^[6-9]$ ]] || [[ "$todo_num" == "10" ]]; then
        echo "Workflow System Implementation"
    elif [[ "$todo_num" =~ ^1[1-4]$ ]]; then
        echo "CHESTER AI Integration"
    else
        echo "Infrastructure Enhancement"
    fi
}

# Get milestone for TODO based on sprint structure
get_milestone_for_todo() {
    local todo_id="$1"
    local todo_num=$(echo "$todo_id" | sed 's/TODO-0*//')
    
    if [[ "$todo_num" =~ ^[1-5]$ ]]; then
        echo "Express Dev System Complete"
    elif [[ "$todo_num" =~ ^[6-7]$ ]]; then
        echo "Unified Workflow Commands"
    elif [[ "$todo_num" =~ ^[8-9]$ ]] || [[ "$todo_num" == "10" ]]; then
        echo "Advanced Workflow Engine"
    elif [[ "$todo_num" =~ ^1[1-2]$ ]]; then
        echo "CHESTER Core Integration"
    elif [[ "$todo_num" =~ ^1[3-4]$ ]]; then
        echo "CHESTER Advanced Features"
    else
        echo "Production Infrastructure"
    fi
}

# Get move (action sequence) for TODO
get_move_for_todo() {
    local todo_id="$1"
    local description=$(get_real_todo_description "$todo_id")
    
    # Generate move name based on TODO description
    if [[ "$description" =~ "system" || "$description" =~ "integration" ]]; then
        echo "System Integration Move"
    elif [[ "$description" =~ "hierarchy" || "$description" =~ "workflow" ]]; then
        echo "Workflow Enhancement Move"
    elif [[ "$description" =~ "engine" || "$description" =~ "advancement" ]]; then
        echo "Development Engine Move"
    elif [[ "$description" =~ "AI" || "$description" =~ "assist" ]]; then
        echo "AI Enhancement Move"
    else
        echo "Implementation Move"
    fi
}

# ═══════════════════════════════════════════════════════════════════════
# ENHANCED HIERARCHY VISUALIZATION
# ═══════════════════════════════════════════════════════════════════════

# Enhanced integration with unified workflow system
integrate_with_unified_workflow() {
    echo "🔗 HIERARCHY INTEGRATION WITH UNIFIED WORKFLOW"
    echo "═══════════════════════════════════════════════"
    echo ""
    
    # Current TODO in progress
    local current_todo=$(get_hierarchy_next_todo)
    if [[ "$current_todo" != "No active TODOs found" ]]; then
        echo "📍 CURRENT FOCUS:"
        get_todo_hierarchy_context "$current_todo"
        echo ""
    fi
    
    # Show integrated status
    show_hierarchy_progress
}

# Enhanced workflow hierarchy with real TODO integration
show_enhanced_hierarchy() {
    echo "🎯 uDESK ENHANCED WORKFLOW HIERARCHY"
    echo "════════════════════════════════════"
    echo ""
    echo "📊 LIVE HIERARCHY STATUS:"
    echo "─────────────────────────"
    
    echo -e "${BOLD}🌟 GOAL: Personal Growth Through Systems Mastery${NC}"
    echo ""
    
    # Display each mission with its TODOs
    for mission in "Express Dev Foundation" "Workflow System Implementation" "CHESTER AI Integration" "Infrastructure Enhancement"; do
        local mission_todos=$(get_todos_for_mission "$mission")
        
        if [[ -n "$mission_todos" ]]; then
            local mission_status=$(get_mission_completion_status "$mission")
            local mission_color=$([[ "$mission_status" == "COMPLETE" ]] && echo "$GREEN" || echo "$CYAN")
            
            echo -e "${mission_color}🎯 MISSION: $mission ($mission_status)${NC}"
            
            # Get unique milestones for this mission
            local milestones_seen=""
            for todo in $mission_todos; do
                local milestone=$(get_milestone_for_todo "$todo")
                
                # Only process if we haven't seen this milestone before
                if [[ "$milestones_seen" != *"|$milestone|"* ]]; then
                    milestones_seen="$milestones_seen|$milestone|"
                    
                    local milestone_status=$(get_milestone_completion_status "$milestone")
                    local milestone_color=$([[ "$milestone_status" == "COMPLETE" ]] && echo "$GREEN" || echo "$YELLOW")
                    
                    echo -e "   ${milestone_color}🏆 MILESTONE: $milestone ($milestone_status)${NC}"
                    
                    # Get TODOs for this milestone
                    local milestone_todos=$(get_todos_for_milestone "$milestone")
                    for mtodo in $milestone_todos; do
                        local move=$(get_move_for_todo "$mtodo")
                        local todo_status=$(get_real_todo_status "$mtodo")
                        local todo_color=$([[ "$todo_status" == "COMPLETED" ]] && echo "$GREEN" || echo "$RED")
                        local todo_desc=$(get_real_todo_description "$mtodo")
                        
                        echo -e "      ${PURPLE}⚡ MOVE: $move${NC}"
                        echo -e "         ${todo_color}📋 $mtodo: $todo_desc ($todo_status)${NC}"
                    done
                fi
            done
            echo ""
        fi
    done
}

# Get mission completion status
get_mission_completion_status() {
    local mission="$1"
    local todos=($(get_todos_for_mission "$mission"))
    local total=0
    local completed=0
    
    for todo in "${todos[@]}"; do
        ((total++))
        local status=$(get_real_todo_status "$todo")
        if [[ "$status" == "COMPLETED" ]]; then
            ((completed++))
        fi
    done
    
    if [[ $total -eq 0 ]]; then
        echo "NO_TODOS"
    elif [[ $completed -eq $total ]]; then
        echo "COMPLETE"
    elif [[ $completed -gt 0 ]]; then
        echo "IN_PROGRESS ($completed/$total)"
    else
        echo "PENDING"
    fi
}

# Get milestone completion status
get_milestone_completion_status() {
    local milestone="$1"
    local todos=($(get_todos_for_milestone "$milestone"))
    local total=0
    local completed=0
    
    for todo in "${todos[@]}"; do
        ((total++))
        local status=$(get_real_todo_status "$todo")
        if [[ "$status" == "COMPLETED" ]]; then
            ((completed++))
        fi
    done
    
    if [[ $total -eq 0 ]]; then
        echo "NO_TODOS"
    elif [[ $completed -eq $total ]]; then
        echo "COMPLETE"
    elif [[ $completed -gt 0 ]]; then
        echo "IN_PROGRESS ($completed/$total)"
    else
        echo "PENDING"
    fi
}

# Get TODOs for a specific mission
get_todos_for_mission() {
    local mission="$1"
    local all_todos=($(get_active_todos) $(get_completed_todos))
    
    for todo in "${all_todos[@]}"; do
        local todo_mission=$(get_mission_for_todo "$todo")
        if [[ "$todo_mission" == "$mission" ]]; then
            echo "$todo"
        fi
    done
}

# Get TODOs for a specific milestone
get_todos_for_milestone() {
    local milestone="$1"
    local all_todos=($(get_active_todos) $(get_completed_todos))
    
    for todo in "${all_todos[@]}"; do
        local todo_milestone=$(get_milestone_for_todo "$todo")
        if [[ "$todo_milestone" == "$milestone" ]]; then
            echo "$todo"
        fi
    done
}

# ═══════════════════════════════════════════════════════════════════════
# HIERARCHY ANALYSIS AND INSIGHTS
# ═══════════════════════════════════════════════════════════════════════

# Show hierarchy progress summary
show_hierarchy_progress() {
    echo "📊 HIERARCHY PROGRESS SUMMARY"
    echo "═════════════════════════════"
    echo ""
    
    # Mission progress
    echo "🎯 MISSION PROGRESS:"
    echo "───────────────────"
    for mission in "Express Dev Foundation" "Workflow System Implementation" "CHESTER AI Integration" "Infrastructure Enhancement"; do
        local status=$(get_mission_completion_status "$mission")
        local color=$([[ "$status" =~ "COMPLETE" ]] && echo "$GREEN" || echo "$YELLOW")
        echo -e "   ${color}$mission: $status${NC}"
    done
    
    echo ""
    echo "🏆 MILESTONE PROGRESS:"
    echo "─────────────────────"
    for milestone in "Express Dev System Complete" "Unified Workflow Commands" "Advanced Workflow Engine" "CHESTER Core Integration" "CHESTER Advanced Features" "Production Infrastructure"; do
        local status=$(get_milestone_completion_status "$milestone")
        local color=$([[ "$status" =~ "COMPLETE" ]] && echo "$GREEN" || echo "$YELLOW")
        echo -e "   ${color}$milestone: $status${NC}"
    done
    
    echo ""
    echo "⚡ ACTIVE MOVES:"
    echo "──────────────"
    local active_todos=($(get_active_todos))
    for todo in "${active_todos[@]}"; do
        local move=$(get_move_for_todo "$todo")
        local status=$(get_real_todo_status "$todo")
        local color=$([[ "$status" == "IN_PROGRESS" ]] && echo "$PURPLE" || echo "$CYAN")
        echo -e "   ${color}$move (via $todo)${NC}"
    done
}

# ═══════════════════════════════════════════════════════════════════════
# INTEGRATION WITH UNIFIED WORKFLOW SYSTEM
# ═══════════════════════════════════════════════════════════════════════

# Get next recommended TODO based on hierarchy
get_hierarchy_next_todo() {
    local active_todos=($(get_active_todos))
    
    if [[ ${#active_todos[@]} -gt 0 ]]; then
        # Return the lowest numbered active TODO
        echo "${active_todos[0]}"
    else
        echo "No active TODOs found"
    fi
}

# Get hierarchy context for a TODO
get_todo_hierarchy_context() {
    local todo_id="$1"
    
    echo "📋 HIERARCHY CONTEXT FOR $todo_id"
    echo "═════════════════════════════════"
    echo "🎯 Mission: $(get_mission_for_todo "$todo_id")"
    echo "🏆 Milestone: $(get_milestone_for_todo "$todo_id")"
    echo "⚡ Move: $(get_move_for_todo "$todo_id")"
    echo "📝 Description: $(get_real_todo_description "$todo_id")"
    echo "🔄 Status: $(get_real_todo_status "$todo_id")"
}

# Main command interface
main() {
    case "${1:-show}" in
        "show"|"hierarchy")
            show_enhanced_hierarchy
            ;;
        "progress")
            show_hierarchy_progress
            ;;
        "integrated"|"unified")
            integrate_with_unified_workflow
            ;;
        "context")
            if [[ -n "$2" ]]; then
                get_todo_hierarchy_context "$2"
            else
                echo "Usage: $0 context TODO-XXX"
                exit 1
            fi
            ;;
        "next")
            get_hierarchy_next_todo
            ;;
        "help")
            echo "🎯 uDESK Hierarchy Integration Commands:"
            echo "  show        - Display complete hierarchy with real data"
            echo "  progress    - Show mission/milestone progress summary"
            echo "  integrated  - Show integrated view with unified workflow"
            echo "  context ID  - Show hierarchy context for specific TODO"
            echo "  next        - Get next recommended TODO from hierarchy"
            echo "  help        - Show this help message"
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use '$0 help' for available commands"
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
