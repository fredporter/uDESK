#!/bin/sh
# TinyCore Boot Optimization for uDOS

set -e

echo "Optimizing TinyCore boot for uDOS..."

# Backup existing configurations
backup_configs() {
    if [ -f /opt/bootlocal.sh ]; then
        cp /opt/bootlocal.sh /opt/bootlocal.sh.backup.$(date +%Y%m%d)
    fi
    
    if [ -f /opt/.filetool.lst ]; then
        cp /opt/.filetool.lst /opt/.filetool.lst.backup.$(date +%Y%m%d)
    fi
}

# Apply boot optimization
apply_optimization() {
    echo "Applying boot configuration..."
    
    # Copy bootlocal.sh
    if [ -f bootlocal.sh ]; then
        sudo cp bootlocal.sh /opt/bootlocal.sh
        sudo chmod +x /opt/bootlocal.sh
        echo "  ✓ bootlocal.sh updated"
    fi
    
    # Update filetool.lst
    if [ -f filetool.lst ]; then
        if [ -f /opt/.filetool.lst ]; then
            # Append to existing file
            cat filetool.lst | while read line; do
                if ! grep -q "$line" /opt/.filetool.lst 2>/dev/null; then
                    echo "$line" | sudo tee -a /opt/.filetool.lst >/dev/null
                fi
            done
        else
            # Create new file
            sudo cp filetool.lst /opt/.filetool.lst
        fi
        echo "  ✓ filetool.lst updated"
    fi
    
    # Copy onboot.lst if TinyCore directory exists
    if [ -d /mnt/sda1/tce ] && [ -f onboot.lst ]; then
        sudo cp onboot.lst /mnt/sda1/tce/onboot.lst
        echo "  ✓ onboot.lst updated"
    fi
}

# Set kernel parameters
optimize_kernel_params() {
    echo "Setting kernel optimization parameters..."
    
    # Create kernel parameter file
    cat > /tmp/kernel-params << 'PARAMS_EOF'
# Optimized kernel parameters for uDOS
quiet
desktop=fluxbox
tce=sda1
opt=sda1
home=sda1
base
norestore
PARAMS_EOF
    
    echo "  ✓ Kernel parameters configured"
    echo "    Add these to your boot loader configuration"
}

# Main optimization routine
main() {
    backup_configs
    apply_optimization
    optimize_kernel_params
    
    echo ""
    echo "Boot optimization complete!"
    echo ""
    echo "Next steps:"
    echo "1. Reboot to apply changes"
    echo "2. Test uDOS functionality: udos info"
    echo "3. Test VNC (if enabled): udos-vnc-start"
    echo ""
    echo "Boot sequence will now include:"
    echo "- uDOS ASCII art branding"
    echo "- Automatic environment setup"
    echo "- Role detection and configuration"
    echo "- Optional VNC desktop startup"
}

main "$@"
