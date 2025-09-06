#!/bin/bash

# installation-lifespan.sh
# uDOS-inspired Installation Lifespan tracking for uDESK
# Monitors device health, usage patterns, and EOL indicators

# Bash 3.2 compatibility
set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UDESK_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
LIFESPAN_DIR="${UDESK_ROOT}/uMEMORY/.local/data/lifespan"
HEALTH_LOG="${LIFESPAN_DIR}/installation-health.log"
USAGE_LOG="${LIFESPAN_DIR}/usage-patterns.log"
EOL_INDICATORS="${LIFESPAN_DIR}/eol-indicators.json"
INSTALLATION_PROFILE="${LIFESPAN_DIR}/installation-profile.json"

# Health check categories
HEALTH_CATEGORIES=(
    "SYSTEM_PERFORMANCE"    # CPU, memory, disk performance
    "STORAGE_HEALTH"        # Disk space, file system health
    "NETWORK_STABILITY"     # Connection stability, speed
    "WORKFLOW_EFFICIENCY"   # Task completion rates, error frequency
    "USER_SATISFACTION"     # Productivity metrics, frustration indicators
    "SOFTWARE_STABILITY"    # Crash rates, dependency issues
    "SECURITY_POSTURE"      # Update status, vulnerability exposure
    "BACKUP_INTEGRITY"      # Data protection status
    "INTEGRATION_HEALTH"    # External tool compatibility
    "LEGACY_PREPARATION"    # Readiness for knowledge preservation
)

# EOL warning levels
EOL_LEVELS=(
    "HEALTHY"           # Installation running optimally
    "MINOR_ISSUES"      # Small problems, not urgent
    "MODERATE_CONCERN"  # Issues affecting productivity
    "SIGNIFICANT_RISK"  # Problems requiring attention
    "CRITICAL_WARNING"  # Major issues, EOL approaching
    "EOL_IMMINENT"      # End-of-life within days/weeks
    "EOL_REACHED"       # Installation no longer viable
)

# Initialize lifespan tracking
init_lifespan_tracking() {
    mkdir -p "$LIFESPAN_DIR"
    
    # Create installation profile
    if [ ! -f "$INSTALLATION_PROFILE" ]; then
        cat > "$INSTALLATION_PROFILE" << EOF
{
  "installation": {
    "id": "$(hostname)-$(date '+%Y%m%d')",
    "created": "$(date '+%Y-%m-%d %H:%M:%S')",
    "hostname": "$(hostname)",
    "os": "$(uname -s)",
    "os_version": "$(uname -r)",
    "architecture": "$(uname -m)",
    "user": "$(whoami)",
    "shell": "$SHELL",
    "udesk_version": "v1.0.7.3",
    "installation_type": "development"
  },
  "lifespan_tracking": {
    "started": "$(date '+%Y-%m-%d %H:%M:%S')",
    "health_checks_enabled": true,
    "eol_monitoring_enabled": true,
    "legacy_preparation_enabled": true,
    "auto_archive_threshold": "EOL_IMMINENT"
  },
  "baseline_metrics": {
    "initial_disk_free": "$(df -h . | tail -1 | awk '{print $4}')",
    "initial_memory": "$(if command -v free >/dev/null 2>&1; then free -h | grep 'Mem:' | awk '{print $2}'; else echo 'N/A'; fi)",
    "initial_load": "$(uptime | awk '{print $NF}')"
  }
}
EOF
    fi
    
    # Create EOL indicators file
    if [ ! -f "$EOL_INDICATORS" ]; then
        cat > "$EOL_INDICATORS" << EOF
{
  "current_status": "HEALTHY",
  "last_assessment": "$(date '+%Y-%m-%d %H:%M:%S')",
  "indicators": {
    "disk_space_critical": false,
    "memory_issues": false,
    "performance_degradation": false,
    "frequent_crashes": false,
    "outdated_dependencies": false,
    "security_vulnerabilities": false,
    "backup_failures": false,
    "user_frustration_high": false,
    "migration_requested": false,
    "hardware_failure_signs": false
  },
  "eol_predictions": {
    "estimated_eol_date": "",
    "confidence_level": "LOW",
    "primary_risk_factors": [],
    "recommended_actions": []
  },
  "legacy_readiness": {
    "missions_documented": 0,
    "knowledge_archived": 0,
    "export_preparations": 0,
    "migration_plan_ready": false
  }
}
EOF
    fi
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') INIT Installation lifespan tracking initialized" >> "$HEALTH_LOG"
}

