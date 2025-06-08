#!/usr/bin/env bash

# Fancy Linux System Banner
# Features: Colorful ASCII art + Cool box design + System info
# Author: [Your Name]
# Version: 2.0

clear

# Color definitions
BOLD=$(tput bold)
RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BG_BLACK=$(tput setab 0)

# ASCII Art (Tux the Penguin)
TUX_ART="${BLUE}
   ${BOLD}.--.
  |o_o |
  |:_/ |
 //   \\ \\
(|     | )
/'\\_   _/\`\\
\\___)=(___/
${RESET}"

# System info functions
get_uptime() {
    uptime -p | sed 's/^up //'
}

get_memory() {
    free -h | awk '/Mem:/ {print $3 "/" $2}'
}

get_load() {
    awk '{printf "%.1f %.1f %.1f", $1, $2, $3}' /proc/loadavg
}

# Get system data
OS=$(source /etc/os-release && echo "$PRETTY_NAME")
KERNEL=$(uname -r)
HOSTNAME=$(hostname)
USER=$(whoami)
IP=$(hostname -I | awk '{print $1}')
CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d':' -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')
CORES=$(nproc)
UPTIME=$(get_uptime)
MEMORY=$(get_memory)
LOAD=$(get_load)
DATE=$(date +"%A, %B %d %Y")

# Fancy box banner
cat <<EOF
${BOLD}${MAGENTA}
 ╔════════════════════════════════════════════════════════════════════════════╗
 ║${YELLOW}   ██████╗ ██╗   ██╗███████╗    ███████╗██╗   ██╗███████╗████████╗███████╗   ${MAGENTA}║
 ║${YELLOW}  ██╔════╝ ██║   ██║██╔════╝    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝   ${MAGENTA}║
 ║${YELLOW}  ██║  ███╗██║   ██║█████╗      █████╗   ╚████╔╝ █████╗     ██║   █████╗     ${MAGENTA}║
 ║${YELLOW}  ██║   ██║██║   ██║██╔══╝      ██╔══╝    ╚██╔╝  ██╔══╝     ██║   ██╔══╝     ${MAGENTA}║
 ║${YELLOW}  ╚██████╔╝╚██████╔╝███████╗    ███████╗   ██║   ███████╗   ██║   ███████╗   ${MAGENTA}║
 ║${YELLOW}   ╚═════╝  ╚═════╝ ╚══════╝    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝   ${MAGENTA}║
 ╠════════════════════════════════════════════════════════════════════════════╣
 ║${CYAN}  ${TUX_ART}${MAGENTA}║
 ╠════════════════════════════════════════════╦═══════════════════════════════╣
 ║${GREEN}  ${BOLD}➤ Hostname:${RESET} ${WHITE}${HOSTNAME}${MAGENTA}$(printf '%*s' $((35 - ${#HOSTNAME})) "")║${GREEN}  ${BOLD}➤ Uptime:${RESET} ${WHITE}${UPTIME}${MAGENTA}$(printf '%*s' $((25 - ${#UPTIME})) "")║
 ║${GREEN}  ${BOLD}➤ OS:${RESET} ${WHITE}${OS}${MAGENTA}$(printf '%*s' $((43 - ${#OS})) "")║${GREEN}  ${BOLD}➤ Load:${RESET} ${WHITE}${LOAD}${MAGENTA}$(printf '%*s' $((25 - ${#LOAD})) "")║
 ║${GREEN}  ${BOLD}➤ Kernel:${RESET} ${WHITE}${KERNEL}${MAGENTA}$(printf '%*s' $((40 - ${#KERNEL})) "")║${GREEN}  ${BOLD}➤ Memory:${RESET} ${WHITE}${MEMORY}${MAGENTA}$(printf '%*s' $((25 - ${#MEMORY})) "")║
 ║${GREEN}  ${BOLD}➤ CPU:${RESET} ${WHITE}${CPU}${MAGENTA}$(printf '%*s' $((43 - ${#CPU})) "")║${GREEN}  ${BOLD}➤ IP:${RESET} ${WHITE}${IP}${MAGENTA}$(printf '%*s' $((25 - ${#IP})) "")║
 ╠════════════════════════════════════════════╩═══════════════════════════════╣
 ║${BOLD}${YELLOW}  Date: ${WHITE}${DATE}${MAGENTA}$(printf '%*s' $((70 - ${#DATE})) "")║
 ╚════════════════════════════════════════════════════════════════════════════╝
${RESET}
EOF
