#!/bin/bash
# uDESK Mode System v1.0.7.3
# Express Mode: AI-guided sprint planning for complex development
# Dev Mode: Troubleshooting, debugging, testing, patches

set -e

UDESK_VERSION="1.0.7.3"
MODE_CONFIG="$HOME/uDESK/uMEMORY/config/mode.conf"
EXPRESS_CONFIG="$HOME/uDESK/uMEMORY/config/express-dev.conf"
WORKFLOW_DIR="$HOME/uDESK/uMEMORY/workflows"

# Source uCODE input library
source "$(dirname "${BASH_SOURCE[0]}")/ucode-input.sh"

# Ensure directories exist
mkdir -p "$HOME/uDESK/uMEMORY/workflows/"{todos,missions,milestones,moves}
mkdir -p "$HOME/uDESK/uMEMORY/config"

# Mode Selection Interface
show_mode_selection() {
    echo ""
    echo "    🎯 uDESK MODE SELECTION v${UDESK_VERSION}"
    echo "    ═══════════════════════════════════════"
    echo ""
    echo "    🔧 DEV MODE"
    echo "    • Troubleshooting & debugging"
    echo "    • Testing & patches" 
    echo "    • Quick fixes & validation"
    echo "    • Individual problem solving"
    echo ""
    echo "    🚀 EXPRESS MODE"
    echo "    • AI-guided sprint planning"
    echo "    • Complex development projects"
    echo "    • Multi-task coordination"
    echo "    • Structured workflow management"
    echo ""
}

# Dev Mode (Troubleshooting/Debugging)
activate_dev_mode() {
    echo "🔧 DEV MODE ACTIVATED"
    echo "═══════════════════════"
    echo ""
    echo "🎯 Purpose: Troubleshooting, debugging, testing, patches"
    echo ""
    
    # Set environment
    export UDESK_MODE="dev"
    export UDESK_ASSIST="basic"
    
    # Auto-assist for dev mode
    if [[ -f "$(dirname "${BASH_SOURCE[0]}")/auto-assist.sh" ]]; then
        echo "🤖 Auto-assist available: 'workflow assist show' for suggestions"
    fi
    
    # Save to config
    echo "UDESK_MODE=dev" > "$MODE_CONFIG"
    echo "UDESK_ASSIST=basic" >> "$MODE_CONFIG"
    echo "DEV_ACTIVATED=$(date)" >> "$MODE_CONFIG"
    
    echo "✅ Dev Mode enabled for troubleshooting"
    echo ""
    echo "🛠️  Available tools:"
    echo "   udos debug        # Debug system issues"
    echo "   udos test         # Run specific tests"
    echo "   udos patch        # Apply quick fixes"
    echo "   udos validate     # Validate changes"
    echo ""
    
    # Check if complex task might need Express Mode
    check_for_complex_task
}

# Check if task might benefit from Express Mode
check_for_complex_task() {
    echo "💡 TASK COMPLEXITY ASSESSMENT:"
    echo ""
    echo "What kind of adventure awaits?"
    echo "   SIMPLE   - Quick fix/test/debug (stay in Dev Mode)"
    echo "   MULTI    - Multi-step project (recommend Express Mode)"
    echo "   MAJOR    - Major feature work (recommend Express Mode)"
    echo ""
    
    task_type=$(prompt_ucode "🎯 Task complexity" "SIMPLE|MULTI|MAJOR" "SIMPLE")
    
    case "$task_type" in
        "MULTI"|"MAJOR")
            echo ""
            echo "🚀 RECOMMENDATION: Switch to Express Mode"
            echo "   Complex quests benefit from:"
            echo "   • AI-guided planning (your wise sage)"
            echo "   • TODO management (your quest journal)"
            echo "   • Progress tracking (your advancement log)"
            echo "   • Structured workflow (your battle plan)"
            echo ""
            
            switch_choice=$(prompt_yes_no "⚔️  Embark on Express Mode adventure?" "YES")
            
            if [[ "$switch_choice" == "YES" ]]; then
                echo ""
                echo "🌟 Transitioning to Express Mode..."
                activate_express_mode
                return
            fi
            ;;
        "SIMPLE")
            echo "✅ Dev Mode is perfect for quick fixes and simple spells!"
            ;;
    esac
    
    echo ""
    echo "🔧 Dev Mode: Ready for debugging adventures!"
}

