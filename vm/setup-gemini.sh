#!/bin/bash
# Setup Gemini CLI as free alternative to Claude

echo "🤖 Setting up Gemini CLI (Free AI Assistant)..."

# Install Gemini CLI via npm
if command -v npm >/dev/null 2>&1; then
    npm install -g @google/generative-ai-cli
else
    echo "❌ Node.js not available, installing..."
    tce-load -wi nodejs
    npm install -g @google/generative-ai-cli
fi

# Create wrapper script for easy access
cat > /usr/local/bin/ai << 'EOF'
#!/bin/bash
# uDOS AI Assistant using Gemini CLI

# Check if API key is configured
if [ -z "$GEMINI_API_KEY" ] && [ ! -f ~/.gemini-key ]; then
    echo "🔑 Gemini API Key Setup Required"
    echo "1. Get free API key: https://makersuite.google.com/app/apikey"
    echo "2. Save to: echo 'your-key' > ~/.gemini-key"
    echo "3. Run: source ~/.bashrc"
    exit 1
fi

# Load API key if available
if [ -f ~/.gemini-key ]; then
    export GEMINI_API_KEY=$(cat ~/.gemini-key)
fi

# Run Gemini CLI with user input
if [ $# -eq 0 ]; then
    echo "uDOS AI Assistant (Gemini)"
    echo "Usage: ai 'your question'"
    echo "Example: ai 'how do I list files in Linux?'"
else
    gemini generate "$*"
fi
EOF

chmod +x /usr/local/bin/ai

# Create API key helper
cat > /usr/local/bin/ai-setup << 'EOF'
#!/bin/bash
# Setup Gemini API key

echo "🔑 Gemini API Key Setup"
echo "1. Visit: https://makersuite.google.com/app/apikey"
echo "2. Create a free API key"
echo "3. Enter your API key below:"
echo ""

read -p "API Key: " -s api_key
echo ""

if [ -n "$api_key" ]; then
    echo "$api_key" > ~/.gemini-key
    chmod 600 ~/.gemini-key
    
    # Add to bashrc
    if ! grep -q "GEMINI_API_KEY" ~/.bashrc; then
        echo "export GEMINI_API_KEY=\$(cat ~/.gemini-key 2>/dev/null)" >> ~/.bashrc
    fi
    
    echo "✅ Gemini API key configured!"
    echo "💡 Run 'ai \"hello\"' to test"
else
    echo "❌ No API key provided"
fi
EOF

chmod +x /usr/local/bin/ai-setup

echo "✅ Gemini CLI setup complete!"
echo "💡 Run 'ai-setup' to configure your free API key"
