# VoidPWN - Next Steps

## What's Done

Your VoidPWN project is complete and ready to deploy.

### Created Files

```
VoidPWN/
├── scripts/
│   ├── core/             Setup, test, tools, dashboard
│   ├── network/          WiFi tools, recon, scenarios
│   └── python/           Python logic (scanning, visualization)
├── voidpwn.sh            Interactive menu (main interface)
├── README.md             Full documentation
├── LICENSE               MIT License
└── docs/                 Documentation (Quickstart, Deployment, etc)
```

---

## What To Do Now

### Step 1: Transfer to Your Raspberry Pi

**Option A: Git Clone (Easiest)**
```bash
# SSH into your Pi
ssh kali@<YOUR_PI_IP>

# Clone the repo (once you push to GitHub)
git clone https://github.com/void0x11/VoidPWN.git
cd VoidPWN
```

**Option B: Direct Copy**
```bash
# From Windows, copy to Pi
scp -r C:\Users\ahmedamin\Github\VoidPWN kali@<PI_IP>:~/
```

**Option C: USB Drive**
1. Copy `VoidPWN` folder to USB
2. Plug into Pi
3. Copy from USB to Pi home directory

---

### Step 2: Run Setup (30-60 minutes)

```bash
# Make scripts executable
chmod +x *.sh

# Run main setup
sudo ./scripts/core/setup.sh

# Wait for installation to complete
# This installs 50+ tools automatically
```

---

### Step 3: Reboot

```bash
sudo reboot
```

---

### Step 4: Start Using VoidPWN

```bash
# Launch the interactive menu
voidpwn

# Or use scripts directly:
sudo ./scripts/network/wifi_tools.sh --scan
sudo ./scripts/network/recon.sh --discover
```

---

## Installation Checklist

- [ ] Transfer VoidPWN to Raspberry Pi
- [ ] Run `chmod +x *.sh`
- [ ] Run `sudo ./scripts/core/setup.sh`
- [ ] Wait for installation (30-60 min)
- [ ] Reboot Pi
- [ ] Plug in ALFA WiFi adapter
- [ ] Test with `voidpwn` command
- [ ] LAST: Install LCD with `sudo ./scripts/core/install_lcd.sh`

---

## Quick Command Reference

| What You Want | Command |
|---------------|---------|
| **Launch menu** | `voidpwn` |
| **Scan WiFi** | `sudo ./scripts/network/wifi_tools.sh --scan` |
| **Capture handshake** | `sudo ./scripts/network/wifi_tools.sh --handshake <BSSID> <CH>` |
| **Network scan** | `sudo ./scripts/network/recon.sh --quick 192.168.1.0/24` |
| **Full port scan** | `sudo ./scripts/network/recon.sh --full 192.168.1.100` |
| **Install LCD** | `sudo ./scripts/core/install_lcd.sh` |
| **Revert to HDMI** | `cd ~/VoidPWN/LCD-show-kali && sudo ./LCD-hdmi` |

---

## What You Get

### WiFi Tools
- Network scanning
- WPA handshake capture
- Automated attacks (Wifite)
- Deauth attacks
- Password cracking

### Network Tools
- Host discovery
- Port scanning (quick/full/stealth)
- Vulnerability scanning
- Web enumeration
- SMB/DNS enumeration

### System
- Interactive menu
- Remote SSH access
- Battery management (PiSugar)
- Auto-login
- Power optimization

---

## Documentation

| File | Purpose |
|------|---------|
| [README.md](README.md) | Complete project overview |
| [docs/QUICKSTART.md](docs/QUICKSTART.md) | Quick reference guide |
| [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) | Detailed installation steps |

---

## Important Notes

### LCD Display
Install the LCD LAST. After running `install_lcd.sh`, your HDMI won't work anymore. Make sure everything else is working first via SSH.

### Legal Warning
Only test networks you own or have permission to test. Unauthorized hacking is illegal.

### WiFi Adapter
Make sure to plug in your ALFA AWUS036ACS adapter (or compatible) for WiFi attacks to work.

---

## You're Ready

Your VoidPWN project is complete and ready to deploy.

Next action: Transfer the files to your Pi and run `sudo ./scripts/core/setup.sh`

Happy ethical hacking.

---

## Need Help?

1. Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed steps
2. Check [QUICKSTART.md](QUICKSTART.md) for troubleshooting
3. Run `./script.sh --help` for script-specific help
