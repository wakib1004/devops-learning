#Level 9: Script to Monitor Directory Changes
#A script that monitors "Arena" directory for any changes (file creation, modification, or deletion) and logs the changes with a timestamp in changes_log.txt

directory="Arena"
log_file="changes_log.txt"

#Automates the monitoring of the above changes in the directory and logs the changes with a timestamp in changes_log.txt
inotifywait -m "$directory" -e create,modify,delete | while read line; do

        file_name=$(echo $line | awk '{print $NF}')
        event=$(echo $line | awk '{print $2}')

        if [[ "$event" == "CREATE" ]]; then
                echo "The file "$file_name" was created at $(date)" >> "$log_file"
        elif [[ "$event" == "DELETE" ]]; then
                echo "The file "$file_name" was deleted at $(date)" >> "$log_file"
        else
                echo "The file "$file_name" was modified at $(date)" >> "$log_file"
        fi

done
