#!/bin/bash
# M1 Comprehensive Test Script
# Tests the clean uDOS installation and functionality

echo "🚀 M1 uDOS Test Suite"
echo "===================="

# Test 1: Installation
echo "📦 Testing installation..."
if command -v udos >/dev/null 2>&1; then
    echo "✅ udos command available"
else
    echo "❌ udos command not found"
    exit 1
fi

# Test 2: Version check
echo "🔍 Testing version..."
if udos version >/dev/null 2>&1; then
    echo "✅ udos version works"
    udos version
else
    echo "❌ udos version failed"
fi

# Test 3: Role system
echo "👤 Testing role system..."
if udos role >/dev/null 2>&1; then
    echo "✅ udos role works"
    udos role
else
    echo "❌ udos role failed"
fi

# Test 4: Core commands
echo "⚙️  Testing core commands..."
for cmd in "help" "var list" "data list"; do
    if udos $cmd >/dev/null 2>&1; then
        echo "✅ udos $cmd works"
    else
        echo "❌ udos $cmd failed"
    fi
done

# Test 5: Wrapper scripts
echo "🔗 Testing wrapper scripts..."
for wrapper in uvar udata utpl; do
    if command -v $wrapper >/dev/null 2>&1; then
        echo "✅ $wrapper available"
    else
        echo "❌ $wrapper not found"
    fi
done

echo ""
echo "🎉 M1 Test Complete!"
echo "If all tests passed, M1 is ready and we can begin M2 development."
