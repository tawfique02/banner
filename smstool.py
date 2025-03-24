import os
import json
import time
import vonage

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
    os.system(f'termux-sms-send -n {number} "{message}"')
    log_sms(number, message, "Termux")
    print("[+] SMS Sent via Termux")

def load_config():
    """Load configuration from config.json"""
    if os.path.exists('config.json'):
        with open('config.json', 'r') as file:
            return json.load(file)
    return {}

def save_config(config):
    """Save configuration to config.json"""
    with open('config.json', 'w') as file:
        json.dump(config, file, indent=4)

def log_sms(number, message, method):
    """Log SMS to a file"""
    with open("sms_log.txt", "a") as log_file:
        log_file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - [{method}] To: {number} - {message}\n")

def send_sms_nexmo(number, message):
    """Send SMS using Nexmo (Vonage) API"""
    config = load_config()
    if 'nexmo_api_key' not in config or 'nexmo_api_secret' not in config or 'nexmo_number' not in config:
        print("[!] Nexmo API not configured. Run 'configure_nexmo' first.")
        return
    
    client = vonage.Client(key=config['nexmo_api_key'], secret=config['nexmo_api_secret'])
    sms = vonage.Sms(client)
    
    try:
        response = sms.send_message({
            'from': config['nexmo_number'],
            'to': number,
            'text': message,
        })
        if response["status"] == "0":
            log_sms(number, message, "Nexmo")
            print("[+] SMS Sent via Nexmo")
        else:
            print(f"[!] Error: {response['error-text']}")
    except Exception as e:
        print(f"[!] Error sending SMS via Nexmo: {e}")

def configure_nexmo():
    """Configure Nexmo credentials"""
    api_key = input("Enter Nexmo API Key: ")
    api_secret = input("Enter Nexmo API Secret: ")
    number = input("Enter Nexmo Phone Number: ")
    config = {'nexmo_api_key': api_key, 'nexmo_api_secret': api_secret, 'nexmo_number': number}
    save_config(config)
    print("[+] Nexmo API Configured Successfully")

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
        print("\n[1] Send SMS\n[2] Configure Nexmo (Linux)\n[3] View SMS Logs\n[4] Exit")
        choice = input("Choose an option: ")
        
        if choice == '1':
            number = input("Enter recipient number: ")
            message = input("Enter your message: ")
            
            if is_termux():
                send_sms_termux(number, message)
            else:
                send_sms_nexmo(number, message)
        elif choice == '2':
            configure_nexmo()
        elif choice == '3':
            view_logs()
        elif choice == '4':
            exit()
        else:
            print("[!] Invalid choice")

if __name__ == "__main__":
    main()
