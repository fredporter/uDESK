#!/bin/bash
# TinyCore VM Setup for uDOS
# Run this script in a fresh TinyCore VM

echo "🚀 uDOS TinyCore VM Setup"
echo "================================"

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

# Step 2: Switch to bash and run installation
echo "🐚 Switching to bash and installing clean uDOS..."
bash -c "

# Create working directory and clone repository
echo '📁 Setting up workspace...'
mkdir -p /home/tc/Code
cd /home/tc/Code

echo '🔄 Cloning uDESK repository...'
git clone https://github.com/fredporter/uDESK.git
cd uDESK

echo '🛠️  Running clean uDOS installer...'
chmod +x vm/current/install-clean-udos.sh
./vm/current/install-clean-udos.sh

echo '🔧 Loading PATH configuration...'
source ~/.profile

echo '🧪 Testing clean installation...'
udos version
udos help

echo ''
echo '🎉 Clean uDOS TinyCore VM Setup Complete!'
echo '=========================================='
echo 'Clean Architecture:'
echo '  /usr/local/bin/udos    - Main unified command'
echo '  /usr/local/bin/uvar    - Variable management wrapper'
echo '  /usr/local/bin/udata   - Data management wrapper'
echo '  /usr/local/bin/utpl    - Template management wrapper'
echo ''
echo 'Available commands:'
echo '  udos help         - Show all commands'
echo '  udos init         - Initialize environment'
echo '  udos role detect  - Detect capabilities'
echo '  udos info         - System information'
echo '  uvar set KEY=VAL  - Set variable'
echo '  utpl list         - List templates'
echo ''
echo 'Repository location: /home/tc/Code/uDESK'
echo ''

"
