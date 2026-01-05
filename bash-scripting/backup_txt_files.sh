#Backup Script for Text Files
:' 
Creates a script that prompts for a source directory,
creates a timestamped backup directory if it doesn’t exist, copies all .txt files into it, 
and displays the number of files backed up
'
#!/bin/bash

timestamp=$(date '+%d/%m/%Y %H:%M')
backup_dir="backup_"$timestamp""
total_txt_backups=$(ls "$src_dir"/*.txt | wc -l)

echo "Write the name of the directory from which you want to backup all the .txt files"
read src_dir

mkdir -p "$backup_dir"
cp "$src_dir"/*.txt "$backup_dir"/

echo "Backup directory created: "$backup_dir". Copying .txt files..."
echo "Number of .txt files backed up: "$total_txt_backups""
