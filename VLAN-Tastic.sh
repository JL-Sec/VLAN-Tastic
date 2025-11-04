#!/bin/bash

# Function to create VLAN interfaces with static IPs
create_vlan_interfaces_static() {
    local vlan_file=$1
    local base_interface=$2

    while IFS=' ' read -r vlan_id ip_addr; do
        sudo ip link add link $base_interface name vlan$vlan_id type vlan id $vlan_id
        sudo ip link set dev vlan$vlan_id up
        sudo ip addr add $ip_addr dev vlan$vlan_id
        echo "Configured vlan$vlan_id with IP $ip_addr on base interface $base_interface"
    done < $vlan_file
}

# Function to create VLAN interfaces with DHCP
create_vlan_interfaces_dhcp() {
    local vlan_file=$1
    local base_interface=$2

    while IFS=' ' read -r vlan_id subnet_mask; do
        sudo ip link add link $base_interface name vlan$vlan_id type vlan id $vlan_id
        sudo ip link set dev vlan$vlan_id up
        sudo dhclient vlan$vlan_id
        echo "Configured vlan$vlan_id with DHCP on base interface $base_interface"
    done < $vlan_file
}

# Function to check VLAN interfaces
check_vlan_tags() {
    interfaces=$(ip link show)

    echo "$interfaces" | while read -r line; do
        if [[ "$line" =~ @ ]]; then
            interface_name=$(echo "$line" | awk '{print $2}' | cut -d':' -f1)
            vlan_id=$(echo "$interface_name" | cut -d'@' -f1 | grep -o -E '[0-9]+$')
            base_interface=$(echo "$interface_name" | cut -d'@' -f2)
            echo "Interface: $interface_name, VLAN ID: $vlan_id, Base Interface: $base_interface"
        fi
    done
}

# Function to delete VLAN interfaces
delete_vlan_interfaces() {
    local vlan_id=$1
    if [ -z "$vlan_id" ]; then
        interfaces=$(ip link show)
        echo "$interfaces" | while read -r line; do
            if [[ "$line" =~ @ ]]; then
                full_interface_name=$(echo "$line" | awk '{print $2}' | cut -d':' -f1)
                vlan_interface_name=$(echo "$full_interface_name" | cut -d'@' -f1)
                sudo ip link delete $vlan_interface_name
                echo "Deleted VLAN interface: $vlan_interface_name"
            fi
        done
    else
        sudo ip link delete vlan$vlan_id
        echo "Deleted VLAN interface: vlan$vlan_id"
    fi
}

# Function to display available interfaces
show_interfaces() {
    ip link show | awk -F: '/^[0-9]+: / { print $2 }'
}

# Function to display help message
show_help() {
    echo "VLAN-tastic - A VLAN management tool"
    echo ""    
    echo "This tool allows you to create, check, and delete VLAN interfaces on your system whilst on a trunk port"
    echo "You can also list the available base interfaces to use for VLAN creation."
    echo "The tool takes an input text file containing the VLAN IDs followed by the IP or subnet mask"
    echo ""
    echo "Usage: $0 [OPTION] [FILE] [INTERFACE]"
    echo ""
    echo "Options:"
    echo "  -c, --create-static FILE INTERFACE   Create VLAN interfaces with static IPs from FILE using INTERFACE"
    echo "  -d, --create-dhcp FILE INTERFACE     Create VLAN interfaces with DHCP from FILE using INTERFACE"
    echo "  -k, --check                          Check existing VLAN interfaces"
    echo "  -r, --delete [VLAN_ID]               Delete specific VLAN interface if VLAN_ID is provided, otherwise delete all VLAN interfaces"
    echo "  -i, --interfaces                     Show available base interfaces"
    echo "  -h, --help                           Display this help message"
    echo ""
    echo "Sample FILE format for static IPs (1,20,24,500 are the VLAN IDs. The last octet will be your static IP. E.g. in the first example below, your static IP will be 10.0.0.7. It will automatically figure out the gateway.):"
    echo "  1 10.0.0.7/24"
    echo "  20 192.168.0.29/24"
    echo "  24 172.168.0.88/24"
    echo "  500 10.0.0.72/24"
    echo ""
    echo "Sample FILE format for DHCP:"
    echo "  1 /24"
    echo "  2 /24"
    echo "  5 /22"
    echo "  15 /24"
    echo ""
    echo "Example Usage:"
    echo ""
    echo "./VLAN-tastic.sh -c INPUT-FILE.txt eth0"
}

# Main script logic
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

case $1 in
    -c|--create-static)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: No file or interface provided for VLAN creation."
            show_help
            exit 1
        fi
        create_vlan_interfaces_static $2 $3
        ;;
    -d|--create-dhcp)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: No file or interface provided for VLAN creation."
            show_help
            exit 1
        fi
        create_vlan_interfaces_dhcp $2 $3
        ;;
    -k|--check)
        check_vlan_tags
        ;;
    -r|--delete)
        delete_vlan_interfaces $2
        ;;
    -i|--interfaces)
        show_interfaces
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo "Error: Invalid option."
        show_help
        exit 1
        ;;
esac
