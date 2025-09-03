# uDOS TinyCore VM One-Liner Installation
# Copy and paste this command into your fresh TinyCore VM

## Single Command Installation:
```bash
curl -sSL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/quick-vm-setup.sh | bash
```

## Alternative Step-by-Step Method:

### Step 1: Install tools and clone repository
```bash
tce-load -wi git bash curl wget
bash
mkdir -p /home/tc/Code && cd /home/tc/Code
git clone https://github.com/fredporter/uDESK.git
cd uDESK
```

### Step 2: Run the installer
```bash
chmod +x vm/current/install-udos-tinycore.sh
./vm/current/install-udos-tinycore.sh
```

### Step 3: Load PATH and test
```bash
source ~/.profile
udos version
udos help
```

## Manual Installation (if git fails):

### If you need to install manually from local files:
```bash
# After cloning, if installer doesn't work:
sudo mkdir -p /usr/local/share/udos
sudo cp build/uDOS-core/usr/local/share/udos/* /usr/local/share/udos/
sudo chmod +x /usr/local/share/udos/*
echo 'export PATH=$PATH:/usr/local/share/udos' >> ~/.profile
source ~/.profile
udos version
```

## Troubleshooting:

### If udos command not found:
```bash
export PATH=$PATH:/usr/local/share/udos
source ~/.profile
```

### Check installation:
```bash
ls -la /usr/local/share/udos/
which udos
echo $PATH
```

### Test direct execution:
```bash
/usr/local/share/udos/udos version
```
