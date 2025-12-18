# System Interface Manual

This manual provides a technical overview of the VoidPWN Head-Up Display (HUD) and its integration with the Python backend.

---

## 🏗️ Technical Architecture

The HUD is a single-page application (SPA) built with Vanilla JavaScript, interfacing with a Flask REST API.

- **Frontend Core**: `app.js` manages state, UI rendering, and asynchronous API polling.
- **Backend Core**: `server.py` handles route definitions and executes shell scripts via the `subprocess` module.
- **Data Flow**:
  1. UI Action (e.g., Click 'Scan') -> `fetch('/api/recon/quick')`.
  2. Backend starts `recon.sh` -> returns JSON with task PID.
  3. UI polls `/api/reports` -> updates live console container.

---

## 🧭 Operational Modules

### 1. System Console & Metrics
- **Resource Monitoring**: `app.js` polls `/api/system/stats` every 2 seconds. The backend retrieves data using the `psutil` library.
- **Interface Verification**: Displays the status of `wlan1mon` by parsing the output of `iwconfig`.

### 2. Radar and Global Inventory
- **Asset Discovery**: Triggering a scan executes `nmap -oX output.xml`. 
- **Data Parsing**: `server.py` utilizes `xml.etree.ElementTree` to parse the Nmap XML, extracting hostnames, IPv4 addresses, and open ports. These are persisted in `output/devices.json`.
- **Target Selection**: Selecting an inventory item updates the global `activeTarget` object in `app.js`. This object is automatically passed as a parameter in subsequent POST/GET requests to the API.

### 3. Tactical Assessment Tabs
- **NETWORK**: Interfaces with `recon.sh` for Layer 3/4 scans.
- **WIFI**: Interfaces with `wifi_tools.sh` for Layer 2 assessments.
- **SCENARIOS**: Triggers high-level shell orchestration in `scenarios.sh`.

### 4. Direct Process Monitoring
The centralized console provides a real-time stream of background activity.
- **Live Output**: `app.js` reads from the `/api/reports/live` endpoint, which streams the last 50 lines of the active tool's log file using `tail -n 50`.

### 5. Reporting and Exfiltration
The **REPORTS** tab provides direct access to the `output/` directory structure.
- **Metadata**: Each report entry displays the command executed, start time, and status (Running/Success/Failed).
- **Blob Access**: Direct links allow for the retrieval of `.cap`, `.pcapng`, and `.nmap` files generated during assessments.

---

## ⌨️ Input and Interaction

### Virtual Keyboard Implementation
- Built using native DOM events, the keyboard intercepts Focus events on `input` and `textarea` elements. It injects characters directly into the `value` property of the target element, ensuring compatibility with touch-based TFT displays.

### UI Status Mapping
- **Active (Green)**: Process ID is present in the backend's active task list.
- **Warning (Yellow)**: Backend reported a non-zero exit code or stderr activity.
- **Identified (Red)**: NSE script output contains "VULNERABLE" or "CRITICAL" strings.

---
*For direct script parameter definitions, refer to the [Technical Reference](./TECHNICAL_REFERENCE.md).*
