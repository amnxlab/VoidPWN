# Attack and Feature Reference

This document provides a comprehensive technical reference for the security assessment features integrated into the VoidPWN platform, detailing the underlying tools, methodologies, and implementation logic.

---

## 📡 Wireless Assessment Features

### 1. PMKID Clientless Capture
- **Methodology**: Intercepts the Pairwise Master Key ID from the RSN IE during an association request.
- **Tools**: `hcxdumptool` (capture), `hcxpcapngtool` (extraction).
- **Implementation**: `wifi_tools.sh --pmkid` -> `hcxdumptool -o [out] -i [iface] --enable_status=1`.
- **Technical Logic**: Exploits the fact that many Access Points include the PMKID in the RSN Information Element of the first EAPOL message. This allows for offline decryption of the WPA2 PSK without requiring an active client or deauthentication session.

### 2. WPS Pixie-Dust Research
- **Methodology**: Offline cryptographic attack against the WPS PIN using low-entropy nonces.
- **Tools**: `reaver`, `pixiewps`.
- **Implementation**: `wifi_tools.sh --pixie` -> `reaver -i [iface] -b [bssid] -K 1 -vv`.
- **Technical Logic**: Targets the predictable generation of E-S1 and E-S2 nonces in specific wireless chipsets. Capturing these during the M3 message allows for the immediate recovery of the WPS PIN.

### 3. MDK4 Protocol Stress Testing
- **Beacon Flooding**:
  - Implementation: `wifi_tools.sh --beacon` -> `mdk4 [iface] b [-f ssid_list]`.
  - Logic: Injects randomized Beacon frames to saturate client scan lists and test signal discovery resilience.
- **Authentication Flooding**:
  - Implementation: `wifi_tools.sh --auth` -> `mdk4 [iface] a [-a bssid]`.
  - Logic: Floods the target AP's association table with spoofed MAC addresses to test resource management.

### 4. WPA/WPA2 Handshake Capture
- **Methodology**: Interception of the 4-way EAPOL exchange between client and AP.
- **Tools**: `airodump-ng`, `aireplay-ng`.
- **Implementation**: `wifi_tools.sh --handshake` -> `airodump-ng -c [ch] --bssid [bssid] -w [out] [iface]` followed by `aireplay-ng --deauth 10 -a [bssid] [iface]`.

---

## 🛰️ Network Reconnaissance Features

### 1. TCP SYN Stealth Scanning
- **Methodology**: Half-open scanning to identify active ports without completing the TCP 3-way handshake.
- **Tools**: `nmap -sS`.
- **Implementation**: `recon.sh --stealth` -> `nmap -sS -T2 -f -D RND:10 [target]`.
- **Technical Logic**: Sends a SYN packet; receipt of SYN/ACK identifies an open port. The scanner immediately sends a RST packet, ensuring the connection is never fully established, which bypasses many application-level logs.

### 2. Service and OS Fingerprinting
- **Methodology**: Analyzing protocol responses and packet header micro-behaviors (TTL, window sizes).
- **Tools**: `nmap -sV -O -A`.
- **Implementation**: `recon.sh --full` -> `nmap -sV -sC -O -A -p- [target]`.
- **Technical Logic**: `-sV` probes for service versions; `-O` identifies the OS stack; `-sC` executes the Nmap Scripting Engine (NSE) for default security audits.

### 3. Enumeration and Web Discovery
- **Web Fuzzing**: `recon.sh --web` -> `gobuster dir -u [url] -w [wordlist]`.
- **SMB Audit**: `recon.sh --smb` -> `enum4linux -a [target]`.
- **Technical Logic**: Automated discovery of unlinked directories and sensitive configuration files through recursive brute-forcing and protocol-specific metadata extraction.

---

## 🤖 Workflow Automation Logic

Scenarios in VoidPWN act as high-level orchestrators, chaining multiple scripts with state management.

### Example: WiFi Audit Orchestration
1.  **Preparation**: Interface state transition to monitor mode via `airmon-ng`.
2.  **Survey**: Background sniffing to map the local signal environment.
3.  **Targeting**: Logic-based selection of high-signal targets for sequential assessment.
4.  **Capture**: Concurrent execution of PMKID and Handshake capture engines.

---
*For direct API mappings and script parameter definitions, refer to the [Technical Reference](./TECHNICAL_REFERENCE.md).*
