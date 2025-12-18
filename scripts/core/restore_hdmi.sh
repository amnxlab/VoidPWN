#!/bin/bash

################################################################################
# VoidPWN - HDMI Switcher
# Description: Restores HDMI output and disables LCD drivers
# Author: void0x11
# Usage: sudo ./restore_hdmi.sh
################################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[*]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

log_info "Restoring HDMI output..."
log_warning "This will disable the 3.5 LCD and reboot the system."

# Check if LCD directory exists
if [ -d "/home/$SUDO_USER/LCD-show-kali" ]; then
    cd "/home/$SUDO_USER/LCD-show-kali"
    
    # Use the provided driver script to switch back to LCD
    # Usually it's ./LCD-hdmi
    if [ -f "./LCD-hdmi" ]; then
        log_info "Found driver script, switching to HDMI..."
        ./LCD-hdmi
        exit 0
    fi
fi

# Fallback: Manual restoration of /boot/config.txt
log_info "Driver script not found, manually restoring /boot/config.txt..."

if [ -f "/boot/config.txt.bak" ]; then
    cp /boot/config.txt.bak /boot/config.txt
    log_success "Restored backup config"
    log_info "Rebooting in 3 seconds..."
    sleep 3
    reboot
else
    log_error "No backup found. Please edit /boot/config.txt manually to remove LCD overlays."
    exit 1
fi
