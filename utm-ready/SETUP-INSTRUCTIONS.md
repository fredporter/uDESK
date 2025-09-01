# 🚀 uDESK UTM Setup Instructions

## Step 1: Create UTM VM

1. **Open UTM** on your Mac
2. **Create New VM** → **Virtualize** → **Linux**
3. **Configure VM:**
   - **Boot ISO:** `TinyCore-current.iso` (in this folder)
   - **RAM:** 1024 MB (1 GB)
   - **Storage:** 4 GB
   - **Display:** **Console Only** ⚠️ *This fixes "display not active" errors*
   - **Network:** NAT or Bridged

## Step 2: Boot TinyCore

1. **Start the VM**
2. **Wait for TinyCore to boot** (text interface is normal)
3. **Login:** username `tc` (no password)

## Step 3: Install uDESK

**Method 1 - Drag & Drop:**
1. Drag `udesk-packages` folder into VM window
2. In TinyCore: `cd /tmp/udesk-packages`
3. Run: `./install-udesk.sh`

**Method 2 - Shared Folder:**
1. Set UTM shared folder to `udesk-packages`
2. In TinyCore: `sudo mount /dev/sdb1 /mnt/sdb1`
3. Run: `/mnt/sdb1/install-udesk.sh`

## Step 4: Test uDESK

```bash
udos-info              # System information
udos-detect-role       # Should show "admin"
udos-service list      # Available services
```

## Step 5: Persistence

Your uDESK installation is automatically persistent!
- Reboot: `sudo reboot`
- uDESK will load automatically

## Troubleshooting

**"Display not active" error:**
- Set Display to "Console Only" in UTM settings

**Packages not found:**
- Ensure .tcz files are copied to VM
- Check: `ls *.tcz` shows the package files

**Network issues:**
- In TinyCore: `sudo dhcp.sh`

---

## 🎉 Success!

Your markdown-focused operating system is ready!

**Quick commands:**
- `micro filename.md` - Edit markdown files
- `echo "# Hello uDESK!" > test.md` - Create markdown
- `cat test.md` - View files

*Everything in uDESK is markdown! 🚀*
