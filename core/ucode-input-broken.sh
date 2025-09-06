#!/bin/bash
# uDESK uCODE Input Library v1.0.7.3  
# Smart input parsing with colored options and Nethack-inspired messaging

# Color definitions for consistent UI
GREEN='\033[0;32m'     # Default/Recommended option
YELLOW='\033[1;33m'    # Alternative options
CYAN='\033[0;36m'      # Prompts and labels  
RED='\033[0;31m'       # Warnings/Errors
BLUE='\033[0;34m'      # Information
BOLD='\033[1m'         # Emphasis
NC='\033[0m'           # No Color (reset)

# uCODE Standard Input Handling Functions with Smart Matching
# ============================================================

# Parse uCODE format input - case insensitive, supports shortcuts and partial matches
parse_ucode_input() {
    local input="$1"
    local options="$2"  # Format: "UPDATE|DESTROY|CANCEL" or "YES|NO"
    local allow_empty="$3"  # Optional: "allow_empty" to permit null entries
    
    # Handle empty input
    if [[ -z "$input" ]]; then
        if [[ "$allow_empty" == "allow_empty" ]]; then
            echo "EMPTY"
            return 0
        else
            echo "NULL_REJECTED"
            return 1
        fi
    fi
    
    # Convert to uppercase for comparison
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
    
    # Split options by pipe (bash 3.2 compatible)
    local options_list=""
    local remaining="$options"
    while [[ -n "$remaining" ]]; do
        if [[ "$remaining" == *"|"* ]]; then
            options_list="$options_list ${remaining%%|*}"
            remaining="${remaining#*|}"
        else
            options_list="$options_list $remaining"
            break
        fi
    done
    
    # Check for exact match first
    for opt in $options_list; do
        if [[ "$input" == "$opt" ]]; then
            echo "$opt"
            return 0
        fi
    done
    
    # Check for partial matches (must be unique)
    local matches=""
    local match_count=0
    for opt in $options_list; do
        if [[ "$opt" == "$input"* ]]; then
            matches="$matches $opt"
            ((match_count++))
        fi
    done
    
    # If exactly one match, use it
    if [[ $match_count -eq 1 ]]; then
        echo "$matches" | sed 's/^ *//'
        return 0
    fi
    
    # If multiple matches, it's ambiguous
    if [[ $match_count -gt 1 ]]; then
        echo "AMBIGUOUS"
        return 1
    fi
    
    # No matches found
    echo "INVALID"
    return 1
}

# Prompt with uCODE format, colored options, and Nethack flair
prompt_ucode() {
    local prompt="$1"
    local options="$2"  # Format: "UPDATE|DESTROY|CANCEL"
    local default="$3"  # Optional default value
    local allow_empty="$4"  # Optional: "allow_empty"
    
    # Build display options with colors (bash 3.2 compatible)
    local options_array="$options"
    local display_opts=""
    local opt_count=0
    local current_opt
    
    # Count options first
    local temp_options="$options"
    while [[ -n "$temp_options" ]]; do
        if [[ "$temp_options" == *"|"* ]]; then
            temp_options="${temp_options#*|}"
            ((opt_count++))
        else
            ((opt_count++))
            break
        fi
    done
    
    # Build display string manually
    local remaining_options="$options"
    local i=0
    while [[ -n "$remaining_options" ]]; do
        if [[ "$remaining_options" == *"|"* ]]; then
            current_opt="${remaining_options%%|*}"
            remaining_options="${remaining_options#*|}"
        else
            current_opt="$remaining_options"
            remaining_options=""
        fi
        
        if [[ -n "$default" && "$current_opt" == "$default" ]]; then
            # Default option in green
            display_opts+="${GREEN}${current_opt}${NC}"
        else
            # Alternative options in yellow
            display_opts+="${YELLOW}${current_opt}${NC}"
        fi
        
        ((i++))
        if [[ $i -lt $opt_count ]]; then
            display_opts+="|"
        fi
    done
    
    while true; do
        if [[ -n "$default" ]]; then
            echo -e "${CYAN}$prompt${NC} [${display_opts}]: \c"
            read input
            # Use default if empty
            if [[ -z "$input" ]]; then
                input="$default"
            fi
        else
            echo -e "${CYAN}$prompt${NC} [${display_opts}]: \c"
            read input
        fi
        
        result=$(parse_ucode_input "$input" "$options" "$allow_empty")
        case "$result" in
            "INVALID")
                echo -e "${RED}⚠️  Your incantation '$input' fizzles out!${NC} The magical choices are: [${display_opts}]"
                echo -e "   ${BLUE}💡 Try partial matches like 'y' for YES, 'c' for CONFIRM, etc.${NC}"
                ;;
            "AMBIGUOUS")
                echo -e "${YELLOW}🔮 Your spell '$input' is too vague! Multiple possibilities detected.${NC}"
                echo -e "   ${BLUE}📜 Available enchantments: [${display_opts}]${NC}"
                echo -e "   ${CYAN}⚔️  Be more specific, brave adventurer!${NC}"
                ;;
            "NULL_REJECTED")
                echo -e "${RED}🚫 The void whispers back... but we need an actual choice!${NC}"
                echo -e "   ${BLUE}🎯 Pick from the sacred options: [${display_opts}]${NC}"
                ;;
            "EMPTY")
                echo "$result"
                return 0
                ;;
            *)
                echo -e "${GREEN}✨ Accepted: $result${NC}"
                echo "$result"
                return 0
                ;;
        esac
        echo ""
    done
}

# Specialized prompts for common uDESK patterns
prompt_yes_no() {
    local prompt="$1"
    local default="$2"
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

# Test function to validate the input system
test_ucode_input() {
    echo "🧪 Testing uCODE Input System"
    echo "═══════════════════════════"
    
    echo ""
    echo "Test 1: YES/NO prompt"
    result=$(prompt_yes_no "🤔 Do you like Nethack references?" "YES")
    echo "Result: $result"
    
    echo ""
    echo "Test 2: Duration prompt"
    result=$(prompt_duration "⏰ How long should this quest take?")
    echo "Result: $result"
    
    echo ""
    echo "Test 3: Custom options"
    result=$(prompt_ucode "🎯 Choose your class" "WARRIOR|MAGE|ROGUE|HEALER" "MAGE")
    echo "Result: $result"
    
    echo ""
    echo "✅ uCODE input system tested!"
}

# Export functions for use in other scripts
export -f parse_ucode_input
export -f prompt_ucode
export -f prompt_yes_no
export -f prompt_confirm_modify
export -f prompt_duration
export -f prompt_priority
