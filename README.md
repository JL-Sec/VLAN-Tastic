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

### Static IPs

Each line in the file defines a VLAN ID and a static IP in CIDR format.

Example File.txt:
```
10 192.168.10.7/24
20 10.0.20.15/24
```
This creates:

VLAN 10 → IP: 192.168.10.7

VLAN 20 → IP: 10.0.20.15

💡 The gateway will be set automatically based on the subnet.

### DHCP:

Each line defines a VLAN ID and a subnet mask. The interface will use DHCP to obtain an IP within that subnet.

Example File.txt:
```
30 /24
40 /22
```
This creates:

VLAN 30 → DHCP IP in a /24 network

VLAN 40 → DHCP IP in a /22 network

💡 The gateway will be set automatically based on the subnet.

# Quick Start

```
chmod +x vlantastic.sh
./vlantastic.sh -c vlans.txt eth0
```
