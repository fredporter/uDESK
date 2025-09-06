#!/bin/bash

# workflow-advancement.sh
# Intelligent workflow advancement engine for uDESK
# Analyzes TODO progress and suggests optimal next actions

# Bash 3.2 compatibility
set -e

# Source required dependencies
UDESK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Note: Not sourcing other scripts to avoid command conflicts

# Configuration
ADVANCEMENT_LOG="${UDESK_ROOT}/uMEMORY/.local/logs/workflow-advancement.log"
PATTERNS_FILE="${UDESK_ROOT}/uMEMORY/.local/data/user-patterns.json"
MOMENTUM_FILE="${UDESK_ROOT}/uMEMORY/.local/data/workflow-momentum.log"

# Ensure required directories exist
mkdir -p "$(dirname "$ADVANCEMENT_LOG")"
mkdir -p "$(dirname "$PATTERNS_FILE")"
mkdir -p "$(dirname "$MOMENTUM_FILE")"

# Initialize momentum tracking
init_momentum_tracking() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') INIT Workflow advancement engine initialized" >> "$ADVANCEMENT_LOG"
    
    if [ ! -f "$MOMENTUM_FILE" ]; then
        cat > "$MOMENTUM_FILE" << 'EOF'
# Workflow Momentum Log
# Format: TIMESTAMP ACTION TODO_ID DURATION_MINUTES CONTEXT
EOF
    fi
    
    if [ ! -f "$PATTERNS_FILE" ]; then
        cat > "$PATTERNS_FILE" << 'EOF'
{
  "session_patterns": {
    "typical_session_length": 90,
    "productive_hours": ["09", "10", "11", "14", "15", "16"],
    "preferred_todo_types": ["implementation", "testing", "documentation"]
  },
  "completion_patterns": {
    "average_todo_duration": 45,
    "success_rate_by_type": {
      "implementation": 0.85,
      "documentation": 0.95,
      "testing": 0.75,
      "integration": 0.70
    }
  },
  "momentum_indicators": {
    "streak_count": 0,
    "recent_completions": [],
    "blocked_count": 0,
    "last_major_milestone": ""
  }
}
EOF
    fi
}

# Analyze current TODO state
analyze_todo_state() {
    local todos_file="${UDESK_ROOT}/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md"
    local total_todos=0
    local completed_todos=0
    local current_milestone=""
    local next_todo=""
    
    if [ ! -f "$todos_file" ]; then
        echo "ERROR: TODO file not found"
        return 1
    fi
    
    # Count TODOs and find current state
    while IFS= read -r line; do
        if [[ "$line" =~ ^//[[:space:]]*TODO-[0-9]+: ]]; then
            total_todos=$((total_todos + 1))
            if [[ "$line" =~ ✅.*COMPLETED ]]; then
                completed_todos=$((completed_todos + 1))
            elif [ -z "$next_todo" ] && [[ ! "$line" =~ ✅ ]]; then
                next_todo=$(echo "$line" | sed 's/^\/\/[[:space:]]*TODO-\([0-9]\+\):.*/\1/')
            fi
        elif [[ "$line" =~ ^//[[:space:]]*MILESTONE: ]]; then
            if [ -n "$next_todo" ] && [ -z "$current_milestone" ]; then
                current_milestone=$(echo "$line" | sed 's/^\/\/[[:space:]]*MILESTONE:[[:space:]]*//')
            fi
        fi
    done < "$todos_file"
    
    # Calculate progress metrics
    local completion_rate=0
    if [ "$total_todos" -gt 0 ]; then
        completion_rate=$((completed_todos * 100 / total_todos))
    fi
    
    # Export state for other functions
    export TODO_TOTAL="$total_todos"
    export TODO_COMPLETED="$completed_todos"
    export TODO_COMPLETION_RATE="$completion_rate"
    export TODO_NEXT="$next_todo"
    export TODO_CURRENT_MILESTONE="$current_milestone"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') STATE total=$total_todos completed=$completed_todos rate=${completion_rate}% next=TODO-$next_todo" >> "$ADVANCEMENT_LOG"
}

# Detect TODO dependencies and blockers
analyze_dependencies() {
    local todo_id="$1"
    local dependencies=()
    local blockers=()
    local suggestions=()
    
    # Define dependency patterns
    case "$todo_id" in
        "009")
            dependencies=("006" "007" "008")
            if [ "$TODO_COMPLETED" -lt 8 ]; then
                blockers+=("Previous workflow TODOs must be completed")
            fi
            suggestions+=("Focus on workflow engine architecture")
            suggestions+=("Build on existing hierarchy system")
            ;;
        "010")
            dependencies=("009")
            suggestions+=("Requires workflow advancement engine")
            suggestions+=("Focus on visual representation")
            ;;
        "011")
            dependencies=("010")
            suggestions+=("Needs completed workflow system")
            suggestions+=("Begin Tauri interface design")
            ;;
        "012")
            dependencies=("011")
            suggestions+=("Requires CHESTER desktop base")
            suggestions+=("Create widget architecture")
            ;;
        *)
            suggestions+=("Continue with current TODO sequence")
            ;;
    esac
    
    # Check if dependencies are met
    local deps_met=true
    for dep in "${dependencies[@]}"; do
        if ! grep -q "TODO-${dep}:.*✅.*COMPLETED" "${UDESK_ROOT}/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" 2>/dev/null; then
            deps_met=false
            blockers+=("TODO-${dep} must be completed first")
        fi
    done
    
    # Export results
    export DEPS_MET="$deps_met"
    echo "${suggestions[@]}"
}

