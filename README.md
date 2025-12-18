# 🌌 VoidPWN: Neural Network Pentesting Console

VoidPWN is a professional-grade, automated network pentesting platform designed for Raspberry Pi (ARM) environments. It features a "VoidOS" cyberpunk-inspired HUD for real-time monitoring and high-stakes operations.

![Version](https://img.shields.io/badge/Version-3.0-cyan)
![OS](https://img.shields.io/badge/OS-Kali_Linux-blue)
![Architecture](https://img.shields.io/badge/Architecture-ARMv8-magenta)

---

## 🚀 Vision
VoidPWN transforms a standard Raspberry Pi into a high-powered tactical console. It automates the friction of manual command-line pentesting with a modern, touch-friendly HUD, shared device inventory, and one-click attack scenarios.

## 🛠️ Core Capabilities

### 1. **Tactical Network HUD**
A modern, glassmorphic interface designed for small TFT screens and remote web access. Features real-time system metrics (CPU, RAM, Temp) and a live operation log.

### 2. **Automated Intelligence (SCENARIOS)**
One-click workflows that chain complex tools together:
- **WiFi Audit**: Auto-scan, capture, and test WPS security.
- **Network Sweep**: Deep discovery of all local hosts and services.
- **Stealth Recon**: Quiet scanning with decoy IPs to evade IDS/IPS.
- **Web Hunt**: Automatic identification of every web vulnerability on the network.

### 3. **Advanced WiFi Arsenal**
- **PMKID Sniper**: Clientless capture (works even on empty networks).
- **WPS Pixie-Dust**: 10-second password recovery via entropy exploitation.
- **Chaos Mode (MDK4)**: Beacon flooding to spoof 100+ networks and Auth-flooding to reboot APs.
- **Evil Twin (ROGUE AP)**: One-click cloning of target networks with credential harvesting.

### 4. **Device Inventory & Management**
- **Centralized Inventory**: Discovered devices are saved with IP, MAC, Vendor, and Port info.
- **Global Targeting**: Select a device once; it becomes the target for all attacks, recon, and throttling across all tabs.
- **Persistence**: Save notes and custom tags for your targets.

---

## 📦 Installation & Setup

### 1. **Base System**
Install VoidPWN on a fresh Kali Linux Raspberry Pi environment:
```bash
git clone https://github.com/void0x11/VoidPWN.git
cd VoidPWN
sudo ./scripts/core/install_lcd.sh  # If using a TFT screen
```

### 2. **Core Tools**
```bash
sudo ./scripts/core/install_tools.sh # Standard suite
sudo ./scripts/core/install_advanced_tools.sh # Modern WiFi Arsenal (MDK4, PMKID)
```

### 3. **Launch the Dashboard**
The dashboard runs as a systemd service or can be started manually:
```bash
cd dashboard
python3 server.py
# Access at http://<PI_IP>:5000
```

---

## 🕹️ User Guide Summary

1.  **CONNECT**: Connect the Pi to your uplink WiFi or Ethernet.
2.  **RADAR (SCAN)**: Perform a **QUICK** or **DEEP** scan to populate your inventory.
3.  **TARGETING**: Click a device in the right sidebar. It is now your active target.
4.  **ENGAGE (ATTACK)**:
    - Use **RECON** to find vulnerabilities.
    - Use **CHAOS** (MDK4) to disrupt signals.
    - Use **THROTTLE** to limit a target's bandwidth to 56kbps.
5.  **REPORTS**: All actions are logged and summarized in the Reports tab for your final pentest write-up.

---

## ⚠️ Legal Disclaimer
**VoidPWN is for authorized penetration testing and educational purposes only.** Unauthorized access to computer systems is illegal worldwide. The developers are not responsible for misuse of this tool.

---
*Created by void0x11 | Built for the Void.*
