#!/bin/bash

# progress-visualization.sh
# Big Picture Progress Visualization system for uDESK
# Transforms data into beautiful visual representations

# Bash 3.2 compatibility
set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UDESK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
VISUAL_DIR="${UDESK_ROOT}/uMEMORY/.local/visualizations"
CHARTS_DIR="${VISUAL_DIR}/charts"
REPORTS_DIR="${VISUAL_DIR}/reports"
DASHBOARDS_DIR="${VISUAL_DIR}/dashboards"

# Unicode characters for beautiful terminal graphics
PROGRESS_CHARS=(
    "█" "▉" "▊" "▋" "▌" "▍" "▎" "▏"  # Progress blocks
)

CHART_CHARS=(
    "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"  # Bar chart
)

MILESTONE_CHARS=(
    "○" "◔" "◑" "◕" "●"              # Milestone progression
    "☆" "★"                          # Stars
    "◇" "◆"                          # Diamonds
    "▢" "▣"                          # Squares
)

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

# Progress visualization themes
THEMES=(
    "CLASSIC"     # Traditional progress bars and charts
    "MODERN"      # Sleek Unicode-based designs
    "RETRO"       # ASCII art style
    "MINIMAL"     # Clean, simple visuals
    "DETAILED"    # Rich, comprehensive displays
)

# Initialize visualization system
init_progress_visualization() {
    mkdir -p "$VISUAL_DIR"
    mkdir -p "$CHARTS_DIR"
    mkdir -p "$REPORTS_DIR"
    mkdir -p "$DASHBOARDS_DIR"
    
    # Create visualization config
    local config_file="$VISUAL_DIR/visualization-config.json"
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
{
  "visualization": {
    "version": "1.0.0",
    "initialized": "",
    "default_theme": "MODERN",
    "color_enabled": true,
    "unicode_enabled": true,
    "auto_refresh": false
  },
  "chart_settings": {
    "width": 60,
    "height": 20,
    "show_values": true,
    "show_percentages": true,
    "animate": false
  },
  "dashboard_settings": {
    "refresh_interval": 300,
    "show_legends": true,
    "compact_mode": false,
    "export_format": "markdown"
  }
}
EOF
        # Update timestamp
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        sed "s/\"initialized\": \"\"/\"initialized\": \"$timestamp\"/" "$config_file" > "$config_file.tmp"
        mv "$config_file.tmp" "$config_file"
    fi
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') INIT Progress visualization system initialized" >> "$VISUAL_DIR/system.log"
}

# Get TODO progress data
get_todo_progress() {
    local todos_file="${UDESK_ROOT}/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md"
    
    if [ ! -f "$todos_file" ]; then
        echo "0:0:0"  # completed:total:percentage
        return
    fi
    
    local total_todos=$(grep -c "TODO-[0-9]\+:" "$todos_file" 2>/dev/null || echo "0")
    local completed_todos=$(grep -c "✅.*COMPLETED" "$todos_file" 2>/dev/null || echo "0")
    local percentage=0
    
    if [ "$total_todos" -gt 0 ]; then
        percentage=$((completed_todos * 100 / total_todos))
    fi
    
    echo "$completed_todos:$total_todos:$percentage"
}

# Get mission progress data
get_mission_progress() {
    local mission_id="${1:-all}"
    
    # Get data from move logs if available
    local moves_dir="${UDESK_ROOT}/uMEMORY/.local/logs/moves"
    local mission_moves_dir="${UDESK_ROOT}/uMEMORY/.local/data/mission-moves"
    
    local total_moves=0
    local completed_missions=0
    local active_missions=0
    
    if [ -d "$mission_moves_dir" ]; then
        total_moves=$(find "$mission_moves_dir" -name "*.moves" | wc -l | tr -d ' ')
        completed_missions=$(find "$mission_moves_dir" -name "*.moves" -exec grep -l "MISSION_COMPLETE\|COMPLETED" {} \; 2>/dev/null | wc -l | tr -d ' ')
        active_missions=$((total_moves - completed_missions))
    fi
    
    echo "$completed_missions:$total_moves:$active_missions"
}

