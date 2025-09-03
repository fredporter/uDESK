#!/bin/sh
# /opt/bootlocal.sh - TinyCore boot customization with uDOS integration
# This file is executed during the boot process

# Enable networking
/usr/bin/dhcp.sh &

# uDOS Boot Integration
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh boot
fi

# Initialize uDOS environment
if [ -f /usr/local/bin/udos-boot-art.sh ]; then
    /usr/local/bin/udos-boot-art.sh init
fi

# Auto-start VNC if configured
if [ "$UDOS_AUTO_VNC" = "yes" ] && [ -f /usr/local/bin/udos-vnc-start ]; then
    /usr/local/bin/udos-vnc-start &
fi

# Set uDOS role if not already set
if [ -z "$UDOS_ROLE" ] && [ -f /usr/local/bin/udos-detect-role ]; then
    export UDOS_ROLE=$(udos-detect-role)
fi

# Load additional uDOS services
if [ -f /usr/local/bin/udos ]; then
    udos boot-services >/dev/null 2>&1 || true
fi
