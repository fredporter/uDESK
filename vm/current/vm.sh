#!/bin/bash
# Quick TinyCore VM Setup for uDOS
# Run this script in a fresh TinyCore VM

echo "🚀 uDOS TinyCore VM Quick Setup"
echo "==============================="

# Function to check if command was successful
check_success() {
    if [ $? -eq 0 ]; then
        echo "✅ $1"
    else
        echo "❌ $1 failed"
        exit 1
    fi
}

# Step 1: Install essential tools
echo "📦 Installing essential tools..."
tce-load -wi git bash curl wget
check_success "Essential tools installed"

# Step 2: Switch to bash
echo "🐚 Switching to bash..."
bash -c "

# Step 3: Create working directory and clone repository
echo '📁 Setting up workspace...'
mkdir -p /home/tc/Code
cd /home/tc/Code

echo '🔄 Cloning uDESK repository...'
git clone https://github.com/fredporter/uDESK.git
cd uDESK

echo '🛠️  Running uDOS installer...'
chmod +x vm/current/install-udos-tinycore.sh
./vm/current/install-udos-tinycore.sh

echo '🔧 Loading PATH configuration...'
source ~/.profile

echo '🧪 Testing installation...'
udos version

echo ''
echo '🎉 uDOS TinyCore VM Setup Complete!'
echo '======================================'
echo 'Available commands:'
echo '  udos version  - Show version information'
echo '  udos help     - Show help information'
echo '  udos info     - Show system information'
echo ''
echo 'Repository location: /home/tc/Code/uDESK'
echo ''

"
