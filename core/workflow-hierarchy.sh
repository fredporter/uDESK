#!/bin/bash
# uDESK Unified Workflow Hierarchy System v1.0.7.3
# Goal → Mission → Milestone → Move → TODO structure
# Enhanced with real TODO integration

set -e

# Set script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source uCODE input for consistency
source "$(dirname "${BASH_SOURCE[0]}")/ucode-input.sh"

# Source the enhanced hierarchy integration
source "$(dirname "${BASH_SOURCE[0]}")/hierarchy-integration.sh"

WORKFLOW_DIR="$HOME/uDESK/uMEMORY/workflows"
mkdir -p "$WORKFLOW_DIR"/{goals,missions,milestones,moves,todos}

# Colors for hierarchy visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Enhanced hierarchy display using new integration
show_hierarchy() {
    show_enhanced_hierarchy
}

# Show integration with unified workflow
show_unified_integration() {
    integrate_with_unified_workflow
}

# Show active workflow status
show_active_hierarchy() {
    local active_mission=$(get_active_mission)
    
    if [[ -n "$active_mission" ]]; then
        echo -e "   ${GREEN}🎯 Active Mission: $active_mission${NC}"
        
        # Related Milestones  
        local milestones=$(get_mission_milestones "$active_mission")
        if [[ -n "$milestones" ]]; then
            local milestone_count=$(echo "$milestones" | wc -l | tr -d ' ')
            local milestone_label=$(format_plural "MILESTONE" "$milestone_count")
            echo -e "   ${BLUE}   🏆 $milestone_label:${NC}"
            while IFS= read -r milestone; do
                local status=$(get_milestone_status "$milestone")
                local color=$([[ "$status" == "COMPLETE" ]] && echo "$GREEN" || echo "$YELLOW")
                echo -e "      ${color}• $milestone ($status)${NC}"
                
                # Related Moves
                local moves=$(get_milestone_moves "$milestone")
                if [[ -n "$moves" ]]; then
                    while IFS= read -r move; do
                        local move_status=$(get_move_status "$move")
                        local move_color=$([[ "$move_status" == "COMPLETE" ]] && echo "$GREEN" || echo "$PURPLE")
                        echo -e "         ${move_color}⚡ $move ($move_status)${NC}"
                        
                        # Related TODOs
                        local todos=$(get_move_todos "$move")
                        if [[ -n "$todos" ]]; then
                            while IFS= read -r todo; do
                                local todo_status=$(get_todo_status "$todo")
                                local todo_color=$([[ "$todo_status" == "COMPLETE" ]] && echo "$GREEN" || echo "$RED")
                                echo -e "            ${todo_color}📋 $todo ($todo_status)${NC}"
                            done <<< "$todos"
                        fi
                    done <<< "$moves"
                fi
            done <<< "$milestones"
        fi
    else
        echo -e "   ${RED}⚠️  No active mission found${NC}"
        echo -e "   ${BLUE}💡 Use: workflow mission create${NC}"
    fi
}

# Get current active goal
get_active_goal() {
    local goal_file="$WORKFLOW_DIR/goals/active.md"
    if [[ -f "$goal_file" ]]; then
        grep "^# " "$goal_file" | head -1 | sed 's/^# 🌟 GOAL: //'
    else
        echo "No active goal defined"
    fi
}

# Get current active mission
get_active_mission() {
    local mission_file="$WORKFLOW_DIR/missions/active.md"
    if [[ -f "$mission_file" ]]; then
        grep "^# " "$mission_file" | head -1 | sed 's/^# //'
    fi
}

# Get milestones for a mission
get_mission_milestones() {
    local mission="$1"
    local mission_file="$WORKFLOW_DIR/missions/active.md"
    if [[ -f "$mission_file" ]]; then
        awk '/^## MILESTONES/,/^## / {
            if (/^- \[/) print $0
        }' "$mission_file" | sed 's/^- \[.\] //'
    fi
}

