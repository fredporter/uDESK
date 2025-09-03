# 🚀 ONE-COMMAND GIT DEPLOYMENT WITH VIRTDS & SPICE

## 🔧 BOOTSTRAP (Fresh TinyCore VM - Run FIRST):

```bash
# Step 1: Enable networking
sudo dhcp.sh

# Step 2: Install essential tools
tce-load -wi curl.tcz
tce-load -wi bash.tcz  
tce-load -wi git.tcz
```

## ⚡ THEN Copy-Paste This ONE Command:

```bash
curl -sL https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/git-deploy.sh | bash
```

## Or Download and Run:

```bash
wget https://raw.githubusercontent.com/fredporter/uDESK/main/vm/current/git-deploy.sh
chmod +x git-deploy.sh
./git-deploy.sh
```

## Advanced Options:

```bash
# Network setup only
./git-deploy.sh network

# SPICE setup only  
./git-deploy.sh spice

# VirtDS (shared folders) only
./git-deploy.sh virtds

# Verify installation
./git-deploy.sh verify
```

## What This Script Does:

✅ **Auto-detects** VM environment (UTM, QEMU, VirtualBox)  
✅ **Sets up networking** (DHCP, connectivity test)  
✅ **Installs tools** (git, curl, wget, bash)  
✅ **Enables SPICE** (clipboard, display integration)  
✅ **Mounts VirtDS** (VirtIO shared folders)  
✅ **Clones uDESK** from GitHub automatically  
✅ **Installs uDOS** with clean architecture  
✅ **Configures persistence** (TinyCore)  
✅ **Sets up auto-startup** (ready on boot)  
✅ **Verifies everything** works perfectly  

## Result:

After running, you'll have:
- ✅ Full uDOS M1 system installed
- ✅ SPICE clipboard working  
- ✅ Shared folders mounted at `/mnt/virtds`
- ✅ Auto-startup on VM boot
- ✅ All commands ready: `udos`, `uvar`, `udata`, `utpl`

## VM-Specific Features:

### UTM/QEMU:
- SPICE agent for clipboard sync
- VirtIO 9P shared folder mounting
- Optimized for macOS integration

### VirtualBox:
- Guest additions integration
- Shared folder auto-mounting
- Clipboard bidirectional

### Generic Linux:
- Basic Git-based installation
- Standard tool setup
- Manual networking

*One command deploys everything! 🎉*
