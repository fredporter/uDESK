
#!/bin/sh

set -e

echo "uDOS GitHub Installation..."

if ! which bash >/dev/null 2>&1; then
    echo "Installing bash..."
    tce-load -wi bash
    
    if ! which bash >/dev/null 2>&1; then
        echo "Failed to install bash. Continuing with sh..."
        USE_SH=true
    else
        echo " bash installed successfully"
        USE_SH=false
    fi
else
    USE_SH=false
fi

if ! which curl >/dev/null 2>&1; then
    echo " Installing curl..."
    tce-load -wi curl
    
    if ! which curl >/dev/null 2>&1; then
        echo " Failed to install curl. Manual installation required."
        echo "Try: tce-load -wi curl"
        exit 1
    fi
    echo " curl installed successfully"
fi

if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo " No internet connection"
    exit 1
fi

GITHUB_RAW="https://raw.githubusercontent.com/fredporter/uDESK/main/build/uDOS-core/usr/local/bin"

echo " Downloading uDOS CLI tools..."

sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/local/share/udos/templates

echo "Downloading udos..."
curl -sL "${GITHUB_RAW}/udos" | sudo tee /usr/local/bin/udos > /dev/null

echo "Downloading uvar..."
curl -sL "${GITHUB_RAW}/uvar" | sudo tee /usr/local/bin/uvar > /dev/null

echo "Downloading udata..."
curl -sL "${GITHUB_RAW}/udata" | sudo tee /usr/local/bin/udata > /dev/null

echo "Downloading utpl..."
curl -sL "${GITHUB_RAW}/utpl" | sudo tee /usr/local/bin/utpl > /dev/null

echo "Downloading udos-detect-role..."
curl -sL "${GITHUB_RAW}/udos-detect-role" | sudo tee /usr/local/bin/udos-detect-role > /dev/null

echo "Downloading udos-update..."
curl -sL "${GITHUB_RAW}/udos-update" | sudo tee /usr/local/bin/udos-update > /dev/null

echo "Downloading udos-help..."
curl -sL "${GITHUB_RAW}/udos-help" | sudo tee /usr/local/bin/udos-help > /dev/null

sudo chmod +x /usr/local/bin/udos*
sudo chmod +x /usr/local/bin/uvar
sudo chmod +x /usr/local/bin/udata
sudo chmod +x /usr/local/bin/utpl

echo "Downloading default template..."
curl -sL "https://raw.githubusercontent.com/fredporter/uDESK/main/build/uDOS-core/usr/local/share/udos/templates/document.md" | \
    sudo tee /usr/local/share/udos/templates/document.md > /dev/null || echo "Template download failed (optional)"

if [ -f /opt/.filetool.lst ]; then
    grep -qxF 'usr/local/bin/udos' /opt/.filetool.lst || echo 'usr/local/bin/udos' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/uvar' /opt/.filetool.lst || echo 'usr/local/bin/uvar' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/udata' /opt/.filetool.lst || echo 'usr/local/bin/udata' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/utpl' /opt/.filetool.lst || echo 'usr/local/bin/utpl' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/udos-detect-role' /opt/.filetool.lst || echo 'usr/local/bin/udos-detect-role' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/udos-update' /opt/.filetool.lst || echo 'usr/local/bin/udos-update' >> /opt/.filetool.lst
    grep -qxF 'usr/local/bin/udos-help' /opt/.filetool.lst || echo 'usr/local/bin/udos-help' >> /opt/.filetool.lst
    grep -qxF 'usr/local/share/udos' /opt/.filetool.lst || echo 'usr/local/share/udos' >> /opt/.filetool.lst
    grep -qxF 'home/tc/.udos' /opt/.filetool.lst || echo 'home/tc/.udos' >> /opt/.filetool.lst
fi

udos init

echo ""
echo " uDOS GitHub Installation Complete!"
echo ""
echo "Test the installation:"
echo "  udos version"
echo "  udos info"
echo "  udos var set EDITOR=micro"
echo "  udos var list"
echo "  udos tpl list"
echo ""
echo "Full CLI tools available:"
echo "  udos  - Main CLI"
echo "  uvar  - Variables"
echo "  udata - Data management"
echo "  utpl  - Templates"
echo ""
