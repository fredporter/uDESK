#!/bin/bash
# uDESK Unified Workflow Hier# Hiera# Hierarchy definitions (compatible with older bash)
show_hierarchy_levels() {
    echo "   🌟 GOAL: Ultimate Purpose (Years)"
    echo "   🎯 MISSION: Strategic Goal (Months)"
    echo "   🏆 MILESTONE: Major Checkpoint (Weeks)" 
    echo "   ⚡ MOVE: Action Sequence (Days)"
    echo "   📋 TODO: Individual Task (Hours)"
}initions (compatible with older bash)
show_hierarchy_levels() {
    echo "   🌟 GOAL: Ultimate Purpose (Years)"
    echo "   🎯 MISSION: Strategic Goal (Months)"
    echo "   🏆 MILESTONE: Major Checkpoint (Weeks)" 
    echo "   ⚡ MOVE: Action Sequence (Days)"
    echo "   📋 TODO: Individual Task (Hours)"
}stem v1.0.7.3
# Goal → Mission → Milestone → Move → TODO structure

set -e

# Source uCODE input for consistency
source "$(dirname "${BASH_SOURCE[0]}")/ucode-input.sh"

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

# Plural formatting helper for consistent display
format_plural() {
    local word="$1"
    local count="${2:-1}"
    
    if [[ $count -eq 1 ]]; then
        echo "$word"
    else
        case "$word" in
            "TODO") echo "TODOs" ;;
            "MOVE") echo "MOVEs" ;;
            "MILESTONE") echo "MILESTONEs" ;;
            "MISSION") echo "MISSIONs" ;;
            "GOAL") echo "GOALs" ;;
            *) echo "${word}s" ;;
        esac
    fi
}

# Hierarchy definitions (compatible with older bash)
show_hierarchy_levels() {
    echo "   � GOAL: Ultimate Purpose (Years)"
    echo "   �🎯 MISSION: Strategic Goal (Months)"
    echo "   🏆 MILESTONE: Major Checkpoint (Weeks)" 
    echo "   ⚡ MOVE: Action Sequence (Days)"
    echo "   📋 TODO: Individual Task (Hours)"
}

# Show workflow hierarchy overview
show_hierarchy() {
    echo "🎯 uDESK WORKFLOW HIERARCHY"
    echo "═══════════════════════════"
    echo ""
    echo "📊 STRUCTURE OVERVIEW:"
    echo "─────────────────────"
    
    show_hierarchy_levels
    
    echo ""
    echo "🔄 WORKFLOW FLOW:"
    echo "─────────────────"
    echo "   � GOAL: Personal Growth Through Systems Mastery"
    echo "      ↓"
    echo "   �🎯 MISSION: Build uDESK Educational Platform"
    echo "      ↓"
    echo "   🏆 MILESTONE: Express Dev Mode Complete"
    echo "      ↓"
    echo "   ⚡ MOVE: Implement Sprint Progress Tracking"
    echo "      ↓"
    echo "   📋 TODO: Create progress visualization function"
    echo ""
    
    # Show current active items
    show_active_hierarchy
}

# Show active items across all hierarchy levels
show_active_hierarchy() {
    echo "🎯 CURRENT ACTIVE ITEMS:"
    echo "───────────────────────"
    
    # Active Mission
    local active_mission=$(get_active_mission)
    if [[ -n "$active_mission" ]]; then
        echo -e "   ${CYAN}🎯 MISSION: $active_mission${NC}"
        
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
    local mission_file="$WORKFLOW_DIR/missions/active.md"
    if [[ -f "$mission_file" ]]; then
        if grep -q "\[x\] $milestone" "$mission_file"; then
            echo "COMPLETE"
        elif grep -q "\[ \] $milestone" "$mission_file"; then
            echo "PENDING"
        else
            echo "UNKNOWN"
        fi
    fi
}

# Get moves for a milestone
get_milestone_moves() {
    local milestone="$1"
    local milestone_file="$WORKFLOW_DIR/milestones/${milestone// /-}.md"
    if [[ -f "$milestone_file" ]]; then
        awk '/^## MOVES/,/^## / {
            if (/^- \[/) print $0
        }' "$milestone_file" | sed 's/^- \[.\] //'
    fi
}

# Get move status
get_move_status() {
    local move="$1"
    local move_file="$WORKFLOW_DIR/moves/${move// /-}.md"
    if [[ -f "$move_file" ]]; then
        local status=$(grep "^Status:" "$move_file" | cut -d' ' -f2-)
        echo "${status:-UNKNOWN}"
    else
        echo "NOT_STARTED"
    fi
}

