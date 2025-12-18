# VoidPWN Technical Reference

This document provides a low-level technical mapping of the VoidPWN platform's automation logic, from dashboard API endpoints to backend shell script execution.

---

## 1. Wireless Operations (`wifi_tools.sh`)

All wireless actions are orchestrated by `scripts/network/wifi_tools.sh`. The dashboard interfaces with this script via the following parameters.

### Monitor Mode Control
- **Logic**: Uses `airmon-ng` to terminate conflicting processes (NetworkManager, wpa_supplicant) and switch the wireless chipset to monitor state.
- **Commands**:
  - Enable: `airmon-ng start <iface>` or `iwconfig <iface> mode monitor` (fallback).
  - Disable: `airmon-ng stop <iface>mon` and `systemctl restart NetworkManager`.

### PMKID Capture
- **Endpoint**: `/api/wifi/pmkid`
- **Execution**: `sudo ./wifi_tools.sh --pmkid [duration]`
- **Internal Command**: `timeout [duration] hcxdumptool -o [output.pcapng] -i [monitor_iface] --enable_status=1`
- **Implementation Note**: Exploits the RSN IE field. Captured hashes are stored in `output/captures/` and must be converted using `hcxpcapngtool` for cracking.

### WPS Pixie-Dust
- **Endpoint**: `/api/wifi/pixie`
- **Execution**: `sudo ./wifi_tools.sh --pixie <BSSID>`
- **Internal Command**: `reaver -i [monitor_iface] -b [BSSID] -K 1 -vv`
- **Logic**: Exploits low-entropy nonces in the WPS exchange to recover the PIN offline.

### MDK4 Attack Vectors
- **Beacon Flood**: 
  - Execution: `sudo ./wifi_tools.sh --beacon [ssid_file]`
  - Command: `mdk4 [iface] b [-f ssid_file]`
- **Auth Flood**:
  - Execution: `sudo ./wifi_tools.sh --auth [BSSID]`
  - Command: `mdk4 [iface] a [-a BSSID]`

---

## 2. Network Reconnaissance (`recon.sh`)

Reconnaissance actions are executed via `scripts/network/recon.sh`.

### Host Discovery (Quick Scan)
- **Endpoint**: `/api/recon/quick`
- **Execution**: `sudo ./recon.sh --quick <target>`
- **Command**: `nmap -sn <target>`
- **Logic**: Performs an ARP scan (if local) or ICMP echo request (if remote) to map active hosts without port scanning.

### Service Enumeration (Full Scan)
- **Endpoint**: `/api/recon/full`
- **Execution**: `sudo ./recon.sh --full <target>`
- **Command**: `nmap -sV -sC -O -A -p- -oA [output] <target>`
- **Flags**:
  - `-sV`: Version detection.
  - `-sC`: Default script scanning (NSE).
  - `-O`: Operating System detection.
  - `-A`: Aggressive mode (combines -O, -sV, -sC, and traceroute).
  - `-p-`: Scan all 65,535 ports.

### Stealth Reconnaissance
- **Endpoint**: `/api/recon/stealth`
- **Execution**: `sudo ./recon.sh --stealth <target>`
- **Command**: `nmap -sS -T2 -f -D RND:10 -oA [output] <target>`
- **Logic**:
  - `-sS`: TCP SYN scan (half-open).
  - `-T2`: Polite timing to avoid IDS thresholds.
  - `-f`: Packet fragmentation to bypass simple firewalls.
  - `-D RND:10`: Generates 10 random decoy IP addresses.

---

## 3. Automation Scenarios (`scenarios.sh`)

Scenarios are multi-stage workflows orchestrated by `scripts/network/scenarios.sh`.

### Wireless Audit Workflow
1.  **Preparation**: Calls `wifi_tools.sh --monitor-on`.
2.  **Discovery**: Executes `timeout [duration] airodump-ng -w [output] --output-format csv [iface]`.
3.  **Process Integration**: The script parses the CSV output to identify high-signal targets for subsequent capture attempts.

### Web Service Assessment Workflow
1.  **Scanning**: `nmap -p 80,443,8080 --open [network]`.
2.  **Fingerprinting**: Executes `WhatWeb` against discovered IPs.
3.  **Enumeration**: Automated `GoBuster` directory fuzzing:
    - `gobuster dir -u [url] -w /usr/share/wordlists/dirb/common.txt`
4.  **Vulnerability Audit**: Targeted Nikto and SQLMap execution:
    - `nikto -h [url]`
    - `sqlmap -u [url] --batch --crawl=2`

---

## 4. Backend Architecture (`server.py`)

### Process Management
The dashboard uses the `subprocess` module to manage long-running background tasks.
- **Method**: `subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)`
- **Thread Handling**: Each attack or scan is spawned as an independent process. The dashboard captures the PID to track status and allows for manual termination via the UI.

### Data Storage
- **`output/devices.json`**: Acts as the primary state store for host discovery.
- **`output/reports/`**: Root directory for all generated logs, capture files, and Nmap XML/GNMAP results.
- **XML Parsing**: The dashboard utilizes `xml.etree.ElementTree` to parse Nmap XML outputs and extract service metadata for the UI inventory.
