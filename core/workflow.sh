#!/bin/bash
# uDESK Unified Workflow Hierarchy System     echo ""
    echo "Workflow Management:"
    echo "  goal create \"Name\"       # Create new ultimate goal"
    echo "  mission create \"Name\"    # Create new mission"
    echo "  milestone add \"Name\"     # Add milestone"
    echo "  move create \"Action\"     # Create move/action"
    echo "  workflow advance          # Get next recommended action"
    echo "  workflow status           # Show big picture progress"3
# Mission → Milestone → Move → TODO structure

set -e

# Source uCODE input for consistency
source "$(dirname "${BASH_SOURCE[0]}")/ucode-input.sh"

WORKFLOW_DIR="$HOME/uDESK/uMEMORY/workflows"
mkdir -p "$WORKFLOW_DIR"/{missions,milestones,moves,todos}

# Colors for hierarchy visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Hierarchy definitions (bash 3.2 compatible)
get_hierarchy_description() {
    case "$1" in
        "GOAL") echo "🌟 Ultimate Purpose (Years)" ;;
        "MISSION") echo "🎯 Strategic Goal (Months)" ;;
        "MILESTONE") echo "🏆 Major Checkpoint (Weeks)" ;;
        "MOVE") echo "⚡ Action Sequence (Days)" ;;
        "TODO") echo "📋 Individual Task (Hours)" ;;
        *) echo "Unknown level" ;;
    esac
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Show TODO management interface
show_todo_help() {
    echo "📋 uDESK Workflow Management v1.0.7.3"
    echo "════════════════════════════════════"
    echo ""
    echo "TODO Management:"
    echo "  todo list                 # Show active TODOs"
    echo "  todo add \"Task name\"      # Add new TODO"
    echo "  todo complete N           # Mark TODO N as complete"
    echo "  todo next                 # Show next priority TODO"
    echo "  todo progress             # Show completion progress"
    echo ""
    echo "Workflow Management:"
    echo "  mission create \"Name\"     # Create new mission"
    echo "  milestone add \"Name\"      # Add milestone"
    echo "  move create \"Action\"      # Create move/action"
    echo "  workflow advance          # Get next recommended action"
    echo "  workflow status           # Show big picture progress"
    echo ""
}

# List active TODOs
list_todos() {
    echo "📋 ACTIVE TODOS"
    echo "═══════════════"
    
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    if [[ -z "$todo_files" ]]; then
        echo "No active TODOs found."
        echo "💡 Use 'todo add \"Task name\"' to create your first TODO"
        return
    fi
    
    local todo_count=0
    local completed_count=0
    
    for file in $todo_files; do
        echo ""
        echo -e "${CYAN}$(basename "$file" .md)${NC}:"
        
        # Parse TODOs from markdown
        while IFS= read -r line; do
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*\[([ x])\][[:space:]]*(.*) ]]; then
                local status="${BASH_REMATCH[1]}"
                local task="${BASH_REMATCH[2]}"
                ((todo_count++))
                
                if [[ "$status" == "x" ]]; then
                    echo -e "  ${GREEN}✅ $task${NC}"
                    ((completed_count++))
                else
                    echo -e "  ${YELLOW}⏳ $task${NC}"
                fi
            elif [[ "$line" =~ TODO-([0-9]+):(.*) ]]; then
                local todo_num="${BASH_REMATCH[1]}"
                local todo_text="${BASH_REMATCH[2]}"
                ((todo_count++))
                
                if [[ "$line" =~ ✅ ]]; then
                    echo -e "  ${GREEN}✅ TODO-$todo_num:$todo_text${NC}"
                    ((completed_count++))
                elif [[ "$line" =~ 🚧 ]]; then
                    echo -e "  ${BLUE}🚧 TODO-$todo_num:$todo_text${NC}"
                else
                    echo -e "  ${YELLOW}⏳ TODO-$todo_num:$todo_text${NC}"
                fi
            fi
        done < "$file"
    done
    
    echo ""
    echo "📊 Progress: $completed_count/$todo_count completed"
    
    if [[ $todo_count -gt 0 ]]; then
        local percentage=$((completed_count * 100 / todo_count))
        echo "🎯 Completion: $percentage%"
    fi
}

# Add new TODO
add_todo() {
    local task="$1"
    
    if [[ -z "$task" ]]; then
        read -p "📝 Enter TODO description: " task
    fi
    
    local todo_file="$WORKFLOW_DIR/todos/active.md"
    
    # Create file if it doesn't exist
    if [[ ! -f "$todo_file" ]]; then
        cat > "$todo_file" << EOF
# Active TODOs

## Current Sprint
EOF
    fi
    
    # Add the TODO
    echo "- [ ] $task" >> "$todo_file"
    
    echo -e "${GREEN}✅ TODO added:${NC} $task"
    echo "📄 Location: $todo_file"
}