# Get milestone status
get_milestone_status() {
    local milestone="$1"
    local milestone_file="$WORKFLOW_DIR/milestones/${milestone// /-}.md"
    if [[ -f "$milestone_file" ]]; then
        if grep -q "Status: COMPLETE" "$milestone_file"; then
            echo "COMPLETE"
        elif grep -q "Status: IN_PROGRESS" "$milestone_file"; then
            echo "IN_PROGRESS"
        else
            echo "PENDING"
        fi
    else
        echo "NOT_FOUND"
    fi
}

# Get moves for a milestone
get_milestone_moves() {
    local milestone="$1"
    echo "Move 1: Implementation"
    echo "Move 2: Testing"
}

# Get move status
get_move_status() {
    local move="$1"
    # Placeholder - would check actual move files
    echo "PENDING"
}

# Get todos for a move
get_move_todos() {
    local move="$1"
    echo "TODO-001: Start implementation"
    echo "TODO-002: Write tests"
}

# Get todo status
get_todo_status() {
    local todo="$1"
    # Placeholder - would check actual todo files
    echo "PENDING"
}

# Check if todo is completed
check_todo_completed() {
    local todo_id="$1"
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    for file in $todo_files; do
        if grep -q "✅.*$todo_id:" "$file"; then
            return 0
        fi
    done
    return 1
}

# Create new goal
create_goal() {
    echo "🌟 GOAL CREATION WIZARD"
    echo "═══════════════════════"
    echo ""
    
    local goal_name
    goal_name=$(prompt_text "🌟 Enter ultimate goal name")
    
    local goal_description
    goal_description=$(prompt_text "📝 Enter goal description")
    
    local timeframe
    timeframe=$(prompt_ucode "⏰ Goal timeframe" "1-YEAR|2-YEARS|5-YEARS|LIFETIME" "2-YEARS")
    
    echo ""
    echo "🌟 GOAL SUMMARY:"
    echo "   Name: $goal_name"
    echo "   Description: $goal_description" 
    echo "   Timeframe: $timeframe"
    echo ""
    
    local confirm
    confirm=$(prompt_confirm_modify "🎯 Create this ultimate goal")
    
    if [[ "$confirm" == "CONFIRM" ]]; then
        local goal_file="$WORKFLOW_DIR/goals/goal-$(date +%Y%m%d-%H%M%S).md"
        cat > "$goal_file" << EOF
# 🌟 GOAL: $goal_name

**Created:** $(date)
**Timeframe:** $timeframe
**Status:** ACTIVE

## Description
$goal_description

## Purpose
This represents the ultimate purpose and direction for personal growth.

## Related Missions
<!-- Missions that support this goal will be listed here -->

## Progress Tracking
- [ ] Initial goal defined
- [ ] Supporting missions created
- [ ] First milestone achieved
- [ ] Regular progress reviews

---
*Generated by uDESK Workflow Hierarchy System v1.0.7.3*
EOF
        
        echo "✅ Goal created: $goal_file"
        growth_message "Goal creation builds long-term vision and purpose" "success"
    else
        echo "🔄 Goal creation cancelled"
    fi
}

# Create new mission
create_mission() {
    echo "🎯 MISSION CREATION WIZARD"
    echo "═══════════════════════════"
    echo ""
    
    local mission_name
    mission_name=$(prompt_text "⚡ Enter mission name")
    
    local mission_description
    mission_description=$(prompt_text "📝 Enter mission description")
    
    local duration
    duration=$(prompt_duration "⏰ Mission duration")
    
    echo ""
    echo "🎯 MISSION SUMMARY:"
    echo "   Name: $mission_name"
    echo "   Description: $mission_description" 
    echo "   Duration: $duration"
    echo ""
    
    local confirm
    confirm=$(prompt_confirm_modify "🎯 Create this mission")
    
    if [[ "$confirm" == "CONFIRM" ]]; then
        local mission_file="$WORKFLOW_DIR/missions/active.md"
        cat > "$mission_file" << EOF
# 🎯 MISSION: $mission_name

**Created:** $(date)
**Duration:** $duration
**Status:** ACTIVE

## Description
$mission_description

## MILESTONES
- [ ] Milestone 1: Planning phase
- [ ] Milestone 2: Implementation
- [ ] Milestone 3: Testing & validation

## SUCCESS CRITERIA
- [ ] All milestones completed
- [ ] Objectives achieved
- [ ] Documentation complete

---
*Mission created: $(date)*
EOF
        
        echo "✅ Mission created: $mission_file"
        echo "💡 Next: Add milestones with 'workflow milestone create'"
        growth_message "Mission planning develops strategic thinking" "success"
    else
        echo "🔄 Mission creation cancelled"
    fi
}

