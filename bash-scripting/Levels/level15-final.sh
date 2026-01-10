#Level 15: Boss Battle 3 - Advanced Scripting
:' A script that presents a menu to the user with the following options:
- Check disk space
- Show system uptime
- Backup the Arena directory and keep the last 3 backups
- Parse a configuration file settings.conf and display the values
and executes the chosen task
'

#!/bin/bash

SOURCE_DIR=Arena/
BACKUP_DIR=Backups/

CONFIG_FILE="settings.conf"
TIMESTAMP=$(date '+%Y-%m-%d')-$(date +%-T)
FILE_NAME=backup_$TIMESTAMP.tgz

options=("Check disk space" "Show system uptime" "Backup Arena DIR" "Parse and display value of settings.config")

select opt in ${options[@]};
 do
    case $opt in
        "Check disk space")
            df -h
            ;;
        "Show system uptime")

            uptime
            ;;
        "Backup Arena DIR to Backups DIR")

            tar --create --gzip --file="$BACKUP_DIR""$FILE_NAME" "$SOURCE_DIR"

            cd $SOURCE_DIR
            ls -t | tail -n +4 | while IFS= read -r line; do
             rm $line
            done
            ;;
        "Parse and display value of settings.config")

           while IFS= read -r line; do
            key=$(echo "$line" | cut -d= -f1)
            value=${line#*=}

            echo "Value:$value"
           done < $CONFIG_FILE
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

