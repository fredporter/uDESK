# uDESK v1.0.7 Development Guidelines

## 🏗️ Repository Organization

### Directory Structure
```
uDESK/
├── build.sh                    # Unified build script
├── Launch-uDOS-macOS.command   # macOS launcher
├── Launch-uDOS-Ubuntu.sh       # Ubuntu launcher  
├── Launch-uDOS-Windows.bat     # Windows launcher
├── README.md                   # Project overview
├── LICENSE                     # GNU GPL v3
├── core/                       # uDESK system core
│   ├── docs/                   # Core documentation
│   │   ├── dev/               # Development notes
│   │   ├── ARCHITECTURE.md    # System architecture
│   │   ├── BUILD.md          # Build instructions
│   │   └── CONTRIBUTING.md   # This file
│   └── tinycore/              # TinyCore patches
├── uCORE/                     # Core runtime
├── uMEMORY/                   # Memory system
├── uNETWORK/                  # Network system
├── uSCRIPT/                   # Script system
├── uKNOWLEDGE/                # Knowledge system
├── app/                       # Desktop applications
│   └── tauri/                # Tauri backend (Rust)
└── build/                     # Build artifacts (ignored)
```

## 📜 Development Rules

### 1. **Clean Architecture Philosophy**
- Unified build system with cross-platform support
- Role-based deployment (user/wizard/developer/iso)
- Zero external dependencies beyond GCC
- 30-second setup time target

### 2. **File Organization**
- **NO** test files in root directory
- **NO** temporary files committed
- **NO** IDE-specific files (except .vscode/ for workspace)
- **NO** compiled binaries or build artifacts
- **Core modules** in respective u* directories (uCORE/, uMEMORY/, etc.)
- **Documentation** in core/docs/ with dev/ subdirectory
- **Desktop app** in app/ with tauri/ backend

### 3. **Build Artifacts**
- Build artifacts (executables, packages) are **NOT** committed
- Generated directories (build/, dist/, target/) are ignored
- Clean builds must work from fresh checkout
- Use unified `./build.sh MODE` for all builds

### 4. **Naming Conventions**
- Scripts: `kebab-case.sh`
- Directories: `lowercase` or `uPREFIX` for core modules
- Markdown files: `UPPERCASE.md` for docs, `lowercase.md` for configs
- No spaces in filenames
- Descriptive names over abbreviations

### 5. **Cross-Platform Requirements**
- All scripts must work on macOS, Ubuntu, and Windows
- Use platform launchers for environment setup
- Include appropriate file extensions (.command, .sh, .bat)
- Test on multiple platforms before committing

### 6. **Git Hygiene**
- Atomic commits (one logical change per commit)
- Descriptive commit messages following conventional commits
- No merge commits on main branch
- Clean up branches after merge
- Comprehensive .gitignore for all platforms

## 🔧 Development Workflow

### Setting Up Development Environment
```bash
# 1. Clone and setup
git clone <repo-url> uDESK
cd uDESK

# 2. Use platform launcher for dependencies
./Launch-uDOS-macOS.command     # macOS
./Launch-uDOS-Ubuntu.sh         # Ubuntu/Debian  
./Launch-uDOS-Windows.bat       # Windows

# 3. Build for development
./build.sh developer

# 4. Test desktop app
cd app
npm run tauri dev
```

### Making Changes

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make Changes Following Architecture**
   - Core system changes in respective u* modules
   - Desktop app changes in app/
   - Documentation in core/docs/
   - Follow cross-platform requirements

3. **Test Your Changes**
   ```bash
   # Test all build modes
   ./build.sh user
   ./build.sh wizard  
   ./build.sh developer
   
   # Test desktop app
   cd app
   npm run tauri build
   ```

4. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: descriptive message"
   git push origin feature/your-feature
   ```

### Before Committing - Checklist

- [ ] No build artifacts committed
- [ ] Cross-platform compatibility verified
- [ ] All build modes work
- [ ] Desktop app builds successfully
- [ ] Documentation updated
- [ ] Platform launchers work
- [ ] Follows clean architecture principles

## 🚫 What NOT to Commit

### Files That Should Never Be Committed
- Build executables (`udesk`, `udesk-app` binaries)
- `target/` directory (Rust/Tauri builds)
- `dist/` directory (frontend builds)
- `build/` directory (build artifacts)
- `node_modules/` (npm dependencies)
- `.DS_Store`, `*~`, `*.tmp`
- Platform-specific temp files

### Directories That Should Stay Clean
- **Root directory**: Only essential launchers and build script
- **core/**: System architecture and documentation
- **u* modules**: Core runtime components only
- **app/**: Desktop application source only

## 🎯 Modern Development Integration

### VS Code Integration
- Workspace configured in `uDOS.code-workspace`
- Tasks defined for unified build system
- Extensions recommended for Rust/Tauri development
- Settings optimized for cross-platform development

### Development Tools Setup
```bash
### Development Tools Setup
```bash
# Desktop app development
cd app
npm install
npm run tauri dev

# Core system development  
./build.sh developer
./udos dev --help
```
```

## 📚 Documentation Standards

### Required Documentation
- Every core module needs README.md explaining purpose
- API documentation for command interfaces
- Installation instructions in core/docs/BUILD.md
- Architecture decisions in core/docs/ARCHITECTURE.md
- Development notes in core/docs/dev/

### Markdown Style
- Use proper headings hierarchy
- Include code blocks with syntax highlighting
- Add table of contents for long documents
- Use emoji for visual hierarchy (sparingly)
- Follow conventional commit format in messages

## 🔍 Code Review Guidelines

### Pull Request Requirements
- Descriptive title and description
- Link to relevant issues
- Include cross-platform test results
- Update documentation
- Follow clean architecture principles

### Review Checklist
- [ ] Follows v1.0.7 clean architecture
- [ ] No banned files committed
- [ ] Cross-platform compatibility
- [ ] All build modes work
- [ ] Desktop app integration works
- [ ] Documentation updated
- [ ] Performance impact considered

## 🐛 Issue Reporting

### Bug Reports Should Include
- uDESK version (v1.0.7)
- Host OS (macOS, Ubuntu, Windows)
- Build mode (user, wizard, developer)
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs from build/ directory

### Feature Requests Should Include
- Use case description
- Integration with existing clean architecture
- Cross-platform compatibility considerations
- Impact on 30-second setup goal

## ⚡ Performance Guidelines

### Build System
- Unified build script for all platforms
- Mode-based feature bundling
- Minimal dependency chain (GCC only)
- Platform launchers handle environment setup

### Desktop Integration
- Tauri for native cross-platform apps
- Efficient IPC between frontend and backend
- Lazy loading of advanced features
- Responsive UI for all screen sizes

### Core System
- Fast startup time (< 5 seconds)
- Efficient memory usage
- Command routing optimization
- Minimal system resource footprint

## 🔐 Security Considerations

### Never Commit
- API keys or credentials
- SSH keys or certificates
- Personal information
- Hardcoded passwords
- Build artifacts with embedded secrets

### Best Practices
- Use environment variables for configuration
- Sanitize user input in all interfaces
- Validate all external dependencies
- Use secure communication protocols
- Follow Rust security guidelines for Tauri components

### Platform Security
- Respect platform-specific security models
- Use code signing for distribution builds
- Validate integrity of auto-installed dependencies
- Secure IPC between desktop app components

---

## 📞 Getting Help

### Development Support
- Check core/docs/ for comprehensive documentation
- Review existing issues and discussions
- Test with platform launchers first
- Follow the issue templates

### Quick Start
```bash
# Get up and running quickly
./Launch-uDOS-[Platform].[ext]  # Install dependencies
./build.sh developer           # Build development version
./udos help                    # Explore available commands
```

### Community Guidelines
- Be respectful and constructive
- Share knowledge and help others
- Follow the clean architecture principles
- Test thoroughly before contributing

**Remember**: uDESK v1.0.7 is designed for simplicity and speed - when in doubt, choose the cleaner, faster approach! 🚀