#!/bin/bash
# Test uCODE prompt compatibility

# Source the uCODE input library
source /Users/fredbook/Code/uDESK/core/ucode-input.sh

echo "🧪 Testing prompt_ucode function..."
echo ""

# Test the exact call from express-dev.sh
echo "About to call: prompt_ucode \"Which mode calls to you?\" \"DEV|EXPRESS\" \"EXPRESS\""
result=$(prompt_ucode "Which mode calls to you?" "DEV|EXPRESS" "EXPRESS")
echo "Result: '$result'"
echo ""

echo "✅ Test completed!"
