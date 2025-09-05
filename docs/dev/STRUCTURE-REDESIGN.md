# uDESK Repository Structure Redesign
# ===================================

## Current Chaos: 97 directories! 🔥
- Too many nested folders (build/src/vm/docs/etc.)
- Unclear purposes and overlapping functions
- Against uDOS flat architecture philosophy
- Hard to navigate and maintain

## Proposed Flat Structure

### Core Linux Standards Architecture:
```
uDESK/                          # Root
├── usr/                        # Linux standard structure  
│   ├── bin/                    # Main executables (udos, uvar, udata, utpl)
│   └── share/udos/             # System files, templates, config
├── opt/                        # Optional uDOS components
│   └── udos/                   # uDOS-specific files
├── etc/                        # Configuration files
│   └── udos/                   # uDOS configuration
└── var/                        # Variable data
    └── udos/                   # Runtime data, logs
```

### Development & Distribution:
```
uDESK/                          # Root
├── usr/bin/                    # ← Core executables (4 files)
├── usr/share/udos/             # ← System files  
├── docs/                       # ← Essential documentation only
├── install.sh                  # ← Single installer (root level)
├── test.sh                     # ← Single test script (root level)  
└── README.md                   # ← Getting started
```

## Elimination Strategy

### 🗑️ REMOVE ENTIRELY:
- `/vm/archive/` - Legacy cruft (34 files)
- `/scripts/` - Scattered utilities (8 files)  
- `/build/` - Generated files (38 files)
- `/src/` - Redundant with usr/ (8 files)
- `/tcz-packages/` - Generated packages (10 files)
- `/packaging/` - Build artifacts
- `/isos/` - ISO generation
- `/offline-distribution/` - Distribution artifacts
- `/boot-config/` - Specific to old workflow
- `/utm-ready/` - Legacy VM setup
- `/tools/` - Merge with usr/bin/
- `/out/` - Build artifacts

### ✅ KEEP & RESTRUCTURE:
- `/dev/m2-integration/` → `/usr/share/udos/m2/`
- `/docs/` → `/docs/` (essential only)
- Core executables → `/usr/bin/`
- Templates → `/usr/share/udos/templates/`
- Configuration → `/etc/udos/`

## Target Structure (12 total items):
```
uDESK/
├── usr/
│   ├── bin/udos                # Main command
│   ├── bin/uvar                # Variable wrapper  
│   ├── bin/udata               # Data wrapper
│   ├── bin/utpl                # Template wrapper
│   └── share/udos/             # System files
│       ├── templates/          # Template system
│       ├── m2/                 # M2 integration
│       └── roles/              # Role definitions
├── etc/udos/                   # Configuration
├── docs/                       # Essential docs only
│   ├── README.md               # Getting started
│   ├── ARCHITECTURE.md         # System design  
│   └── HIERARCHY.md            # Role system
├── install.sh                  # Single installer
├── test.sh                     # Single test script
├── LICENSE                     # Legal
└── README.md                   # Root documentation
```

## Implementation Plan

### Phase 1: Create New Structure
1. Create `/usr/bin/` and move core executables
2. Create `/usr/share/udos/` for system files
3. Create `/etc/udos/` for configuration
4. Move M2 integration to proper location

### Phase 2: Consolidate Essential Files
1. Single `/install.sh` at root (combines all installers)
2. Single `/test.sh` at root (integrates udos test)
3. Essential docs only in `/docs/`
4. Everything else goes in Linux standard locations

### Phase 3: Mass Deletion
1. Remove all build artifacts
2. Remove all legacy/archive directories  
3. Remove scattered script directories
4. Remove VM-specific directories

### Phase 4: Validation
1. Test installation works
2. Test M2 integration works
3. Verify all functionality preserved
4. Update all documentation

## Benefits of Flat Structure

### ✅ Advantages:
- **Findable**: Everything in logical Linux locations
- **Flat**: Minimal nesting, easy navigation
- **Standard**: Follows usr/bin, usr/share conventions
- **Clean**: No build artifacts in repo
- **Simple**: Single install.sh, single test.sh
- **Maintainable**: Clear purpose for every file

### 📏 Size Reduction:
- **From**: 97 directories, 200+ files
- **To**: ~12 directories, ~30 essential files
- **Reduction**: 85%+ smaller and cleaner

## Migration Commands

### Safe Backup:
```bash
git tag backup-before-restructure
git push origin backup-before-restructure
```

### Structure Creation:
```bash
mkdir -p usr/bin usr/share/udos/{templates,m2,roles} etc/udos
```

### Mass Cleanup:
```bash
rm -rf build/ src/ vm/ scripts/ packaging/ isos/ tcz-packages/
rm -rf offline-distribution/ boot-config/ utm-ready/ tools/ out/
```

*Ready to execute this dramatic simplification?*
