#Level 12: Simple Configuration File Parser
#A script that reads a configuration file "file.config" in the format KEY=VALUE and prints each key-value pair.

#!/bin/bash
config_file="file.config"

#Exits the script if the file does not exist
if [ ! -f $config_file ]; then 
 echo "File does not exist"
 exit 1
fi

#Reads the file line by line and prints key-value pair.
while IFS= read -r line; do
 key=$(echo "$line" | cut -d= -f1)
 value=${line#*=}
 
 echo "Key:$key Value:$value"
 done < "$config_file"
