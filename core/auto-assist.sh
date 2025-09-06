#!/bin/bash
# uDESK Express Dev - Auto-Assist Mode v1.0.7.3
# Context-aware development assistance system

set -e

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ucode-input.sh"

# Configuration
ASSIST_CONFIG_DIR="$HOME/uDESK/uMEMORY/auto-assist"
CONTEXT_CACHE="${ASSIST_CONFIG_DIR}/context-cache.json"
SUGGESTIONS_LOG="${ASSIST_CONFIG_DIR}/suggestions.log"
USER_PREFERENCES="${ASSIST_CONFIG_DIR}/preferences.conf"

# Create directories
mkdir -p "${ASSIST_CONFIG_DIR}"

# Auto-assist mode state
AUTO_ASSIST_ENABLED=false
CONTEXT_AWARENESS=true
SUGGESTION_FREQUENCY="smart" # smart, frequent, minimal

# Initialize preferences if they don't exist
init_preferences() {
    if [[ ! -f "${USER_PREFERENCES}" ]]; then
        cat > "${USER_PREFERENCES}" << 'EOF'
# uDESK Auto-Assist Preferences
AUTO_ASSIST_ENABLED=true
CONTEXT_AWARENESS=true
SUGGESTION_FREQUENCY=smart
LEARNING_MODE=true
PRIVACY_MODE=false
PREFERRED_LANGUAGES=bash,c,javascript,typescript
DEVELOPMENT_FOCUS=workflow-systems
ASSISTANCE_LEVEL=intermediate
EOF
        echo "✅ Initialized auto-assist preferences: ${USER_PREFERENCES}"
    fi
    
    # Load preferences
    source "${USER_PREFERENCES}"
}

# Context detection functions
detect_current_context() {
    local context_type="unknown"
    local working_directory="$(pwd)"
    local current_files=()
    
    # Detect project type based on files in directory
    if [[ -f "package.json" ]]; then
        context_type="nodejs"
    elif [[ -f "Cargo.toml" ]]; then
        context_type="rust"
    elif [[ -f "Makefile" ]] || [[ -f "CMakeLists.txt" ]]; then
        context_type="c-cpp"
    elif [[ -f "*.sh" ]] || [[ "${working_directory}" == *"/core"* ]]; then
        context_type="bash-scripting"
    elif [[ "${working_directory}" == *"/uDESK"* ]]; then
        context_type="udesk-development"
    fi
    
    # Get recently modified files (bash 3.2 compatible)
    current_files=$(find . -maxdepth 2 -name "*.sh" -o -name "*.c" -o -name "*.h" -o -name "*.js" -o -name "*.ts" -o -name "*.md" 2>/dev/null | head -10 | tr '\n' ',' | sed 's/,$//')
    
    # Create context object
    cat > "${CONTEXT_CACHE}" << EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "context_type": "${context_type}",
    "working_directory": "${working_directory}",
    "current_files": "${current_files}"
}
EOF
    
    echo "${context_type}"
}

# Suggestion engine
generate_suggestions() {
    local context_type="$1"
    local suggestions=()
    
    case "${context_type}" in
        "udesk-development")
            suggestions=(
                "💡 Run 'workflow sprint status' to check current TODO progress"
                "🔧 Use 'workflow show' to visualize complete hierarchy"
                "📝 Consider creating a new milestone with 'workflow milestone create'"
                "🧪 Test workflow commands with './core/workflow-hierarchy.sh help'"
                "📊 Check system status with './core/todo-management.sh status'"
            )
            ;;
        "bash-scripting")
            suggestions=(
                "🛡️ Add 'set -e' for error handling"
                "📝 Include script documentation header"
                "🔍 Use 'shellcheck' for script validation"
                "📁 Check if SCRIPT_DIR is properly set"
                "⚡ Consider using functions for repeated code"
            )
            ;;
        "nodejs")
            suggestions=(
                "📦 Run 'npm audit' for security check"
                "🧪 Add unit tests for new features"
                "📝 Update package.json version for releases"
                "🔧 Consider TypeScript for better type safety"
                "🏗️ Review build scripts in package.json"
            )
            ;;
        "c-cpp")
            suggestions=(
                "🛡️ Check for memory leaks with valgrind"
                "📝 Add proper header guards"
                "🧪 Create unit tests for functions"
                "📊 Profile performance critical sections"
                "🔧 Use static analysis tools"
            )
            ;;
        *)
            suggestions=(
                "📝 Document your current work progress"
                "🔄 Commit changes frequently with descriptive messages"
                "🧪 Test your changes before committing"
                "📊 Review TODO items in current project"
                "🎯 Focus on completing current milestone"
            )
            ;;
    esac
    
    # Log suggestion generation
    echo "$(date): Generated ${#suggestions[@]} suggestions for context: ${context_type}" >> "${SUGGESTIONS_LOG}"
    
    printf '%s\n' "${suggestions[@]}"
}

