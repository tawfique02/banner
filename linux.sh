#!/usr/bin/env bash

# Linux System Information Banner
# Displays key system metrics in a formatted banner
# Author: [Your Name]
# Version: 1.1

# Clear terminal
clear

# Color definitions using tput
readonly BOLD=$(tput bold)
readonly RESET=$(tput sgr0)
readonly GREEN=$(tput setaf 2)
readonly BLUE=$(tput setaf 4)
readonly YELLOW=$(tput setaf 3)
readonly WHITE=$(tput setaf 7)

# System information gathering functions
get_uptime() {
    uptime -p | sed 's/^up //'
}

get_memory() {
    free -h | awk '/Mem:/ {print $3 "/" $2}'
}

get_load() {
    awk '{printf "%.1f %.1f %.1f", $1, $2, $3}' /proc/loadavg
}

get_disk() {
    df -h / | awk 'NR==2 {print $4 " free"}'
}

# Collect system data
readonly OS=$(source /etc/os-release && echo "$PRETTY_NAME")
readonly KERNEL=$(uname -r)
readonly HOSTNAME=$(hostname)
readonly USER=$(whoami)
readonly IP=$(hostname -I | awk '{print $1}')
readonly CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d':' -f2 | sed 's/^[ \t]*//')
readonly CORES=$(nproc)
readonly UPTIME=$(get_uptime)
readonly MEMORY=$(get_memory)
readonly LOAD=$(get_load)
readonly DISK=$(get_disk)
readonly DATE=$(date +"%A, %B %d %Y %H:%M:%S")

# Display banner
cat <<EOF
${BOLD}${GREEN}================================================================================
${BLUE}*                         LINUX SYSTEM INFORMATION                          *
${GREEN}*--------------------------------------------------------------------------------*
${WHITE}*  ${YELLOW}Hostname${WHITE}: ${HOSTNAME}${RESET}$(printf '%*s' $((55 - ${#HOSTNAME})) "")*
${WHITE}*  ${YELLOW}OS${WHITE}: ${OS}${RESET}$(printf '%*s' $((63 - ${#OS})) "")*
${WHITE}*  ${YELLOW}Kernel${WHITE}: ${KERNEL}${RESET}$(printf '%*s' $((60 - ${#KERNEL})) "")*
${WHITE}*  ${YELLOW}Uptime${WHITE}: ${UPTIME}${RESET}$(printf '%*s' $((60 - ${#UPTIME})) "")*
${WHITE}*  ${YELLOW}CPU${WHITE}: ${CPU} (${CORES} cores)${RESET}$(printf '%*s' $((48 - ${#CPU} - ${#CORES} - 10)) "")*
${WHITE}*  ${YELLOW}Memory${WHITE}: ${MEMORY}${RESET}$(printf '%*s' $((60 - ${#MEMORY})) "")*
${WHITE}*  ${YELLOW}Load Avg${WHITE}: ${LOAD}${RESET}$(printf '%*s' $((58 - ${#LOAD})) "")*
${WHITE}*  ${YELLOW}Disk (/)${WHITE}: ${DISK}${RESET}$(printf '%*s' $((58 - ${#DISK})) "")*
${WHITE}*  ${YELLOW}IP Address${WHITE}: ${IP}${RESET}$(printf '%*s' $((56 - ${#IP})) "")*
${GREEN}*--------------------------------------------------------------------------------*
${WHITE}*  ${YELLOW}Date${WHITE}: ${DATE}${RESET}$(printf '%*s' $((58 - ${#DATE})) "")*
${GREEN}================================================================================
${BLUE}${BOLD}System is operational and ready for use. Have a productive session!${RESET}
EOF
