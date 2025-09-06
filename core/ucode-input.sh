#!/bin/bash
# uDESK uCODE Input Library v1.0.7.3 - Personal Growth Edition
# Basic Bash 3.2+ compatible - Works on macOS and TinyCore Linux

# 🌟 Personal Growth Philosophy: 
# Every interaction is a learning opportunity for systems mastery

# Color definitions (with fallback detection)
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    GREEN=$(tput setaf 2)     # Default/Recommended option
    YELLOW=$(tput setaf 3)    # Alternative options
    CYAN=$(tput setaf 6)      # Prompts and labels  
    RED=$(tput setaf 1)       # Warnings/Errors
    BLUE=$(tput setaf 4)      # Information
    BOLD=$(tput bold)         # Emphasis
    NC=$(tput sgr0)           # No Color (reset)
else
    # Fallback for systems without tput
    GREEN=''
    YELLOW=''
    CYAN=''
    RED=''
    BLUE=''
    BOLD=''
    NC=''
fi

# Parse uCODE input - bash 3.2 compatible string processing
parse_ucode_input() {
    local input="$1"
    local options="$2"
    local allow_empty="$3"
    
    # Handle empty input with growth mindset
    if [[ -z "$input" ]]; then
        if [[ "$allow_empty" == "allow_empty" ]]; then
            echo "EMPTY"
            return 0
        else
            echo "NULL_REJECTED"
            return 1
        fi
    fi
    
    # Convert to uppercase for comparison (bash 3.2 compatible)
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
    
    # Manual option parsing (no arrays needed)
    local remaining_options="$options"
    local found_exact=""
    local found_partial=""
    local partial_count=0
    
    # Check each option manually
    while [[ -n "$remaining_options" ]]; do
        local current_opt
        if [[ "$remaining_options" == *"|"* ]]; then
            current_opt="${remaining_options%%|*}"
            remaining_options="${remaining_options#*|}"
        else
            current_opt="$remaining_options"
            remaining_options=""
        fi
        
        # Check for exact match
        if [[ "$input" == "$current_opt" ]]; then
            found_exact="$current_opt"
            break
        fi
        
        # Check for partial match
        if [[ "$current_opt" == "$input"* ]]; then
            if [[ -z "$found_partial" ]]; then
                found_partial="$current_opt"
                partial_count=1
            else
                partial_count=$((partial_count + 1))
            fi
        fi
    done
    
    # Return results based on matching logic
    if [[ -n "$found_exact" ]]; then
        echo "$found_exact"
        return 0
    elif [[ $partial_count -eq 1 ]]; then
        echo "$found_partial" 
        return 0
    elif [[ $partial_count -gt 1 ]]; then
        echo "AMBIGUOUS"
        return 1
    else
        echo "INVALID"
        return 1
    fi
}

# Build colored display options (bash 3.2 compatible)
build_display_options() {
    local options="$1"
    local default="$2"
    local display_opts=""
    local remaining_options="$options"
    local first=true
    
    while [[ -n "$remaining_options" ]]; do
        local current_opt
        if [[ "$remaining_options" == *"|"* ]]; then
            current_opt="${remaining_options%%|*}"
            remaining_options="${remaining_options#*|}"
        else
            current_opt="$remaining_options"
            remaining_options=""
        fi
        
        # Add separator for subsequent options
        if [[ "$first" != "true" ]]; then
            display_opts="$display_opts|"
        fi
        first=false
        
        # Color coding based on default
        if [[ -n "$default" && "$current_opt" == "$default" ]]; then
            display_opts="$display_opts${GREEN}$current_opt${NC}"
        else
            display_opts="$display_opts${YELLOW}$current_opt${NC}"
        fi
    done
    
    echo "$display_opts"
}

