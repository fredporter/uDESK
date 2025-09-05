#!/bin/bash
# uDESK Setup with Comprehensive Self-Healing System v1.0.7.2
# Ensures system integrity and auto-repairs common issues

set -e

echo "🔧 uDESK Setup & Health Check v1.0.7.2"
echo "======================================="

# Define essential directory structure
declare -A ESSENTIAL_DIRS=(
    ["$HOME/uDESK"]="uDESK root directory"
    ["$HOME/uDESK/iso/current"]="TinyCore ISO storage"
    ["$HOME/uDESK/iso/archive"]="TinyCore ISO archive"
    ["$HOME/uDESK/uMEMORY"]="Embedded uMEMORY workspace"
    ["$HOME/uDESK/uMEMORY/.local/logs"]="Application logs (XDG)"
    ["$HOME/uDESK/uMEMORY/.local/backups"]="User backups (XDG)"
    ["$HOME/uDESK/uMEMORY/.local/state"]="Session state (XDG)"
    ["$HOME/uDESK/uMEMORY/sandbox"]="User workspace"
    ["$HOME/uDESK/uMEMORY/sandbox/projects"]="User projects"
    ["$HOME/uDESK/uMEMORY/sandbox/drafts"]="Draft workspace"
    ["$HOME/uDESK/uMEMORY/sandbox/experiments"]="Experimental workspace"
    ["$HOME/uDESK/runtime"]="Runtime files"
    ["$HOME/uDESK/logs"]="uDESK system logs"
)

# Define essential files that should exist
declare -A ESSENTIAL_FILES=(
    ["$HOME/uDESK/installers/download-tinycore.sh"]="TinyCore downloader script"
    ["$HOME/uDESK/installers/setup.sh"]="This setup script"
    ["$HOME/uDESK/install.sh"]="Main installer"
)

# Define downloadable/recoverable files
declare -A RECOVERABLE_ACTIONS=(
    ["$HOME/uDESK/iso/current/TinyCore-current.iso"]="bash $HOME/uDESK/installers/download-tinycore.sh"
)

# Health check functions
check_directories() {
    echo "📁 Checking essential directories..."
    local missing_count=0
    local created_count=0
    
    for dir in "${!ESSENTIAL_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "⚠️  Missing: ${ESSENTIAL_DIRS[$dir]}"
            echo "   📂 $dir"
            echo "🔨 Creating directory..."
            mkdir -p "$dir"
            ((missing_count++))
            ((created_count++))
        else
            echo "✓ ${ESSENTIAL_DIRS[$dir]}"
        fi
    done
    
    if [ $missing_count -gt 0 ]; then
        echo "📝 Created $created_count missing directories"
    else
        echo "✅ All essential directories present"
    fi
    
    return $missing_count
}

