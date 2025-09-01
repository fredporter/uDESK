#!/bin/sh
echo "=== GitHub Access Diagnostic ==="
echo "Testing connection to GitHub..."

# Basic connectivity
echo "1. Testing ping to github.com:"
ping -c 2 github.com

echo ""
echo "2. Testing curl to GitHub:"
curl -I https://github.com 2>&1

echo ""
echo "3. Testing raw GitHub access:"
TEST_URL="https://raw.githubusercontent.com/fredporter/uDESK/main/vm/test-basic.sh"
echo "URL: $TEST_URL"
echo "Response:"
curl -v "$TEST_URL" 2>&1

echo ""
echo "4. What we should get:"
echo "#!/bin/sh"
echo "echo \"test\""

echo ""
echo "=== End Diagnostic ==="
