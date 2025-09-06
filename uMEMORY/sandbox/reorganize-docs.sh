#!/bin/bash
# uDESK Documentation Reorganization Script
# Organizes docs into Wiki, Archive, and Active Development

echo "📚 uDESK Documentation Reorganization"
echo "======================================"

# Create archive directories
mkdir -p docs/archive/sessions
mkdir -p docs/archive/completed-versions
mkdir -p docs/archive/dev-summaries
mkdir -p docs/archive/roadmaps-old

echo ""
echo "🎯 WIKI MIGRATION CANDIDATES:"
echo "These should be moved to GitHub Wiki..."

# Core documentation files for wiki
declare -A wiki_files=(
    ["docs/ARCHITECTURE.md"]="Architecture"
    ["docs/BUILD.md"]="Build-System" 
    ["docs/UCODE-MANUAL.md"]="uCODE-Manual"
    ["docs/STYLE-GUIDE.md"]="Style-Guide"
    ["docs/roadmaps/DESKTOP-INTEGRATION.md"]="Desktop-Integration-Roadmap"
)

for file in "${!wiki_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file → wiki/${wiki_files[$file]}.md"
        cp "$file" "wiki-content/${wiki_files[$file]}.md" 2>/dev/null || echo "    (will be copied later)"
    else
        echo "  ❌ $file (not found)"
    fi
done

echo ""
echo "📦 ARCHIVE CANDIDATES:"
echo "These are historical/completed items..."

# Development archive files
declare -A archive_files=(
    ["docs/dev/FINAL-SESSION-SUMMARY-20250904.md"]="docs/archive/sessions/"
    ["docs/dev/SESSION-ECOSYSTEM-20250904.md"]="docs/archive/sessions/"
    ["docs/dev/M1-FOUNDATION-COMPLETE.md"]="docs/archive/completed-versions/"
    ["docs/dev/M2-ECOSYSTEM-COMPLETE.md"]="docs/archive/completed-versions/"
    ["docs/dev/V1_7-ROADMAP-COMPLETED.md"]="docs/archive/completed-versions/"
    ["docs/dev/IMPLEMENTATION-COMPLETE.md"]="docs/archive/dev-summaries/"
    ["docs/dev/IMPLEMENTATION-FINAL.md"]="docs/archive/dev-summaries/"
    ["docs/dev/DOCUMENTATION-CONSOLIDATION-COMPLETE.md"]="docs/archive/dev-summaries/"
    ["docs/roadmaps/V1_0_7-ROADMAP.md"]="docs/archive/roadmaps-old/"
)

for file in "${!archive_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  📦 $file → ${archive_files[$file]}"
    fi
done

echo ""
echo "⚡ KEEP ACTIVE:"
echo "These should stay in their current locations..."

active_files=(
    "docs/dev/AI-WORKFLOW-STANDARDS.md"
    "docs/dev/SESSION-CURRENT.md" 
    "docs/dev/README.md"
    "dev/EXPRESS-DEV-TODOS.md"
    "dev/TAURI-STABILITY-REPORT.md"
)

for file in "${active_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ⚡ $file (actively used)"
    fi
done

echo ""
echo "🗑️  DELETE CANDIDATES:"
echo "These can be safely removed..."

delete_files=(
    "docs/dev/OLD-ROADMAP.md"
    "docs/dev/CLEAN-NAMING-UPDATE.md"
    "docs/dev/CLEAN-NAMING-FINAL.md"
    "docs/WIKI-SETUP.md"
)

for file in "${delete_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  🗑️  $file (outdated/superseded)"
    fi
done

echo ""
echo "💡 RECOMMENDED ACTION PLAN:"
echo "=========================="
echo "1. Move core docs to wiki (Architecture, Build, uCODE Manual, Style Guide)"
echo "2. Archive completed development summaries and old versions"
echo "3. Keep active development files in place"
echo "4. Delete outdated/superseded files"
echo "5. Update main README to point to wiki for documentation"
echo ""
echo "Run with --execute to perform the reorganization"

if [ "$1" = "--execute" ]; then
    echo ""
    echo "🚀 EXECUTING REORGANIZATION..."
    
    # Create archive directories
    mkdir -p docs/archive/{sessions,completed-versions,dev-summaries,roadmaps-old}
    
    # Archive completed items
    for file in "${!archive_files[@]}"; do
        if [ -f "$file" ]; then
            mv "$file" "${archive_files[$file]}"
            echo "  📦 Archived: $file"
        fi
    done
    
    # Delete outdated files
    for file in "${delete_files[@]}"; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "  🗑️  Deleted: $file"
        fi
    done
    
    echo "✅ Reorganization complete!"
fi
