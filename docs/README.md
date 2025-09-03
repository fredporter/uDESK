# uDOS Documentation Index

Welcome to the uDOS documentation hub. This directory contains all documentation organized for easy navigation and reference.

## 📚 Core Documentation

### Getting Started
- **[README.md](../README.md)** - Project overview and quick start
- **[QUICKSTART.md](QUICKSTART.md)** - Quick installation and basic usage
- **[INSTALL.md](INSTALL.md)** - Detailed installation instructions

### Architecture and Design
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture overview
- **[BUILD.md](BUILD.md)** - Build system and development setup
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

### Operational Guides
- **[VM-UPDATE-GUIDE.md](VM-UPDATE-GUIDE.md)** - Virtual machine update procedures

---

## 🗺️ Development Documentation

### Completed Milestones
- **[M1 Foundation Complete](dev/M1-FOUNDATION-COMPLETE.md)** - Core modular architecture completion
- **[M2 Ecosystem Complete](dev/M2-ECOSYSTEM-COMPLETE.md)** - Plugin platform completion
- **[Development Completions](dev/COMPLETIONS.md)** - Complete milestone achievement overview

### Future Roadmaps
- **[Future Roadmap](roadmaps/ROADMAP.md)** - Next phase development plans (M3+)
- **[Ecosystem Future](roadmaps/ECOSYSTEM.md)** - Advanced ecosystem features
- **[Desktop Integration](roadmaps/DESKTOP-INTEGRATION.md)** - Desktop environment plans
- **[Workflow Roadmap](roadmaps/WORKFLOW-ROADMAP.md)** - Advanced workflow features

### Current Status (v1.1.0)
- **M1 Foundation**: ✅ Complete - Modular command interface
- **M2 Ecosystem**: ✅ Complete - Plugin management platform
- **M3 Advanced Features**: 🔮 Future - Enhanced modules and capabilities
- **M4 Enterprise**: 🔮 Future - Enterprise deployment features

---

## 🌐 Ecosystem Platform

### Plugin System
- **[ECOSYSTEM.md](ECOSYSTEM.md)** - Complete ecosystem documentation
- **[Plugin Development Guide](examples/plugins/)** - Plugin development examples
- **[Node.js Integration](dev/NODEJS-INTEGRATION.md)** - Node.js enhancement guide

### Features
- **Plugin Management**: Install, remove, list, run, and info commands
- **Dual-Mode Operation**: Universal shell + optional Node.js enhancement
- **Auto-Detection**: Seamless Node.js integration when available
- **TinyCore Support**: Native Node.js TCZ package installation
- **Universal Compatibility**: Works on any POSIX-compatible system

---

## 🔧 Development Documentation

### Development Process
- **[AI-WORKFLOW-STANDARDS.md](dev/AI-WORKFLOW-STANDARDS.md)** - AI development workflow standards
- **[TESTING.md](dev/TESTING.md)** - Testing procedures and standards
- **[IMPLEMENTATION-COMPLETE.md](dev/IMPLEMENTATION-COMPLETE.md)** - Implementation status tracking

### Project Management
- **[SESSION-CURRENT.md](dev/SESSION-CURRENT.md)** - Current development session status
- **[STRUCTURE-REDESIGN.md](dev/STRUCTURE-REDESIGN.md)** - Repository structure redesign plan
- **[REPO-CLEANUP-PLAN.md](dev/REPO-CLEANUP-PLAN.md)** - Repository cleanup strategy

---

## 🚀 Quick Reference

### Common Tasks
```bash
# Install uDOS
./install.sh

# Run tests
./test.sh

# Check version
usr/bin/udos version

# Test M2 interface
usr/bin/udos test m2
```

### Key Directories
```
uDESK/
├── usr/bin/           # Executable commands
├── usr/share/udos/    # Shared components
├── etc/udos/          # Configuration files
└── docs/              # This documentation
```

### Role Hierarchy
- **GHOST** (0) - Hidden/system access
- **ADMIN** (1) - Full administrative access
- **POWER** (2) - Power user features
- **USER** (3) - Standard user access
- **GUEST** (4) - Limited guest access
- **DEMO** (5) - Demonstration mode
- **TEST** (6) - Testing environment
- **WIZARD** (7) - Guided setup mode

---

## 📊 Project Statistics

### Current State (Post-Cleanup)
- **Directories**: 12 (down from 97)
- **Core Files**: Clean, organized structure
- **Documentation**: Complete and organized
- **Test Coverage**: Built-in testing system

### Milestones Completed
- ✅ **M1**: Foundation and command system
- ✅ **M2**: Web interface and role adaptation
- ✅ **Cleanup**: Repository structure redesign (85% reduction)

---

## 🔍 Finding Information

### By Topic
- **Installation** → `INSTALL.md`, `QUICKSTART.md`
- **Architecture** → `ARCHITECTURE.md`, `BUILD.md`
- **Development** → `dev/` directory
- **Future Plans** → `roadmaps/` directory
- **Contribution** → `CONTRIBUTING.md`

### By User Type
- **New Users** → Start with `QUICKSTART.md`
- **Developers** → See `dev/` directory and `CONTRIBUTING.md`
- **System Admins** → Focus on `INSTALL.md` and `ARCHITECTURE.md`
- **Project Stakeholders** → Review `roadmaps/` directory

### By Status
- **Current Features** → Core documentation files
- **In Development** → `dev/SESSION-CURRENT.md`
- **Planned Features** → `roadmaps/` directory
- **Completed Work** → `dev/IMPLEMENTATION-COMPLETE.md`

---

## 📝 Documentation Standards

### File Organization
- **Core docs** in root `docs/` directory
- **Development docs** in `docs/dev/`
- **Strategic docs** in `docs/roadmaps/`
- **Index files** for navigation

### Naming Conventions
- **ALL-CAPS.md** for major documents
- **lowercase-with-dashes.md** for detailed docs
- **Clear, descriptive filenames**
- **Consistent structure across documents**

### Content Standards
- **Clear headers** and section organization
- **Status indicators** (✅ ⚠️ 🚧 📋) for clarity
- **Cross-references** between related documents
- **Update dates** and version tracking

---

*Last Updated: September 4, 2025*
*Next Review: October 1, 2025*

For questions or suggestions about documentation, see [CONTRIBUTING.md](CONTRIBUTING.md).