# Express Dev Mode ASCII Art
show_express_logo() {
    echo ""
    echo "    🚀 EXPRESS MODE v${UDESK_VERSION}"
    echo "    ═══════════════════════════════════"
    echo "    AI-Guided Sprint Planning & Execution"
    echo "    📋 TODO Integration • 🤖 Auto-Assist"
    echo "    🎯 Complex Development Projects"
    echo ""
}

# Activate Express Mode (Complex Development)
activate_express_mode() {
    show_express_logo
    
    echo "� ACTIVATING EXPRESS MODE..."
    echo ""
    echo "🎯 Purpose: AI-guided sprint planning for complex development"
    echo ""
    
    # Set environment variables
    export UDESK_MODE="express"
    export UDESK_ASSIST="enhanced"
    export UDESK_EXPRESS="true"
    
    # Save to config
    echo "UDESK_MODE=express" > "$EXPRESS_CONFIG"
    echo "UDESK_ASSIST=enhanced" >> "$EXPRESS_CONFIG" 
    echo "UDESK_EXPRESS=true" >> "$EXPRESS_CONFIG"
    echo "EXPRESS_ACTIVATED=$(date)" >> "$EXPRESS_CONFIG"
    
    echo "✅ Express Mode ACTIVATED"
    echo "✅ Enhanced Assist Mode AUTO-ENABLED"
    echo ""
    
    # Initialize auto-assist for Express Mode
    if [[ -f "$(dirname "${BASH_SOURCE[0]}")/auto-assist.sh" ]]; then
        echo "🤖 Initializing Auto-Assist for Express Mode..."
        "$(dirname "${BASH_SOURCE[0]}")/auto-assist.sh" on >/dev/null
        echo "✅ Auto-Assist enabled for enhanced development guidance"
        echo ""
    fi
    
    # Trigger planning session
    echo "🎯 Initiating AI-Guided Sprint Planning..."
    echo ""
    
    # Show current sprint progress
    echo "📊 Checking your current quest progress..."
    if [[ -f "$(dirname "${BASH_SOURCE[0]}")/sprint-progress.sh" ]]; then
        bash "$(dirname "${BASH_SOURCE[0]}")/sprint-progress.sh" show
        echo ""
    fi
    
    start_planning_session
}

# Express Planning Session (for complex development)
start_planning_session() {
    echo "🤖 AI-GUIDED SPRINT PLANNING"
    echo "═══════════════════════════"
    echo "For complex development projects requiring:"
    echo "• Multi-step coordination"
    echo "• TODO management"  
    echo "• Progress tracking"
    echo "• Structured workflow"
    echo ""
    
    # Analyze current project state
    echo "🔍 Analyzing project state..."
    analyze_project_state
    echo ""
    
    # Suggest version number
    suggest_version
    echo ""
    
    # Key planning questions
    ask_planning_questions
    echo ""
    
    # Confirm and launch
    confirm_sprint_launch
}

# Analyze current project state
analyze_project_state() {
    local current_version=$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$HOME/Code/uDESK/README.md" 2>/dev/null | head -1 || echo "v1.0.7.2")
    local git_status=$(cd "$HOME/Code/uDESK" && git status --porcelain 2>/dev/null | wc -l)
    local todo_count=$(find "$WORKFLOW_DIR/todos" -name "*.md" 2>/dev/null | wc -l)
    
    echo "   📊 Current version: $current_version"
    echo "   📝 Uncommitted changes: $git_status $(format_plural "FILE" "$git_status")"
    echo "   ✅ Active $(format_plural "TODO" "$todo_count"): $todo_count $(format_plural "TASK" "$todo_count")"
    echo "   🎯 Project: uDESK Universal Desktop OS"
    echo ""
    echo "   🎨 Recent focus areas:"
    echo "   • Installer system improvements"
    echo "   • Unified command system (udos-core.h)"
    echo "   • VSCode development environment"
    echo "   • Tauri desktop application"
}

# Suggest next version number
suggest_version() {
    echo "🔮 VERSION DIVINATION:"
    echo "   Current: v1.0.7.2"
    echo "   Prophesied: v1.0.7.3 (Express Dev Mode implementation)"
    echo ""
    
    version_choice=$(prompt_confirm_modify "✨ Accept the prophecy?" "CONFIRM")
    
    if [[ "$version_choice" == "MODIFY" ]]; then
        read -p "   🏺 Enter your preferred version incantation: " custom_version
        export EXPRESS_VERSION="$custom_version"
        echo "   ⚡ Version spell cast: $custom_version"
    else
        export EXPRESS_VERSION="v1.0.7.3"
        echo "   ✨ Prophecy accepted: v1.0.7.3"
    fi
}

