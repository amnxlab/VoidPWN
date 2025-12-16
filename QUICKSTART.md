# VoidPWN Quick Start Guide

## Installation on Raspberry Pi

### 1. Transfer Files to Pi

```bash
# From your computer, copy the repo to the Pi
scp -r VoidPWN kali@<PI_IP>:~/

# Or clone directly on the Pi
ssh kali@<PI_IP>
cd ~
git clone https://github.com/void0x11/VoidPWN.git
cd VoidPWN
```

### 2. Make Scripts Executable

```bash
chmod +x *.sh
```

### 3. Run Main Setup

```bash
sudo ./setup.sh
```

This will:
- Update system packages
- Install all pentesting tools
- Configure WiFi adapter
- Set up PiSugar battery management
- Optimize power settings
- Create system shortcuts

Installation takes 30-60 minutes depending on internet speed.

### 4. Reboot

```bash
sudo reboot
```

---

## Usage

### Launch Main Menu

```bash
voidpwn
```

Or:

```bash
cd ~/VoidPWN
./voidpwn.sh
```

### Direct Script Access

```bash
# WiFi attacks
sudo ./wifi_tools.sh --scan
sudo ./wifi_tools.sh --auto-attack

# Network recon
sudo ./recon.sh --quick 192.168.1.0/24
sudo ./recon.sh --full 192.168.1.100

# View help
./wifi_tools.sh --help
./recon.sh --help
```

---

## WiFi Adapter Setup

### Check Adapter

```bash
iwconfig
# Should show wlan0 (built-in) and wlan1 (ALFA)
```

### Enable Monitor Mode

```bash
sudo airmon-ng start wlan1
# Creates wlan1mon interface
```

### Test Packet Injection

```bash
sudo aireplay-ng --test wlan1mon
```

---

## Remote Access

### SSH Access

```bash
# From any computer on the network
ssh kali@<PI_IP>

# Find Pi IP address
ip a
# or
hostname -I
```

### PiSugar Web Interface

Open browser to: `http://<PI_IP>:8421`

---

## Common Tasks

### WiFi Handshake Capture

```bash
# 1. Scan for networks
sudo ./wifi_tools.sh --scan

# 2. Capture handshake (note BSSID and channel from scan)
sudo ./wifi_tools.sh --handshake AA:BB:CC:DD:EE:FF 6

# 3. Crack the handshake
sudo ./wifi_tools.sh --crack ~/VoidPWN/captures/handshake-01.cap
```

### Network Reconnaissance

```bash
# Discover local network
sudo ./recon.sh --discover

# Quick scan
sudo ./recon.sh --quick 192.168.1.0/24

# Full scan of specific host
sudo ./recon.sh --full 192.168.1.100

# Comprehensive scan
sudo ./recon.sh --comprehensive 192.168.1.100
```

### Automated WiFi Attack

```bash
sudo ./wifi_tools.sh --auto-attack
# Uses Wifite to automatically attack nearby networks
```

---

## Output Locations

- **WiFi Captures**: `~/VoidPWN/captures/`
- **Recon Results**: `~/VoidPWN/recon/`

---

## LCD Display (Install Last)

Only run after all other setup is complete:

```bash
sudo ./install_lcd.sh
```

To revert to HDMI:

```bash
cd ~/VoidPWN/LCD-show-kali
sudo ./LCD-hdmi
```

---

## Troubleshooting

### WiFi Adapter Not Detected

```bash
# Check USB devices
lsusb | grep -i alfa

# Restart network manager
sudo systemctl restart NetworkManager

# Replug the adapter
```

### Monitor Mode Issues

```bash
# Kill interfering processes
sudo airmon-ng check kill

# Restart from scratch
sudo airmon-ng stop wlan1mon
sudo systemctl restart NetworkManager
sudo airmon-ng start wlan1
```

### SSH Connection Refused

```bash
# Check SSH status
sudo systemctl status ssh

# Start SSH
sudo systemctl start ssh

# Enable SSH on boot
sudo systemctl enable ssh
```

### Low Battery

- Check PiSugar web interface: `http://<PI_IP>:8421`
- Battery provides 8-10 hours typical usage
- Charge via USB-C while in use

---

## Tool Reference

### Installed Tools

| Category | Tools |
|----------|-------|
| **WiFi** | aircrack-ng, wifite, bettercap, mdk4, reaver |
| **Network** | nmap, masscan, wireshark, ettercap, arp-scan |
| **Password** | hashcat, john, hydra, medusa, crunch |
| **Exploit** | metasploit, sqlmap, responder, impacket |
| **Web** | gobuster, dirb, nikto, wpscan, whatweb |

### Additional Tools

```bash
sudo ./install_tools.sh
```

Choose from:
1. Advanced wireless tools (wifiphisher, fluxion)
2. Social Engineering Toolkit (SET)
3. Post-exploitation frameworks
4. Forensics tools
5. Reverse engineering tools
6. Mobile analysis tools

---

## Legal Notice

This tool is for authorized security testing only.

- Only test networks you own or have written permission to test
- Unauthorized access to computer systems is illegal
- Users are responsible for compliance with local laws
- The authors assume no liability for misuse

Use responsibly. Stay legal. Hack ethically.

---

## Support

For issues or questions:
- Check the main [README.md](README.md)
- Review script help: `./script.sh --help`
- Check Kali documentation: https://www.kali.org/docs/

---

## Updates

```bash
cd ~/VoidPWN
git pull
chmod +x *.sh
```