# Complete a TODO
complete_todo() {
    local todo_num="$1"
    
    if [[ -z "$todo_num" ]]; then
        echo "Usage: todo complete <number>"
        echo "💡 Use 'todo list' to see TODO numbers"
        return 1
    fi
    
    echo "🔍 Searching for TODO-$todo_num..."
    
    # Find and update TODO in files
    local found=false
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    for file in $todo_files; do
        if grep -q "TODO-$todo_num:" "$file"; then
            # Update the TODO status
            sed -i.bak "s/TODO-$todo_num:/✅ TODO-$todo_num:/" "$file"
            sed -i.bak "s/🚧 TODO-$todo_num:/✅ TODO-$todo_num:/" "$file"
            sed -i.bak "s/⏳ TODO-$todo_num:/✅ TODO-$todo_num:/" "$file"
            rm -f "$file.bak"
            
            echo -e "${GREEN}✅ TODO-$todo_num completed!${NC}"
            found=true
            break
        fi
    done
    
    if [[ "$found" == false ]]; then
        echo -e "${RED}❌ TODO-$todo_num not found${NC}"
        echo "💡 Use 'todo list' to see available TODOs"
    fi
}

# Show next priority TODO
show_next_todo() {
    echo "🎯 NEXT PRIORITY TODO"
    echo "═══════════════════"
    
    # Look for current sprint TODOs first
    if [[ -f "$CURRENT_SPRINT" ]]; then
        local next_todo=$(grep -E "^- \[ \]|TODO-[0-9]+:.*[^✅]$" "$CURRENT_SPRINT" | head -1)
        if [[ -n "$next_todo" ]]; then
            echo -e "${YELLOW}📋 From current sprint:${NC}"
            echo "  $next_todo"
            return
        fi
    fi
    
    # Fall back to any active TODO
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    for file in $todo_files; do
        local next_todo=$(grep -E "^- \[ \]|TODO-[0-9]+:.*[^✅]$" "$file" | head -1)
        if [[ -n "$next_todo" ]]; then
            echo -e "${YELLOW}📋 From $(basename "$file" .md):${NC}"
            echo "  $next_todo"
            return
        fi
    done
    
    echo "🎉 No pending TODOs found!"
    echo "💡 Use 'todo add \"Task name\"' to create new TODOs"
}

# Show workflow progress
show_progress() {
    echo "📊 WORKFLOW PROGRESS"
    echo "══════════════════"
    
    # Count TODOs by status
    local total=0
    local completed=0
    local in_progress=0
    
    local todo_files=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null)
    
    for file in $todo_files; do
        while IFS= read -r line; do
            if [[ "$line" =~ TODO-([0-9]+): ]]; then
                ((total++))
                if [[ "$line" =~ ✅ ]]; then
                    ((completed++))
                elif [[ "$line" =~ 🚧 ]]; then
                    ((in_progress++))
                fi
            fi
        done < "$file"
    done
    
    echo "📋 TODOs:"
    echo "  ✅ Completed: $completed"
    echo "  🚧 In Progress: $in_progress"
    echo "  ⏳ Pending: $((total - completed - in_progress))"
    echo "  📊 Total: $total"
    
    if [[ $total -gt 0 ]]; then
        local percentage=$((completed * 100 / total))
        echo ""
        echo "🎯 Overall Progress: $percentage%"
        
        # Progress bar
        local bar_length=20
        local filled=$((percentage * bar_length / 100))
        local empty=$((bar_length - filled))
        
        printf "Progress: ["
        printf "%${filled}s" | tr ' ' '█'
        printf "%${empty}s" | tr ' ' '░'
        printf "] %d%%\n" "$percentage"
    fi
    
    # Show current sprint info if available
    if [[ -f "$CURRENT_SPRINT" ]]; then
        echo ""
        echo -e "${CYAN}📋 Current Sprint:${NC}"
        local sprint_info=$(head -5 "$CURRENT_SPRINT" | tail -4)
        echo "$sprint_info"
    fi
}

# Main command processing
case "${1:-help}" in
    "list"|"ls")
        list_todos
        ;;
    "add"|"create"|"new")
        add_todo "$2"
        ;;
    "complete"|"done"|"finish")
        complete_todo "$2"
        ;;
    "next"|"priority")
        show_next_todo
        ;;
    "progress"|"status")
        show_progress
        ;;
    "help"|"--help"|"-h")
        show_todo_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_todo_help
        exit 1
        ;;
esac
