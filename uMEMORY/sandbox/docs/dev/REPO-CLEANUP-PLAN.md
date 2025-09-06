# uDESK Repository Cleanup Plan
# ============================

## Current State: CHAOS 🔥
- **520+ shell scripts** scattered across repository
- **23 scripts** in vm/ directory alone  
- **8 scripts** in scripts/ directory
- Multiple **legacy/archive** directories with duplicates
- **No clear organization** or purpose documentation

## Cleanup Strategy

### 1. Core Script Consolidation
**Keep only essential, working scripts:**

#### `/vm/current/` (Production VM Scripts)
- ✅ `install.sh` - Main M1 installer (KEEP - working)
- ✅ `setup.sh` - VM environment setup (KEEP - working)  
- ❌ `git-deploy.sh` - Redundant with install.sh (REMOVE)
- ❌ `git-deploy-posix.sh` - Redundant with install.sh (REMOVE)
- ❌ `git-install.sh` - Redundant with install.sh (REMOVE)
- ✅ `utm.sh` - UTM-specific setup (KEEP - unique purpose)
- ❌ `vm.sh` - Generic, unclear purpose (REMOVE)
- ❌ `bootstrap.sh` - Redundant with setup.sh (REMOVE)
- ❌ `udos-startup.sh` - Not essential (REMOVE)
- ❌ `udos-boot-art.sh` - Cosmetic only (REMOVE)
- ❌ `setup-utm-share.sh` - Integrated into utm.sh (REMOVE)

#### `/dev/m2-integration/` (M2 Development)
- ✅ `test-vm.sh` - M2 testing suite (KEEP - just added)

#### Root Directory Cleanup
- ❌ `build.sh` - Move to `/tools/` or remove
- ❌ `cleanup-repo.sh` - Move to `/tools/` 
- ❌ `create-*.sh` - Move to `/tools/` or `/build/`

### 2. Archive/Remove Strategy
**Complete removal of redundant directories:**

#### Remove Entirely:
- 🗑️ `/vm/archive/` - All legacy scripts (7+ scripts)
- 🗑️ `/scripts/` - All development scripts (8 scripts)
- 🗑️ Most root-level build scripts

#### Archive for Historical Reference:
- 📦 Keep one copy of significant legacy scripts in `/docs/legacy/`

### 3. Final Clean Structure
```
uDESK/
├── vm/current/          # Production VM deployment
│   ├── install.sh       # Main M1 installer
│   ├── setup.sh         # VM environment setup
│   └── utm.sh           # UTM-specific setup
├── dev/m2-integration/  # M2 development
│   ├── test-vm.sh       # M2 testing suite
│   ├── udos-web-bridge.js
│   ├── udos-role-ui.js
│   └── udos-m2-complete.js
├── build/               # Build system (existing)
├── tools/               # Utility scripts (new)
│   ├── cleanup-repo.sh
│   └── create-packages.sh
└── docs/legacy/         # Historical reference
    └── script-archive.md
```

## Implementation Steps

### Phase 1: Safety Backup
1. ✅ Document current script inventory
2. ✅ Identify truly essential scripts
3. ✅ Test core functionality (M1 install.sh works)

### Phase 2: Aggressive Cleanup  
1. 🗑️ Remove `/vm/archive/` entirely
2. 🗑️ Remove `/scripts/` directory entirely
3. 🗑️ Remove redundant root-level scripts
4. 🗑️ Clean up `/vm/current/` to essential scripts only

### Phase 3: Reorganization
1. 📁 Create `/tools/` for utility scripts
2. 📁 Move build-related scripts to proper locations
3. 📁 Update all documentation references

### Phase 4: Testing
1. ✅ Verify M1 install.sh still works
2. ✅ Verify M2 test-vm.sh works  
3. ✅ Test VM deployment end-to-end

## Success Criteria
- **Reduce from 520+ to <10 scripts**
- **Clear purpose for every remaining script**
- **Working M1 and M2 deployment**
- **Clean, maintainable repository structure**

## Risk Mitigation
- Keep git history (no force pushes)
- Test before each removal phase
- Document what was removed and why
- Keep essential functionality working

*Ready to execute this cleanup strategy?*
