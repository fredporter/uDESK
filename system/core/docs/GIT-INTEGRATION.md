# uDESK v1.0.7.2 - One-Way Git Setup Integration

## Overview

uDESK includes **one-way git repository synchronization** for setup and installation only. This ensures users always have access to the latest system templates and core files during installation, while keeping development and user environments completely separate.

## How It Works

### Installation Process
1. **Downloads latest uDESK** from GitHub to `~/uDESK/repo/`
2. **Copies bundled templates** from `~/uDESK/repo/uMEMORY/` to `~/uMEMORY/repo/`
3. **Creates user workspace** in `~/uMEMORY/sandbox/` and `~/uMEMORY/.local/`
4. **One-time setup** - no ongoing git synchronization

### Key Principles
- **Setup Only**: Git used only during initial installation and manual updates
- **No Auto-Sync**: User environment never automatically updated
- **Separate Development**: User work isolated from core system
- **User Control**: Updates only when user explicitly runs installer

## How It Works

### First-Time Setup
When `~/uDESK/` directory doesn't exist:
1. Creates complete directory structure: `~/uDESK/{workspace,projects,docs,scripts,uMEMORY}`
2. Clones the official uDESK repository to `~/uDESK/repository/`
3. Copies key files (README.md, LICENSE, docs/) to main directory
4. Shows success confirmation with repository location

### Subsequent Builds
When `~/uDESK/` already exists:
1. Automatically checks for repository updates
2. Pulls latest changes from `main` branch
3. Updates documentation if available
4. Continues with normal build process

## Directory Structure

```
~/uDESK/                    # Main home directory
├── repository/             # Full git repository (auto-synced)
├── docs/                   # Documentation (copied from repo)
├── README.md              # Project README (copied from repo)
├── LICENSE                # License file (copied from repo)
├── workspace/             # User workspace
├── projects/              # User projects
├── scripts/               # User scripts
└── uMEMORY/              # Main workspace directory
    ├── projects/          # Active projects
    ├── docs/              # User documentation
    ├── extensions/        # User extensions
    └── backups/           # Backup files
```

## Features

### Automatic Synchronization
- **Smart Detection**: Checks if `~/uDESK/repository/.git` exists
- **Offline Resilient**: Gracefully handles offline situations
- **Conflict Safe**: Uses `git pull` with error handling
- **Silent Operation**: Updates happen in background during builds

### Repository Management
- **Full Repository**: Complete git history and branches available
- **Key File Copying**: Important files copied to main directory for easy access
- **Documentation Sync**: Automatically updates docs/ directory
- **Version Consistency**: Ensures local files match latest repository state

### Error Handling
- **Git Unavailable**: Continues build if git command not found
- **Network Issues**: Handles offline/network failure gracefully  
- **Access Problems**: Manages authentication or permission issues
- **Conflict Resolution**: Skips update if conflicts detected

## Configuration

### Repository URL
Default: `https://github.com/fredporter/uDESK.git`

To change repository URL, edit the `setup_workspace()` function in `build.sh`:
```bash
local repo_url="https://github.com/yourusername/uDESK.git"
```

### Directory Locations
- **Repository**: `~/uDESK/repository/` (full git repo)
- **Documentation**: `~/uDESK/docs/` (copied from repo)
- **Workspace**: `~/uDESK/uMEMORY/` (user workspace)
- **Config**: `~/.udesk/` (system configuration)

## Commands Integration

### INFO Command
Shows repository status:
```
ℹ️  uDESK v1.0.7 - User Mode
   Role: GHOST
   Theme: POLAROID (default)
   Workspace: ~/uDESK/uMEMORY/
   Config: ~/.udesk/
   Home: ~/uDESK/
   Platform: user
```

### Tips System
Mentions repository sync in build tips:
- User Mode: "Repository synced automatically in ~/uDESK/repository/"
- Wizard+ Mode: "Latest code available in ~/uDESK/repository/"
- Developer Mode: "Repository automatically updated on each build"

## Setup Scripts Integration

### Tauri Setup (`./setup-tauri.sh`)
```
💡 Note: This setup automatically syncs with the latest uDESK repository
   Repository location: ~/uDESK/repository/
   Documentation: ~/uDESK/docs/
```

### TinyCore Setup (`./setup-tinycore.sh`)
```
💡 Note: This setup automatically syncs with the latest uDESK repository
   Repository location: ~/uDESK/repository/
   TinyCore files: ~/uDESK/repository/core/tc/
```

## Benefits

1. **Always Current**: Users automatically get latest features and fixes
2. **Consistent Environment**: Ensures all users have same codebase
3. **Easy Documentation**: Latest docs always available locally
4. **Developer Friendly**: Full git history and branches accessible
5. **Offline Support**: Graceful degradation when network unavailable
6. **Zero Configuration**: Works automatically without user intervention

## Security Considerations

- Uses HTTPS for repository access (no credentials required)
- Only pulls from official repository (no arbitrary code execution)
- Preserves user data in separate directories
- Handles network failures gracefully
- Does not modify user files outside uDESK directories

## Troubleshooting

### Repository Not Cloning
- Check internet connection
- Verify git is installed: `git --version`
- Check GitHub access: `ping github.com`

### Updates Not Working
- Check repository exists: `ls ~/uDESK/repository/.git`
- Manually update: `cd ~/uDESK/repository && git pull`
- Reset if corrupted: `rm -rf ~/uDESK/repository && ./build.sh user`

### Permission Issues
- Ensure write access to home directory
- Check directory ownership: `ls -la ~/uDESK/`
- Fix permissions: `chmod -R u+w ~/uDESK/`

## Version History

- **v1.0.7**: Added automatic git repository synchronization
- **v1.0.6**: Manual repository management only
- **v1.0.5**: No repository integration
