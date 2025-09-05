# uMEMORY System Templates and Structure

This directory contains the bundled uMEMORY system structure that gets installed to `~/uMEMORY/` on the user's system.

## Directory Structure

```
uMEMORY/
├── templates/          # System templates (copied to user)
│   ├── project/        # Project templates
│   ├── document/       # Document templates
│   └── script/         # Script templates
├── config/             # Default configurations (copied to user)
│   ├── defaults.json   # Default system settings
│   └── user.json       # User template settings
└── docs/               # uMEMORY documentation
```

## Installation Process

During uDESK installation:

1. **Copy templates** from here to `~/uMEMORY/repo/templates/`
2. **Copy configs** from here to `~/uMEMORY/repo/config/` 
3. **Create XDG structure** in `~/uMEMORY/.local/`
4. **Create sandbox** in `~/uMEMORY/sandbox/`

## User Structure Created

```
~/uMEMORY/
├── repo/               # Copied from this bundled structure
│   ├── templates/      # System templates
│   └── config/         # Default configurations
├── .local/             # XDG-compliant user data (never tracked)
│   ├── logs/           # Application logs
│   ├── backups/        # User backups
│   └── state/          # Session state
└── sandbox/            # User workspace (never tracked)
    ├── projects/       # User projects
    ├── drafts/         # Draft work
    └── experiments/    # Experimental files
```

## Key Principles

- **Bundled with uDESK**: No separate git repository needed
- **One-way sync**: Templates copied during installation only
- **User autonomy**: User files in `.local/` and `sandbox/` never touched
- **Simple updates**: Re-run installer to get latest templates