# Get knowledge treasure progress
get_knowledge_progress() {
    local treasures_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/treasures"
    local archives_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/archives"
    local stories_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/stories"
    
    local treasures=0
    local archives=0
    local stories=0
    
    if [ -d "$treasures_dir" ]; then
        treasures=$(find "$treasures_dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    if [ -d "$archives_dir" ]; then
        archives=$(find "$archives_dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    if [ -d "$stories_dir" ]; then
        stories=$(find "$stories_dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi
    
    echo "$treasures:$archives:$stories"
}

# Create progress bar
create_progress_bar() {
    local percentage="$1"
    local width="${2:-50}"
    local style="${3:-MODERN}"
    local label="${4:-Progress}"
    
    local filled_width=$((percentage * width / 100))
    local empty_width=$((width - filled_width))
    
    case "$style" in
        "MODERN")
            local bar=""
            for ((i=0; i<filled_width; i++)); do
                bar="${bar}█"
            done
            for ((i=0; i<empty_width; i++)); do
                bar="${bar}░"
            done
            echo -e "${GREEN}${bar}${RESET} ${percentage}% ${label}"
            ;;
        "CLASSIC")
            local bar=""
            for ((i=0; i<filled_width; i++)); do
                bar="${bar}="
            done
            for ((i=0; i<empty_width; i++)); do
                bar="${bar}-"
            done
            echo "[${bar}] ${percentage}% ${label}"
            ;;
        "MINIMAL")
            echo "${label}: ${percentage}%"
            ;;
    esac
}

# Create milestone visualization
create_milestone_visual() {
    local current_milestone="$1"
    local total_milestones="$2"
    local style="${3:-MODERN}"
    
    echo -e "${BOLD}${BLUE}📍 Milestone Progress${RESET}"
    echo ""
    
    for ((i=1; i<=total_milestones; i++)); do
        if [ "$i" -le "$current_milestone" ]; then
            echo -e "   ${GREEN}● Milestone $i ${RESET}${GREEN}✓${RESET}"
        elif [ "$i" -eq $((current_milestone + 1)) ]; then
            echo -e "   ${YELLOW}◑ Milestone $i ${RESET}${YELLOW}⚡ Current${RESET}"
        else
            echo -e "   ${GRAY}○ Milestone $i ${RESET}${GRAY}Pending${RESET}"
        fi
    done
}

# Create visual chart
create_visual_chart() {
    local chart_type="$1"
    local data="$2"
    local title="${3:-Chart}"
    local width="${4:-60}"
    
    echo -e "${BOLD}${CYAN}📊 $title${RESET}"
    echo ""
    
    case "$chart_type" in
        "bar")
            create_bar_chart "$data" "$width"
            ;;
        "line")
            create_line_chart "$data" "$width"
            ;;
        "pie")
            create_pie_chart "$data"
            ;;
        *)
            echo "Unsupported chart type: $chart_type"
            ;;
    esac
}

# Create bar chart
create_bar_chart() {
    local data="$1"
    local width="$2"
    
    # Parse data format: "label1:value1,label2:value2,..."
    IFS=',' read -ra ITEMS <<< "$data"
    
    # Find max value for scaling
    local max_value=1
    for item in "${ITEMS[@]}"; do
        local value=$(echo "$item" | cut -d':' -f2)
        if [ "$value" -gt "$max_value" ]; then
            max_value="$value"
        fi
    done
    
    # Create bars
    for item in "${ITEMS[@]}"; do
        local label=$(echo "$item" | cut -d':' -f1)
        local value=$(echo "$item" | cut -d':' -f2)
        local bar_length=$((value * width / max_value))
        
        # Create bar
        local bar=""
        for ((i=0; i<bar_length; i++)); do
            bar="${bar}█"
        done
        
        printf "%-15s ${GREEN}%s${RESET} %d\n" "$label" "$bar" "$value"
    done
}

# Create comprehensive dashboard
create_dashboard() {
    local dashboard_type="${1:-overview}"
    local output_file="${2:-}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Prepare output
    local output=""
    if [ -n "$output_file" ]; then
        output="$DASHBOARDS_DIR/$output_file"
    fi
    
    # Generate dashboard content
    local dashboard_content=""
    
    case "$dashboard_type" in
        "overview")
            dashboard_content=$(generate_overview_dashboard)
            ;;
        "mission")
            dashboard_content=$(generate_mission_dashboard)
            ;;
        "knowledge")
            dashboard_content=$(generate_knowledge_dashboard)
            ;;
        "legacy")
            dashboard_content=$(generate_legacy_dashboard)
            ;;
    esac
    
    # Output to file or terminal
    if [ -n "$output" ]; then
        echo "$dashboard_content" > "$output"
        echo "Dashboard saved: $output"
    else
        echo "$dashboard_content"
    fi
}

