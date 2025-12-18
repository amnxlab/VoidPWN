# VoidPWN Verification & Test Plan

Follow these steps after running `./scripts/core/setup.sh` but **BEFORE** installing the LCD or Kiosk mode. This ensures the core tools are working correctly.

## 1. System Check
**Goal**: Verify dependencies are installed.
- [ ] Run `voidpwn` in the terminal.
- [ ] Check if the menu loads without errors.
- [ ] Select **[5] System Tools** -> **[1] System Status**.
- [ ] Verify IP address and Interface detection.

## 2. WiFi Adapter Test
**Goal**: Ensure your external socket/adapter is recognized.
- [ ] Connect your ALFA/External adapter.
- [ ] Run: `iwconfig`
- [ ] Verify you see `wlan1` (or similar) in the list.

## 3. Monitor Mode Test (Manual)
**Goal**: Verify chipset supports injection.
- [ ] Run: `sudo airmon-ng start wlan1` (replace wlan1 with your adapter).
- [ ] Run: `iwconfig`
- [ ] Verify the interface is now in `Mode: Monitor` (often named `wlan1mon`).
- [ ] **Stop** it: `sudo airmon-ng stop wlan1mon`.

## 4. WiFi Tools Script Test
**Goal**: Test the automated script logic.
- [ ] Run: `sudo ./scripts/network/wifi_tools.sh`
- [ ] Choose **[1] Scan Networks**.
- [ ] Verify it finds nearby networks and lists them.
- [ ] Press `Ctrl+C` to exit.

## 5. Dashboard Test (Headless)
**Goal**: Verify the web server starts and is accessible.
- [ ] Start the server manually: 
  ```bash
  cd ~/VoidPWN/dashboard
  sudo python3 server.py
  ```
- [ ] On your laptop/phone (same WiFi), open: `http://<PI_IP>:5000`
- [ ] Verify the UI loads.
- [ ] Click "REFRESH ALL" and see if System Metrics update.
- [ ] Press `Ctrl+C` to stop the server.

---

## 6. Proceed to Kiosk Setup
**Only if all above pass:**
1. Run `sudo ./scripts/core/install_lcd.sh` (Reboots system).
2. Run `sudo ./scripts/core/setup_kiosk.sh` (Configures Touch).
3. Reboot and enjoy.