# Create new milestone
create_milestone() {
    echo "🏆 MILESTONE CREATION WIZARD"
    echo "════════════════════════════"
    echo ""
    
    local active_mission=$(get_active_mission)
    if [[ -z "$active_mission" ]]; then
        echo "⚠️  No active mission found!"
        echo "💡 Create a mission first with 'workflow mission create'"
        return 1
    fi
    
    echo "Adding milestone to: $active_mission"
    echo ""
    
    local milestone_name
    milestone_name=$(prompt_text "🏆 Enter milestone name")
    
    local milestone_description
    milestone_description=$(prompt_text "📝 Enter milestone description")
    
    echo ""
    echo "🏆 MILESTONE SUMMARY:"
    echo "   Mission: $active_mission"
    echo "   Name: $milestone_name"
    echo "   Description: $milestone_description"
    echo ""
    
    local confirm
    confirm=$(prompt_confirm_modify "🏆 Create this milestone")
    
    if [[ "$confirm" == "CONFIRM" ]]; then
        local milestone_file="$WORKFLOW_DIR/milestones/${milestone_name// /-}.md"
        cat > "$milestone_file" << EOF
# 🏆 MILESTONE: $milestone_name

**Created:** $(date)
**Mission**: $active_mission  
**Description**: $milestone_description

## OVERVIEW
$milestone_description

## MOVES
- [ ] Move 1: Plan implementation
- [ ] Move 2: Execute development
- [ ] Move 3: Test and validate

## SUCCESS CRITERIA
- [ ] All moves completed
- [ ] Acceptance criteria met
- [ ] Testing passed

---
*Milestone created: $(date)*
EOF
        
        # Add to mission file
        sed -i.bak "/## MILESTONES/a\\
- [ ] $milestone_name" "$WORKFLOW_DIR/missions/active.md"
        
        echo "✅ Milestone created: $milestone_file"
        echo "💡 Next: Create moves with 'workflow move create'"
        growth_message "Milestone planning breaks down complex goals" "success"
    else
        echo "🔄 Milestone creation cancelled"
    fi
}

