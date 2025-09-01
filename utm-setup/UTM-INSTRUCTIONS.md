# 🚀 uDESK UTM Setup Instructions

## Step 1: Create UTM Virtual Machine

1. **Open UTM** on your Mac
2. **Create New VM** → "Virtualize" → "Linux"
3. **Settings:**
   - **Boot ISO Image:** `TinyCore-current.iso` (in this folder)
   - **RAM:** 2GB (2048 MB)
   - **Storage:** 8GB
   - **Shared Directory:** Select the `shared-folder` directory

## Step 2: Boot and Install

1. **Start the VM** with TinyCore ISO
2. **Wait for TinyCore to boot** (should show desktop)
3. **Mount shared folder:**
   ```bash
   sudo mkdir -p /mnt/sdb1
   sudo mount /dev/sdb1 /mnt/sdb1
   ```
4. **Run auto-installer:**
   ```bash
   cd /mnt/sdb1
   ./auto-install-udesk.sh
   ```

## Step 3: Test uDESK

After installation:
```bash
udos-info              # Check system status
udos-detect-role       # Should show "admin"
./udesk-welcome.sh     # Welcome tour
```

## Step 4: Persistence (Optional)

To save changes between reboots:
```bash
sudo reboot            # Test that uDESK loads automatically
```

## Troubleshooting

**If shared folder not working:**
1. Try dragging .tcz files directly into VM
2. Copy to /tmp/ and run installer from there

**If packages don't load:**
1. Check: `ls /mnt/sda1/tce/onboot.lst`
2. Reload: `tce-load -i /mnt/sda1/tce/optional/udos-core.tcz`

**For networking:**
```bash
sudo dhcp.sh           # Enable internet access
```

## Success! 🎉

Your markdown-focused operating system is now running in UTM!