# Perform comprehensive health assessment
perform_health_check() {
    local check_type="${1:-full}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "🔍 Performing health check: $check_type"
    echo "$timestamp START_HEALTH_CHECK $check_type" >> "$HEALTH_LOG"
    
    local overall_status="HEALTHY"
    local issues_found=0
    
    # System Performance Check
    echo "📊 Checking system performance..."
    local load_avg=$(uptime | awk '{print $NF}' | cut -d',' -f1)
    local load_threshold="2.0"
    
    if command -v bc >/dev/null 2>&1; then
        if [ "$(echo "$load_avg > $load_threshold" | bc)" -eq 1 ]; then
            echo "⚠️  High system load detected: $load_avg"
            issues_found=$((issues_found + 1))
        fi
    fi
    
    # Storage Health Check
    echo "💾 Checking storage health..."
    local disk_usage=$(df . | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 85 ]; then
        echo "⚠️  High disk usage: ${disk_usage}%"
        issues_found=$((issues_found + 1))
        if [ "$disk_usage" -gt 95 ]; then
            overall_status="CRITICAL_WARNING"
        fi
    fi
    
    # uDESK Workflow Health
    echo "🔧 Checking uDESK workflow health..."
    local recent_errors=$(grep -c "ERROR\|Failed\|failed" "$UDESK_ROOT"/uMEMORY/.local/logs/*.log 2>/dev/null || echo "0")
    if [ "$recent_errors" -gt 10 ]; then
        echo "⚠️  High error rate detected: $recent_errors recent errors"
        issues_found=$((issues_found + 1))
    fi
    
    # Git Repository Health
    echo "📋 Checking repository health..."
    if [ -d "$UDESK_ROOT/.git" ]; then
        cd "$UDESK_ROOT"
        local uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [ "$uncommitted" -gt 20 ]; then
            echo "⚠️  Many uncommitted changes: $uncommitted files"
            issues_found=$((issues_found + 1))
        fi
        
        # Check if we're behind remote
        local behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo "0")
        if [ "$behind" -gt 10 ]; then
            echo "⚠️  Repository significantly behind: $behind commits"
            issues_found=$((issues_found + 1))
        fi
    fi
    
    # Mission Progress Health
    echo "🎯 Checking mission progress health..."
    if [ -f "$UDESK_ROOT/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" ]; then
        local stalled_todos=$(grep -E "TODO-[0-9]+:" "$UDESK_ROOT/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | grep -v "✅.*COMPLETED" | wc -l | tr -d ' ')
        local total_todos=$(grep -E "TODO-[0-9]+:" "$UDESK_ROOT/uMEMORY/sandbox/workflows/EXPRESS-DEV-TODOS.md" | wc -l | tr -d ' ')
        if [ "$total_todos" -gt 0 ]; then
            local completion_rate=$((100 * (total_todos - stalled_todos) / total_todos))
            if [ "$completion_rate" -lt 30 ]; then
                echo "⚠️  Low mission completion rate: ${completion_rate}%"
                issues_found=$((issues_found + 1))
            fi
        fi
    fi
    
    # Determine overall status
    if [ "$issues_found" -eq 0 ]; then
        overall_status="HEALTHY"
    elif [ "$issues_found" -le 2 ]; then
        overall_status="MINOR_ISSUES"
    elif [ "$issues_found" -le 4 ]; then
        overall_status="MODERATE_CONCERN"
    elif [ "$issues_found" -le 6 ]; then
        overall_status="SIGNIFICANT_RISK"
    else
        overall_status="CRITICAL_WARNING"
    fi
    
    # Log health check results
    echo "$timestamp HEALTH_CHECK_COMPLETE status=$overall_status issues=$issues_found" >> "$HEALTH_LOG"
    
    # Update EOL indicators
    update_eol_indicators "$overall_status" "$issues_found"
    
    echo "✅ Health check complete: $overall_status ($issues_found issues found)"
    
    # Return status for automation
    echo "$overall_status"
}

# Update EOL indicators based on health assessment
update_eol_indicators() {
    local current_status="$1"
    local issues_count="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # For Bash 3.2 compatibility, we'll use a simpler approach
    local temp_file="$EOL_INDICATORS.tmp"
    
    # Create updated EOL indicators
    cat > "$temp_file" << EOF
{
  "current_status": "$current_status",
  "last_assessment": "$timestamp",
  "indicators": {
    "disk_space_critical": $([ "$current_status" = "CRITICAL_WARNING" ] && echo "true" || echo "false"),
    "performance_degradation": $([ "$issues_count" -gt 3 ] && echo "true" || echo "false"),
    "workflow_issues": $([ "$issues_count" -gt 2 ] && echo "true" || echo "false")
  },
  "eol_predictions": {
    "estimated_eol_date": "$(estimate_eol_date "$current_status")",
    "confidence_level": "$(get_confidence_level "$current_status")",
    "primary_risk_factors": [],
    "recommended_actions": ["$(get_recommended_actions "$current_status")"]
  }
}
EOF
    
    mv "$temp_file" "$EOL_INDICATORS"
    echo "$timestamp EOL_INDICATORS_UPDATED status=$current_status" >> "$HEALTH_LOG"
}

# Estimate EOL date based on current status
estimate_eol_date() {
    local status="$1"
    
    case "$status" in
        "HEALTHY")
            echo "$(date -j -v+1y '+%Y-%m-%d' 2>/dev/null || date -d '+1 year' '+%Y-%m-%d' 2>/dev/null || echo 'Unknown')"
            ;;
        "MINOR_ISSUES")
            echo "$(date -j -v+6m '+%Y-%m-%d' 2>/dev/null || date -d '+6 months' '+%Y-%m-%d' 2>/dev/null || echo 'Unknown')"
            ;;
        "MODERATE_CONCERN")
            echo "$(date -j -v+3m '+%Y-%m-%d' 2>/dev/null || date -d '+3 months' '+%Y-%m-%d' 2>/dev/null || echo 'Unknown')"
            ;;
        "SIGNIFICANT_RISK")
            echo "$(date -j -v+1m '+%Y-%m-%d' 2>/dev/null || date -d '+1 month' '+%Y-%m-%d' 2>/dev/null || echo 'Unknown')"
            ;;
        "CRITICAL_WARNING")
            echo "$(date -j -v+1w '+%Y-%m-%d' 2>/dev/null || date -d '+1 week' '+%Y-%m-%d' 2>/dev/null || echo 'Unknown')"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# Get confidence level for EOL prediction
get_confidence_level() {
    local status="$1"
    
    case "$status" in
        "HEALTHY"|"MINOR_ISSUES") echo "MEDIUM" ;;
        "MODERATE_CONCERN"|"SIGNIFICANT_RISK") echo "HIGH" ;;
        "CRITICAL_WARNING") echo "VERY_HIGH" ;;
        *) echo "LOW" ;;
    esac
}

# Get recommended actions based on status
get_recommended_actions() {
    local status="$1"
    
    case "$status" in
        "HEALTHY") echo "Continue regular monitoring" ;;
        "MINOR_ISSUES") echo "Address minor issues, increase monitoring frequency" ;;
        "MODERATE_CONCERN") echo "Investigate root causes, plan improvements" ;;
        "SIGNIFICANT_RISK") echo "Begin legacy preparation, plan migration timeline" ;;
        "CRITICAL_WARNING") echo "Immediate action required, prepare for EOL" ;;
        *) echo "Assess current state" ;;
    esac
}

# Track usage patterns
track_usage_pattern() {
    local activity_type="$1"
    local duration="${2:-0}"
    local context="${3:-general}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp ACTIVITY $activity_type duration=${duration}min context=$context" >> "$USAGE_LOG"
}

# Generate lifespan report
generate_lifespan_report() {
    local report_type="${1:-summary}"
    
    echo "📊 Installation Lifespan Report"
    echo "==============================="
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # Installation info
    if [ -f "$INSTALLATION_PROFILE" ]; then
        echo "🖥️  Installation Profile:"
        local install_id=$(grep '"id"' "$INSTALLATION_PROFILE" | head -1 | cut -d'"' -f4)
        local created=$(grep '"created"' "$INSTALLATION_PROFILE" | head -1 | cut -d'"' -f4)
        local hostname=$(grep '"hostname"' "$INSTALLATION_PROFILE" | head -1 | cut -d'"' -f4)
        echo "   • ID: $install_id"
        echo "   • Created: $created"
        echo "   • Hostname: $hostname"
        echo ""
    fi
    
    # Current health status
    if [ -f "$EOL_INDICATORS" ]; then
        echo "🏥 Current Health Status:"
        local current_status=$(grep '"current_status"' "$EOL_INDICATORS" | cut -d'"' -f4)
        local last_assessment=$(grep '"last_assessment"' "$EOL_INDICATORS" | cut -d'"' -f4)
        echo "   • Status: $current_status"
        echo "   • Last Assessment: $last_assessment"
        echo ""
    fi
    
    # Recent health checks
    if [ -f "$HEALTH_LOG" ]; then
        echo "📋 Recent Health Activity:"
        tail -10 "$HEALTH_LOG" | while IFS= read -r line; do
            echo "   • $line"
        done
        echo ""
    fi
    
    # Usage patterns
    if [ -f "$USAGE_LOG" ]; then
        echo "📈 Usage Patterns (Last 7 days):"
        local week_ago=$(date -j -v-7d '+%Y-%m-%d' 2>/dev/null || date -d '-7 days' '+%Y-%m-%d' 2>/dev/null || echo "$(date '+%Y-%m-%d')")
        grep "$week_ago\|$(date '+%Y-%m-%d')" "$USAGE_LOG" 2>/dev/null | tail -10 | while IFS= read -r line; do
            echo "   • $line"
        done || echo "   • No recent usage data available"
        echo ""
    fi
    
    # EOL predictions
    if [ -f "$EOL_INDICATORS" ]; then
        echo "🔮 EOL Predictions:"
        local estimated_eol=$(grep '"estimated_eol_date"' "$EOL_INDICATORS" | cut -d'"' -f4)
        local confidence=$(grep '"confidence_level"' "$EOL_INDICATORS" | cut -d'"' -f4)
        echo "   • Estimated EOL: $estimated_eol"
        echo "   • Confidence: $confidence"
        echo ""
    fi
    
    echo "💡 Recommendations:"
    echo "   • Run regular health checks with: ./core/installation-lifespan.sh health"
    echo "   • Monitor EOL indicators with: ./core/installation-lifespan.sh status"
    echo "   • Prepare legacy archives as status approaches CRITICAL_WARNING"
}

# Check if EOL threshold reached for automatic actions
check_eol_threshold() {
    if [ ! -f "$EOL_INDICATORS" ]; then
        echo "HEALTHY"
        return
    fi
    
    local current_status=$(grep '"current_status"' "$EOL_INDICATORS" | cut -d'"' -f4)
    
    case "$current_status" in
        "CRITICAL_WARNING"|"EOL_IMMINENT"|"EOL_REACHED")
            echo "EOL_THRESHOLD_REACHED"
            ;;
        *)
            echo "$current_status"
            ;;
    esac
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        "init")
            init_lifespan_tracking
            echo "Installation lifespan tracking initialized"
            ;;
        "health")
            perform_health_check "${2:-full}"
            ;;
        "status")
            if [ -f "$EOL_INDICATORS" ]; then
                local status=$(grep '"current_status"' "$EOL_INDICATORS" | cut -d'"' -f4)
                local last_check=$(grep '"last_assessment"' "$EOL_INDICATORS" | cut -d'"' -f4)
                echo "Current Status: $status"
                echo "Last Check: $last_check"
            else
                echo "No status data available. Run 'init' first."
            fi
            ;;
        "usage")
            track_usage_pattern "$2" "$3" "$4"
            ;;
        "report")
            generate_lifespan_report "$2"
            ;;
        "check-eol")
            check_eol_threshold
            ;;
        "help"|*)
            echo "uDOS Installation Lifespan Tracking v1.0.0"
            echo "==========================================="
            echo ""
            echo "Commands:"
            echo "  init                                    # Initialize lifespan tracking"
            echo "  health [full|quick]                     # Perform health assessment"
            echo "  status                                  # Show current EOL status"
            echo "  usage activity_type [duration] [context] # Track usage pattern"
            echo "  report [summary|detailed]               # Generate lifespan report"
            echo "  check-eol                               # Check if EOL threshold reached"
            echo ""
            echo "Health Statuses: ${EOL_LEVELS[*]}"
            exit 1
            ;;
    esac
}

# Execute if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
