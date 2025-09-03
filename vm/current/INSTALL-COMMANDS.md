# uDOS Clean TinyCore VM Installation

## 🚀 **ONE-LINER INSTALLATION (Recommended):**

### Clean, Modular Installation:
```bash
curl -sSL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/quick-clean-setup.sh | bash
```

### Legacy Installation (if needed):
```bash
curl -sSL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/quick-vm-setup.sh | bash
```

## 📋 **STEP-BY-STEP METHOD:**

### Step 1: Install tools and clone repository
```bash
tce-load -wi git bash curl wget
bash
mkdir -p /home/tc/Code && cd /home/tc/Code
git clone https://github.com/fredporter/uDESK.git
cd uDESK
```

### Step 2: Run the clean installer
```bash
chmod +x vm/current/install-clean-udos.sh
./vm/current/install-clean-udos.sh
```

### Step 3: Load PATH and test
```bash
source ~/.profile
udos version
udos help
```

## 🏗️ **CLEAN ARCHITECTURE:**

```
/usr/local/bin/
├── udos          # Main unified command (all functionality)
├── uvar          # Variable management wrapper
├── udata         # Data management wrapper
└── utpl          # Template management wrapper

/usr/local/share/udos/
├── templates/    # System templates (readme, meeting, daily)
└── lib/          # Shared libraries (future)

/opt/udos/
├── bin/          # Optional executables
├── config/       # System configuration
└── logs/         # System logs
```

## 🎯 **AVAILABLE COMMANDS:**

### Main Commands:
```bash
udos help            # Show all commands
udos init            # Initialize environment
udos info            # System information
udos version         # Show version
```

### Role Management:
```bash
udos role detect     # Detect capabilities and assign role
udos role info       # Show current role information
```

### Variable Management:
```bash
udos var set KEY=VAL # Set environment variable
udos var get KEY     # Get environment variable
udos var list        # List all variables
uvar set KEY=VAL     # Wrapper command
```

### Template Management:
```bash
udos tpl list        # List available templates
udos tpl create NAME # Create file from template
utpl list            # Wrapper command
```

### Data Management:
```bash
udos data list       # List data files
udos data backup     # Backup user data
udata list           # Wrapper command
```

## 🛠️ **MANUAL INSTALLATION (if git fails):**

### If you need to install manually from local files:
```bash
# After cloning, if installer doesn't work:
sudo mkdir -p /usr/local/bin /usr/local/share/udos
sudo cp build/clean-udos/usr/local/bin/* /usr/local/bin/
sudo cp -r build/clean-udos/usr/local/share/udos/* /usr/local/share/udos/
sudo chmod +x /usr/local/bin/*
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.profile
source ~/.profile
udos version
```

## 🐛 **TROUBLESHOOTING:**

### If udos command not found:
```bash
export PATH="/usr/local/bin:$PATH"
source ~/.profile
```

### Check installation:
```bash
ls -la /usr/local/bin/udos*
which udos
echo $PATH
```

### Test direct execution:
```bash
/usr/local/bin/udos version
```

### Role Hierarchy:
```
GHOST → APPRENTICE → SCRIBE → SCHOLAR → SAGE → MASTER → ARCHITECT → WIZARD
```

### Get Help:
```bash
udos help           # General help
udos help var       # Variable help
udos help role      # Role help
udos help tpl       # Template help
```
