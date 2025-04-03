#!/bin/bash

# Function to send SMS via Email to multiple phone numbers
send_sms_via_email() {
    local phone_number=$1
    local carrier=$2
    local message=$3
    local gmail_user="your-email@gmail.com"      # Replace with your Gmail address
    local gmail_password="your-email-password"   # Replace with your Gmail password or App Password

    # Define email-to-SMS gateways for some common carriers
    declare -A carriers
    carriers["verizon"]="vtext.com"
    carriers["att"]="txt.att.net"
    carriers["tmobile"]="tmomail.net"
    carriers["sprint"]="messaging.sprintpcs.com"

    # Check if the carrier exists in the map
    if [ -z "${carriers[$carrier]}" ]; then
        echo "[!] Unknown carrier. Supported carriers: verizon, att, tmobile, sprint."
        return 1
    fi

    # Form the recipient email address (phone_number@carrier_gateway)
    recipient="$phone_number@${carriers[$carrier]}"

    # Send the email using Gmail's SMTP server
    echo "$message" | msmtp --host=smtp.gmail.com --port=587 --tls --auth=on \
        --user=$gmail_user --passwordeval="echo $gmail_password" "$recipient"

    if [ $? -eq 0 ]; then
        echo "[+] SMS sent to $phone_number via $carrier."
    else
        echo "[!] Failed to send SMS."
    fi
}

# Function to send regular email to multiple recipients
send_email() {
    local recipient_email=$1
    local subject=$2
    local message=$3
    local gmail_user="your-email@gmail.com"      # Replace with your Gmail address
    local gmail_password="your-email-password"   # Replace with your Gmail password or App Password

    # Send the email using Gmail's SMTP server
    echo "$message" | msmtp --host=smtp.gmail.com --port=587 --tls --auth=on \
        --user=$gmail_user --passwordeval="echo $gmail_password" --subject="$subject" "$recipient_email"

    if [ $? -eq 0 ]; then
        echo "[+] Email sent to $recipient_email."
    else
        echo "[!] Failed to send email."
    fi
}

# Function to send SMS to a list of phone numbers
send_bulk_sms() {
    local numbers=($1)     # List of phone numbers
    local carrier=$2
    local message=$3

    for number in "${numbers[@]}"; do
        send_sms_via_email "$number" "$carrier" "$message"
    done
}

# Function to send email to a list of email addresses
send_bulk_email() {
    local emails=($1)      # List of email addresses
    local subject=$2
    local message=$3

    for email in "${emails[@]}"; do
        send_email "$email" "$subject" "$message"
    done
}

# Function to get user input for sending SMS to multiple recipients
get_bulk_sms_input() {
    read -p "Enter recipient phone numbers (comma separated, no spaces): " numbers
    read -p "Enter recipient carrier (verizon, att, tmobile, sprint): " carrier
    read -p "Enter your message: " message

    # Convert comma-separated string into an array
    IFS=',' read -r -a numbers_array <<< "$numbers"
    send_bulk_sms "${numbers_array[@]}" "$carrier" "$message"
}

# Function to get user input for sending emails to multiple recipients
get_bulk_email_input() {
    read -p "Enter recipient email addresses (comma separated): " emails
    read -p "Enter subject: " subject
    read -p "Enter your message: " message

    # Convert comma-separated string into an array
    IFS=',' read -r -a emails_array <<< "$emails"
    send_bulk_email "${emails_array[@]}" "$subject" "$message"
}

# Main menu to interact with the script
main_menu() {
    while true; do
        echo "--------------------------------"
        echo "[1] Send SMS to Multiple Numbers"
        echo "[2] Send Email to Multiple Emails"
        echo "[3] Exit"
        echo "--------------------------------"
        read -p "Choose an option: " choice

        case $choice in
            1)
                get_bulk_sms_input
                ;;
            2)
                get_bulk_email_input
                ;;
            3)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "[!] Invalid option. Please choose again."
                ;;
        esac
    done
}

# Run the script
main_menu