# Main command processing
case "${1:-help}" in
    "show"|"status"|"hierarchy")
        show_hierarchy
        ;;
    "goal")
        case "${2:-show}" in
            "create") create_goal ;;
            "show"|*) echo "Goal: $(get_active_goal)" ;;
        esac
        ;;
    "mission")
        case "${2:-show}" in
            "create") create_mission ;;
            "show"|*) echo "Mission: $(get_active_mission)" ;;
        esac
        ;;
    "milestone")
        case "${2:-show}" in
            "create") create_milestone ;;
            "show"|*) get_mission_milestones "$(get_active_mission)" ;;
        esac
        ;;
    "todo")
        case "${2:-show}" in
            "create") create_todo ;;
            "show"|*) get_milestone_todos "$(get_active_milestone)" ;;
        esac
        ;;
    "sprint")
        # Integration with TODO management system
        if [[ -f "${SCRIPT_DIR}/todo-management.sh" ]]; then
            "${SCRIPT_DIR}/todo-management.sh" "${@:2}"
        else
            echo "❌ TODO management system not available at ${SCRIPT_DIR}/todo-management.sh"
            exit 1
        fi
        ;;
    "assist")
        # Integration with auto-assist system
        if [[ -f "${SCRIPT_DIR}/auto-assist.sh" ]]; then
            "${SCRIPT_DIR}/auto-assist.sh" "${@:2}"
        else
            echo "❌ Auto-assist system not available"
            exit 1
        fi
        ;;
    "progress")
        # Integration with sprint progress tracking
        if [[ -f "${SCRIPT_DIR}/sprint-progress.sh" ]]; then
            "${SCRIPT_DIR}/sprint-progress.sh"
        else
            echo "❌ Sprint progress system not available"
            exit 1
        fi
        ;;
    "checkpoint")
        # Integration with milestone checkpoint system
        if [[ -f "${SCRIPT_DIR}/milestone-checkpoints.sh" ]]; then
            "${SCRIPT_DIR}/milestone-checkpoints.sh" "${@:2}"
        else
            echo "❌ Milestone checkpoint system not available"
            exit 1
        fi
        ;;
    "vars"|"variables")
        # Integration with TODO variable system
        if [[ -f "${SCRIPT_DIR}/todo-variables.sh" ]]; then
            "${SCRIPT_DIR}/todo-variables.sh" "${@:2}"
        else
            echo "❌ TODO variable system not available"
            exit 1
        fi
        ;;
    "unified"|"udos")
        # Unified workflow management system
        if [[ -f "${SCRIPT_DIR}/unified-workflow.sh" ]]; then
            "${SCRIPT_DIR}/unified-workflow.sh" "${@:2}"
        else
            echo "❌ Unified workflow system not available"
            exit 1
        fi
        ;;
    "integrated"|"enhanced")
        # Enhanced hierarchy integration
        show_unified_integration
        ;;
    "context")
        # Show TODO hierarchy context
        if [[ -n "$2" ]]; then
            get_todo_hierarchy_context "$2"
        else
            echo "Usage: workflow context TODO-XXX"
            exit 1
        fi
        ;;
    "next")
        # Get next recommended TODO
        get_hierarchy_next_todo
        ;;
    "help"|"--help"|"-h")
        echo "🎯 uDESK Workflow Hierarchy v1.0.7.3"
        echo "════════════════════════════════════"
        echo ""
        echo "📊 Hierarchy Display:"
        echo "  workflow show             # Show complete hierarchy with real TODO data"
        echo "  workflow integrated       # Show integrated view with unified workflow"
        echo "  workflow context TODO-XXX # Show hierarchy context for specific TODO"
        echo "  workflow next             # Get next recommended TODO from hierarchy"
        echo ""
        echo "🔧 Hierarchy Management:"
        echo "  workflow goal create      # Create new ultimate goal"
        echo "  workflow mission create   # Create new mission"
        echo "  workflow milestone create # Create new milestone"
        echo "  workflow move create      # Create new move"
        echo "  workflow todo create      # Create new todo"
        echo ""
        echo "⚡ System Integration:"
        echo "  workflow sprint [cmd]     # TODO management (status/complete/start)"
        echo "  workflow assist [cmd]     # Auto-assist suggestions (run/show/config)"
        echo "  workflow progress         # Show comprehensive sprint progress"
        echo "  workflow checkpoint [cmd] # Milestone checkpoints (check/create/history)"
        echo "  workflow vars [cmd]       # TODO variable system (list/show/get/set)"
        echo "  workflow unified [cmd]    # Unified workflow management (overview/next/complete)"
        echo ""
        echo "💡 Enhanced Features:"
        echo "  • Real-time TODO integration with EXPRESS-DEV-TODOS.md"
        echo "  • Mission/Milestone/Move/TODO relationship mapping"
        echo "  • Sprint progress tracking across hierarchy levels"
        echo "  • Contextual next-action recommendations"
        echo ""
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'workflow help' for available commands"
        exit 1
        ;;
esac
