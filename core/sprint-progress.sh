#!/bin/bash
# uDESK Sprint Progress Tracking System v1.0.7.3
# Milestone checkpoints and completion visualization

set -e

WORKFLOW_DIR="$HOME/uDESK/uMEMORY/workflows"
CURRENT_SPRINT="$WORKFLOW_DIR/sprints/current-sprint.md"
PROGRESS_LOG="$WORKFLOW_DIR/.progress/sprint-progress.log"

# Ensure directories exist
mkdir -p "$WORKFLOW_DIR"/{sprints,.progress}

# Source uCODE input for consistent interface
source "$(dirname "${BASH_SOURCE[0]}")/ucode-input.sh"

# Colors for progress visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Sprint progress tracking
show_sprint_progress() {
    echo "📊 SPRINT PROGRESS TRACKING"
    echo "═══════════════════════════"
    
    if [[ ! -f "$CURRENT_SPRINT" ]]; then
        echo "⚠️  No active sprint detected!"
        echo "   💡 Start Express Mode to begin a new quest"
        return 1
    fi
    
    # Parse sprint info
    local sprint_name=$(grep "^# " "$CURRENT_SPRINT" | head -1 | sed 's/^# //')
    local started=$(grep "Started:" "$CURRENT_SPRINT" | cut -d' ' -f2-)
    local status=$(grep "Status:" "$CURRENT_SPRINT" | cut -d' ' -f2-)
    
    echo -e "${CYAN}🎯 Quest: $sprint_name${NC}"
    echo -e "${BLUE}⏰ Started: $started${NC}"
    echo -e "${YELLOW}📋 Status: $status${NC}"
    echo ""
    
    # Analyze TODO progress
    analyze_todo_progress
    
    # Show milestone status
    show_milestone_status
    
    # Calculate overall progress
    calculate_overall_progress
    
    # Show next recommended action
    suggest_next_action
}

# Analyze TODO completion progress
analyze_todo_progress() {
    local total_todos=0
    local completed_todos=0
    local in_progress_todos=0
    
    # Check EXPRESS-DEV-TODOS.md first (primary source)
    local express_todo_file="$(dirname "${BASH_SOURCE[0]}")/../EXPRESS-DEV-TODOS.md"
    
    if [[ -f "$express_todo_file" ]]; then
        # Count TODOs from EXPRESS-DEV-TODOS.md
        while IFS= read -r line; do
            if [[ "$line" =~ TODO-([0-9]+): ]]; then
                ((total_todos++))
                if [[ "$line" =~ ✅.*COMPLETED ]]; then
                    ((completed_todos++))
                elif [[ "$line" =~ 🚧.*IN\ PROGRESS ]]; then
                    ((in_progress_todos++))
                fi
            fi
        done < "$express_todo_file"
    else
        # Fallback to workflow files
        local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
        
        if [[ -z "$todo_files" ]]; then
            echo "📋 $(format_plural "TODO" 0) PROGRESS ANALYSIS:"
            echo "─────────────────────────"
            echo "   📝 No $(format_plural "TODO" 0) found"
            return
        fi
        
        for file in $todo_files; do
            while IFS= read -r line; do
                if [[ "$line" =~ TODO-([0-9]+): ]]; then
                    ((total_todos++))
                    if [[ "$line" =~ ✅ ]]; then
                        ((completed_todos++))
                    elif [[ "$line" =~ 🚧 ]]; then
                        ((in_progress_todos++))
                    fi
                fi
            done < "$file"
        done
    fi
    
    local pending_todos=$((total_todos - completed_todos - in_progress_todos))
    
    # Now display with proper pluralization
    echo "📋 $(format_plural "TODO" "$total_todos") PROGRESS ANALYSIS:"
    echo "─────────────────────────"
    echo -e "   ${GREEN}✅ Completed: $completed_todos${NC}"
    echo -e "   ${BLUE}🚧 In Progress: $in_progress_todos${NC}"
    echo -e "   ${YELLOW}⏳ Pending: $pending_todos${NC}"
    echo -e "   ${BOLD}📊 Total: $total_todos${NC}"
    
    # Progress percentage
    if [[ $total_todos -gt 0 ]]; then
        local percentage=$((completed_todos * 100 / total_todos))
        echo ""
        echo -e "   ${CYAN}🎯 Completion Rate: $percentage%${NC}"
        
        # Visual progress bar
        draw_progress_bar $percentage
    fi
}

