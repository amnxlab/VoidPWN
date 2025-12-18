# Technical Operational Reference

This document provides a low-level technical mapping of VoidPWN's core scripts and their corresponding CLI parameters. It is intended for advanced users requiring direct script execution or system customization.

---

## 📡 Network Reconnaissance (`recon.sh`)

The `recon.sh` script manages all Layer 3 and Layer 4 scanning operations.

- **Fast Discovery**: `sudo ./recon.sh --quick <TARGET>`
  - Executes: `nmap -sn <TARGET>`
- **Full Enumeration**: `sudo ./recon.sh --full <TARGET>`
  - Executes: `nmap -sV -sC -O -A -p- <TARGET>`
- **Stealth Assessment**: `sudo ./recon.sh --stealth <TARGET>`
  - Executes: `nmap -sS -T2 -f -D RND:10 <TARGET>`
- **Vulnerability Check**: `sudo ./recon.sh --vuln <TARGET>`
  - Executes: `nmap --script vuln <TARGET>`
- **Web Fuzzing**: `sudo ./recon.sh --web <URL> [WORDLIST]`
  - Executes: `gobuster dir -u <URL> -w [WORDLIST] -x php,html,txt,js`

---

## 🎯 Wireless Assessment (`wifi_tools.sh`)

The `wifi_tools.sh` script handles monitor mode transition and Layer 2 assessment vectors.

- **Interface Control**: 
  - `sudo ./wifi_tools.sh --monitor-on` (Starts `airmon-ng`)
  - `sudo ./wifi_tools.sh --monitor-off` (Stops `airmon-ng`)
- **Handshake Interception**: `sudo ./wifi_tools.sh --handshake <BSSID> <CH>`
  - Orchestrates `airodump-ng` and `aireplay-ng --deauth 10`.
- **Clientless Capture**: `sudo ./wifi_tools.sh --pmkid [DURATION]`
  - Executes `hcxdumptool` for specified duration.
- **WPS PIN Recovery**: `sudo ./wifi_tools.sh --pixie <BSSID>`
  - Executes `reaver` with Pixie-Dust entropy attack enabled (`-K 1`).
- **MDK4 Stress Test**:
  - `sudo ./wifi_tools.sh --beacon [FILE]` (Beacon flood)
  - `sudo ./wifi_tools.sh --auth [BSSID]` (Association flood)

---

## 🤖 Workflow Automation (`scenarios.sh`)

Scenarios provide pre-configured missions that chain multiple scripts and parameters.

- **Tiered WiFi Audit**: `sudo ./scenarios.sh` (Manual Menu Option 1)
  - Logic: Monitor ON -> 10m Airodump scan -> Target identification -> Sequential PMKID/Handshake attempts.
- **Stealth Recon Mission**: `sudo ./scenarios.sh` (Manual Menu Option 4)
  - Logic: Fragmentation + Timing T2 + Decoy scanning across specified target range.
- **Web Application Hunt**: `sudo ./scenarios.sh` (Manual Menu Option 3)
  - Logic: Port 80/443 discovery -> Technology identification (WhatWeb) -> Sequential GoBuster/Nikto/SQLMap audits.

---

## ⚙️ System Architecture

### Dashboard Process Handling
The Flask application (`server.py`) interacts with these scripts using `subprocess.Popen`. This allows for non-blocking execution where the UI receives the PID immediately, while the tool continues to stream output to the system logs.

### Inventory Synchronization
Discovered hosts are persisted in `output/devices.json`. The dashboard uses asynchronous polling to refresh the inventory without requiring a page reload.

---
*For comprehensive theoretical analysis and flag references, see the [Technical Reference](./docs/TECHNICAL_REFERENCE.md).*
