#!/bin/bash
# Test plural formatting

source ./core/ucode-input.sh

echo "🧪 Testing format_plural function..."
echo ""
echo "Testing singular forms:"
echo "  1 TODO: $(format_plural "TODO" 1)"
echo "  1 MISSION: $(format_plural "MISSION" 1)"
echo "  1 FILE: $(format_plural "FILE" 1)"
echo ""
echo "Testing plural forms:"
echo "  3 TODO: $(format_plural "TODO" 3)"
echo "  5 MISSION: $(format_plural "MISSION" 5)"
echo "  0 MILESTONE: $(format_plural "MILESTONE" 0)"
echo "  2 GOAL: $(format_plural "GOAL" 2)"
echo ""
echo "✅ Plural formatting test complete!"
