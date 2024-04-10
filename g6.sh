#!/bin/bash

# Function to install packages if not already installed
install_package() {
    if ! dpkg -l "$1" &> /dev/null; then
        echo "Installing $1..."
        sudo apt update
        sudo apt install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Check and install netplan.io
install_package netplan.io

# Check and install net-tools
install_package net-tools

# Create a list file to hold 6to4 tunnels if not exists
service_list_file="6to4_tunnels.txt"
if [ ! -f "$service_list_file" ]; then
    touch "$service_list_file"
fi

# Function to install packages if not already installed
install_package() {
    if ! dpkg -l "$1" &> /dev/null; then
        echo "Installing $1..."
        sudo apt update
        sudo apt install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Check and install socat
install_package socat

# File to store the list of created services
socat_service_list_file="created_services.list"
if [ ! -f "$socat_service_list_file" ]; then
    touch "$socat_service_list_file"
fi

# Function to create a new socat service
create_socat_service() {
    echo "Creating a new socat service..."
    read -p "Enter service name: " service_name
    read -p "Enter local port: " local_port
    read -p "Enter remote IPv6 address: " remote_ipv6
    read -p "Enter remote port: " remote_port

    # Create TCP socat service
    cat <<EOF_TCP | sudo tee "/etc/systemd/system/${service_name}_tcp.service" > /dev/null
[Unit]
Description=Socat Port Forwarding Service for ${service_name} (TCP)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat TCP-LISTEN:${local_port},fork,reuseaddr TCP6:[${remote_ipv6}]:${remote_port}
Restart=always

[Install]
WantedBy=multi-user.target
EOF_TCP

    # Create UDP socat service
    cat <<EOF_UDP | sudo tee "/etc/systemd/system/${service_name}_udp.service" > /dev/null
[Unit]
Description=Socat Port Forwarding Service for ${service_name} (UDP)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat UDP-LISTEN:${local_port},fork,reuseaddr UDP6:[${remote_ipv6}]:${remote_port}
Restart=always

[Install]
WantedBy=multi-user.target
EOF_UDP

    sudo systemctl daemon-reload
    sudo systemctl enable "${service_name}_tcp.service"
    sudo systemctl enable "${service_name}_udp.service"
    sudo systemctl start "${service_name}_tcp.service"
    sudo systemctl start "${service_name}_udp.service"

    echo "Socat services '${service_name}_tcp' and '${service_name}_udp' created successfully."
}

# Function to delete an existing socat service
delete_socat_service() {
    echo "Deleting an existing socat service..."
    echo "List of available services:"
    cat "$socat_service_list_file" | sed 's/^/ - /'
    read -p "Enter service name to delete: " service_name

    if [ -f "/etc/systemd/system/${service_name}_tcp.service" ]; then
        sudo systemctl stop "${service_name}_tcp.service" >/dev/null 2>&1
        sudo systemctl disable "${service_name}_tcp.service" >/dev/null 2>&1
        sudo rm "/etc/systemd/system/${service_name}_tcp.service" >/dev/null 2>&1
    fi

    if [ -f "/etc/systemd/system/${service_name}_udp.service" ]; then
        sudo systemctl stop "${service_name}_udp.service" >/dev/null 2>&1
        sudo systemctl disable "${service_name}_udp.service" >/dev/null 2>&1
        sudo rm "/etc/systemd/system/${service_name}_udp.service" >/dev/null 2>&1
    fi

    sudo systemctl daemon-reload

    # Remove service name from the list file
    sed -i "/^${service_name}$/d" "$socat_service_list_file"

    echo "Socat services '${service_name}_tcp' and '${service_name}_udp' deleted successfully."
}

# Function to list service settings
list_service_settings() {
    echo "Listing service settings..."
    echo "List of available services:"
    cat "$socat_service_list_file" | sed 's/^/ - /'
    read -p "Enter service name to list settings: " service_name

    if [ -f "/etc/systemd/system/${service_name}_tcp.service" ]; then
        echo "Settings for service '${service_name} (TCP)':"
        cat "/etc/systemd/system/${service_name}_tcp.service"
    else
        echo "Service '${service_name}_tcp' not found."
    fi

    if [ -f "/etc/systemd/system/${service_name}_udp.service" ]; then
        echo "Settings for service '${service_name} (UDP)':"
        cat "/etc/systemd/system/${service_name}_udp.service"
    else
        echo "Service '${service_name}_udp' not found."
    fi
}

# Function to create 6to4 tunnel
create_tunnel() {
    echo "Enter the service name for the tunnel:"
    read service_name
    echo "Enter the local public IPv4 address:"
    read local_ipv4
    echo "Enter the remote public IPv4 address:"
    read remote_ipv4
    echo "Enter the local IPv6 address with subnet (e.g., 1001:db8:101::1/64):"
    read local_ipv6

    # Create YAML file for the tunnel
    tunnel_file="/etc/netplan/${service_name}.yaml"
    echo "network:
  version: 2
  tunnels:
    $service_name:
      mode: sit
      local: $local_ipv4
      remote: $remote_ipv4
      addresses:
        - $local_ipv6" | sudo tee "$tunnel_file" > /dev/null
    sudo netplan apply

    # Store tunnel information in the list file
    echo "$service_name" >> "$service_list_file"
    echo "6to4 tunnel created with configuration file: $tunnel_file"
}

# Function to delete a 6to4 tunnel
delete_tunnel() {
    echo ""
    echo "=== List of 6to4 tunnels ==="
    echo ""
    if [ -s "$service_list_file" ]; then
        cat -n "$service_list_file"
    else
        echo "No tunnels configured."
        return
    fi

    echo ""
    echo "Enter the number of the tunnel you want to delete:"
    read tunnel_number

    selected_tunnel=$(sed -n "${tunnel_number}p" "$service_list_file")
    if [ -n "$selected_tunnel" ]; then
        echo "Deleting tunnel: $selected_tunnel"
        tunnel_file="/etc/netplan/${selected_tunnel}.yaml"
        sudo rm "$tunnel_file"
        sudo netplan apply
        sudo ip link delete "$selected_tunnel" # Delete the associated interface
        sed -i "${tunnel_number}d" "$service_list_file"
        echo "6to4 tunnel $selected_tunnel deleted."
    else
        echo "Invalid tunnel number."
    fi
}

# Function to list 6to4 tunnels
list_tunnels() {
    echo ""
    echo "=== List of 6to4 tunnels ==="
    echo ""
    if [ -s "$service_list_file" ]; then
        cat -n "$service_list_file"
    else
        echo "No tunnels configured."
        return
    fi

    echo ""
    echo "Enter the number of the tunnel you want to view configuration:"
    read tunnel_number

    selected_tunnel=$(sed -n "${tunnel_number}p" "$service_list_file")
    if [ -n "$selected_tunnel" ]; then
        tunnel_file="/etc/netplan/${selected_tunnel}.yaml"
        echo "Configuration for tunnel $selected_tunnel:"
        echo ""
        cat "$tunnel_file"
    else
        echo "Invalid tunnel number."
    fi
}

# Main menu
while true; do
    echo ""
    echo "==========Coded By M.Ds ============="
	echo "A tool for create 6to4 tunnels and do routing with minimum cpu usage"
    echo "This code will redirect all TCP/UDP through 6to4 on port you want"
    echo "a gift to OPIran Users"
    echo "========== Socat Service Management =========="
    echo "1. Create a new socat service"
    echo "2. Delete an existing socat service"
    echo "3. List service settings"
    echo "4. Create a 6to4 tunnel"
    echo "5. Delete a 6to4 tunnel"
    echo "6. List 6to4 tunnels"
    echo "7. Exit"
    echo "=============================================="
    read -p "Enter your choice (1-7): " choice

    case "$choice" in
        1)
            create_socat_service
            ;;
        2)
            delete_socat_service
            ;;
        3)
            list_service_settings
            ;;
        4)
            create_tunnel
            ;;
        5)
            delete_tunnel
            ;;
        6)
            list_tunnels
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 7."
            ;;
    esac
done
