# AI-Assisted Development Workflow Standards

## Core Principles
- **Clean Structure**: Maintain Linux-standard directory layout
- **No Directory Sprawl**: Resist creating new directories unless essential
- **Functional Focus**: Prioritize working code over perfect organization
- **Documentation**: Keep docs organized and current

---

## 🏗️ Repository Structure Standards

### MANDATORY: Maintain Clean Architecture
**Current Clean Structure (DO NOT EXPAND):**
```
uDESK/
├── usr/
│   ├── bin/           # ONLY executables (udos, uvar, udata, utpl)
│   └── share/udos/    # ONLY shared components (M2, templates)
├── etc/udos/          # ONLY configuration files
├── docs/              # ONLY documentation
│   ├── *.md          # Core docs (7 files max)
│   ├── dev/          # Development docs (6 files max)
│   └── roadmaps/     # Strategic docs (4 files max)
├── install.sh         # Single installer
├── test.sh           # Single test script
└── README.md         # Project overview
```

### FORBIDDEN: Directory Expansion
**DO NOT CREATE these directories again:**
- ❌ `build/` - Use existing usr/ structure
- ❌ `src/` - Code goes in usr/share/udos/
- ❌ `scripts/` - Use usr/bin/ for executables
- ❌ `vm/` - Use docs/ for VM documentation
- ❌ `packaging/` - Use install.sh
- ❌ `tcz-packages/` - Eliminated
- ❌ `offline-distribution/` - Eliminated
- ❌ `tools/` - Use usr/bin/
- ❌ `out/` - Eliminated

### ALLOWED: Limited Expansion
**Only these additions are permitted:**
- ✅ `usr/share/udos/m3/` - M3 desktop components ONLY
- ✅ `usr/share/udos/templates/` - Template files ONLY
- ✅ `usr/share/udos/roles/` - Role-specific configs ONLY
- ✅ `docs/examples/` - Code examples ONLY (if essential)
3. **Active Tasks** documented with clear next steps
4. **Code Changes** committed with descriptive messages
---

## 🤖 AI Development Rules

### Before Creating ANY Directory
1. **STOP** - Ask "Does this fit existing structure?"
2. **QUESTION** - Can this go in usr/share/udos/?
3. **RESIST** - Directory creation is last resort
4. **DOCUMENT** - Justify any new directory in session notes

### File Placement Rules
| File Type | Location | Example |
|-----------|----------|---------|
| Executables | `usr/bin/` | udos, uvar, udata, utpl |
| JavaScript/Code | `usr/share/udos/` | udos-web-bridge.js |
| Configuration | `etc/udos/` | config, settings |
| Documentation | `docs/` | *.md files |
| Dev Docs | `docs/dev/` | session notes |
| Roadmaps | `docs/roadmaps/` | milestone plans |

### Code Organization Standards
```javascript
// usr/share/udos/component-name.js
// Keep components modular and focused
// Use clear naming: udos-[feature]-[function].js

// GOOD examples:
// usr/share/udos/udos-web-bridge.js
// usr/share/udos/udos-m3-window.js
// usr/share/udos/udos-role-ui.js

// BAD examples:
// src/web/bridge.js
// components/ui/role.js
// scripts/m3/window-manager.js
```

---

## 🚀 M3 Development Standards

### Component Architecture
**For M3 desktop integration, maintain structure:**
```
usr/share/udos/
├── udos-m3-window.js      # Window management
├── udos-m3-desktop.js     # Desktop integration
├── udos-m3-systray.js     # System tray
└── udos-m3-widgets.js     # Desktop widgets
```

### Configuration Management
```
etc/udos/
├── config              # Main config
├── m3-desktop.conf     # M3 desktop settings
├── m3-window.conf      # Window management
└── m3-widgets.conf     # Widget configuration
```

### Testing Integration
```bash
# Add M3 tests to existing test.sh
# Update udos command with M3 test modes:
# udos test m3
# udos test desktop
# udos test widgets
```

---

## 🛡️ Structure Protection

### Daily Structure Check
```bash
# Run this check during development:
find . -type d | wc -l
# Should be ≤ 15 directories total

# Audit new directories:
find . -type d -newer docs/README.md
# Should show minimal or no new directories
```

### Emergency Cleanup
```bash
# If structure gets messy, emergency reset:
git status                    # Check what's been added
rm -rf unwanted-directory/    # Remove directory sprawl
git reset --hard HEAD        # Reset to clean state if needed
```

---

*Last Updated: September 4, 2025*
*Structure: Clean Linux-standard layout maintained*
*Directory Count: 12 (target achieved)*
