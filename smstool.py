import os
import platform
import json
import time
from twilio.rest import Client

def is_termux():
    return os.path.exists('/data/data/com.termux')

def authenticate():
    ADMIN_PASSWORD = "admin"  # Change this to your desired password
    entered_password = input("Enter Admin Password: ")
    if entered_password != ADMIN_PASSWORD:
        print("[!] Incorrect password. Exiting...")
        exit()

def send_sms_termux(number, message):
    os.system(f'termux-sms-send -n {number} "{message}"')
    log_sms(number, message, "Termux")
    print("[+] SMS Sent via Termux")

def load_config():
    try:
        with open('config.json', 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        return {}

def save_config(config):
    with open('config.json', 'w') as file:
        json.dump(config, file, indent=4)

def log_sms(number, message, method):
    with open("sms_log.txt", "a") as log_file:
        log_file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - [{method}] To: {number} - {message}\n")

def send_sms_twilio(number, message):
    config = load_config()
    if 'twilio_sid' not in config or 'twilio_auth' not in config or 'twilio_number' not in config:
        print("[!] Twilio API not configured. Run 'configure_twilio' first.")
        return
    
    client = Client(config['twilio_sid'], config['twilio_auth'])
    client.messages.create(to=number, from_=config['twilio_number'], body=message)
    log_sms(number, message, "Twilio")
    print("[+] SMS Sent via Twilio")

def configure_twilio():
    sid = input("Enter Twilio SID: ")
    auth = input("Enter Twilio Auth Token: ")
    number = input("Enter Twilio Phone Number: ")
    config = {'twilio_sid': sid, 'twilio_auth': auth, 'twilio_number': number}
    save_config(config)
    print("[+] Twilio API Configured Successfully")

def view_logs():
    if os.path.exists("sms_log.txt"):
        with open("sms_log.txt", "r") as log_file:
            logs = log_file.readlines()
            if logs:
                print("\n[SMS Logs]")
                for log in logs:
                    print(log.strip())
            else:
                print("[!] No logs found.")
    else:
        print("[!] No logs found.")

def main():
    authenticate()
    while True:
        print("\n[1] Send SMS\n[2] Configure Twilio (Linux)\n[3] View SMS Logs\n[4] Exit")
        choice = input("Choose an option: ")
        
        if choice == '1':
            number = input("Enter recipient number: ")
            message = input("Enter your message: ")
            
            if is_termux():
                send_sms_termux(number, message)
            else:
                send_sms_twilio(number, message)
        elif choice == '2':
            configure_twilio()
        elif choice == '3':
            view_logs()
        elif choice == '4':
            exit()
        else:
            print("[!] Invalid choice")

if __name__ == "__main__":
    main()
