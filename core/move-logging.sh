#!/bin/bash

# move-logging.sh
# uDOS-inspired Move-logging system for uDESK
# Tracks all significant actions, decisions, and learning moments

# Bash 3.2 compatibility
set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UDESK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
MOVE_LOG_DIR="${UDESK_ROOT}/uMEMORY/.local/logs/moves"
MISSION_MOVES_DIR="${UDESK_ROOT}/uMEMORY/.local/data/mission-moves"
DAILY_MOVES_DIR="${UDESK_ROOT}/uMEMORY/.local/logs/daily"
LEGACY_MOVES_DIR="${UDESK_ROOT}/uMEMORY/.local/legacy/moves"

# Move types for categorization
MOVE_TYPES=(
    "MISSION_START"     # Beginning a new mission
    "MILESTONE_REACH"   # Achieving a milestone
    "TODO_COMPLETE"     # Completing a TODO
    "DECISION_POINT"    # Critical decision made
    "LEARNING_MOMENT"   # Insight or discovery
    "CHALLENGE_FACED"   # Obstacle encountered
    "SOLUTION_FOUND"    # Problem resolution
    "TOOL_DISCOVERY"    # New tool or method learned
    "PATTERN_NOTICED"   # Recurring pattern identified
    "WISDOM_GAINED"     # Deep understanding achieved
    "COLLABORATION"     # Working with others
    "MISTAKE_MADE"      # Error and lesson learned
    "INNOVATION"        # Creative breakthrough
    "REFLECTION"        # Thoughtful analysis
    "DOCUMENTATION"     # Knowledge preservation
)

# Ensure required directories exist
init_move_logging() {
    mkdir -p "$MOVE_LOG_DIR"
    mkdir -p "$MISSION_MOVES_DIR" 
    mkdir -p "$DAILY_MOVES_DIR"
    mkdir -p "$LEGACY_MOVES_DIR"
    
    # Create index files if they don't exist
    local index_file="$MOVE_LOG_DIR/move-index.json"
    if [ ! -f "$index_file" ]; then
        cat > "$index_file" << 'EOF'
{
  "move_logging": {
    "version": "1.0.0",
    "initialized": "",
    "total_moves": 0,
    "missions_tracked": [],
    "move_types_used": [],
    "last_move_id": 0
  },
  "statistics": {
    "moves_per_day_average": 0,
    "most_active_mission": "",
    "most_common_move_type": "",
    "learning_moments_count": 0,
    "wisdom_gained_count": 0
  }
}
EOF
        # Update initialization timestamp
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        sed -i '' "s/\"initialized\": \"\"/\"initialized\": \"$timestamp\"/" "$index_file"
    fi
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') INIT Move-logging system initialized" >> "$MOVE_LOG_DIR/system.log"
}

# Generate unique move ID
generate_move_id() {
    local date_prefix=$(date '+%Y%m%d')
    local time_suffix=$(date '+%H%M%S')
    local random_suffix=$(printf "%03d" $((RANDOM % 1000)))
    echo "MOVE_${date_prefix}_${time_suffix}_${random_suffix}"
}

# Log a move with full context
log_move() {
    local move_type="$1"
    local description="$2"
    local mission_id="${3:-GENERAL}"
    local context="${4:-standard}"
    local impact_level="${5:-MEDIUM}"
    
    if [ -z "$move_type" ] || [ -z "$description" ]; then
        echo "❌ Error: Move type and description required"
        echo "Usage: log_move MOVE_TYPE 'description' [mission_id] [context] [impact_level]"
        return 1
    fi
    
    # Validate move type
    local valid_type=false
    for valid in "${MOVE_TYPES[@]}"; do
        if [ "$move_type" = "$valid" ]; then
            valid_type=true
            break
        fi
    done
    
    if [ "$valid_type" != "true" ]; then
        echo "⚠️  Warning: '$move_type' is not a standard move type"
        echo "Valid types: ${MOVE_TYPES[*]}"
    fi
    
    # Generate move data
    local move_id=$(generate_move_id)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local date_only=$(date '+%Y-%m-%d')
    local time_only=$(date '+%H:%M:%S')
    
    # Create detailed move record
    local move_file="$MOVE_LOG_DIR/${move_id}.move"
    cat > "$move_file" << EOF
{
  "move_id": "$move_id",
  "timestamp": "$timestamp",
  "date": "$date_only",
  "time": "$time_only",
  "move_type": "$move_type",
  "description": "$description",
  "mission_id": "$mission_id",
  "context": "$context",
  "impact_level": "$impact_level",
  "session_info": {
    "working_directory": "$(pwd)",
    "git_branch": "$(git branch --show-current 2>/dev/null || echo 'unknown')",
    "git_commit": "$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
  },
  "system_info": {
    "hostname": "$(hostname)",
    "user": "$(whoami)",
    "os": "$(uname -s)",
    "shell": "$SHELL"
  }
}
EOF
    
    # Add to daily log
    local daily_log="$DAILY_MOVES_DIR/${date_only}.moves"
    echo "$timestamp [$move_type] $description (Mission: $mission_id, Impact: $impact_level)" >> "$daily_log"
    
    # Add to mission-specific log if not GENERAL
    if [ "$mission_id" != "GENERAL" ]; then
        local mission_log="$MISSION_MOVES_DIR/${mission_id}.moves"
        echo "$timestamp [$move_type] $description (Impact: $impact_level)" >> "$mission_log"
    fi
    
    # Add to main system log
    echo "$timestamp MOVE_LOGGED $move_id [$move_type] $description" >> "$MOVE_LOG_DIR/system.log"
    
    # Update statistics
    update_move_statistics "$move_type" "$mission_id" "$impact_level"
    
    echo "📝 Move logged: $move_id [$move_type] $description"
}