# Smart timing for suggestions
should_show_suggestion() {
    local last_suggestion_time=0
    
    if [[ -f "${SUGGESTIONS_LOG}" ]]; then
        last_suggestion_time=$(stat -f %m "${SUGGESTIONS_LOG}" 2>/dev/null || echo 0)
    fi
    
    local current_time=$(date +%s)
    local time_diff=$((current_time - last_suggestion_time))
    
    case "${SUGGESTION_FREQUENCY}" in
        "frequent")
            [[ $time_diff -gt 300 ]] # 5 minutes
            ;;
        "minimal")
            [[ $time_diff -gt 3600 ]] # 1 hour
            ;;
        "smart"|*)
            # Smart timing: 15 minutes, but less if user is actively working
            if [[ $time_diff -gt 900 ]]; then
                return 0
            elif [[ $time_diff -gt 600 ]] && [[ $(find . -name "*.sh" -o -name "*.c" -o -name "*.js" -newer "${SUGGESTIONS_LOG}" 2>/dev/null | wc -l) -gt 0 ]]; then
                return 0
            else
                return 1
            fi
            ;;
    esac
}

# Main auto-assist function
run_auto_assist() {
    init_preferences
    
    if [[ "${AUTO_ASSIST_ENABLED}" != "true" ]]; then
        return 0
    fi
    
    local context_type
    context_type=$(detect_current_context)
    
    if should_show_suggestion; then
        echo ""
        echo "🤖 uDESK Auto-Assist (${context_type} context)"
        echo "═══════════════════════════════════════"
        
        # Get suggestions and pick random one (bash 3.2 compatible)
        local suggestions_temp="/tmp/suggestions_$$"
        generate_suggestions "${context_type}" > "${suggestions_temp}"
        local suggestion_count=$(wc -l < "${suggestions_temp}")
        
        # Show random suggestion for variety
        if [[ ${suggestion_count} -gt 0 ]]; then
            local random_index=$((RANDOM % suggestion_count + 1))
            local random_suggestion=$(sed -n "${random_index}p" "${suggestions_temp}")
            echo "${random_suggestion}"
        fi
        rm -f "${suggestions_temp}"
        echo ""
        echo "💭 Type 'assist help' for more suggestions or 'assist off' to disable"
        echo ""
    fi
}

# Interactive assist mode
interactive_assist() {
    init_preferences
    local context_type
    context_type=$(detect_current_context)
    
    echo "🤖 uDESK Auto-Assist Interactive Mode"
    echo "═══════════════════════════════════════"
    echo "Context: ${context_type}"
    echo ""
    
    echo ""
    
    # Show suggestions (bash 3.2 compatible)
    local suggestion_count=0
    generate_suggestions "${context_type}" | while IFS= read -r suggestion; do
        suggestion_count=$((suggestion_count + 1))
        echo "  ${suggestion_count}. ${suggestion}"
    done
    echo ""
}

