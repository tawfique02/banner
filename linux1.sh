#!/usr/bin/env bash

# Elite Linux System Banner
# Features: Perfect border sequencing + Colorful design + Comprehensive system info
# Author: [Your Name]
# Version: 2.1

clear

# Color definitions
BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

# Box drawing characters
TL="${MAGENTA}╔" # Top-left
TR="${MAGENTA}╗" # Top-right
BL="${MAGENTA}╚" # Bottom-left
BR="${MAGENTA}╝" # Bottom-right
HZ="${MAGENTA}═" # Horizontal
VT="${MAGENTA}║" # Vertical
LJ="${MAGENTA}╠" # Left-join
RJ="${MAGENTA}╣" # Right-join
TJ="${MAGENTA}╦" # Top-join
BJ="${MAGENTA}╩" # Bottom-join
CR="${MAGENTA}╬" # Cross

# System information functions
get_uptime() {
    uptime -p | sed 's/^up //'
}

get_memory() {
    free -h | awk '/Mem:/ {print $3 "/" $2}'
}

get_disk() {
    df -h / | awk 'NR==2 {print $4 " free"}'
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
LOAD=$(awk '{printf "%.1f %.1f %.1f", $1, $2, $3}' /proc/loadavg)
DISK=$(get_disk)
DATE=$(date +"%A, %B %d %Y %H:%M:%S")

# Calculate dynamic spacing
HOSTNAME_SPACE=$((50 - ${#HOSTNAME}))
OS_SPACE=$((50 - ${#OS}))
KERNEL_SPACE=$((50 - ${#KERNEL}))
CPU_SPACE=$((50 - ${#CPU} - ${#CORES} - 10))
UPTIME_SPACE=$((25 - ${#UPTIME}))
LOAD_SPACE=$((25 - ${#LOAD}))
MEMORY_SPACE=$((25 - ${#MEMORY}))
IP_SPACE=$((25 - ${#IP}))
DISK_SPACE=$((25 - ${#DISK}))
DATE_SPACE=$((70 - ${#DATE}))

# Build the banner
cat <<EOF
${TL}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${TR}
${VT}${BOLD}${YELLOW}        ███████╗██╗   ██╗███████╗████████╗███████╗██████╗         ${RESET}${MAGENTA}${VT}
${VT}${BOLD}${YELLOW}        ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗        ${RESET}${MAGENTA}${VT}
${VT}${BOLD}${YELLOW}        █████╗   ╚████╔╝ █████╗     ██║   █████╗  ██████╔╝        ${RESET}${MAGENTA}${VT}
${VT}${BOLD}${YELLOW}        ██╔══╝    ╚██╔╝  ██╔══╝     ██║   ██╔══╝  ██╔══██╗        ${RESET}${MAGENTA}${VT}
${VT}${BOLD}${YELLOW}        ███████╗   ██║   ███████╗   ██║   ███████╗██║  ██║        ${RESET}${MAGENTA}${VT}
${VT}${BOLD}${YELLOW}        ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝        ${RESET}${MAGENTA}${VT}
${LJ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${RJ}
${VT}${GREEN}  ${BOLD}➤ Hostname:${RESET} ${WHITE}${HOSTNAME}${MAGENTA}$(printf '%*s' ${HOSTNAME_SPACE} "")${VT}
${VT}${GREEN}  ${BOLD}➤ OS:${RESET} ${WHITE}${OS}${MAGENTA}$(printf '%*s' ${OS_SPACE} "")${VT}
${VT}${GREEN}  ${BOLD}➤ Kernel:${RESET} ${WHITE}${KERNEL}${MAGENTA}$(printf '%*s' ${KERNEL_SPACE} "")${VT}
${VT}${GREEN}  ${BOLD}➤ CPU:${RESET} ${WHITE}${CPU} (${CORES} cores)${MAGENTA}$(printf '%*s' ${CPU_SPACE} "")${VT}
${LJ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${RJ}
${VT}${GREEN}  ${BOLD}➤ Uptime:${RESET} ${WHITE}${UPTIME}${MAGENTA}$(printf '%*s' ${UPTIME_SPACE} "")${VT}${GREEN}  ${BOLD}➤ Load:${RESET} ${WHITE}${LOAD}${MAGENTA}$(printf '%*s' ${LOAD_SPACE} "")${VT}
${VT}${GREEN}  ${BOLD}➤ Memory:${RESET} ${WHITE}${MEMORY}${MAGENTA}$(printf '%*s' ${MEMORY_SPACE} "")${VT}${GREEN}  ${BOLD}➤ Disk:${RESET} ${WHITE}${DISK}${MAGENTA}$(printf '%*s' ${DISK_SPACE} "")${VT}
${VT}${GREEN}  ${BOLD}➤ IP:${RESET} ${WHITE}${IP}${MAGENTA}$(printf '%*s' ${IP_SPACE} "")${VT}${GREEN}  ${BOLD}➤ User:${RESET} ${WHITE}${USER}${MAGENTA}$(printf '%*s' $((25 - ${#USER})) "")${VT}
${LJ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${RJ}
${VT}${BOLD}${YELLOW}  Date: ${WHITE}${DATE}${MAGENTA}$(printf '%*s' ${DATE_SPACE} "")${VT}
${BL}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${HZ}${BR}
${RESET}
EOF