# Update move statistics
update_move_statistics() {
    local move_type="$1"
    local mission_id="$2" 
    local impact_level="$3"
    
    local index_file="$MOVE_LOG_DIR/move-index.json"
    local temp_file="$MOVE_LOG_DIR/move-index.tmp"
    
    # For simplicity in Bash 3.2, we'll append to a stats log
    local stats_log="$MOVE_LOG_DIR/statistics.log"
    echo "$(date '+%Y-%m-%d %H:%M:%S') TYPE=$move_type MISSION=$mission_id IMPACT=$impact_level" >> "$stats_log"
}

# Get move history for a specific timeframe
get_move_history() {
    local timeframe="${1:-today}"
    local mission_filter="${2:-all}"
    
    case "$timeframe" in
        "today")
            local date_filter=$(date '+%Y-%m-%d')
            if [ -f "$DAILY_MOVES_DIR/${date_filter}.moves" ]; then
                echo "📅 Today's moves ($date_filter):"
                cat "$DAILY_MOVES_DIR/${date_filter}.moves"
            else
                echo "📅 No moves recorded for today"
            fi
            ;;
        "week")
            echo "📅 This week's moves:"
            find "$DAILY_MOVES_DIR" -name "*.moves" -mtime -7 -exec cat {} \; | sort
            ;;
        "mission")
            if [ "$mission_filter" != "all" ] && [ -f "$MISSION_MOVES_DIR/${mission_filter}.moves" ]; then
                echo "🎯 Moves for mission: $mission_filter"
                cat "$MISSION_MOVES_DIR/${mission_filter}.moves"
            else
                echo "❌ Mission '$mission_filter' not found or no moves recorded"
            fi
            ;;
        *)
            echo "❌ Unknown timeframe: $timeframe"
            echo "Available: today, week, mission"
            ;;
    esac
}

# Generate move insights and patterns
analyze_moves() {
    local analysis_type="${1:-summary}"
    
    case "$analysis_type" in
        "summary")
            echo "📊 Move Analysis Summary"
            echo "======================="
            
            # Count total moves
            local total_moves=$(find "$MOVE_LOG_DIR" -name "*.move" | wc -l | tr -d ' ')
            echo "Total moves logged: $total_moves"
            
            # Count by type
            echo ""
            echo "📋 Moves by Type:"
            if [ -f "$MOVE_LOG_DIR/statistics.log" ]; then
                grep "TYPE=" "$MOVE_LOG_DIR/statistics.log" | cut -d'=' -f2 | cut -d' ' -f1 | sort | uniq -c | sort -nr | head -10
            fi
            
            # Recent activity
            echo ""
            echo "🕒 Recent Activity (Last 5 moves):"
            find "$MOVE_LOG_DIR" -name "*.move" -exec basename {} .move \; | sort | tail -5 | while read move_id; do
                if [ -f "$MOVE_LOG_DIR/${move_id}.move" ]; then
                    local timestamp=$(grep '"timestamp"' "$MOVE_LOG_DIR/${move_id}.move" | cut -d'"' -f4)
                    local move_type=$(grep '"move_type"' "$MOVE_LOG_DIR/${move_id}.move" | cut -d'"' -f4)
                    local description=$(grep '"description"' "$MOVE_LOG_DIR/${move_id}.move" | cut -d'"' -f4)
                    echo "   $timestamp [$move_type] $description"
                fi
            done
            ;;
        "patterns")
            echo "🔍 Move Pattern Analysis"
            echo "======================="
            
            echo "🎯 Mission Activity:"
            if [ -f "$MOVE_LOG_DIR/statistics.log" ]; then
                grep "MISSION=" "$MOVE_LOG_DIR/statistics.log" | cut -d'=' -f3 | cut -d' ' -f1 | grep -v "GENERAL" | sort | uniq -c | sort -nr
            fi
            
            echo ""
            echo "⚡ Impact Distribution:"
            if [ -f "$MOVE_LOG_DIR/statistics.log" ]; then
                grep "IMPACT=" "$MOVE_LOG_DIR/statistics.log" | cut -d'=' -f4 | sort | uniq -c | sort -nr
            fi
            ;;
        "wisdom")
            echo "🧠 Wisdom and Learning Insights"
            echo "==============================="
            
            echo "💡 Learning Moments:"
            find "$MOVE_LOG_DIR" -name "*.move" -exec grep -l '"move_type": "LEARNING_MOMENT"' {} \; | while read move_file; do
                local description=$(grep '"description"' "$move_file" | cut -d'"' -f4)
                local timestamp=$(grep '"timestamp"' "$move_file" | cut -d'"' -f4)
                echo "   $timestamp: $description"
            done
            
            echo ""
            echo "🌟 Wisdom Gained:"
            find "$MOVE_LOG_DIR" -name "*.move" -exec grep -l '"move_type": "WISDOM_GAINED"' {} \; | while read move_file; do
                local description=$(grep '"description"' "$move_file" | cut -d'"' -f4)
                local timestamp=$(grep '"timestamp"' "$move_file" | cut -d'"' -f4)
                echo "   $timestamp: $description"
            done
            ;;
    esac
}