check_essential_files() {
    echo ""
    echo "📄 Checking essential files..."
    local missing_files=()
    local found_count=0
    
    for file in "${!ESSENTIAL_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            echo "⚠️  Missing: ${ESSENTIAL_FILES[$file]}"
            echo "   📄 $file"
            missing_files+=("$file")
        else
            echo "✓ ${ESSENTIAL_FILES[$file]}"
            ((found_count++))
        fi
    done
    
    echo "📊 Found $found_count/${#ESSENTIAL_FILES[@]} essential files"
    
    # Attempt to heal missing files
    if [ ${#missing_files[@]} -gt 0 ]; then
        echo ""
        echo "🔄 Attempting to heal ${#missing_files[@]} missing files..."
        heal_missing_files "${missing_files[@]}"
        return $?
    fi
    
    return 0
}

check_recoverable_resources() {
    echo ""
    echo "📥 Checking recoverable resources..."
    local missing_count=0
    
    for resource in "${!RECOVERABLE_ACTIONS[@]}"; do
        if [ ! -f "$resource" ]; then
            echo "⚠️  Missing: $(basename "$resource")"
            echo "🔄 Attempting recovery..."
            if eval "${RECOVERABLE_ACTIONS[$resource]}"; then
                echo "✅ Successfully recovered: $(basename "$resource")"
            else
                echo "❌ Failed to recover: $(basename "$resource")"
                ((missing_count++))
            fi
        else
            echo "✓ $(basename "$resource")"
        fi
    done
    
    return $missing_count
}

heal_missing_files() {
    local missing_files=("$@")
    local healed_count=0
    
    echo "🩺 Attempting to heal ${#missing_files[@]} missing files..."
    
    # Try git operations to restore missing files
    if [ -d "$HOME/uDESK/repo/.git" ]; then
        echo "🔄 Updating uDESK repository..."
        cd "$HOME/uDESK/repo"
        
        # Gentle restoration - don't lose local changes
        if git status --porcelain | grep -q .; then
            echo "⚠️  Local changes detected - using safe update..."
            git fetch origin
            git merge origin/main 2>/dev/null || git merge origin/master 2>/dev/null || echo "⚠️  Merge failed - manual intervention may be needed"
        else
            echo "🔄 Clean repository - performing hard reset..."
            git fetch origin
            git reset --hard origin/main 2>/dev/null || git reset --hard origin/master 2>/dev/null || echo "⚠️  Reset failed"
        fi
    fi
    
    # Check if files are now present after git operations
    local still_missing=()
    for file in "${missing_files[@]}"; do
        if [ -f "$file" ]; then
            echo "✅ Healed: $(basename "$file")"
            ((healed_count++))
        else
            still_missing+=("$file")
        fi
    done
    
    if [ ${#still_missing[@]} -gt 0 ]; then
        echo ""
        echo "💥 Unable to heal ${#still_missing[@]} files:"
        printf "   📄 %s\n" "${still_missing[@]}"
        echo ""
        echo "🆘 Manual intervention required:"
        echo "   1. Check internet connection"
        echo "   2. Verify repository integrity"
        echo "   3. Re-run installer: bash install.sh"
        return 1
    else
        echo "✅ All files successfully healed! ($healed_count/$((${#missing_files[@]})))"
        return 0
    fi
}

validate_permissions() {
    echo ""
    echo "🔐 Validating permissions..."
    local fixed_count=0
    
    # Make scripts executable
    if [ -d "$HOME/uDESK/repo/scripts" ]; then
        find "$HOME/uDESK/repo/scripts" -name "*.sh" -type f | while read -r script; do
            if [ ! -x "$script" ]; then
                chmod +x "$script"
                echo "🔧 Fixed permissions: $(basename "$script")"
                ((fixed_count++))
            fi
        done
    fi
    
    # Make main installer executable
    if [ -f "$HOME/uDESK/repo/install.sh" ] && [ ! -x "$HOME/uDESK/repo/install.sh" ]; then
        chmod +x "$HOME/uDESK/repo/install.sh"
        echo "🔧 Fixed permissions: install.sh"
        ((fixed_count++))
    fi
    
    if [ $fixed_count -eq 0 ]; then
        echo "✅ All permissions correct"
    fi
}

generate_health_report() {
    echo ""
    echo "📋 Health Report Summary"
    echo "======================="
    echo "📂 Directory structure: $([ -d "$HOME/uDESK/repo" ] && echo "✅ OK" || echo "❌ FAIL")"
    echo "📄 Essential files: $([ -f "$HOME/uDESK/repo/install.sh" ] && echo "✅ OK" || echo "❌ FAIL")"
    echo "📀 TinyCore ISO: $([ -f "$HOME/uDESK/iso/current/TinyCore-current.iso" ] && echo "✅ OK" || echo "⚠️  MISSING")"
    echo "🔧 Git repository: $([ -d "$HOME/uDESK/repo/.git" ] && echo "✅ OK" || echo "❌ FAIL")"
    echo "🏠 uMEMORY structure: $([ -d "$HOME/uMEMORY/sandbox" ] && echo "✅ OK" || echo "❌ FAIL")"
}

# Main health check and setup sequence
main() {
    echo "🏥 Starting comprehensive health check..."
    
    local exit_code=0
    
    # Run all health checks
    check_directories || ((exit_code++))
    check_essential_files || ((exit_code++))
    check_recoverable_resources || ((exit_code++))
    validate_permissions
    
    # Generate final report
    generate_health_report
    
    echo ""
    if [ $exit_code -eq 0 ]; then
        echo "✅ Health check completed successfully!"
        echo "🚀 uDESK system is ready for use"
    else
        echo "⚠️  Health check completed with $exit_code issues"
        echo "🔧 Some components may need manual attention"
    fi
    
    echo ""
    echo "📍 System Locations:"
    echo "   Core: ~/uDESK/repo/"
    echo "   Data: ~/uMEMORY/"
    echo "   ISOs: ~/uDESK/iso/"
    
    return $exit_code
}

# Execute main function
main "$@"