# Key planning questions
ask_planning_questions() {
    echo "🎯 QUEST PLANNING COUNCIL:"
    echo ""
    
    # Primary objective
    echo "1. 🏹 What is your primary quest objective?"
    echo "   Divined: Implement Express Dev Mode with AI-guided workflows"
    
    objective_choice=$(prompt_confirm_modify "Accept this divine mission?" "CONFIRM")
    
    if [[ "$objective_choice" == "MODIFY" ]]; then
        read -p "   📜 Describe your true quest: " primary_objective
        export EXPRESS_OBJECTIVE="$primary_objective"
    else
        export EXPRESS_OBJECTIVE="Implement Express Dev Mode with AI-guided workflows"
    fi
    
    # Time scope
    echo ""
    echo "2. ⏰ How long shall this epic adventure last?"
    
    duration_choice=$(prompt_duration "Choose your quest duration")
    export EXPRESS_DURATION="$duration_choice"
    
    # Priority focus
    echo ""
    echo "3. 🎖️  Which path will you forge first, brave developer?"
    echo "   EXPRESS  - Express Dev System (Core functionality)"
    echo "   WORKFLOW - Workflow Integration (TODOs, missions)"  
    echo "   CHESTER  - CHESTER Desktop (UI development)"
    echo "   INFRA    - Infrastructure (Deployment, testing)"
    
    priority_choice=$(prompt_ucode "📊 Priority quest order (e.g., EXPRESS,WORKFLOW,CHESTER,INFRA)" "EXPRESS|WORKFLOW|CHESTER|INFRA" "EXPRESS" "allow_empty")
    export EXPRESS_PRIORITIES="${priority_choice:-EXPRESS,WORKFLOW,CHESTER,INFRA}"
    
    # Success criteria
    echo ""
    echo "4. 🏆 How will you know when victory is achieved?"
    echo "   Foretold: Express Dev Mode functional, TODOs integrated, VSCode setup"
    
    success_choice=$(prompt_confirm_modify "Accept these victory conditions?" "CONFIRM")
    
    if [[ "$success_choice" == "MODIFY" ]]; then
        read -p "   🎯 Define your triumph: " success_criteria
        export EXPRESS_SUCCESS="$success_criteria"
    else
        export EXPRESS_SUCCESS="Express Dev Mode functional, TODOs integrated, VSCode setup"
    fi
}

# Confirm and launch sprint
confirm_sprint_launch() {
    echo "📋 QUEST MANIFEST:"
    echo "═══════════════════"
    echo "   🎯 Version: $EXPRESS_VERSION"
    echo "   � Objective: $EXPRESS_OBJECTIVE"
    echo "   ⏰ Duration: $EXPRESS_DURATION"
    echo "   📊 Priorities: $EXPRESS_PRIORITIES"
    echo "   🏆 Victory: $EXPRESS_SUCCESS"
    echo ""
    
    launch_choice=$(prompt_yes_no "🚀 Embark on this Express Mode quest?" "YES")
    
    if [[ "$launch_choice" == "YES" ]]; then
        echo ""
        echo "🎉 EXPRESS MODE QUEST BEGINS!"
        echo "═══════════════════════════════"
        echo "⚡ The ancient magics of structured development awaken..."
        
        # Save sprint config
        save_sprint_config
        
        # Initialize TODO system
        initialize_todo_system
        
        # Show next steps
        show_next_steps
    else
        echo ""
        echo "🏃 Quest postponed. Perhaps another time, brave developer."
        echo "   💭 Returning to the realm of mode selection..."
        show_mode_selection
    fi
}

# Save sprint configuration
save_sprint_config() {
    local sprint_config="$WORKFLOW_DIR/sprints/current-sprint.md"
    mkdir -p "$WORKFLOW_DIR/sprints"
    
    cat > "$sprint_config" << EOF
# Express Mode Sprint - $EXPRESS_VERSION

**Started:** $(date)
**Duration:** $EXPRESS_DURATION
**Status:** ACTIVE
**Mode:** Express (Complex Development)

## Objective
$EXPRESS_OBJECTIVE

## Success Criteria
$EXPRESS_SUCCESS

## Priority Order
$EXPRESS_PRIORITIES

## Progress
- [ ] Express Dev System
- [ ] Workflow Integration  
- [ ] CHESTER Desktop
- [ ] Infrastructure

## Notes
Sprint launched with AI-guided planning session.
Enhanced assist mode enabled for complex development.
Use 'udos mode dev' for simple troubleshooting tasks.
EOF

    echo "   💾 Sprint config saved to: $sprint_config"
}

