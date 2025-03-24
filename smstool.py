
import os
import time

def is_termux():
    """Check if running on Termux (Android)"""
    return os.path.exists('/data/data/com.termux')

def authenticate():
    """Authenticate user with password protection"""
    ADMIN_PASSWORD = "admin"  # Change this to your desired password
    entered_password = input("Enter Admin Password: ")
    if entered_password != ADMIN_PASSWORD:
        print("[!] Incorrect password. Exiting...")
        exit()

def send_sms_termux(number, message):
    """Send SMS using Termux"""
    # Debugging: Print the command before execution
    print(f"[DEBUG] Executing Termux command to send SMS: termux-sms-send -n {number} \"{message}\"")
    
    # Execute the termux-sms-send command and capture the result
    result = os.system(f'termux-sms-send -n {number} "{message}"')

    # Check the result of the command
    if result == 0:
        print(f"[+] SMS Sent to {number}: {message}")
        log_sms(number, message)  # Log the sent message
    else:
        print("[!] Failed to send SMS.")
        print(f"[DEBUG] Command failed with result code: {result}")
        # Send an SMS back indicating failure
        send_sms_termux(number, "Failed to send your message. There was an error.")

def send_bulk_sms(numbers, message, num_messages):
    """Send multiple SMS to numbers"""
    for i in range(num_messages):
        for number in numbers:
            send_sms_termux(number, message)
            time.sleep(1)  # Add a delay between sending messages to avoid spamming

def log_sms(number, message):
    """Log SMS to a file"""
    with open("sms_log.txt", "a") as log_file:
        log_file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - To: {number} - {message}\n")

def view_logs():
    """View the SMS logs"""
    if os.path.exists("sms_log.txt"):
        with open("sms_log.txt", "r") as log_file:
            logs = log_file.readlines()
            if logs:
                print("\n[SMS Logs]")
                print("".join(logs[-5:]))  # Show last 5 logs for performance
            else:
                print("[!] No logs found.")
    else:
        print("[!] No logs found.")

def main():
    """Main function"""
    authenticate()
    
    while True:
        print("\n[1] Send Bulk SMS\n[2] View SMS Logs\n[3] Exit")
        choice = input("Choose an option: ")
        
        if choice == '1':
            # Get a list of numbers to send SMS to
            numbers = input("Enter recipient numbers (comma separated): ").split(',')
            message = input("Enter your message: ")

            # Clean up phone numbers (remove extra spaces)
            numbers = [number.strip() for number in numbers]

            # Prompt for number of messages to send (1 to 50)
            num_messages = int(input("Enter the number of SMS to send (1-50): "))
            if num_messages < 1 or num_messages > 50:
                print("[!] Invalid number. Please enter a number between 1 and 50.")
                continue

            send_bulk_sms(numbers, message, num_messages)

        elif choice == '2':
            view_logs()
        elif choice == '3':
            exit()
        else:
            print("[!] Invalid choice")

if __name__ == "__main__":
    main()
