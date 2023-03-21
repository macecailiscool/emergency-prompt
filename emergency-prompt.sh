#!/bin/bash

# Check if system integrity protection is enabled
if csrutil status | grep -q "System Integrity Protection status: enabled."
then
    echo "Oooooh... that's not good. Turn off system integrity protection and try again."
    exit 1
fi

# Create a log file with a timestamp
log_file="/var/log/emergency-prompt-$(date +"%Y-%m-%d_%H-%M-%S").log"
touch "$log_file"

# Display warning message about the risks
echo "WARNING: This script is intended for use in emergency situations only, and may cause data loss or system instability. Use at your own risk."
echo "Do you understand the risks and wish to proceed? (y/n)"

# Read user's confirmation
read -r confirm

# Validate user's confirmation
if [[ $confirm != "y" && $confirm != "Y" ]]
then
    echo "Aborted by user."
    exit 0
fi

# Display prompt to the user
echo "EMERGENCY PROMPT"
echo "Choose one of the following options:"
echo "1. Force restart the Dock"
echo "2. Force restart the Finder"
echo -e "\e[31m3. Force restart the whole system\e[0m"

# Read user's choice
read -p "Enter your choice (1/2/3): " choice

# Validate user's choice
if [[ ! $choice =~ ^[1-3]$ ]]
then
    echo "Invalid choice."
    echo "Invalid choice." >> "$log_file"
    exit 1
fi

# Confirm with the user before executing the selected action
if [[ $choice -eq 3 ]]
then
    read -p $'\e[31mWoah woah woah. I\'m gonna stop you right there. Are you absolutely positive? You WILL, and I mean, WILL lose ALL UNSAVED CHANGES! Do you wish to proceed? Your choice, amigo. (y/n)\e[0m ' confirm
else
    read -p "Are you sure you want to continue? (y/n): " confirm
fi

if [[ $confirm != "y" && $confirm != "Y" ]]
then
    echo "Aborted by user."
    echo "Aborted by user." >> "$log_file"
    exit 0
fi

# Execute the selected action
case $choice in
    1)
        if killall Dock >> "$log_file" 2>&1
        then
            echo "Dock restarted successfully."
        else
            echo "Failed to restart Dock."
        fi
        ;;
    2)
        if killall Finder >> "$log_file" 2>&1
        then
            echo "Finder restarted successfully."
        else
            echo "Failed to restart Finder."
        fi
        ;;
    3)
        echo -e "\e[31mSystem restarting in 5 seconds. Press Ctrl+C to cancel.\e[0m"
        sleep 5
        if sudo reboot >> "$log_file" 2>&1
        then
            echo "System restarted successfully."
        else
            echo "Failed to restart system."
        fi
        ;;
esac

echo "Action completed."
echo "Action completed." >> "$log_file"