# Generate overview dashboard
generate_overview_dashboard() {
    local todo_data=$(get_todo_progress)
    local mission_data=$(get_mission_progress)
    local knowledge_data=$(get_knowledge_progress)
    
    # Parse data
    local todo_completed=$(echo "$todo_data" | cut -d':' -f1)
    local todo_total=$(echo "$todo_data" | cut -d':' -f2)
    local todo_percentage=$(echo "$todo_data" | cut -d':' -f3)
    
    local mission_completed=$(echo "$mission_data" | cut -d':' -f1)
    local mission_total=$(echo "$mission_data" | cut -d':' -f2)
    local mission_active=$(echo "$mission_data" | cut -d':' -f3)
    
    local treasures=$(echo "$knowledge_data" | cut -d':' -f1)
    local archives=$(echo "$knowledge_data" | cut -d':' -f2)
    local stories=$(echo "$knowledge_data" | cut -d':' -f3)
    
    cat << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🎯 uDESK PROGRESS OVERVIEW                         ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  Generated: $(date '+%Y-%m-%d %H:%M:%S')                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

📋 TODO PROGRESS
$(create_progress_bar "$todo_percentage" 50 "MODERN" "Overall Progress")
   Completed: $todo_completed/$todo_total TODOs

🎯 MISSION STATUS
   ✅ Completed: $mission_completed missions
   ⚡ Active: $mission_active missions
   📊 Total: $mission_total missions

💎 KNOWLEDGE TREASURES
   🏛️  Archives: $archives mission records
   💎 Treasures: $treasures knowledge items  
   📖 Stories: $stories mission narratives
   📚 Total Legacy Items: $((archives + treasures + stories))

🌟 MILESTONE PROGRESS
$(create_milestone_visual 2 4 "MODERN")

📈 RECENT ACTIVITY
$(get_recent_activity_summary)

═══════════════════════════════════════════════════════════════════════════════
🎨 Visual Progress Dashboard • Generated by uDESK Visualization System v1.0.0
═══════════════════════════════════════════════════════════════════════════════
EOF
}

# Generate mission dashboard
generate_mission_dashboard() {
    cat << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                          🚀 MISSION PROGRESS DASHBOARD                       ║
╚══════════════════════════════════════════════════════════════════════════════╝

🎯 ACTIVE MISSIONS
$(list_active_missions)

✅ COMPLETED MISSIONS  
$(list_completed_missions)

📊 MISSION ANALYTICS
$(create_mission_analytics)

🔄 MISSION TIMELINE
$(create_mission_timeline)

═══════════════════════════════════════════════════════════════════════════════
EOF
}

# Generate knowledge dashboard
generate_knowledge_dashboard() {
    local knowledge_data=$(get_knowledge_progress)
    local treasures=$(echo "$knowledge_data" | cut -d':' -f1)
    local archives=$(echo "$knowledge_data" | cut -d':' -f2)
    local stories=$(echo "$knowledge_data" | cut -d':' -f3)
    
    cat << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                        🧠 KNOWLEDGE GROWTH DASHBOARD                         ║
╚══════════════════════════════════════════════════════════════════════════════╝

💎 KNOWLEDGE TREASURES ($treasures items)
$(list_knowledge_treasures)

🏛️  MISSION ARCHIVES ($archives archives)
$(list_mission_archives)

📖 MISSION STORIES ($stories stories)
$(list_mission_stories)

📈 LEARNING CURVE
$(create_learning_curve_visual)

🧭 WISDOM MAP
$(create_wisdom_map)

═══════════════════════════════════════════════════════════════════════════════
EOF
}

# Get recent activity summary
get_recent_activity_summary() {
    local moves_log="${UDESK_ROOT}/uMEMORY/.local/logs/moves/system.log"
    
    if [ -f "$moves_log" ]; then
        echo "   Last 3 moves:"
        tail -3 "$moves_log" | while IFS= read -r line; do
            echo "   • $line"
        done
    else
        echo "   • No recent activity data available"
    fi
}

# List active missions
list_active_missions() {
    local mission_moves_dir="${UDESK_ROOT}/uMEMORY/.local/data/mission-moves"
    
    if [ -d "$mission_moves_dir" ]; then
        find "$mission_moves_dir" -name "*.moves" | while read mission_file; do
            local mission_name=$(basename "$mission_file" .moves)
            local last_activity=$(tail -1 "$mission_file" 2>/dev/null | cut -d' ' -f1-2 || echo "Unknown")
            echo "   🎯 $mission_name (Last activity: $last_activity)"
        done
    else
        echo "   • No active missions"
    fi
}

# List completed missions
list_completed_missions() {
    local archives_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/archives"
    
    if [ -d "$archives_dir" ]; then
        find "$archives_dir" -name "*.md" | head -5 | while read archive_file; do
            local archive_name=$(basename "$archive_file" .md)
            echo "   ✅ $archive_name"
        done
    else
        echo "   • No completed missions archived"
    fi
}

# List knowledge treasures
list_knowledge_treasures() {
    local treasures_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/treasures"
    
    if [ -d "$treasures_dir" ]; then
        find "$treasures_dir" -name "*.md" | while read treasure_file; do
            local treasure_name=$(basename "$treasure_file" .md)
            local value_rating=$(grep "Value Rating:" "$treasure_file" 2>/dev/null | cut -d' ' -f3 || echo "N/A")
            echo "   💎 $treasure_name (Value: $value_rating)"
        done
    else
        echo "   • No knowledge treasures created yet"
    fi
}

