#!/bin/bash

# Clear the terminal screen
clear

# Set colors using tput
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)

# Define the banner
cat <<EOF
${BOLD}${GREEN}*****************************************************
${CYAN}*              Welcome to Termux!               *
${CYAN}*   System Info: $(date)                        *
${CYAN}*   Username: $(whoami)                         *
${CYAN}*   Hostname: $(hostname)                       *
${CYAN}*   IP Address: $(hostname -I)                  *
${CYAN}*   Battery: $(termux-battery-status | jq '.percentage')%    *
${GREEN}*****************************************************
${CYAN}Let's begin your journey with Termux!${NORMAL}
EOF
