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
udos version    # Test main command
udos help       # Show all commands
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
# Display Format          # Actual Command
UDOS HELP                  udos help
UDOS INIT                  udos init  
UDOS INFO                  udos info
UDOS VERSION               udos version
```

### Role Management:
```bash
# Display Format          # Actual Command
UDOS ROLE DETECT           udos role detect
UDOS ROLE INFO             udos role info
```

### Variable Management:
```bash
# Display Format          # Actual Command
UDOS VAR SET KEY=VALUE     udos var set KEY=VALUE
UDOS VAR GET KEY           udos var get KEY
UDOS VAR LIST              udos var list
UVAR SET KEY=VALUE         uvar set KEY=VALUE
```

### Template Management:
```bash
# Display Format          # Actual Command
UDOS TPL LIST              udos tpl list
UDOS TPL CREATE NAME       udos tpl create NAME
UTPL LIST                  utpl list
```

### Data Management:
```bash
# Display Format          # Actual Command
UDOS DATA LIST             udos data list
UDOS DATA BACKUP           udos data backup
UDATA LIST                 udata list
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
ls -la /usr/local/bin/udos*    # Check executable files
which udos                     # Find udos location
echo $PATH                     # Check PATH variable
```

### Test direct execution:
```bash
/usr/local/bin/udos version    # Run with full path
```

### Role Hierarchy:
```
👻 GHOST → ⚰️ TOMB → 🤖 DRONE → � CRYPT → 😈 IMP → ⚔️ KNIGHT → 🧙‍♂️ SORCERER → 🧙‍♀️ WIZARD
```

### Get Help:
```bash
# Display Format          # Actual Command
UDOS HELP                  udos help          # General help
UDOS HELP VAR              udos help var      # Variable help  
UDOS HELP ROLE             udos help role     # Role help
UDOS HELP TPL              udos help tpl      # Template help
```