# Generate intelligent action suggestions
suggest_next_actions() {
    local context="$1"
    local suggestions=()
    local priority_actions=()
    
    # Analyze current time and session context
    local current_hour=$(date '+%H')
    local session_time=$(get_session_duration)
    
    # Time-based suggestions
    if [ "$current_hour" -ge 9 ] && [ "$current_hour" -le 11 ]; then
        priority_actions+=("HIGH_FOCUS: Peak productivity hours - tackle complex implementation")
    elif [ "$current_hour" -ge 14 ] && [ "$current_hour" -le 16 ]; then
        priority_actions+=("GOOD_FOCUS: Good for integration and testing tasks")
    else
        priority_actions+=("LOW_FOCUS: Consider documentation or planning tasks")
    fi
    
    # Session length suggestions
    if [ "$session_time" -gt 60 ]; then
        suggestions+=("BREAK: Consider a short break - session over 60 minutes")
    elif [ "$session_time" -gt 120 ]; then
        suggestions+=("LONG_BREAK: Take a longer break - session over 2 hours")
    fi
    
    # TODO-specific suggestions
    local current_todo="${TODO_NEXT:-unknown}"
    case "$current_todo" in
        "009")
            suggestions+=("START: Begin workflow advancement engine architecture")
            suggestions+=("PLAN: Define core engine interfaces and data flow")
            suggestions+=("CODE: Create advancement algorithm framework")
            suggestions+=("TEST: Validate with current TODO data")
            ;;
        "010")
            suggestions+=("DESIGN: Plan progress visualization system")
            suggestions+=("BUILD: Create visual progress components")
            suggestions+=("INTEGRATE: Connect with advancement engine")
            ;;
        "011")
            suggestions+=("RESEARCH: Study TinyCore aesthetic patterns")
            suggestions+=("PROTOTYPE: Create basic Tauri interface")
            suggestions+=("DESIGN: Plan CHESTER desktop layout")
            ;;
        *)
            suggestions+=("CONTINUE: Proceed with next TODO in sequence")
            suggestions+=("REVIEW: Check completed TODOs for integration opportunities")
            ;;
    esac
    
    # Momentum-based suggestions
    local recent_completions=$(tail -5 "$MOMENTUM_FILE" 2>/dev/null | grep -c "COMPLETED" || echo "0")
    if [ "$recent_completions" -ge 3 ]; then
        suggestions+=("MOMENTUM: High completion rate - consider tackling challenging task")
    elif [ "$recent_completions" -le 1 ]; then
        suggestions+=("REBUILD: Low momentum - start with smaller, achievable task")
    fi
    
    # Output all suggestions
    printf "%s\n" "${priority_actions[@]}" "${suggestions[@]}"
}

# Get current session duration in minutes  
get_session_duration() {
    local start_time=$(grep "INIT" "$ADVANCEMENT_LOG" 2>/dev/null | tail -1 | cut -d' ' -f1-2 || echo "$(date '+%Y-%m-%d %H:%M:%S')")
    # Use stat for cross-platform compatibility
    local current_epoch=$(date "+%s")
    local duration_minutes=60  # Default session duration
    echo "$duration_minutes"
}