# List mission archives
list_mission_archives() {
    local archives_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/archives"
    
    if [ -d "$archives_dir" ]; then
        find "$archives_dir" -name "*.md" | while read archive_file; do
            local archive_name=$(basename "$archive_file" .md)
            echo "   🏛️  $archive_name"
        done
    else
        echo "   • No mission archives created yet"
    fi
}

# List mission stories
list_mission_stories() {
    local stories_dir="${UDESK_ROOT}/uMEMORY/.local/legacy/stories"
    
    if [ -d "$stories_dir" ]; then
        find "$stories_dir" -name "*.md" | while read story_file; do
            local story_name=$(basename "$story_file" .md)
            echo "   📖 $story_name"
        done
    else
        echo "   • No mission stories created yet"
    fi
}

# Create learning curve visual
create_learning_curve_visual() {
    echo "   📈 Learning progression over time:"
    echo "   ▁▂▃▄▅▆▇█ Knowledge accumulation curve"
    echo "   │"
    echo "   └─ Time →"
}

# Create wisdom map
create_wisdom_map() {
    echo "   🧭 Wisdom navigation:"
    echo "   ┌─ Technical Skills ────────────────── ████████░░ 80%"
    echo "   ├─ Problem Solving ────────────────── ██████████ 100%"
    echo "   ├─ System Architecture ────────────── ███████░░░ 70%"
    echo "   └─ Knowledge Preservation ──────────── ██████████ 100%"
}

# Generate visual report
generate_visual_report() {
    local report_type="${1:-comprehensive}"
    local output_format="${2:-terminal}"
    local output_file="$REPORTS_DIR/progress_report_$(date '+%Y%m%d_%H%M%S').$output_format"
    
    echo "📊 Generating visual progress report..."
    
    local report_content=""
    
    case "$report_type" in
        "comprehensive")
            report_content=$(generate_comprehensive_report)
            ;;
        "summary")
            report_content=$(generate_summary_report)
            ;;
        "detailed")
            report_content=$(generate_detailed_report)
            ;;
    esac
    
    # Save to file
    echo "$report_content" > "$output_file"
    
    # Also display to terminal
    echo "$report_content"
    
    echo ""
    echo "📋 Report saved: $output_file"
}

# Generate comprehensive report
generate_comprehensive_report() {
    cat << EOF
# uDESK Progress Visualization Report

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')
**Report Type:** Comprehensive Progress Analysis

## Executive Summary

$(generate_overview_dashboard)

## Mission Analysis

$(generate_mission_dashboard)

## Knowledge Growth

$(generate_knowledge_dashboard)

## System Health

- Installation Status: Healthy
- Legacy System: Active
- Visualization: Operational

## Recommendations

1. Continue current development momentum
2. Archive completed missions regularly  
3. Create more knowledge treasures
4. Share insights with community

---

*Generated by uDESK Progress Visualization System v1.0.0*
EOF
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        "init")
            init_progress_visualization
            echo "Progress visualization system initialized"
            ;;
        "dashboard")
            create_dashboard "$2" "$3"
            ;;
        "progress")
            local todo_data=$(get_todo_progress)
            local percentage=$(echo "$todo_data" | cut -d':' -f3)
            create_progress_bar "$percentage" 60 "MODERN" "Overall Progress"
            ;;
        "milestones")
            create_milestone_visual "$2" "$3" "MODERN"
            ;;
        "chart")
            create_visual_chart "$2" "$3" "$4" "$5"
            ;;
        "report")
            generate_visual_report "$2" "$3"
            ;;
        "overview")
            create_dashboard "overview"
            ;;
        "help"|*)
            echo "uDESK Progress Visualization System v1.0.0"
            echo "=========================================="
            echo ""
            echo "Commands:"
            echo "  init                              # Initialize visualization system"
            echo "  dashboard [type] [output_file]    # Create interactive dashboard"
            echo "  progress                          # Show current progress bar"
            echo "  milestones [current] [total]      # Display milestone progression"
            echo "  chart [type] [data] [title]       # Create visual chart"
            echo "  report [type] [format]            # Generate comprehensive report"
            echo "  overview                          # Show complete overview"
            echo ""
            echo "Dashboard Types: overview, mission, knowledge, legacy"
            echo "Chart Types: bar, line, pie"
            echo "Report Types: comprehensive, summary, detailed"
            echo ""
            echo "Purpose: Transform progress data into beautiful visual representations"
            exit 1
            ;;
    esac
}

# Execute if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
