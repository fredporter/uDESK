# uDESK Development Rules & Guidelines

## 🏗️ Repository Organization

### Directory Structure
```
uDESK/
├── build.sh              # Main build script
├── README.md              # Project overview
├── CONTRIBUTING.md        # This file
├── LICENSE               # GNU GPL v3
├── docs/                 # Documentation
├── isos/                 # ISO creation tools
├── packaging/            # TCZ package build scripts
├── scripts/              # All workflow scripts
│   ├── setup-*.sh       # Setup automation
│   ├── dev-*.sh         # Development helpers  
│   ├── utm-*.sh         # UTM VM scripts
│   └── *.sh             # Utility scripts
├── src/                  # Source code
└── tools/                # Development tools
```

## 📜 Development Rules

### 1. **Markdown Everything Philosophy**
- All configuration must be in markdown format
- Documentation-driven development
- Self-documenting code and configs
- Git-friendly plain text only

### 2. **File Organization**
- **NO** test files in root directory
- **NO** temporary files committed
- **NO** IDE-specific files
- **NO** compiled binaries or ISOs
- **Scripts** go in `scripts/` directory
- **Documentation** goes in `docs/` directory

### 3. **Build Artifacts**
- Build artifacts (`*.tcz`, `*.iso`) are **NOT** committed
- Generated directories (`utm-setup/`, `build/`, `out/`) are ignored
- Clean builds must work from fresh checkout
- Use `./build.sh --clean` for clean builds

### 4. **Naming Conventions**
- Scripts: `kebab-case.sh`
- Directories: `lowercase`  
- Markdown files: `UPPERCASE.md` for docs, `lowercase.md` for configs
- No spaces in filenames
- Descriptive names over abbreviations

### 5. **Script Requirements**
- All scripts must be executable (`chmod +x`)
- Include shebang: `#!/bin/bash`
- Include description comment
- Use `set -e` for error handling
- Provide help with `--help`

### 6. **Git Hygiene**
- Atomic commits (one logical change per commit)
- Descriptive commit messages
- No merge commits on main branch
- Clean up branches after merge
- Use `.gitignore` comprehensively

## 🔧 Development Workflow

### Setting Up Development Environment
```bash
# 1. Clone and setup
git clone <repo-url> uDESK
cd uDESK

# 2. Run development setup
./scripts/dev-setup.sh

# 3. Build packages
./build.sh --clean --role admin

# 4. Test in VM
./scripts/utm-auto-setup.sh
```

### Making Changes

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make Changes Following Rules**
   - Keep files organized per directory structure
   - Follow naming conventions
   - Update documentation

3. **Test Your Changes**
   ```bash
   ./build.sh --clean
   ./scripts/utm-auto-setup.sh  # Test in VM
   ```

4. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: descriptive message"
   git push origin feature/your-feature
   ```

### Before Committing - Checklist

- [ ] No test files in root
- [ ] No temporary files
- [ ] No build artifacts
- [ ] Scripts are executable
- [ ] Documentation updated
- [ ] Build works clean
- [ ] VM setup works

## 🚫 What NOT to Commit

### Files That Should Never Be Committed
- `*.iso` files (TinyCore ISOs)
- `*.tcz` files (built packages)
- `build/` directory
- `out/` directory  
- `utm-setup/`, `utm-ready/` directories
- `test/`, `logs/` directories
- `.DS_Store`, `*~`, `*.tmp`
- IDE files (`.vscode/`, `.idea/`)

### Directories That Should Stay Clean
- **Root directory**: Only essential files
- **scripts/**: Only properly named scripts
- **docs/**: Only documentation
- **src/**: Only source code

## 🎯 Claude Code Integration

### Smart-Assisted Development
- Use Claude Code for generating components
- All Smart-generated content in markdown format
- Review and test Smart-generated code
- Document Smart assistance in commits

### Claude Code Setup in VM
```bash
# Inside TinyCore VM after uDESK installation
./install-claude-code.sh
claude-code  # Start development session
```

## 📚 Documentation Standards

### Required Documentation
- Every script needs header comment explaining purpose
- README.md for each major component
- Installation instructions in docs/INSTALL.md
- Architecture decisions in docs/ARCHITECTURE.md

### Markdown Style
- Use proper headings hierarchy
- Include code blocks with syntax highlighting
- Add table of contents for long documents
- Use emoji for visual hierarchy (sparingly)

## 🔍 Code Review Guidelines

### Pull Request Requirements
- Descriptive title and description
- Link to relevant issues
- Include test results
- Update documentation
- Follow commit message format

### Review Checklist
- [ ] Follows directory structure
- [ ] No banned files committed
- [ ] Scripts are executable
- [ ] Documentation updated
- [ ] Build system works
- [ ] VM integration works

## 🐛 Issue Reporting

### Bug Reports Should Include
- uDESK version
- Host OS (macOS, Linux)
- VM software (UTM, QEMU)
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs

### Feature Requests Should Include
- Use case description
- Markdown-first approach
- Integration with existing workflow
- Backward compatibility considerations

## ⚡ Performance Guidelines

### Build System
- Keep packages small (< 10KB each)
- Use SquashFS compression
- Minimize dependencies
- Cache downloads when possible

### VM Integration  
- Support both automated and manual setup
- Provide fallbacks for missing tools
- Test on different VM platforms
- Document hardware requirements

## 🔐 Security Considerations

### Never Commit
- API keys or credentials
- SSH keys or certificates
- Personal information
- Hardcoded passwords

### Best Practices
- Use environment variables for secrets
- Sanitize user input in scripts
- Validate downloaded files
- Use HTTPS for downloads

---

## 📞 Getting Help

- Check existing documentation first
- Search closed issues
- Ask in discussions
- Follow the templates for issues/PRs

**Remember**: uDESK is markdown-everything. When in doubt, make it markdown! 🚀