# Track workflow momentum
track_momentum() {
    local action="$1"
    local todo_id="$2"
    local duration="${3:-0}"
    local context="${4:-general}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp $action TODO-$todo_id ${duration}min $context" >> "$MOMENTUM_FILE"
    
    # Update momentum indicators
    if [ "$action" = "COMPLETED" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') MOMENTUM TODO-$todo_id completed in ${duration} minutes" >> "$ADVANCEMENT_LOG"
    fi
}

# Generate comprehensive advancement report
generate_advancement_report() {
    echo "=== Workflow Advancement Engine Report ==="
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # Current state
    analyze_todo_state
    echo "📊 Current State:"
    echo "   • Total TODOs: $TODO_TOTAL"
    echo "   • Completed: $TODO_COMPLETED"
    echo "   • Progress: ${TODO_COMPLETION_RATE}%"
    echo "   • Next TODO: TODO-${TODO_NEXT}"
    echo "   • Current Milestone: $TODO_CURRENT_MILESTONE"
    echo ""
    
    # Dependencies
    echo "🔗 Dependencies Analysis:"
    local deps_suggestions=$(analyze_dependencies "$TODO_NEXT")
    if [ "$DEPS_MET" = "true" ]; then
        echo "   ✅ All dependencies met for TODO-${TODO_NEXT}"
    else
        echo "   ⚠️  Dependencies pending for TODO-${TODO_NEXT}"
    fi
    echo ""
    
    # Action suggestions
    echo "💡 Intelligent Suggestions:"
    suggest_next_actions "advancement_report" | while IFS= read -r suggestion; do
        local type=$(echo "$suggestion" | cut -d':' -f1)
        local text=$(echo "$suggestion" | cut -d':' -f2-)
        case "$type" in
            "HIGH_FOCUS") echo "   🎯 $text" ;;
            "GOOD_FOCUS") echo "   ⚡ $text" ;;
            "LOW_FOCUS") echo "   💤 $text" ;;
            "BREAK") echo "   ☕ $text" ;;
            "LONG_BREAK") echo "   🛌 $text" ;;
            "MOMENTUM") echo "   🚀 $text" ;;
            "REBUILD") echo "   🔧 $text" ;;
            *) echo "   • $suggestion" ;;
        esac
    done
    echo ""
    
    # Session info
    local session_duration=$(get_session_duration)
    echo "⏱️  Session Info:"
    echo "   • Duration: ${session_duration} minutes"
    echo "   • Time: $(date '+%H:%M')"
    echo ""
    
    # Recent momentum
    echo "📈 Recent Momentum:"
    if [ -f "$MOMENTUM_FILE" ]; then
        tail -3 "$MOMENTUM_FILE" | while IFS= read -r entry; do
            if [ -n "$entry" ] && [[ ! "$entry" =~ ^# ]]; then
                echo "   • $entry"
            fi
        done
    else
        echo "   • No momentum data available"
    fi
}

# Main command dispatcher
main() {
    local command="${1:-report}"
    
    case "$command" in
        "init")
            init_momentum_tracking
            echo "Workflow advancement engine initialized"
            ;;
        "analyze")
            analyze_todo_state
            echo "Analysis complete - TODO-${TODO_NEXT} is next (${TODO_COMPLETION_RATE}% complete)"
            ;;
        "suggest")
            analyze_todo_state
            local suggestions=$(suggest_next_actions "${2:-general}")
            echo "🔍 Action Suggestions:"
            echo "$suggestions" | while IFS= read -r suggestion; do
                echo "   • $suggestion"
            done
            ;;
        "track")
            track_momentum "$2" "$3" "$4" "$5"
            echo "Momentum tracked: $2 TODO-$3"
            ;;
        "dependencies")
            analyze_todo_state
            analyze_dependencies "${TODO_NEXT}" > /dev/null
            echo "Dependencies for TODO-${TODO_NEXT}: $DEPS_MET"
            ;;
        "report")
            generate_advancement_report
            ;;
        *)
            echo "Usage: $0 {init|analyze|suggest|track|dependencies|report}"
            echo ""
            echo "Commands:"
            echo "  init        - Initialize advancement engine"
            echo "  analyze     - Analyze current TODO state"
            echo "  suggest     - Get intelligent action suggestions"
            echo "  track       - Track workflow momentum"
            echo "  dependencies- Check TODO dependencies"
            echo "  report      - Generate comprehensive report"
            exit 1
            ;;
    esac
}

# Execute if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