# Initialize TODO system for this sprint
initialize_todo_system() {
    echo "   📋 Initializing TODO system..."
    
    # Create sprint TODOs
    local todo_file="$WORKFLOW_DIR/todos/express-dev-v1073.md"
    cat > "$todo_file" << EOF
# Express Dev Sprint TODOs - v1.0.7.3

## Priority 1: Express Dev System
- [ ] TODO-001: Express Dev Mode activation flow
- [ ] TODO-002: AI-guided planning session system  
- [ ] TODO-003: VSCode TODO Tree integration
- [ ] TODO-004: Auto-assist mode activation
- [ ] TODO-005: Sprint progress tracking

## Priority 2: Workflow System
- [ ] TODO-006: TODOs into uDESK variable system
- [ ] TODO-007: Unified workflow management commands
- [ ] TODO-008: Mission/milestone/move/todo hierarchy
- [ ] TODO-009: Workflow advancement engine
- [ ] TODO-010: Big picture progress visualization

## Priority 3: CHESTER Desktop
- [ ] TODO-011: TinyCore-inspired Tauri interface
- [ ] TODO-012: Desktop workflow widgets
- [ ] TODO-013: VSCode browser simulation integration
- [ ] TODO-014: Production app with dock integration

## Priority 4: Infrastructure
- [ ] TODO-015: Dual structure deployment system
- [ ] TODO-016: VSCode workspace configuration  
- [ ] TODO-017: Development-to-local deployment tools
- [ ] TODO-018: Comprehensive testing framework
EOF

    echo "   ✅ TODOs initialized: $todo_file"
}

# Show next steps
show_next_steps() {
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "   1. udos todo list           # View active TODOs"
    echo "   2. udos todo next           # Get next priority task"
    echo "   3. udos progress           # Show sprint progress"
    echo "   4. udos assist suggest     # Get AI suggestions"
    echo ""
    echo "🤖 ASSIST MODE: ACTIVE"
    echo "   Context-aware suggestions enabled"
    echo "   Workflow guidance available"
    echo ""
    echo "🚀 EXPRESS DEV MODE: READY FOR DEVELOPMENT!"
}

# Main execution
case "${1:-select}" in
    "select"|"choose")
        show_mode_selection
        echo "🎯 Choose your development path, adventurer:"
        echo ""
        
        mode_choice=$(prompt_ucode "Which mode calls to you?" "DEV|EXPRESS" "EXPRESS")
        
        case "$mode_choice" in
            "DEV") 
                echo "⚒️  Dev Mode chosen - may your debugging be swift!"
                activate_dev_mode 
                ;;
            "EXPRESS") 
                echo "🚀 Express Mode chosen - prepare for an epic quest!"
                activate_express_mode 
                ;;
        esac
        ;;
    "dev"|"debug"|"troubleshoot")
        activate_dev_mode
        ;;
    "express"|"sprint"|"plan")
        activate_express_mode
        ;;
    "status")
        if [[ -f "$EXPRESS_CONFIG" ]] && grep -q "UDESK_EXPRESS=true" "$EXPRESS_CONFIG"; then
            echo "🚀 Express Mode: ACTIVE"
            source "$EXPRESS_CONFIG"
            echo "   Started: $EXPRESS_ACTIVATED"
            echo "   Assist: $UDESK_ASSIST"
        elif [[ -f "$MODE_CONFIG" ]] && grep -q "UDESK_MODE=dev" "$MODE_CONFIG"; then
            echo "� Dev Mode: ACTIVE" 
            source "$MODE_CONFIG"
            echo "   Started: $DEV_ACTIVATED"
            echo "   Assist: $UDESK_ASSIST"
        else
            echo "💤 No development mode active"
        fi
        ;;
    "deactivate"|"stop"|"off")
        rm -f "$EXPRESS_CONFIG" "$MODE_CONFIG"
        echo "💤 All development modes: DEACTIVATED"
        ;;
    *)
        echo "uDESK Mode System v$UDESK_VERSION"
        echo ""
        echo "Usage: $0 {select|dev|express|status|deactivate}"
        echo ""
        echo "Modes:"
        echo "  dev       - Troubleshooting/debugging mode"  
        echo "  express   - AI-guided sprint planning mode"
        echo "  select    - Interactive mode selection"
        echo "  status    - Show current mode"
        echo "  deactivate - Turn off development modes"
        exit 1
        ;;
esac
