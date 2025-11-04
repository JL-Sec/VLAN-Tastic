# VLANtastic 

VLANtastic is a lightweight bash script that lets you create, check, and delete multiple VLAN interfaces in seconds — designed for when you're on a trunk port and need quick VLAN setup (static or DHCP).

## Features
- Create multiple VLAN interfaces from a text file  
- Supports static IP or DHCP config  
- Delete specific or all VLAN interfaces  
- Check existing VLANs and list base interfaces  

## Usage
```bash
./vlantastic.sh [OPTION] [FILE] [INTERFACE]

## Options

Option	Description
-c --create-static FILE IFACE	Create VLANs with static IPs
-d --create-dhcp FILE IFACE	Create VLANs with DHCP
-k --check	Show current VLAN interfaces
-r --delete [ID]	Delete one or all VLANs
-i --interfaces	List base interfaces
-h --help	Show help
```

## VLAN File Examples
Sample file format for static IPs (e.g., 1, 20, 24, 500 are VLAN IDs. The last octet defines the static IP — e.g., 10.0.0.7/24 assigns 10.0.0.7 as the static IP. The gateway is inferred automatically.)

## Static:
### file.txt
10 192.168.10.7/24
20 10.0.20.15/24

## DHCP:
### file.txt
30 /24
40 /22

# Quick Start

```
chmod +x vlantastic.sh
./vlantastic.sh -c vlans.txt eth0
```
