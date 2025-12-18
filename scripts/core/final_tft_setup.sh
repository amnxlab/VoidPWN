#!/bin/bash

################################################################################
# VoidPWN - Final TFT Portrait Mode Setup
# Description: Complete setup for TFT in portrait mode with correct touch
# Author: void0x11
# Usage: sudo ./final_tft_setup.sh
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

USER_NAME="${SUDO_USER:-kali}"
USER_HOME="/home/$USER_NAME"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   VoidPWN TFT Portrait Mode Setup     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Display Rotation to Portrait
log_info "Step 1/4: Configuring display rotation (Portrait Mode)..."

mkdir -p "$USER_HOME/.config/autostart"

cat > "$USER_HOME/.config/autostart/rotate-display.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Rotate Display
Exec=/bin/bash -c "sleep 2 && xrandr -o right"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chown "$USER_NAME:$USER_NAME" "$USER_HOME/.config/autostart/rotate-display.desktop"
log_success "Display will rotate to portrait mode (vertical)"

# Step 2: Touch Calibration for Portrait Mode
log_info "Step 2/4: Configuring touch calibration for portrait..."

# Corrected matrix for portrait mode with proper left/right orientation
# Matrix: 0 -1 1 1 0 0 0 0 1
cat > "$USER_HOME/.config/autostart/calibrate-touch.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Calibrate Touch
Exec=/bin/bash -c "sleep 3 && TOUCH_ID=$(xinput list | grep -i 'touch\|ADS7846' | grep -o 'id=[0-9]*' | grep -o '[0-9]*' | head -1) && [ -n \"$TOUCH_ID\" ] && xinput set-prop $TOUCH_ID 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chown "$USER_NAME:$USER_NAME" "$USER_HOME/.config/autostart/calibrate-touch.desktop"
log_success "Touch calibration configured for portrait mode"

# Step 3: Chromium Kiosk Mode
log_info "Step 3/4: Configuring Chromium kiosk mode..."

cat > "$USER_HOME/.config/autostart/voidpwn-dashboard.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=VoidPWN Dashboard
Exec=/bin/bash -c "sleep 8 && chromium --noerrdialogs --disable-infobars --password-store=basic --kiosk http://localhost:5000"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

cat > "$USER_HOME/.config/autostart/disable-screensaver.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Disable Screensaver
Exec=/bin/bash -c "xset -dpms && xset s off && xset s noblank"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chown -R "$USER_NAME:$USER_NAME" "$USER_HOME/.config/autostart"
log_success "Chromium kiosk mode configured"

# Step 4: Verify Services
log_info "Step 4/4: Verifying services..."

if systemctl is-active voidpwn.service &>/dev/null; then
    log_success "Dashboard service is running"
else
    log_warning "Starting dashboard service..."
    systemctl start voidpwn.service
fi

# Summary
echo ""
log_success "TFT Portrait Mode Setup Complete!"
echo ""
echo -e "${YELLOW}Configuration Summary:${NC}"
echo "  ✓ Display: Will rotate to portrait (vertical)"
echo "  ✓ Touch: Calibrated for portrait orientation"
echo "  ✓ Dashboard: Auto-launches in kiosk mode"
echo ""
echo -e "${BLUE}Touch Calibration Matrix:${NC}"
echo "  0 -1  1"
echo "  1  0  0"
echo "  0  0  1"
echo ""
echo -e "${GREEN}Next Step:${NC}"
echo "  Reboot the system: ${YELLOW}sudo reboot${NC}"
echo ""
echo -e "${CYAN}After reboot:${NC}"
echo "  • TFT will display in PORTRAIT mode (vertical)"
echo "  • Touch: Up=Up, Down=Down, Left=Left, Right=Right"
echo "  • Dashboard launches automatically"
echo ""