# Configuration management
configure_assist() {
    echo "🔧 Auto-Assist Configuration"
    echo "═══════════════════════════"
    
    echo "Current settings:"
    echo "  Auto-Assist: ${AUTO_ASSIST_ENABLED}"
    echo "  Context Awareness: ${CONTEXT_AWARENESS}"
    echo "  Suggestion Frequency: ${SUGGESTION_FREQUENCY}"
    echo ""
    
    while true; do
        echo "Options:"
        echo "  1. Toggle auto-assist (currently: ${AUTO_ASSIST_ENABLED})"
        echo "  2. Change frequency (currently: ${SUGGESTION_FREQUENCY})"
        echo "  3. Reset preferences"
        echo "  4. Exit"
        echo ""
        
        prompt_text "Select option (1-4)" choice
        
        case "${choice}" in
            "1")
                if [[ "${AUTO_ASSIST_ENABLED}" == "true" ]]; then
                    sed -i.bak 's/AUTO_ASSIST_ENABLED=true/AUTO_ASSIST_ENABLED=false/' "${USER_PREFERENCES}"
                    echo "✅ Auto-assist disabled"
                else
                    sed -i.bak 's/AUTO_ASSIST_ENABLED=false/AUTO_ASSIST_ENABLED=true/' "${USER_PREFERENCES}"
                    echo "✅ Auto-assist enabled"
                fi
                rm -f "${USER_PREFERENCES}.bak"
                source "${USER_PREFERENCES}"
                ;;
            "2")
                echo "Frequency options: smart, frequent, minimal"
                prompt_text "Enter frequency" new_freq
                if [[ "${new_freq}" =~ ^(smart|frequent|minimal)$ ]]; then
                    sed -i.bak "s/SUGGESTION_FREQUENCY=.*/SUGGESTION_FREQUENCY=${new_freq}/" "${USER_PREFERENCES}"
                    echo "✅ Frequency updated to ${new_freq}"
                    rm -f "${USER_PREFERENCES}.bak"
                    source "${USER_PREFERENCES}"
                else
                    echo "❌ Invalid frequency option"
                fi
                ;;
            "3")
                rm -f "${USER_PREFERENCES}"
                init_preferences
                echo "✅ Preferences reset to defaults"
                ;;
            "4")
                break
                ;;
            *)
                echo "❌ Invalid option"
                ;;
        esac
        echo ""
    done
}

# Command interface
case "${1:-run}" in
    "run"|"auto")
        run_auto_assist
        ;;
    "show"|"suggestions")
        interactive_assist
        ;;
    "config"|"configure")
        configure_assist
        ;;
    "on"|"enable")
        sed -i.bak 's/AUTO_ASSIST_ENABLED=false/AUTO_ASSIST_ENABLED=true/' "${USER_PREFERENCES}" 2>/dev/null || init_preferences
        rm -f "${USER_PREFERENCES}.bak"
        echo "✅ Auto-assist enabled"
        ;;
    "off"|"disable")
        sed -i.bak 's/AUTO_ASSIST_ENABLED=true/AUTO_ASSIST_ENABLED=false/' "${USER_PREFERENCES}" 2>/dev/null || init_preferences
        rm -f "${USER_PREFERENCES}.bak"
        echo "✅ Auto-assist disabled"
        ;;
    "status")
        init_preferences
        echo "🤖 Auto-Assist Status"
        echo "═══════════════════"
        echo "Enabled: ${AUTO_ASSIST_ENABLED}"
        echo "Context: $(detect_current_context)"
        echo "Frequency: ${SUGGESTION_FREQUENCY}"
        echo "Config: ${USER_PREFERENCES}"
        ;;
    "help"|"--help")
        echo "🤖 uDESK Auto-Assist Commands"
        echo "═══════════════════════════"
        echo ""
        echo "Commands:"
        echo "  assist run           # Run context-aware suggestions"
        echo "  assist show          # Show interactive suggestions"
        echo "  assist config        # Configure preferences"
        echo "  assist on/off        # Enable/disable auto-assist"
        echo "  assist status        # Show current status"
        echo ""
        echo "Auto-assist provides context-aware development suggestions"
        echo "based on your current working environment and project type."
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'assist help' for available commands"
        exit 1
        ;;
esac
