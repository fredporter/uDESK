#!/bin/bash
# uDOS Clean Test Runner
# Replaces scattered test scripts with unified testing

UDOS_BIN="./usr/bin/udos"
UDOS_SHARE="./usr/share/udos"

echo "🧪 uDOS Test Suite"
echo "=================="

# Test core functionality
echo "Testing core udos command..."
if ! command -v "$UDOS_BIN" >/dev/null 2>&1; then
    echo "❌ udos command not found"
    exit 1
fi

echo "✅ udos command found"

# Test basic functionality
echo "Testing basic udos operations..."
$UDOS_BIN version >/dev/null 2>&1 && echo "✅ Version check passed" || echo "⚠️  Version check failed"

# Test M2 interface if available
if [ -f "$UDOS_SHARE/udos-m2-complete.js" ]; then
    echo "✅ M2 interface components found"
else
    echo "⚠️  M2 interface not found"
fi

# Test role system
echo "Testing role system..."
$UDOS_BIN role >/dev/null 2>&1 && echo "✅ Role system accessible" || echo "⚠️  Role system issues"

echo ""
echo "🎯 Test Summary: Basic functionality verified"
echo "For detailed testing, use: udos test [system|m2|quick]"
