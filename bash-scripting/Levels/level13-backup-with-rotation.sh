#13: Backup Script with Rotation
#A script that backs up a directory to a specified location and keeps only the last 5 backups.

#!/bin/bash

source_dir=Arena/
backup_dir=Backups/

mkdir -p $backup_dir
timestamp=$(date '+%Y-%m-%d')-$(date +%-T)
backup_name=backup-${timestamp}.tgz

#Backs up a directory
tar --create --gzip --file="$backup_dir""$backup_name" "$source_dir"

# keeps only the last 5 backups.
cd $backup_dir
ls -1t | tail -n +6 | while IFS= read -r line; do
 rm $line
done
cd ..
