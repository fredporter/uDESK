#!/bin/bash
# Test uCODE Input System

source "$(dirname "${BASH_SOURCE[0]}")/core/ucode-input.sh"

echo "🧪 uCODE Input System Test"
echo "═══════════════════════════"
echo ""

# Test basic functionality
echo "Test 1: Basic parsing"
result=$(parse_ucode_input "y" "YES|NO")
echo "Input 'y' with options 'YES|NO' → Result: $result"

result=$(parse_ucode_input "conf" "CONFIRM|MODIFY")
echo "Input 'conf' with options 'CONFIRM|MODIFY' → Result: $result"

result=$(parse_ucode_input "xyz" "YES|NO")
echo "Input 'xyz' with options 'YES|NO' → Result: $result"

echo ""
echo "✅ Basic parsing tests complete!"
echo ""
echo "Now testing interactive prompts..."
echo ""

# Test interactive prompts - but exit cleanly for automation
echo "Would run: prompt_yes_no \"🤖 Do you like the new input system?\" \"YES\""
echo "Would run: prompt_duration \"⏰ How long for testing?\""

echo ""
echo "🎉 All tests completed!"