# Export moves for legacy preservation
export_moves_for_legacy() {
    local mission_id="$1"
    local output_dir="${2:-$LEGACY_MOVES_DIR}"
    
    if [ -z "$mission_id" ]; then
        echo "❌ Mission ID required for legacy export"
        return 1
    fi
    
    local legacy_file="$output_dir/legacy-moves-${mission_id}-$(date '+%Y%m%d').md"
    
    echo "# Mission Move Log: $mission_id" > "$legacy_file"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$legacy_file"
    echo "" >> "$legacy_file"
    
    if [ -f "$MISSION_MOVES_DIR/${mission_id}.moves" ]; then
        echo "## Chronological Move History" >> "$legacy_file"
        echo "" >> "$legacy_file"
        
        cat "$MISSION_MOVES_DIR/${mission_id}.moves" | while IFS= read -r line; do
            echo "- $line" >> "$legacy_file"
        done
        
        echo "" >> "$legacy_file"
        echo "## Move Analysis" >> "$legacy_file"
        echo "" >> "$legacy_file"
        
        # Extract learning moments and wisdom
        echo "### Learning Moments" >> "$legacy_file"
        find "$MOVE_LOG_DIR" -name "*.move" -exec grep -l "\"mission_id\": \"$mission_id\"" {} \; | while read move_file; do
            local move_type=$(grep '"move_type"' "$move_file" | cut -d'"' -f4)
            if [ "$move_type" = "LEARNING_MOMENT" ] || [ "$move_type" = "WISDOM_GAINED" ]; then
                local description=$(grep '"description"' "$move_file" | cut -d'"' -f4)
                local timestamp=$(grep '"timestamp"' "$move_file" | cut -d'"' -f4)
                echo "- **$timestamp**: $description" >> "$legacy_file"
            fi
        done
        
        echo "📜 Legacy export complete: $legacy_file"
    else
        echo "❌ No moves found for mission: $mission_id"
    fi
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        "init")
            init_move_logging
            echo "Move-logging system initialized"
            ;;
        "log")
            log_move "$2" "$3" "$4" "$5" "$6"
            ;;
        "history")
            get_move_history "$2" "$3"
            ;;
        "analyze")
            analyze_moves "$2"
            ;;
        "export")
            export_moves_for_legacy "$2" "$3"
            ;;
        "help"|*)
            echo "uDOS Move-logging System v1.0.0"
            echo "==============================="
            echo ""
            echo "Commands:"
            echo "  init                                    # Initialize move-logging system"
            echo "  log TYPE 'description' [mission] [context] [impact]  # Log a move"
            echo "  history [today|week|mission] [mission_id]           # View move history"
            echo "  analyze [summary|patterns|wisdom]                   # Analyze moves"
            echo "  export mission_id [output_dir]                      # Export for legacy"
            echo ""
            echo "Move Types:"
            printf "  %s\n" "${MOVE_TYPES[@]}"
            echo ""
            echo "Impact Levels: LOW, MEDIUM, HIGH, CRITICAL"
            exit 1
            ;;
    esac
}

# Execute if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
