# VoidPWN - Portable Pentesting Device

A portable network penetration testing device built on Raspberry Pi 4 with Kali Linux, featuring standalone power, touchscreen display, and comprehensive pentesting capabilities.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi%204-red.svg)
![OS](https://img.shields.io/badge/OS-Kali%20Linux%20ARM-purple.svg)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Hardware Components](#hardware-components)
- [Installation Guide](#installation-guide)
- [Usage](#usage)
- [Scripts Reference](#scripts-reference)
- [Troubleshooting](#troubleshooting)

---

## Overview

VoidPWN transforms a Raspberry Pi 4 into a fully-featured portable penetration testing platform. Inspired by projects like Pwnagotchi and ThePwnPal, this device provides:

- **Portability**: Compact form factor with integrated battery
- **Power**: Full Kali Linux toolset
- **Stealth**: Small enough to deploy covertly for remote attacks
- **Accessibility**: Touchscreen interface and SSH access from anywhere

Designed for security professionals, red teamers, and ethical hackers who require mobile pentesting capabilities.

---

## Features

- **Standalone Power**: 5000mAh battery providing 8-10 hours of operation
- **Touchscreen Display**: 3.5" LCD for direct interaction
- **Dual-Band WiFi**: 2.4GHz and 5GHz with monitor mode and packet injection
- **Remote Access**: SSH-enabled for worldwide command and control
- **Pre-configured Tools**: Automated setup scripts for common pentesting tasks
- **Attack Automation**: One-command WiFi attacks, reconnaissance, and exploitation

---

## Hardware Components

| Component | Model | Purpose | Link |
|-----------|-------|---------|------|
| **SBC** | Raspberry Pi 4 (8GB) | Main computing platform | [Amazon](https://www.amazon.com/Raspberry-Pi-Computer-Suitable-Workstation/dp/B0899VXM8F) |
| **Display** | Waveshare 3.5" RPi LCD (C) | Touchscreen interface | [Waveshare](https://www.waveshare.com/3.5inch-rpi-lcd-c.htm) |
| **Battery** | PiSugar S Plus (5000mAh) | Portable power supply | [Tindie](https://www.tindie.com/products/pisugar/pisugar-s-plus-battery-for-raspberry-pi-3b3b4b/) |
| **WiFi Adapter** | ALFA AWUS036ACS | Monitor mode and injection | [Amazon](https://www.amazon.com/ALFA-NETWORK-AWUS036ACS-Alfa-Adapter/dp/B0752CTSGD) |
| **Case** | Aluminum Cooling Case | Heat dissipation | [Amazon](https://www.amazon.com/dp/B0BBPPYV76) |
| **Storage** | MicroSD Card (32GB+) | OS and data storage | Any Class 10 |

**Estimated Total Cost**: Approximately $250-300 USD

---

## Installation Guide

### Prerequisites
- Raspberry Pi 4 (4GB or 8GB recommended)
- MicroSD card (32GB minimum, Class 10)
- Internet connection (WiFi or Ethernet)
- HDMI monitor and keyboard (for initial setup)

### Step 1: Flash Kali Linux ARM

1. Download [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Download [Kali Linux ARM image](https://www.kali.org/get-kali/#kali-arm)
3. Flash the image:
   - Device: Raspberry Pi 4
   - OS: Use Custom → Kali Linux ARM Image
   - Storage: Your MicroSD card

### Step 2: Initial Boot and Configuration

```bash
# Default credentials
# Username: kali
# Password: kali

# Change password immediately
passwd

# Update system
sudo apt update && sudo apt upgrade -y

# Enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Find your IP address
ip a
```

### Step 3: Clone VoidPWN Repository

```bash
cd ~
git clone https://github.com/void0x11/VoidPWN.git
cd VoidPWN
chmod +x *.sh
```

### Step 4: Run Setup Script

```bash
# Install all tools and configure system
sudo ./setup.sh

# This will:
# - Install pentesting tools
# - Configure WiFi adapter
# - Set up auto-start services
# - Optimize power settings
```

### Step 5: Hardware Assembly

1. **WiFi Adapter**: Plug ALFA adapter into USB 3.0 port (blue)
2. **PiSugar Battery**: Mount using M2.5 screws from underside
3. **LCD Display**: Save for last (after all software configuration)

### Step 6: LCD Display (Final Step)

```bash
# Only run this when everything else is configured
sudo ./install_lcd.sh
```

---

## Usage

### Quick Start

```bash
# WiFi reconnaissance
./wifi_tools.sh --scan

# Automated WiFi attack
./wifi_tools.sh --auto-attack

# Network reconnaissance
./recon.sh --target 192.168.1.0/24

# Launch interactive menu
./voidpwn.sh
```

### Remote Access

```bash
# From any computer on the network
ssh kali@<RASPBERRY_PI_IP>

# Or use the PiSugar web interface
http://<RASPBERRY_PI_IP>:8421
```

---

## Scripts Reference

| Script | Description | Usage |
|--------|-------------|-------|
| `setup.sh` | Main installation script | `sudo ./setup.sh` |
| `wifi_tools.sh` | WiFi attack automation | `./wifi_tools.sh --help` |
| `recon.sh` | Network reconnaissance | `./recon.sh --target <IP>` |
| `install_tools.sh` | Install additional tools | `sudo ./install_tools.sh` |
| `install_lcd.sh` | LCD display driver setup | `sudo ./install_lcd.sh` |
| `voidpwn.sh` | Interactive main menu | `./voidpwn.sh` |

---

## Troubleshooting

### WiFi Adapter Not Detected

```bash
# Check if adapter is recognized
lsusb | grep -i alfa
iwconfig

# Restart network manager
sudo systemctl restart NetworkManager
```

### SSH Connection Refused

```bash
# Ensure SSH is running
sudo systemctl status ssh
sudo systemctl start ssh
```

### LCD Display Not Working

```bash
# Revert to HDMI
cd ~/VoidPWN/LCD-show-kali
sudo ./LCD-hdmi
```

---

## License

MIT License - See [LICENSE](LICENSE) file for details

---

## Acknowledgments

- Inspired by [Pwnagotchi](https://pwnagotchi.ai/) and [ThePwnPal](https://github.com/Shlucus/ThePwnPal)
- Built with [Kali Linux](https://www.kali.org/)
- Community tools and scripts from the infosec community

---

## Legal Disclaimer

This tool is for educational purposes and authorized security testing only. Unauthorized access to computer systems is illegal. Always obtain proper authorization before conducting security assessments.

Use responsibly. Stay legal. Hack ethically.