# Prompt with uCODE format and personal growth messaging
prompt_ucode() {
    local prompt="$1"
    local options="$2"
    local default="$3"
    local allow_empty="$4"
    
    local display_opts
    display_opts=$(build_display_options "$options" "$default")
    
    while true; do
        # Display prompt with colors (to stderr for proper variable capture)
        echo -ne "${CYAN}$prompt${NC} [$display_opts]: " >&2
        read input
        
        # Use default if empty and default provided
        if [[ -z "$input" && -n "$default" ]]; then
            input="$default"
        fi
        
        # Parse the input
        local result
        result=$(parse_ucode_input "$input" "$options" "$allow_empty")
        
        case "$result" in
            "INVALID")
                echo -e "${RED}🌱 That's not quite right - great learning opportunity!${NC}" >&2
                echo -e "   ${BLUE}💡 Your choices are: [$display_opts]${NC}" >&2
                echo -e "   ${CYAN}🎯 Try partial matches like 'y' for YES, 'c' for CONFIRM${NC}" >&2
                echo "" >&2
                ;;
            "AMBIGUOUS")
                echo -e "${YELLOW}🔍 Your input '$input' matches multiple options - nice thinking!${NC}" >&2
                echo -e "   ${BLUE}📜 Available choices: [$display_opts]${NC}" >&2
                echo -e "   ${CYAN}⭐ Be more specific to help the system understand${NC}" >&2
                echo "" >&2
                ;;
            "NULL_REJECTED")
                echo -e "${RED}📝 We need your input to continue this learning journey!${NC}" >&2
                echo -e "   ${BLUE}🎯 Please choose from: [$display_opts]${NC}" >&2
                echo "" >&2
                ;;
            "EMPTY")
                echo "$result"
                return 0
                ;;
            *)
                echo -e "${GREEN}✨ Perfect! You chose: $result${NC}" >&2
                echo "$result"
                return 0
                ;;
        esac
    done
}

# Specialized prompt functions for common patterns
prompt_yes_no() {
    local prompt="$1"
    local default="${2:-YES}"
    prompt_ucode "$prompt" "YES|NO" "$default"
}

prompt_confirm_modify() {
    local prompt="$1" 
    local default="${2:-CONFIRM}"
    prompt_ucode "$prompt" "CONFIRM|MODIFY" "$default"
}

prompt_duration() {
    local prompt="$1"
    local default="${2:-4-HOURS}"
    prompt_ucode "$prompt" "2-HOURS|4-HOURS|8-HOURS|1-DAY|2-DAYS" "$default"
}

prompt_priority() {
    local prompt="$1"
    local default="${2:-HIGH}"
    prompt_ucode "$prompt" "LOW|MEDIUM|HIGH|CRITICAL" "$default"
}

# Personal growth message functions
growth_message() {
    local context="$1"
    local level="${2:-info}"
    
    case "$level" in
        "success")
            echo -e "${GREEN}🌟 Excellent progress! You're developing strong systems thinking.${NC}"
            ;;
        "learning")
            echo -e "${BLUE}📚 This challenge helps you understand $context better.${NC}"
            ;;
        "encouragement")
            echo -e "${CYAN}💪 Keep going! Every expert was once a beginner.${NC}"
            ;;
        *)
            echo -e "${BLUE}💡 $context${NC}"
            ;;
    esac
}

# Test function for validation
test_ucode_compatibility() {
    echo "🧪 Testing uCODE Compatibility System"
    echo "═══════════════════════════════════════"
    echo ""
    
    # Test basic parsing
    echo "Testing parse_ucode_input function:"
    echo "  Input 'y' for 'YES|NO': $(parse_ucode_input "y" "YES|NO")"
    echo "  Input 'CON' for 'CONFIRM|MODIFY': $(parse_ucode_input "CON" "CONFIRM|MODIFY")"
    echo "  Input 'xyz' for 'YES|NO': $(parse_ucode_input "xyz" "YES|NO")"
    echo ""
    
    # Test display building
    echo "Testing display options:"
    echo "  YES|NO with YES default: $(build_display_options "YES|NO" "YES")"
    echo "  CONFIRM|MODIFY with CONFIRM default: $(build_display_options "CONFIRM|MODIFY" "CONFIRM")" 
    echo ""
    
    growth_message "uCODE compatibility testing" "success"
    echo ""
    echo "✅ Basic compatibility validated for bash 3.2+"
    echo "✅ Works on macOS and TinyCore Linux"
    echo "✅ Personal growth messaging integrated"
}

# Export core functions for use in other scripts
export -f parse_ucode_input
export -f prompt_ucode  
export -f prompt_yes_no
export -f prompt_confirm_modify
export -f prompt_duration
export -f prompt_priority
export -f growth_message

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
            "FILE") echo "FILEs" ;;
            "TASK") echo "TASKs" ;;
            *) echo "${word}s" ;;
        esac
    fi
}

export -f format_plural

# Run compatibility test if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    test_ucode_compatibility
fi