# Draw ASCII progress bar
draw_progress_bar() {
    local percentage=$1
    local bar_length=30
    local filled=$((percentage * bar_length / 100))
    local empty=$((bar_length - filled))
    
    printf "   Progress: ["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %d%%\n" "$percentage"
}

# Show milestone status
show_milestone_status() {
    echo ""
    echo "🏆 MILESTONE STATUS:"
    echo "───────────────────"
    
    # Check for milestone markers in TODO files
    local milestones=(
        "Express Dev System:TODO-001,TODO-002,TODO-003,TODO-004,TODO-005"
        "Workflow Integration:TODO-006,TODO-007,TODO-008,TODO-009,TODO-010"
        "CHESTER Desktop:TODO-011,TODO-012,TODO-013,TODO-014"
        "Infrastructure:TODO-015,TODO-016,TODO-017,TODO-018"
    )
    
    for milestone_data in "${milestones[@]}"; do
        IFS=':' read -r milestone_name todo_list <<< "$milestone_data"
        IFS=',' read -ra todos <<< "$todo_list"
        
        local completed_count=0
        local total_count=${#todos[@]}
        
        # Check completion status for each TODO in milestone
        for todo in "${todos[@]}"; do
            if check_todo_completed "$todo"; then
                ((completed_count++))
            fi
        done
        
        local milestone_percentage=$((completed_count * 100 / total_count))
        
        if [[ $milestone_percentage -eq 100 ]]; then
            echo -e "   ${GREEN}🏆 $milestone_name: COMPLETE!${NC}"
        elif [[ $milestone_percentage -gt 0 ]]; then
            echo -e "   ${YELLOW}🚧 $milestone_name: $milestone_percentage% ($completed_count/$total_count)${NC}"
        else
            echo -e "   ${RED}⏳ $milestone_name: Not started${NC}"
        fi
    done
}

# Check if a specific TODO is completed
check_todo_completed() {
    local todo_id="$1"
    local express_todo_file="$(dirname "${BASH_SOURCE[0]}")/../EXPRESS-DEV-TODOS.md"
    
    # Check EXPRESS-DEV-TODOS.md first
    if [[ -f "$express_todo_file" ]]; then
        if grep -q "$todo_id:.*✅.*COMPLETED" "$express_todo_file"; then
            return 0
        fi
    fi
    
    # Fallback to workflow files
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    for file in $todo_files; do
        if grep -q "✅.*$todo_id:" "$file"; then
            return 0
        fi
    done
    return 1
}

# Calculate overall sprint progress
calculate_overall_progress() {
    echo ""
    echo "⚡ OVERALL QUEST PROGRESS:"
    echo "─────────────────────────"
    
    # Calculate weighted progress based on priority
    local express_weight=40
    local workflow_weight=30
    local chester_weight=20
    local infra_weight=10
    
    # Get milestone percentages
    local express_pct=$(get_milestone_percentage "TODO-001,TODO-002,TODO-003,TODO-004,TODO-005")
    local workflow_pct=$(get_milestone_percentage "TODO-006,TODO-007,TODO-008,TODO-009,TODO-010")
    local chester_pct=$(get_milestone_percentage "TODO-011,TODO-012,TODO-013,TODO-014")
    local infra_pct=$(get_milestone_percentage "TODO-015,TODO-016,TODO-017,TODO-018")
    
    local weighted_total=$(( (express_pct * express_weight + workflow_pct * workflow_weight + chester_pct * chester_weight + infra_pct * infra_weight) / 100 ))
    
    echo -e "   ${CYAN}🎯 Express System: $express_pct% (Priority Weight: $express_weight%)${NC}"
    echo -e "   ${BLUE}🔄 Workflow System: $workflow_pct% (Priority Weight: $workflow_weight%)${NC}"
    echo -e "   ${PURPLE}🎨 CHESTER Desktop: $chester_pct% (Priority Weight: $chester_weight%)${NC}"
    echo -e "   ${YELLOW}🏗️ Infrastructure: $infra_pct% (Priority Weight: $infra_weight%)${NC}"
    echo ""
    echo -e "   ${BOLD}${GREEN}⚡ OVERALL PROGRESS: $weighted_total%${NC}"
    
    draw_progress_bar $weighted_total
    
    # Progress messages with Nethack flair
    if [[ $weighted_total -eq 100 ]]; then
        echo -e "   ${GREEN}🎉 Quest Complete! You have achieved mastery!${NC}"
    elif [[ $weighted_total -ge 75 ]]; then
        echo -e "   ${CYAN}⚔️  Nearly there, brave developer! Victory is within reach!${NC}"
    elif [[ $weighted_total -ge 50 ]]; then
        echo -e "   ${YELLOW}🔥 Halfway through your epic journey! Keep pushing forward!${NC}"
    elif [[ $weighted_total -ge 25 ]]; then
        echo -e "   ${BLUE}🌟 Good progress! The path ahead becomes clearer.${NC}"
    else
        echo -e "   ${RED}🏴 The quest has begun! May fortune favor your coding!${NC}"
    fi
}

# Get milestone completion percentage
get_milestone_percentage() {
    local todo_list="$1"
    IFS=',' read -ra todos <<< "$todo_list"
    
    local completed_count=0
    local total_count=${#todos[@]}
    
    for todo in "${todos[@]}"; do
        if check_todo_completed "$todo"; then
            ((completed_count++))
        fi
    done
    
    echo $((completed_count * 100 / total_count))
}

# Suggest next action based on progress
suggest_next_action() {
    echo ""
    echo "🎯 NEXT RECOMMENDED ACTION:"
    echo "──────────────────────────"
    
    # Find next priority TODO
    local priority_todos=(
        "TODO-001" "TODO-002" "TODO-003" "TODO-004" "TODO-005"
        "TODO-006" "TODO-007" "TODO-008" "TODO-009" "TODO-010"
        "TODO-011" "TODO-012" "TODO-013" "TODO-014"
        "TODO-015" "TODO-016" "TODO-017" "TODO-018"
    )
    
    for todo in "${priority_todos[@]}"; do
        if ! check_todo_completed "$todo"; then
            local todo_description=$(get_todo_description "$todo")
            echo -e "   ${YELLOW}⚡ $todo: $todo_description${NC}"
            echo -e "   ${CYAN}💡 Use: udos todo work $todo${NC}"
            return
        fi
    done
    
    echo -e "   ${GREEN}🎉 All TODOs complete! Time to celebrate your victory!${NC}"
}

# Get TODO description
get_todo_description() {
    local todo_id="$1"
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    for file in $todo_files; do
        local description=$(grep "$todo_id:" "$file" | sed "s/.*$todo_id: *//; s/✅ //; s/🚧 //; s/⏳ //")
        if [[ -n "$description" ]]; then
            echo "$description"
            return
        fi
    done
    echo "Unknown TODO"
}

# Log progress entry
log_progress() {
    local action="$1"
    local details="$2"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $action: $details" >> "$PROGRESS_LOG"
}

# Main command processing
case "${1:-show}" in
    "show"|"status"|"progress")
        show_sprint_progress
        ;;
    "milestones"|"milestone")
        show_milestone_status
        ;;
    "log"|"history")
        if [[ -f "$PROGRESS_LOG" ]]; then
            echo "📜 PROGRESS LOG:"
            echo "═══════════════"
            tail -20 "$PROGRESS_LOG"
        else
            echo "📜 No progress log found"
        fi
        ;;
    "help"|"--help"|"-h")
        echo "📊 uDESK Sprint Progress Tracking v1.0.7.3"
        echo "════════════════════════════════════════"
        echo ""
        echo "Commands:"
        echo "  progress show      # Show complete progress dashboard"
        echo "  progress milestones # Show milestone status only"
        echo "  progress log       # Show recent progress history"
        echo ""
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'progress help' for available commands"
        exit 1
        ;;
esac
