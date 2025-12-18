# 📖 VoidPWN Operative's Guide

Welcome, Operative. This guide will walk you through your first mission with VoidPWN, from setup to final reports.

## 🧭 Navigating the HUD

The VoidPWN interface is divided into 6 Tactical Tabs:

### 1. **CONNECT (WiFi Liaison)**
- **Purpose**: Bridge the gap between the Pi and the outside world.
- **Workflow**: 
    1. Click **SCAN** to see neighboring APs.
    2. Click an entry to select it.
    3. Tap the **PASSWORD** field; the virtual keyboard will rise.
    4. Type your password and hit **CONNECT**.

### 2. **RADAR (Discovery)**
- **Purpose**: Build your target inventory.
- **Quick Scan**: Fast ARP scan to find active IPs.
- **Deep Scan**: Thorough Nmap version detection (takes 2-5 minutes).
- **Details**: Clicking **DETAILS** on a device card shows open ports and allows you to add custom **Notes** (e.g., "HR Admin Laptop") and **Tags** (e.g., "Vulnerable", "High Value").

### 3. **ATTACK (The Arsenal)**
- **Standard Panel**: Deauth, Evil Twin, and Handshake captures.
- **Advanced Panel**:
    - **PMKID Sniper**: Use this for clientless networks.
    - **WPS Pixie**: Use this on networks with WPS Enabled.
- **Throttle**: Select a device IP, choose a speed (like 56kbit), and hit **START LIMIT**. Watch as their internet slows to a crawl.

### 4. **SCENARIOS (Auto-Pilot)**
- **Stealth Recon**: Ideal for bypassing modern intrusion detection.
- **Web Hunt**: Automatically finds all `http(s)` services and runs directory discovery.
- **WiFi Audit**: The "One Button Hack" – scans, captures handshakes, and tries WPS automatically.

### 5. **REPORTS (The Logbook)**
Every action you take is logged here with a timestamp. This is your source of truth for post-operation documentation. Click any column to sort by time or type.

### 6. **SYSTEM (Core Control)**
Manage the Pi's power states and display. If you accidentally lose your desktop environment on the TFT, use **SWITCH TO HDMI** to restore the display.

---

## 🛠️ Common Operations Walkthrough

### Scenario A: Obtaining a WPA2 Password (Clientless)
1. Go to **ATTACK**.
2. Select your target WiFi network in the right sidebar (Network Target).
3. Click **PMKID SNIPER**.
4. Wait for the capture to finish (default 300s).
5. Convert the resulting `.pcapng` in the `output/captures` folder to a hash and crack it!

### Scenario B: Identifying a High-Value Target
1. Run a **DEEP SCAN** in the **RADAR** tab.
2. Review the **DETAILS** of each device in the sidebar.
3. Look for "PORT 3389" (RDP) or "PORT 8080" (Admin Panels).
4. Tag these devices as **"HIGH VALUE"**.
5. Switch to the **RECON** tab and run a **VULN SCAN** specifically on those IPs.

---

## 🛑 Safety Protocols

- **Monitor Mode**: Some tools will automatically put your interface into monitor mode. If your internet stops working, check the **SYSTEM** tab to ensure monitor mode is toggled off when finished.
- **Sudo Permissions**: Always run the server with `sudo` to ensure it has raw packet access.

---
*Good luck, Operative. The Void is waiting.*
