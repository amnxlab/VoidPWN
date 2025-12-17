#!/usr/bin/env python3

import sys
import os
import subprocess
import argparse
import time
from datetime import datetime
import ipaddress
import socket

# Colors
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
CYAN = '\033[96m'
RESET = '\033[0m'

def print_banner():
    print(f"\n{CYAN}")
    print("╔═══════════════════════════════════╗")
    print("║     VOIDPWN SMART SCANNER         ║")
    print("╚═══════════════════════════════════╝")
    print(f"{RESET}")

def log(msg, type="INFO"):
    timestamp = datetime.now().strftime("%H:%M:%S")
    if type == "INFO":
        print(f"[{timestamp}] {BLUE}[*]{RESET} {msg}")
    elif type == "SUCCESS":
        print(f"[{timestamp}] {GREEN}[+]{RESET} {msg}")
    elif type == "WARN":
        print(f"[{timestamp}] {YELLOW}[!]{RESET} {msg}")
    elif type == "ERROR":
        print(f"[{timestamp}] {RED}[-]{RESET} {msg}")

def run_command(cmd, quiet=False):
    try:
        if quiet:
            subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
        else:
            subprocess.run(cmd, shell=True, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def scan_target(target, output_dir):
    log(f"Starting smart scan on {target}")
    
    # Create directory for target
    target_dir = os.path.join(output_dir, target.replace('/', '_'))
    os.makedirs(target_dir, exist_ok=True)
    
    # Phase 1: Port Scan
    log("Phase 1: Fast Port Scan")
    nmap_cmd = f"nmap -T4 -F {target} -oG {target_dir}/fast_scan.gnmap"
    run_command(nmap_cmd, quiet=True)
    
    # Parse open ports
    open_ports = []
    try:
        with open(f"{target_dir}/fast_scan.gnmap", 'r') as f:
            for line in f:
                if "Ports:" in line:
                    parts = line.split("Ports:")[1].strip().split(',')
                    for port in parts:
                        if "open" in port:
                            p = port.split('/')[0].strip()
                            open_ports.append(p)
    except Exception as e:
        log(f"Error parsing scan results: {e}", "ERROR")

    if not open_ports:
        log("No open ports found", "WARN")
        return

    log(f"Found open ports: {', '.join(open_ports)}", "SUCCESS")
    
    # Phase 2: Service Enumeration
    log("Phase 2: Service Enumeration")
    ports_str = ','.join(open_ports)
    nmap_svc_cmd = f"nmap -sV -sC -p {ports_str} {target} -oN {target_dir}/service_scan.nmap"
    run_command(nmap_svc_cmd)
    
    # Phase 3: Targeted Attacks
    log("Phase 3: Targeted Enumeration")
    
    # Web (80, 443, 8080, 8443)
    web_ports = ['80', '443', '8080', '8443']
    found_web = [p for p in open_ports if p in web_ports]
    
    if found_web:
        log(f"Web services detected on ports: {', '.join(found_web)}", "INFO")
        for port in found_web:
            protocol = "https" if port in ['443', '8443'] else "http"
            url = f"{protocol}://{target}:{port}"
            
            log(f"Running Nikto on {url}...")
            run_command(f"nikto -h {url} -o {target_dir}/nikto_{port}.txt -T 2", quiet=True)
            
            log(f"Running Gobuster on {url}...")
            run_command(f"gobuster dir -u {url} -w /usr/share/wordlists/dirb/common.txt -o {target_dir}/gobuster_{port}.txt -q", quiet=True)
            
    # SMB (445)
    if '445' in open_ports:
        log("SMB detected - Checking for vulnerabilities", "INFO")
        run_command(f"nmap -p 445 --script smb-vuln* {target} -oN {target_dir}/smb_vulns.nmap")
        log("Running Enum4Linux", "INFO")
        run_command(f"enum4linux -a {target} > {target_dir}/enum4linux.txt", quiet=True)

    # SSH (22)
    if '22' in open_ports:
        log("SSH detected - Checking for weak algorithms", "INFO")
        run_command(f"nmap -p 22 --script ssh2-enum-algos {target} -oN {target_dir}/ssh_audit.nmap")

    log(f"Scan complete! Results saved in {target_dir}", "SUCCESS")

def main():
    print_banner()
    parser = argparse.ArgumentParser(description='VoidPWN Smart Scanner')
    parser.add_argument('target', help='Target IP or network')
    args = parser.parse_args()
    
    if os.geteuid() != 0:
        log("This script requires root privileges", "ERROR")
        sys.exit(1)
        
    output_base = os.path.expanduser("~/VoidPWN/output/recon")
    scan_target(args.target, output_base)

if __name__ == "__main__":
    main()
