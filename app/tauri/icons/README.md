# uDESK Blue Diamond Icon

This directory contains the uDOS blue diamond icon in various formats for the Tauri application.

## Icon Formats Needed

### Tauri Requirements
- `32x32.png` - Small icon
- `128x128.png` - Medium icon  
- `128x128@2x.png` - High DPI medium
- `icon.png` - Default icon (usually 512x512)
- `icon.ico` - Windows ICO format
- `icon.icns` - macOS ICNS format

### Creating Icons from Source

If you have the uDOS blue diamond source image:

```bash
# Create PNG icons
sips -z 32 32 source.png --out 32x32.png
sips -z 128 128 source.png --out 128x128.png
sips -z 256 256 source.png --out 128x128@2x.png
sips -z 512 512 source.png --out icon.png

# Create ICO for Windows
convert icon.png icon.ico

# Create ICNS for macOS
mkdir icon.iconset
sips -z 16 16 source.png --out icon.iconset/icon_16x16.png
sips -z 32 32 source.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32 source.png --out icon.iconset/icon_32x32.png
sips -z 64 64 source.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128 source.png --out icon.iconset/icon_128x128.png
sips -z 256 256 source.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256 source.png --out icon.iconset/icon_256x256.png
sips -z 512 512 source.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512 source.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 source.png --out icon.iconset/icon_512x512@2x.png
iconutil -c icns icon.iconset
```

## Temporary Placeholder

For now, we'll create a placeholder blue diamond using SVG converted to PNG.
