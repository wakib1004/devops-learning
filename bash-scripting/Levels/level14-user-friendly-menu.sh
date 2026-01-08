#Level 14: User-Friendly Menu Script
:' 
An interactive script that presents a menu with options for different system tasks
(e.g., check disk space, show system uptime, list users), and executes the chosen task.
'

#!/bin/bash

echo "Please enter the a number to choose one of the tasks"
options=("List users" "Show system uptime" "Check disk space" "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "List users")
            echo "Listing users"
            who | awk '{print $1}'
            ;;
        "Show system uptime")
            echo "Showing system uptime"
            uptime
            ;;
        "Check disc space")
            echo "Checking disc space"
            df -H
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option ${REPLY}, select one of the numbers";;
    esac
done
