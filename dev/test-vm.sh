#!/bin/bash
# Host-side script to test changes in VM (UTM Compatible)

VM_IP="${VM_IP:-192.168.64.2}"  # UTM default, or set VM_IP environment variable
VM_USER="tc"

echo "🔄 Testing uDOS changes in VM (UTM)..."

case "$1" in
    "deploy")
        echo "📤 Deploying to UTM VM..."
        
        # Try to copy via SCP if SSH works
        if ssh -o ConnectTimeout=5 "$VM_USER@$VM_IP" "echo 'SSH OK'" 2>/dev/null; then
            echo "Using SCP deployment..."
            
            # Create temp directory on VM
            ssh "$VM_USER@$VM_IP" "mkdir -p /tmp/udos-update"
            
            # Copy all CLI tools
            scp build/uDOS-core/usr/local/bin/udos "$VM_USER@$VM_IP:/tmp/udos-update/"
            scp build/uDOS-core/usr/local/bin/uvar "$VM_USER@$VM_IP:/tmp/udos-update/"
            scp build/uDOS-core/usr/local/bin/udata "$VM_USER@$VM_IP:/tmp/udos-update/"
            scp build/uDOS-core/usr/local/bin/utpl "$VM_USER@$VM_IP:/tmp/udos-update/"
            
            # Install on VM
            ssh "$VM_USER@$VM_IP" << 'EOF'
sudo cp /tmp/udos-update/* /usr/local/bin/
sudo chmod +x /usr/local/bin/udos*
rm -rf /tmp/udos-update
echo "✅ uDOS CLI tools deployed via SCP!"
EOF
        else
            echo "❌ SSH not available. Use manual deployment:"
            echo ""
            echo "1. Copy this to your UTM VM terminal:"
            echo "   curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash"
            echo ""
            echo "2. Or manually copy files from build/uDOS-core/usr/local/bin/"
            echo ""
            echo "3. Set VM_IP environment variable: export VM_IP=your.vm.ip"
        fi
        ;;
    "test")
        echo "🧪 Running tests..."
        if ssh -o ConnectTimeout=5 "$VM_USER@$VM_IP" "echo 'SSH OK'" 2>/dev/null; then
            ssh "$VM_USER@$VM_IP" << 'EOF'
echo "Testing uDOS functionality..."
udos version
udos init
udos var set TEST_VAR="Hello from $(date)"
udos var get TEST_VAR
udos var list
echo '{"test": "data", "timestamp": "'$(date)'"}' | udata save test-config 2>/dev/null || echo "udata not fully available"
echo "✅ Basic tests completed"
EOF
        else
            echo "❌ SSH not available to $VM_IP"
            echo "💡 Try: export VM_IP=your.actual.vm.ip"
            echo "💡 Or test manually in VM with: udos version && udos test"
        fi
        ;;
    "connect")
        echo "🔗 Connecting to VM..."
        if ssh -o ConnectTimeout=5 "$VM_USER@$VM_IP" "echo 'SSH OK'" 2>/dev/null; then
            ssh "$VM_USER@$VM_IP"
        else
            echo "❌ SSH not available to $VM_IP"
            echo "💡 Check UTM network settings and VM IP"
            echo "💡 Try: export VM_IP=your.actual.vm.ip"
        fi
        ;;
    "install")
        echo "🚀 Installing uDOS in UTM VM..."
        if ssh -o ConnectTimeout=5 "$VM_USER@$VM_IP" "echo 'SSH OK'" 2>/dev/null; then
            echo "Installing via SSH..."
            ssh "$VM_USER@$VM_IP" << 'EOF'
# Install curl first if needed
if ! command -v curl >/dev/null 2>&1; then
    echo "📦 Installing curl..."
    tce-load -wi curl
fi

# Install uDOS
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash
EOF
        else
            echo "❌ SSH not available. Manual installation required:"
            echo ""
            echo "In your UTM VM terminal, run these commands:"
            echo "  tce-load -wi curl"
            echo "  curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash"
            echo ""
        fi
        ;;
    "ip")
        echo "🔍 Detecting VM IP..."
        echo "Current VM_IP: $VM_IP"
        echo ""
        echo "To find your UTM VM IP:"
        echo "1. In UTM VM: ip addr show"
        echo "2. Look for inet address (usually 192.168.64.x)"
        echo "3. Set: export VM_IP=your.vm.ip"
        echo "4. Test: ./test-vm.sh connect"
        ;;
    *)
        echo "UTM VM Testing Commands:"
        echo "  install     - Install uDOS in UTM VM (one-liner)"
        echo "  deploy      - Deploy latest build to VM (if SSH works)"
        echo "  test        - Run basic functionality tests"  
        echo "  connect     - SSH into VM (if configured)"
        echo "  ip          - Help with VM IP detection"
        echo ""
        echo "UTM Setup:"
        echo "  1. Find VM IP: In VM run 'ip addr show'"
        echo "  2. Set IP: export VM_IP=192.168.64.X"
        echo "  3. Install: ./test-vm.sh install"
        echo "  4. Test: ./test-vm.sh test"
        echo ""
        echo "Manual Installation (if SSH not working):"
        echo "  In UTM VM: curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/github-install.sh | bash"
        ;;
esac
