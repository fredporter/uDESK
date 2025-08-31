# uDESK Development Quick Start

> Get up and running with uDESK development in minutes

## TL;DR - One Command Setup

```bash
# Set up everything
./dev-setup.sh

# Build and test
./build.sh --role admin
./isos/run_qemu.sh --image out/udesk-v1.0.6-admin.iso
```

## Development Environment

### Your Markdown-Focused Workflow

Perfect for your "let Claude do it" approach:

```bash
# 1. Generate new component with Claude
claude "Create a markdown-based network configuration system for uDESK"

# 2. Review the generated markdown
glow network-config.md

# 3. Integrate into build
mv network-config.md src/udos-core/etc/udos/
./build.sh --core-only

# 4. Test immediately
./isos/run_qemu.sh --image out/udesk-v1.0.6-admin.iso
```

### Integration with Your Setup

Since you have:
- **micro** for editing
- **glow** for viewing  
- **Claude Code** for generation

Perfect workflow:
1. **Claude generates** → markdown files/configs/scripts
2. **glow reviews** → verify output looks good
3. **micro tweaks** → small manual adjustments if needed
4. **build.sh** → creates packages and images
5. **run_qemu.sh** → immediate testing

## Current Project Status

Based on your roadmap, you're at **M0 - Scope & Baseline**:

### ✅ Completed
- ✅ Architecture plan (README.md)
- ✅ Role definitions (docs/ROLES.md)
- ✅ Build system structure
- ✅ Extension manifest concept
- ✅ Repository scaffolding

### 🚧 Next: M1 - Core Integration

**Ready to implement:**
```bash
# Build the core package
./packaging/build_udos_core.sh

# This creates udos-core.tcz with:
# - Markdown-based configs (/etc/udos/*.md)
# - Role detection (udos-detect-role)
# - Service helper (udos-service)
# - First-boot wizard
# - System info (udos-info)
```

## Immediate Next Steps

### 1. Download TinyCore Base
```bash
cd /Users/fredbook/Code/uDESK
wget http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso
```

### 2. Test Build System
```bash
# Make scripts executable
find . -name "*.sh" -exec chmod +x {} \;

# Test core build
./packaging/build_udos_core.sh

# Should create: build/udos-core.tcz
```

### 3. Create First Test Image
```bash
# Build basic role image
./build.sh --role basic

# Test in QEMU
./isos/run_qemu.sh --image out/udesk-v1.0.6-basic.iso
```

## Development Priorities

Based on your roadmap, focus on:

### Week 1: M1 - Core Integration
- ✅ Package `udos-core.tcz` (scripts ready)
- 🔄 Implement boot hooks
- 🔄 Set persistence defaults
- **Goal**: Boot to CLI with `udos-core` active

### Week 2: M2 - Roles & Policies  
- 🔄 Users/groups setup
- 🔄 Sudoers configuration
- 🔄 Role enforcement
- **Goal**: Switchable roles working

### Week 3: M3 - GUI & Apps
- 🔄 Desktop environment 
- 🔄 Markdown-focused app set
- 🔄 Kiosk mode for Basic
- **Goal**: Desktop images ready

## Integration with Your Workflow

### Claude + uDESK Development

Perfect synergy:
1. **Use Claude Code to generate system components**
2. **Everything generated in markdown format**
3. **Immediate integration into build system**
4. **Test in isolated TinyCore environment**

Example Claude prompts for uDESK:
- "Generate a markdown-based service configuration system"
- "Create boot scripts that read markdown config files"  
- "Design a markdown template system for uDESK users"
- "Build a role-switching mechanism with markdown logs"

### Your Development Environment

Since you prefer minimal tools:
- **micro** for quick edits of generated files
- **glow** for reviewing complex markdown configs
- **Claude Code** for heavy generation work
- **build.sh** for packaging everything
- **QEMU** for immediate testing

## Ready to Go!

Your uDESK project is perfectly set up for your markdown-everything vision. The build system is ready, the role architecture is solid, and everything integrates with your preferred tools.

**Next action**: Download TinyCore ISO and run your first build!

```bash
cd /Users/fredbook/Code/uDESK
wget http://tinycorelinux.net/14.x/x86_64/release/TinyCore-current.iso
./build.sh --role admin
```

You'll have a bootable markdown-focused OS in minutes! 🚀
