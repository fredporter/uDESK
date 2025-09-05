# uDESK Installer Icons & Assets

This directory contains assets for the uDESK installer launchers.

## Mac Icon Setup

To add a custom icon to the `udesk-install.command` file:

1. **Create your icon** (1024x1024 PNG recommended)
2. **Convert to ICNS format**:
   ```bash
   sips -s format icns your-icon.png --out assets/udesk-icon.icns
   ```
3. **Apply the icon**:
   ```bash
   ./add-icon.sh
   ```

## Icon Requirements

- **Format**: ICNS (Apple Icon format)
- **Size**: 1024x1024 base resolution
- **Design**: Should represent uDESK branding
- **File name**: `udesk-icon.icns`

## Alternative Methods

If you have an existing .app with an icon you like:
```bash
# Copy icon from existing app
cp /Applications/YourApp.app/Contents/Resources/icon.icns assets/udesk-icon.icns
./add-icon.sh
```

## Distribution Files

- `udesk-install.command` - Mac installer (can have custom icon)
- `udesk-install-ubuntu.sh` - Ubuntu/Linux installer  
- `udesk-install-windows.bat` - Windows installer

All installers follow the same bootstrap pattern and download the core system from GitHub.
