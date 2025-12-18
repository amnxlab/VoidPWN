#!/bin/bash

################################################################################
# VoidPWN - Auto-Login & Kiosk Fix Script
# Description: Configures auto-login and Chromium kiosk mode for dashboard
# Author: void0x11
# Usage: sudo ./fix_autologin.sh
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
log_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

USER_NAME="${SUDO_USER:-kali}"
USER_HOME="/home/$USER_NAME"

log_info "Configuring auto-login and kiosk mode for user: $USER_NAME"

# Step 1: Configure LightDM Auto-Login
log_info "Step 1: Configuring LightDM auto-login..."

LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

if [ -f "$LIGHTDM_CONF" ]; then
    # Backup original
    cp "$LIGHTDM_CONF" "$LIGHTDM_CONF.bak"
    
    # Remove any existing autologin lines
    sed -i '/^autologin-user=/d' "$LIGHTDM_CONF"
    sed -i '/^autologin-user-timeout=/d' "$LIGHTDM_CONF"
    
    # Add autologin configuration under [Seat:*]
    if grep -q "^\[Seat:\*\]" "$LIGHTDM_CONF"; then
        sed -i "/^\[Seat:\*\]/a autologin-user=$USER_NAME\nautologin-user-timeout=0" "$LIGHTDM_CONF"
    else
        echo -e "\n[Seat:*]\nautologin-user=$USER_NAME\nautologin-user-timeout=0" >> "$LIGHTDM_CONF"
    fi
    
    log_success "LightDM configured"
else
    log_warning "LightDM config not found, trying alternative method..."
    
    # Try creating the config
    mkdir -p /etc/lightdm/lightdm.conf.d/
    cat > /etc/lightdm/lightdm.conf.d/50-autologin.conf <<EOF
[Seat:*]
autologin-user=$USER_NAME
autologin-user-timeout=0
EOF
    log_success "Created LightDM autologin config"
fi

# Step 2: Create/Update .xinitrc
log_info "Step 2: Creating .xinitrc..."

cat > "$USER_HOME/.xinitrc" <<'EOF'
#!/bin/bash

# Disable screen saver and power management
xset -dpms
xset s off
xset s noblank

# Hide cursor if not moving
unclutter -idle 0.1 -root &

# Start window manager (removes title bars for fullscreen feel)
matchbox-window-manager -use_titlebar no &

# Wait a moment for network/server
sleep 5

# Start Chromium in Kiosk Mode
# Pointing to localhost:5000 where the systemd service is running
chromium --noerrdialogs --disable-infobars --kiosk http://localhost:5000 &

# Keep session alive
exec sh /etc/X11/Xsession
EOF

chown "$USER_NAME:$USER_NAME" "$USER_HOME/.xinitrc"
chmod +x "$USER_HOME/.xinitrc"

log_success ".xinitrc created"

# Step 3: Enable Graphical Target
log_info "Step 3: Enabling graphical boot..."

systemctl set-default graphical.target
systemctl enable lightdm

log_success "Graphical target enabled"

# Step 4: Verify Service
log_info "Step 4: Verifying voidpwn.service..."

if systemctl is-enabled voidpwn.service &>/dev/null; then
    log_success "voidpwn.service is enabled"
else
    log_warning "Enabling voidpwn.service..."
    systemctl enable voidpwn.service
fi

if systemctl is-active voidpwn.service &>/dev/null; then
    log_success "voidpwn.service is running"
else
    log_warning "Starting voidpwn.service..."
    systemctl start voidpwn.service
fi

# Step 5: Summary
echo ""
log_success "Configuration complete!"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "  ✓ Auto-login configured for user: $USER_NAME"
echo "  ✓ .xinitrc created with Chromium kiosk mode"
echo "  ✓ Graphical boot enabled"
echo "  ✓ Dashboard service verified"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Reboot: sudo reboot"
echo "  2. System should auto-login and launch dashboard"
echo "  3. If successful, install TFT: sudo ~/VoidPWN/scripts/core/install_lcd.sh"
echo ""
log_warning "Reboot required for changes to take effect"
