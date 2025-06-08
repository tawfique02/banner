#!/usr/bin/env bash

# Termux Welcome Banner Script
# Displays system information in a formatted banner upon terminal launch
# Author: [Your Name]
# Version: 1.0

# Clear terminal for clean display
clear

# Initialize color variables using tput for cross-platform compatibility
readonly BOLD=$(tput bold)
readonly NORMAL=$(tput sgr0)
readonly GREEN=$(tput setaf 2)
readonly CYAN=$(tput setaf 6)

# Function to safely retrieve battery percentage
get_battery_percentage() {
    if command -v termux-battery-status &> /dev/null && command -v jq &> /dev/null; then
        termux-battery-status 2>/dev/null | jq -r '.percentage' || echo "N/A"
    else
        echo "N/A"
    fi
}

# Generate system information
readonly CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")
readonly USERNAME=$(whoami)
readonly HOSTNAME=$(hostname)
readonly IP_ADDRESS=$(hostname -I | awk '{print $1}')
readonly BATTERY_PERCENTAGE=$(get_battery_percentage)

# Display formatted banner
cat <<EOF
${BOLD}${GREEN}*****************************************************
${CYAN}*               TERMUX SYSTEM INFORMATION              *
${GREEN}*---------------------------------------------------*
${CYAN}*  Date: ${CURRENT_DATE%-*}                    *
${CYAN}*  User: ${USERNAME}@${HOSTNAME}$(printf '%*s' $((24 - ${#USERNAME} - ${#HOSTNAME})) "") *
${CYAN}*  IP Address: ${IP_ADDRESS}$(printf '%*s' $((31 - ${#IP_ADDRESS})) "") *
${CYAN}*  Battery Level: ${BATTERY_PERCENTAGE}%$(printf '%*s' $((28 - ${#BATTERY_PERCENTAGE})) "")*
${GREEN}*****************************************************
${CYAN}${BOLD}Ready for secure, efficient mobile development!${NORMAL}
EOF
