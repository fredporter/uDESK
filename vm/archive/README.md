# uDESK VM Archive

This directory contains archived files from the uDESK TinyCore VM development process.

## Directory Structure

### troubleshooting/
Development and diagnostic tools used during TinyCore compatibility testing:
- `github-diagnostic.sh` - Network connectivity and GitHub access testing
- `test-bash.sh` - Shell compatibility testing
- `test-basic.sh` - Basic functionality testing  
- `m2-update.sh` - M2 role hierarchy update script

### legacy/
Superseded installation scripts from development iterations:
- `auto-install.sh` - Early automation attempt
- `bootstrap-install.sh` - Initial bootstrap installer
- `github-install-minimal.sh` - Minimal GitHub installer
- `github-install.sh` - Original GitHub installer
- `manual-install.sh` - Manual installation script
- `simple-install.sh` - Simplified installer
- `setup-gemini.sh` - Development testing script

## Current Active Files

The production-ready files are maintained in `/vm/current/`:
- `install-udos.sh` - Hybrid distribution manager (primary installer)
- `udos-boot-art.sh` - ASCII art and boot integration
- `INSTALL-INSTRUCTIONS.txt` - Installation documentation

## Usage

These archived files are preserved for:
1. **Reference** - Understanding development progression
2. **Debugging** - Troubleshooting specific TinyCore issues
3. **Recovery** - Fallback options if current system fails
4. **Learning** - Examples of different installation approaches

To use any archived script:
```sh
cd /path/to/uDESK/vm/archive/[category]
chmod +x [script-name].sh
./[script-name].sh
```

**Note**: Archived scripts may require modification for current uDOS v1.0.5 compatibility.
