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

Each line contains a VLAN ID followed by a static IP in CIDR notation. The last octet of the IP address is what gets assigned to the VLAN interface.

For example, in the file below: 10 192.168.10.7/24 → VLAN 10 will have the IP 192.168.10.7, and the gateway is determined automatically.

## Static:
### file.txt
```
10 192.168.10.7/24
20 10.0.20.15/24
```

## DHCP:

For DHCP, each line contains a VLAN ID and a subnet mask. The interface will use DHCP to obtain an IP within that subnet. 

In the example below: 30 /24 creates VLAN 30, and assigns it an IP via DHCP from the associated /24 network.

### file.txt
```
30 /24
40 /22
```
# Quick Start

```
chmod +x vlantastic.sh
./vlantastic.sh -c vlans.txt eth0
```