# Get todos for a move
get_move_todos() {
    local move="$1"
    local move_file="$WORKFLOW_DIR/moves/${move// /-}.md"
    if [[ -f "$move_file" ]]; then
        awk '/^## TODOS/,/^## / {
            if (/^- \[/) print $0
        }' "$move_file" | sed 's/^- \[.\] //'
    fi
}

# Get todo status
get_todo_status() {
    local todo="$1"
    # Check if TODO is in our main TODO system
    if check_todo_completed "$todo"; then
        echo "COMPLETE"
    else
        echo "PENDING"
    fi
}

# Check if TODO is completed (from sprint-progress.sh)
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
    goal_name=$(prompt_ucode "🌟 Enter ultimate goal name")
    
    local goal_description
    goal_description=$(prompt_ucode "📝 Enter goal description")
    
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
    mission_name=$(prompt_ucode "⚡ Enter mission name")
    
    local mission_description
    mission_description=$(prompt_ucode "📝 Enter mission description")
    
    local duration
    duration=$(prompt_duration "⏰ Mission duration")
    
    echo ""
    echo "🎯 MISSION SUMMARY:"
    echo "   Name: $mission_name"
    echo "   Description: $mission_description" 
    echo "   Duration: $duration"
    echo ""
    
    local confirm
    confirm=$(prompt_yes_no "🚀 Create this mission?")
    
    if [[ "$confirm" == "YES" ]]; then
        # Create mission file
        cat > "$WORKFLOW_DIR/missions/active.md" << EOF
# $mission_name

**Status**: ACTIVE  
**Created**: $(date)  
**Duration**: $duration  
**Description**: $mission_description

## OVERVIEW
$mission_description

## MILESTONES
- [ ] Milestone 1: Define core objectives
- [ ] Milestone 2: Implement foundation
- [ ] Milestone 3: Complete and validate

## SUCCESS CRITERIA
- [ ] All milestones completed
- [ ] Quality standards met
- [ ] Documentation complete
- [ ] Community ready

## RESOURCES
- Development team
- Documentation
- Community feedback

---
*Mission created: $(date)*
EOF
        
        echo "✅ Mission '$mission_name' created successfully!"
        echo "💡 Next: Add milestones with 'workflow milestone create'"
    else
        echo "❌ Mission creation cancelled"
    fi
}

# Create new milestone
create_milestone() {
    local active_mission=$(get_active_mission)
    if [[ -z "$active_mission" ]]; then
        echo "⚠️  No active mission found. Create a mission first."
        return 1
    fi
    
    echo "🏆 MILESTONE CREATION WIZARD"
    echo "════════════════════════════"
    echo "Mission: $active_mission"
    echo ""
    
    local milestone_name
    milestone_name=$(prompt_ucode "🎯 Enter milestone name")
    
    local milestone_description  
    milestone_description=$(prompt_ucode "📝 Enter milestone description")
    
    echo ""
    echo "🏆 MILESTONE SUMMARY:"
    echo "   Name: $milestone_name"
    echo "   Description: $milestone_description"
    echo "   Mission: $active_mission"
    echo ""
    
    local confirm
    confirm=$(prompt_yes_no "🚀 Create this milestone?")
    
    if [[ "$confirm" == "YES" ]]; then
        # Create milestone file
        local milestone_file="$WORKFLOW_DIR/milestones/${milestone_name// /-}.md"
        cat > "$milestone_file" << EOF
# $milestone_name

**Status**: PENDING  
**Created**: $(date)  
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
        local mission_file="$WORKFLOW_DIR/missions/active.md"
        sed -i.bak "/## MILESTONES/a\\
- [ ] $milestone_name
" "$mission_file"
        
        echo "✅ Milestone '$milestone_name' created and linked to mission!"
        echo "💡 Next: Add moves with 'workflow move create'"
    else
        echo "❌ Milestone creation cancelled"
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
    "help"|"--help"|"-h")
        echo "🎯 uDESK Workflow Hierarchy v1.0.7.3"
        echo "════════════════════════════════════"
        echo ""
        echo "Commands:"
        echo "  workflow show             # Show complete hierarchy"
        echo "  workflow goal create      # Create new ultimate goal"
        echo "  workflow mission create   # Create new mission"
        echo "  workflow milestone create # Create new milestone"
        echo "  workflow move create      # Create new move"
        echo "  workflow todo create      # Create new todo"
        echo ""
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'workflow help' for available commands"
        exit 1
        ;;
esac
